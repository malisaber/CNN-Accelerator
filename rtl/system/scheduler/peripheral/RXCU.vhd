
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.my_pack_v2.ALL;
USE IEEE.math_real.ALL;

entity RXCU is
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		
		-- Tx Buff:
		Rx_Buff_Push					:	OUT	std_logic;
		
		--	Tx Config
		Rx_Conf_Enable					:	IN	std_logic;
		
		--	Tx line
		Rx_Rx							:	IN	std_logic;
		
		--	Tx Control Signals
		Rx_Cont_All_ini					:	OUT	std_logic;
		Rx_Cont_Res_en					:	OUT	std_logic;
		Rx_Cont_Res_end					:	IN	std_logic);
end RXCU;
 
architecture Behavioral of RXCU is 
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		TYPEs
	--------------------------------------------------------------------------
	TYPE	FSM							IS	(idle, Rece, comp, save);
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
	PROCESS (P_S, Cond_Start, Rx_Cont_Res_end)
	BEGIN
		N_S								<=	P_S;
		CASE P_S IS
			WHEN	idle				=>	IF	Cond_Start = '1'		THEN	N_S	<=	Rece;		END IF;
			WHEN	Rece				=>	IF	Rx_Cont_Res_end = '1'	THEN	N_S	<=	comp;		END IF;
			WHEN	comp				=>										N_S	<=	save;
			WHEN	save				=>										N_S	<=	idle;
		END CASE;			
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS (P_S)
	BEGIN
		Rx_Cont_All_ini					<=	'0';
		Rx_Cont_Res_en					<=	'0';
		Rx_Buff_Push					<=	'0';
		
		CASE P_S IS
			WHEN	idle				=>	Rx_Cont_All_ini		<=	'1';
			WHEN	Rece				=>	Rx_Cont_Res_en		<=	'1';
			WHEN	comp				=>	NULL;
			WHEN	save				=>	Rx_Buff_Push		<=	'1';
		END CASE;			
	END PROCESS;
	--------------------------------------------------------------------------
	Cond_Start							<=	(NOT Rx_Rx) AND Rx_Conf_Enable;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
end Behavioral;



