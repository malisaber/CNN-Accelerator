library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.my_pack_v2.ALL;
USE IEEE.math_real.ALL;

entity CNT_FSM_0 is
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		Enable							:	IN	std_logic;
		--	Status Signals
		start							:	IN	std_logic;
		CNT_PEs_PAUSE					:	IN	std_logic;
		Zpad_eq							:	IN	std_logic;
		Kern_eq							:	IN	std_logic;
		Colm_eq							:	IN	std_logic;
		Chan_eq							:	IN	std_logic;
		Rows_eq							:	IN	std_logic;
		Cntr_eq							:	IN	std_logic;
		GBMs_eq							:	IN	std_logic;
		all_updated						:	IN	std_logic;
		CMD_STA_ACK						:	IN	std_logic;
		pipo_ready						:	IN	std_logic;
		--	Control Signals
		ini								:	OUT	std_logic;
		Zpad_inc						:	OUT	std_logic;
		Kern_inc						:	OUT	std_logic;
		Colm_inc						:	OUT	std_logic;
		Chan_inc						:	OUT	std_logic;
		Rows_inc						:	OUT	std_logic;
		Cntr_inc						:	OUT	std_logic;
		Bank_inc						:	OUT	std_logic;
		GBMs_inc						:	OUT	std_logic;
		SHR_enable						:	OUT	std_logic;
		SHR_clear						:	OUT	std_logic;
		PIPR_enable						:	OUT	std_logic;
		OBUF_set						:	OUT	std_logic;
		OBUF_clr						:	OUT	std_logic;
		inject_zero						:	OUT	std_logic;
		swap_ifm						:	OUT	std_logic;
		clr_flag						:	OUT	std_logic;
		PingPong						:	OUT	std_logic;
		SA_start						:	OUT	std_logic;
		done							:	OUT	std_logic);
end CNT_FSM_0;

architecture Behavioral of CNT_FSM_0 is
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		TYPE
	--------------------------------------------------------------------------
	TYPE	FSM							IS	(L0, L1, L2, L3, L4, L5, L6, L7, L8, L9);
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		SIGNALS
	--------------------------------------------------------------------------
	SIGNAL	P_S							:	FSM;
	SIGNAL	N_S							:	FSM;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
begin
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		IMPLEMENTATION
	--------------------------------------------------------------------------
	PROCESS	(clk, rst)
	BEGIN
		IF rst = '1' THEN
			P_S							<=	L0;
		ELSIF clk = '1' AND clk'EVENT THEN
			IF	Enable = '1'			THEN
				IF	CNT_PEs_PAUSE = '0'	THEN
					P_S					<=	N_S;
				END IF;
			ELSE
				P_S						<=	L0;
			END IF;
		END IF;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS(	P_S,			start,			Zpad_eq,		Kern_eq,	
				Colm_eq,		Chan_eq,		Rows_eq,		Cntr_eq,	
				GBMs_eq,		all_updated,	CMD_STA_ACK,	pipo_ready)
	BEGIN
		N_S								<=	P_S;
		CASE	P_S	IS
			WHEN	L0					=>									N_S	<=	L1;
			WHEN	L1					=>	IF	start = '1'			THEN	N_S	<=	L2;						END IF;
			WHEN	L2					=>	IF	all_updated = '1'	THEN	N_S	<=	L3;						END IF;
			WHEN	L3					=>									N_S	<=	L4;
			WHEN	L4					=>	IF	Kern_eq = '1'		THEN	N_S	<=	L5;						END IF;
			WHEN	L5					=>	IF	Colm_eq = '0'		THEN	N_S	<=	L3;	ELSE	N_S	<=	L6;	END	IF;
			WHEN	L6					=>	IF	Chan_eq = '0'		THEN	N_S	<=	L3;	ELSE	N_S	<=	L7;	END	IF;
			WHEN	L7					=>	IF	pipo_ready = '1'	THEN	N_S	<=	L8;	ELSE	N_S	<=	L7;	END IF;
			WHEN	L8					=>	IF	Rows_eq = '0'		THEN	N_S	<=	L2;	ELSE	N_S	<=	L9;	END	IF;
			WHEN	L9					=>									N_S	<=	L1;
		END CASE;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS(	P_S,		start,		Zpad_eq,	Kern_eq,	Colm_eq,	
				Chan_eq,	Rows_eq,	Cntr_eq,	GBMs_eq,	all_updated)
	BEGIN
		ini								<=	'0';
		Zpad_inc						<=	'0';
		Kern_inc						<=	'0';
		Colm_inc						<=	'0';
		Chan_inc						<=	'0';
		Rows_inc						<=	'0';
		Cntr_inc						<=	'0';
		Bank_inc						<=	'0';
		GBMs_inc						<=	'0';
		SHR_enable						<=	'0';
		SHR_clear						<=	'0';
		PIPR_enable						<=	'0';
		OBUF_set						<=	'0';
		OBUF_clr						<=	'0';
		inject_zero						<=	'0';
		swap_ifm						<=	'0';
		clr_flag						<=	'0';
		PingPong						<=	'0';
		SA_start						<=	'0';
		done							<=	'0';
		CASE	P_S	IS
			WHEN	L0					=>	ini			<=	'1';
			WHEN	L1					=>	SHR_clear	<=	'1';
											done		<=	'1';
			WHEN	L2					=>	OBUF_clr	<=	'1';
			WHEN	L3					=>	SHR_enable	<=	'1';
			WHEN	L4					=>	Kern_inc	<=	'1';
											PIPR_enable	<=	'1';
			WHEN	L5					=>	Colm_inc	<=	'1';
			WHEN	L6					=>	Chan_inc	<=	'1';
											OBUF_set	<=	'1';
											SHR_clear	<=	'1';
			WHEN	L7					=>	SA_start	<=	'1';
			WHEN	L8					=>	Rows_inc	<=	'1';
											Bank_inc	<=	'1';
											clr_flag	<=	'1';
											PingPong	<=	'1';
											done		<=	'1';
			WHEN	L9					=>	done		<=	'1';
		END CASE;
	END PROCESS;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
end Behavioral;

