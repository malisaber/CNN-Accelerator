library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.math_real.ALL;
USE work.my_pack_v2.ALL;

entity Connector_complete is
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
			
		Slave_min_add	:	IN	Unc_1D_P_Addr_array	(SLAVE_CNT-2		DOWNTO 0);
		Slave_max_add	:	IN	Unc_1D_P_Addr_array	(SLAVE_CNT-2		DOWNTO 0);
		Slave_CS		:	OUT	Unc_1D_array		(SLAVE_CNT-1		DOWNTO 0);
		Slave_SSM		:	OUT	Unc_2D_array		(SLAVE_CNT-1		DOWNTO 0,	SM_size-1	DOWNTO 0));
end Connector_complete;

architecture Behavioral of Connector_complete is
	TYPE	SM_type		IS	ARRAY	(NATURAL RANGE <>) OF std_logic_vector(SM_size-1 DOWNTO 0);
	TYPE	DMA_SM_TYPE	IS	ARRAY	(NATURAL RANGE <>) OF std_logic_vector(SM_size-1 DOWNTO 0);
	
	TYPE	states		IS	(s_idle, s_finding_mstr, s_finding_slv, s_connecting, s_answering, s_disconnecting);
	
	SIGNAL	Adds		:	Unc_1D_P_Addr_array	(MASTER_CNT-1			DOWNTO 0);
	SIGNAL	Mins		:	Unc_1D_P_Addr_array	(SLAVE_CNT-2			DOWNTO 0);
	SIGNAL	Maxs		:	Unc_1D_P_Addr_array	(SLAVE_CNT-2			DOWNTO 0);
	
	SIGNAL	MSM			:	SM_type(MASTER_CNT-1						DOWNTO 0);
	SIGNAL	SSM			:	SM_type(SLAVE_CNT-1							DOWNTO 0);
	
	SIGNAL	state		:	states;
	--SIGNAL	N_S			:	states;
	
	SIGNAL	all_zero	:	std_logic_vector(SLAVE_CNT-2				DOWNTO 0)	:=	(OTHERS	=>	'0');
	SIGNAL	all_reqs	:	std_logic_vector(MASTER_CNT-1				DOWNTO 0);
	SIGNAL	fre_reqs	:	std_logic_vector(MASTER_CNT-1				DOWNTO 0);
	SIGNAL	sig_dest	:	std_logic_vector(SLAVE_CNT-2				DOWNTO 0);
begin
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	Adds				<=	Master_Address;
	Mins				<=	Slave_min_add;
	Maxs				<=	Slave_max_add;
	--------------------------------------------------------------------------------------
	MSM_gen_1		:	FOR i IN MASTER_CNT-1	DOWNTO	0 				GENERATE
		MSM_gen_2	:	FOR j IN SM_size-1		DOWNTO	0 				GENERATE
			Master_MSM(i,j)	<=	MSM(i)(j);
		END GENERATE;
		all_reqs(i)	<=	Master_req(i);
		fre_reqs(i)	<=	Master_req(i) AND (NOT aswering(i));
	END GENERATE;
	--------------------------------------------------------------------------------------
	SSM_gen_1		:	FOR i IN SLAVE_CNT-1	DOWNTO	0				GENERATE
		SSM_gen_2	:	FOR j IN SM_size-1		DOWNTO	0				GENERATE
			Slave_SSM(i,j)	<=	SSM(i)(j);
		END GENERATE;
	END GENERATE;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	PROCESS(clk, rst)
		VARIABLE	req_cntr	:	INTEGER	RANGE 0 TO MASTER_CNT;
		VARIABLE	slv_cntr	:	INTEGER	RANGE 0 TO SLAVE_CNT;
		VARIABLE	destination	:	std_logic_vector(SLAVE_CNT-2		DOWNTO 0);
		VARIABLE	watch_dog	:	std_logic_vector(SLAVE_CNT*2		DOWNTO 0);
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
			destination		:=	(OTHERS	=>	'0');
			watch_dog		:=	(OTHERS	=>	'1');
		ELSIF clk = '1' AND clk'EVENT THEN
			CASE state IS
				WHEN	s_idle			=>	IF (prev_bussy = '1') AND (stop_in = '0') AND (fre_reqs /= (MASTER_CNT-1 DOWNTO 0 => '0')) THEN
												state							<=	s_finding_mstr;
												stop_out						<=	'1';
											END IF;
											destination							:=	(OTHERS	=>	'0');
											watch_dog							:=	(OTHERS	=>	'1');
											
				WHEN	s_finding_mstr	=>	IF  fre_reqs = (MASTER_CNT-1 DOWNTO 0 => '0') THEN	
												state							<=	s_idle;
											ELSE
												IF fre_reqs(req_cntr) = '0' THEN
													req_cntr					:=	req_cntr + 1;
													IF req_cntr = MASTER_CNT THEN
														req_cntr				:=	0;
													END IF;
												ELSE
													state						<=	s_finding_slv;
												END IF;
											END IF;
											stop_out							<=	'1';
											watch_dog							:=	(OTHERS	=>	'1');
											
				WHEN	s_finding_slv	=>	FOR i IN SLAVE_CNT-2 DOWNTO 0 LOOP
												IF	(unsigned(Adds(req_cntr))	>=	unsigned(Mins(i)))	AND
													(unsigned(Adds(req_cntr))	<=	unsigned(Maxs(i)))	THEN
													destination(i)				:=	'1';
												END IF;
											END LOOP;
											sig_dest							<=	destination;
											IF	destination 					= all_zero	THEN
												IF	taken(SLAVE_CNT-1)			=	'0'		THEN
													state						<=	s_connecting;
													slv_cntr					:=	SLAVE_CNT-1;
												END IF;
											ELSE
												FOR i IN SLAVE_CNT-2 DOWNTO 0 LOOP
													IF	(destination(i)			=	'1')	AND
														(taken(i)				=	'0')	THEN
														state						<=	s_connecting;
														slv_cntr					:=	i;
													END IF;
												END LOOP;
											END IF;
											watch_dog							:=	watch_dog(SLAVE_CNT*2-1	DOWNTO 0) & '0';
											IF UNSIGNED(watch_dog) = 0			THEN
												state							<=	s_finding_mstr;
												req_cntr						:=	req_cntr + 1;
												IF req_cntr = MASTER_CNT		THEN
													req_cntr					:=	0;
												END IF;
											END IF;
											
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
		--WAIT ON clk, rst;
	END PROCESS;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
end Behavioral;

