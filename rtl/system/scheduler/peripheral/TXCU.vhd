
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.my_pack_v2.ALL;
USE IEEE.math_real.ALL;

entity TXCU is
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		
		-- Tx Buff:
		Tx_Buff_Empty					:	IN	std_logic;
		Tx_Buff_Pop						:	OUT	std_logic;
		
		--	Tx Config
		Tx_Conf_Enable					:	IN	std_logic;
		
		--	Tx Control Signals
		Tx_Cont_All_ini					:	OUT	std_logic;
		Tx_Cont_Pip_load				:	OUT	std_logic;
		Tx_Cont_Trn_en					:	OUT	std_logic;
		Tx_Cont_Trn_end					:	IN	std_logic);
end TXCU;

architecture Behavioral of TXCU is
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		TYPEs
	--------------------------------------------------------------------------
	TYPE	FSM							IS	(idle, pop, trans);
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		SIGNALS
	--------------------------------------------------------------------------
	SIGNAL	P_S							:	FSM;
	SIGNAL	N_S							:	FSM;
	SIGNAL	Cond_Start					:	std_logic;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
begin
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		SIGNALING
	--------------------------------------------------------------------------
	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			P_S							<=	idle;
		ELSIF clk = '1' AND clk'EVENT THEN
			P_S							<=	N_S;
		END IF;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS (P_S, Cond_Start, Tx_Cont_Trn_end)
	BEGIN
		N_S								<=	P_S;
		CASE P_S IS
			WHEN	idle				=>	IF	Cond_Start = '1'		THEN	N_S	<=	pop;		END IF;
			WHEN	pop					=>										N_S	<=	trans;
			WHEN	trans				=>	IF	Tx_Cont_Trn_end = '1'	THEN	N_S	<=	idle;		END IF;
		END CASE;			
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS (P_S)
	BEGIN
		Tx_Cont_All_ini					<=	'0';
		Tx_Buff_Pop						<=	'0';
		Tx_Cont_Pip_load				<=	'0';
		Tx_Cont_Trn_en					<=	'0';
		
		CASE P_S IS
			WHEN	idle				=>	Tx_Cont_All_ini		<=	'1';
			WHEN	pop					=>	Tx_Cont_All_ini		<=	'1';
											Tx_Buff_Pop			<=	'1';
											Tx_Cont_Pip_load	<=	'1';
			WHEN	trans				=>	Tx_Cont_Trn_en		<=	'1';
		END CASE;			
	END PROCESS;
	--------------------------------------------------------------------------
	Cond_Start							<=	(NOT Tx_Buff_Empty) AND Tx_Conf_Enable;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
end Behavioral;



