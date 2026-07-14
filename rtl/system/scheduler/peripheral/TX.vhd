
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.my_pack_v2.ALL;
USE IEEE.math_real.ALL;

entity TX is
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		
		-- Tx Buff:
		Tx_Buff_Din						:	IN	std_logic_vector(7	DOWNTO	0);
		Tx_Buff_Empty					:	IN	std_logic;
		Tx_Buff_Pop						:	OUT	std_logic;
		
		--	Tx Config
		Tx_Conf_Top_max					:	IN	std_logic_vector(15	DOWNTO	0);
		Tx_Conf_Clk_Div					:	IN	std_logic_vector(3	DOWNTO	0);
		Tx_Conf_Enable					:	IN	std_logic;
		
		--	Tx line
		Tx_Tx							:	OUT	std_logic);
end TX;

architecture Behavioral of TX is
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		COMPONENTS
	--------------------------------------------------------------------------
	COMPONENT							TXDP 
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		-- Tx Buff:
		Tx_Buff_Din						:	IN	std_logic_vector(7	DOWNTO	0);
		--	Tx Config
		Tx_Conf_Top_max					:	IN	std_logic_vector(15	DOWNTO	0);
		Tx_Conf_Clk_Div					:	IN	std_logic_vector(3	DOWNTO	0);
		--	Tx line
		Tx_Tx							:	OUT	std_logic;
		--	Tx Control Signals
		Tx_Cont_All_ini					:	IN	std_logic;
		Tx_Cont_Pip_load				:	IN	std_logic;
		Tx_Cont_Trn_en					:	IN	std_logic;
		Tx_Cont_Trn_end					:	OUT	std_logic);
	END	COMPONENT;
	--------------------------------------------------------------------------
	COMPONENT							TXCU
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
	END	COMPONENT;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		SIGNALS
	--------------------------------------------------------------------------
	SIGNAL	Tx_Cont_All_ini				:	std_logic;
	SIGNAL	Tx_Cont_Pip_load			:	std_logic;
	SIGNAL	Tx_Cont_Trn_en				:	std_logic;
	SIGNAL	Tx_Cont_Trn_end				:	std_logic;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
begin
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		INSTANCEs
	--------------------------------------------------------------------------
	TXDP_unit							:	TXDP
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		-- Tx Buff:
		Tx_Buff_Din						=>	Tx_Buff_Din,
		--	Tx Config
		Tx_Conf_Top_max					=>	Tx_Conf_Top_max,
		Tx_Conf_Clk_Div					=>	Tx_Conf_Clk_Div,
		--	Tx line
		Tx_Tx							=>	Tx_Tx,
		--	Tx Control Signals
		Tx_Cont_All_ini					=>	Tx_Cont_All_ini,
		Tx_Cont_Pip_load				=>	Tx_Cont_Pip_load,
		Tx_Cont_Trn_en					=>	Tx_Cont_Trn_en,
		Tx_Cont_Trn_end					=>	Tx_Cont_Trn_end);
	--------------------------------------------------------------------------
	TXCU_unit							:	TXCU
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		-- Tx Buff:
		Tx_Buff_Empty					=>	Tx_Buff_Empty,
		Tx_Buff_Pop						=>	Tx_Buff_Pop,
		--	Tx Config
		Tx_Conf_Enable					=>	Tx_Conf_Enable,
		--	Tx Control Signals
		Tx_Cont_All_ini					=>	Tx_Cont_All_ini,
		Tx_Cont_Pip_load				=>	Tx_Cont_Pip_load,
		Tx_Cont_Trn_en					=>	Tx_Cont_Trn_en,
		Tx_Cont_Trn_end					=>	Tx_Cont_Trn_end);
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
end Behavioral;



