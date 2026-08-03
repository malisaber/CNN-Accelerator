library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.math_real.ALL;
USE work.my_pack_v2.ALL;

--------------------------------------------------------------------------------------
--	PIPELINED REDESIGN of Connector_double_mem_map_address
--
--	Same entity, same generics, same ports as the original -> drop-in replacement.
--
--	WHAT CHANGED AND WHY
--	--------------------
--	The original s_finding_slv state did, in a single clock edge and for every
--	slave i in one loop:
--	    - two full range checks (4 x 32-bit unsigned >=/<= compares, since each
--	      slave has TWO apertures: min_1/max_1 and min_2/max_2)
--	    - an OR between the two range results
--	    - an AND against `taken(i)`
--	    - and, on a match, an immediate state transition + slv_cntr capture
--	This was actually worse than Connector_complete's single-aperture version:
--	twice the comparators feeding directly into the priority decision, in the
--	same cycle, replicated across up to SLAVE_CNT slaves and `ways` connectors.
--
--	Here it's split into two states / two pipeline stages:
--
--	  s_decode_addr    : ONLY the two range checks + the OR between them.
--	                     Result goes to a SIGNAL (`destination`), i.e. it is
--	                     registered before anything else uses it.
--	  s_arbitrate_slot : ONLY the priority-encode of the already-registered
--	                     `destination` against `taken`. No arithmetic compares
--	                     happen on this path anymore - just 1-bit logic, and it
--	                     naturally re-checks the latest `taken` every cycle it
--	                     has to retry, without recomputing the address decode.
--
--	Net effect: the longest combinational chain from any input to any register
--	drops from "4 x 32-bit compares + OR + AND + priority mux" to just
--	"1-bit priority mux" on the arbitration path, at the cost of one extra
--	clock cycle per arbitration attempt.
--
--	No handshake/interface changes needed - Master_grant/Slave_CS are already
--	registered outputs consumed by handshake-based masters/slaves elsewhere in
--	the hierarchy, so they tolerate the extra cycle transparently.
--
--	Note: like the original, this has no watchdog / no-match fallback for
--	s_finding_slv (unlike Connector_complete, which has a "default slave"
--	catch-all). That behaviour is preserved as-is here; only the timing
--	structure of the decode/arbitrate logic has changed.
--
--	OPTIONAL FURTHER OPTIMIZATION (not done here, just noted):
--	If the two apertures per slave are power-of-two aligned in your memory
--	map, each range check in s_decode_addr can become a single equality
--	compare on the upper address bits instead of >=/<=, shrinking stage 1
--	further without changing this structure.
--------------------------------------------------------------------------------------

entity Connector_double_mem_map_address is
	GENERIC(
		MASTER_CNT		:	INTEGER	:=	15;
		SLAVE_CNT		:	INTEGER	:=	15;
		SM_size			:	INTEGER	:=	4;
		Name			:	STRING	:=	"name");
	PORT(
		clk				:	IN	std_logic;
		rst				:	IN	std_logic;

		stop_in			:	IN	std_logic;
		stop_out		:	OUT	std_logic;
		prev_bussy		:	IN	std_logic;
		this_bussy		:	OUT	std_logic;
		this_done		:	OUT	std_logic;
		aswering		:	IN	std_logic_vector	(MASTER_CNT-1		DOWNTO 0);
		taken			:	IN	std_logic_vector	(SLAVE_CNT-1		DOWNTO 0);

		Master_Address	:	IN	Unc_1D_P_Addr_array	(MASTER_CNT-1		DOWNTO 0);
		Master_req		:	IN	Unc_1D_array		(MASTER_CNT-1		DOWNTO 0);
		Master_grant	:	OUT	Unc_1D_array		(MASTER_CNT-1		DOWNTO 0);
		Master_MSM		:	OUT	Unc_2D_array		(MASTER_CNT-1		DOWNTO 0,	SM_size-1	DOWNTO 0);

		Slave_min_add_1	:	IN	Unc_1D_P_Addr_array	(SLAVE_CNT-1		DOWNTO 0);
		Slave_max_add_1	:	IN	Unc_1D_P_Addr_array	(SLAVE_CNT-1		DOWNTO 0);
		Slave_min_add_2	:	IN	Unc_1D_P_Addr_array	(SLAVE_CNT-1		DOWNTO 0);
		Slave_max_add_2	:	IN	Unc_1D_P_Addr_array	(SLAVE_CNT-1		DOWNTO 0);
		Slave_CS		:	OUT	Unc_1D_array		(SLAVE_CNT-1		DOWNTO 0);
		Slave_SSM		:	OUT	Unc_2D_array		(SLAVE_CNT-1		DOWNTO 0,	SM_size-1	DOWNTO 0));
end Connector_double_mem_map_address;

architecture Pipelined of Connector_double_mem_map_address is
	TYPE	SM_type		IS	ARRAY	(NATURAL RANGE <>) OF std_logic_vector(SM_size-1 DOWNTO 0);

	--	s_decode_addr / s_arbitrate_slot replace the original single s_finding_slv
	TYPE	states		IS	(s_idle, s_finding_mstr, s_decode_addr, s_arbitrate_slot,
							 s_connecting, s_answering, s_disconnecting);

	SIGNAL	Adds		:	Unc_1D_P_Addr_array	(SLAVE_CNT-1		DOWNTO 0);
	SIGNAL	Mins_1		:	Unc_1D_P_Addr_array	(SLAVE_CNT-1		DOWNTO 0);
	SIGNAL	Maxs_1		:	Unc_1D_P_Addr_array	(SLAVE_CNT-1		DOWNTO 0);
	SIGNAL	Mins_2		:	Unc_1D_P_Addr_array	(SLAVE_CNT-1		DOWNTO 0);
	SIGNAL	Maxs_2		:	Unc_1D_P_Addr_array	(SLAVE_CNT-1		DOWNTO 0);

	SIGNAL	MSM			:	SM_type(MASTER_CNT-1 DOWNTO 0);
	SIGNAL	SSM			:	SM_type(SLAVE_CNT-1  DOWNTO 0);

	SIGNAL	state		:	states;

	SIGNAL	all_reqs	:	std_logic_vector(MASTER_CNT-1 DOWNTO 0);
	SIGNAL	fre_reqs	:	std_logic_vector(MASTER_CNT-1 DOWNTO 0);

	--	Registered address-decode result: written once in s_decode_addr,
	--	consumed (possibly over several retries against changing `taken`)
	--	in s_arbitrate_slot.
	SIGNAL	destination	:	std_logic_vector(SLAVE_CNT-1 DOWNTO 0);
begin
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	Adds				<=	Master_Address;
	Mins_1				<=	Slave_min_add_1;
	Maxs_1				<=	Slave_max_add_1;
	Mins_2				<=	Slave_min_add_2;
	Maxs_2				<=	Slave_max_add_2;
	--------------------------------------------------------------------------------------
	MSM_gen_1		:	FOR i IN MASTER_CNT-1	DOWNTO 0 GENERATE
		MSM_gen_2	:	FOR j IN SM_size-1		DOWNTO 0 GENERATE
			Master_MSM(i,j)	<=	MSM(i)(j);
		END GENERATE;
		all_reqs(i)	<=	Master_req(i);
		fre_reqs(i)	<=	Master_req(i) AND (NOT aswering(i));
	END GENERATE;
	--------------------------------------------------------------------------------------
	SSM_gen_1		:	FOR i IN SLAVE_CNT-1	DOWNTO 0 GENERATE
		SSM_gen_2	:	FOR j IN SM_size-1		DOWNTO 0 GENERATE
			Slave_SSM(i,j)	<=	SSM(i)(j);
		END GENERATE;
	END GENERATE;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	PROCESS(clk, rst)
		VARIABLE	req_cntr	:	INTEGER	RANGE 0 TO MASTER_CNT;
		VARIABLE	slv_cntr	:	INTEGER	RANGE 0 TO SLAVE_CNT;
	BEGIN
		IF rst = '1' THEN
			state			<=	s_idle;
			req_cntr		:=	0;
			slv_cntr		:=	0;
			stop_out		<=	'0';
			this_bussy		<=	'0';
			Master_grant	<=	(OTHERS	=>	'0');
			Slave_CS		<=	(OTHERS	=>	'0');
			MSM				<=	(OTHERS	=>	(OTHERS	=>	'0'));
			SSM				<=	(OTHERS	=>	(OTHERS	=>	'0'));
			this_done		<=	'0';
			destination		<=	(OTHERS	=>	'0');
		ELSIF clk = '1' AND clk'EVENT THEN
			CASE state IS
				--------------------------------------------------------------
				--	Unchanged: idle / master scan
				--------------------------------------------------------------
				WHEN	s_idle			=>	IF (prev_bussy = '1') AND (stop_in = '0') AND (fre_reqs /= (MASTER_CNT-1 DOWNTO 0 => '0')) THEN
												state							<=	s_finding_mstr;
												stop_out						<=	'1';
											END IF;

				WHEN	s_finding_mstr	=>	IF  fre_reqs = (MASTER_CNT-1 DOWNTO 0 => '0') THEN
												state							<=	s_idle;
											ELSE
												IF fre_reqs(req_cntr) = '0' THEN
													req_cntr					:=	req_cntr + 1;
													IF req_cntr = MASTER_CNT THEN
														req_cntr				:=	0;
													END IF;
												ELSE
													state						<=	s_decode_addr;
												END IF;
											END IF;
											stop_out							<=	'1';

				--------------------------------------------------------------
				--	STAGE 1 (new): pure dual-aperture address decode.
				--	Only the 4 x 32-bit >=/<= compares + OR live here; the
				--	result is registered and NOT touched again this cycle.
				--------------------------------------------------------------
				WHEN	s_decode_addr	=>	FOR i IN SLAVE_CNT-1 DOWNTO 0 LOOP
												IF	((unsigned(Adds(req_cntr))	>=	unsigned(Mins_1(i)))	AND
													(unsigned(Adds(req_cntr))	<=	unsigned(Maxs_1(i))))	OR
													((unsigned(Adds(req_cntr))	>=	unsigned(Mins_2(i)))	AND
													(unsigned(Adds(req_cntr))	<=	unsigned(Maxs_2(i))))	THEN
													destination(i)				<=	'1';
												ELSE
													destination(i)				<=	'0';
												END IF;
											END LOOP;
											state								<=	s_arbitrate_slot;

				--------------------------------------------------------------
				--	STAGE 2 (new): priority-encode the already-registered
				--	`destination` against `taken`. Only 1-bit logic here -
				--	no arithmetic compares share this cycle. Retries every
				--	cycle against the latest `taken` without recomputing the
				--	address decode.
				--------------------------------------------------------------
				WHEN	s_arbitrate_slot=>	FOR i IN SLAVE_CNT-1 DOWNTO 0 LOOP
												IF	(destination(i)	=	'1')	AND
													(taken(i)		=	'0')	THEN
													state						<=	s_connecting;
													slv_cntr					:=	i;
												END IF;
											END LOOP;

				--------------------------------------------------------------
				--	Unchanged from here down.
				--------------------------------------------------------------
				WHEN	s_connecting	=>	state								<=	s_answering;
											Master_grant(req_cntr)				<=	'1';
											Slave_CS(slv_cntr)					<=	'1';
											MSM(req_cntr)						<=	std_logic_vector(to_unsigned(slv_cntr, SM_size));
											SSM(slv_cntr)						<=	std_logic_vector(to_unsigned(req_cntr, SM_size));
											this_bussy							<=	'1';

				WHEN	s_answering		=>	stop_out	<=	'0';
											this_bussy	<=	'0';
											IF	all_reqs(req_cntr) = '0' THEN
												state							<=	s_disconnecting;
												Master_grant					<=	(OTHERS	=>	'0');
												Slave_CS						<=	(OTHERS	=>	'0');
												MSM								<=	(OTHERS	=>	(OTHERS	=>	'0'));
												SSM								<=	(OTHERS	=>	(OTHERS	=>	'0'));
												req_cntr						:=	req_cntr + 1;
												IF req_cntr = MASTER_CNT THEN
													req_cntr					:=	0;
												END IF;
												this_done						<=	'1';
											END IF;

				WHEN	s_disconnecting	=>	IF prev_bussy = '0' THEN
												this_done						<=	'0';
												state							<=	s_idle;
											END IF;

			END CASE;

		END IF;
	END PROCESS;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
end Pipelined;
