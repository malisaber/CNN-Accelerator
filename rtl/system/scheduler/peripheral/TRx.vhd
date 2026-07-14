
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.my_pack_v2.ALL;
USE IEEE.math_real.ALL;

entity TRx is
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		
		-- Tx Buff:
		------	OUT
		Rx_Buff_Dout					:	OUT	std_logic_vector(8	DOWNTO	0);
		Rx_Buff_Push					:	OUT	std_logic;
		------	IN
		Tx_Buff_Din						:	IN	std_logic_vector(7	DOWNTO	0);
		Tx_Buff_Empty					:	IN	std_logic;
		Tx_Buff_Pop						:	OUT	std_logic;
		
		--	Tx Config
		TR_Conf_Top_max					:	IN	std_logic_vector(15	DOWNTO	0);
		TR_Conf_Clk_Div					:	IN	std_logic_vector(3	DOWNTO	0);
		Tx_Conf_Enable					:	IN	std_logic;
		Rx_Conf_Enable					:	IN	std_logic;
		
		--	Tx line
		Rx_Rx							:	IN	std_logic;
		Tx_Tx							:	OUT	std_logic);
end TRx;

architecture Behavioral of TRx is
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		COMPONENTS
	--------------------------------------------------------------------------
	COMPONENT							RX
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		-- Tx Buff:
		Rx_Buff_Dout					:	OUT	std_logic_vector(8	DOWNTO	0);
		Rx_Buff_Push					:	OUT	std_logic;
		--	Tx Config
		Rx_Conf_Top_max					:	IN	std_logic_vector(15	DOWNTO	0);
		Rx_Conf_Clk_Div					:	IN	std_logic_vector(3	DOWNTO	0);
		Rx_Conf_Enable					:	IN	std_logic;
		--	Tx line
		Rx_Rx							:	IN	std_logic);
	END	COMPONENT;
	--------------------------------------------------------------------------
	COMPONENT							TX
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
	END	COMPONENT;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
begin
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		INSTANCEs
	--------------------------------------------------------------------------
	RX_unit								:	RX
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		-- Tx Buff:
		Rx_Buff_Dout					=>	Rx_Buff_Dout,
		Rx_Buff_Push					=>	Rx_Buff_Push,
		--	Tx Config
		Rx_Conf_Top_max					=>	TR_Conf_Top_max,
		Rx_Conf_Clk_Div					=>	TR_Conf_Clk_Div,
		Rx_Conf_Enable					=>	Rx_Conf_Enable,
		--	Tx line
		Rx_Rx							=>	Rx_Rx);
	--------------------------------------------------------------------------
	TX_unit								:	TX
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		-- Tx Buff:
		Tx_Buff_Din						=>	Tx_Buff_Din,
		Tx_Buff_Empty					=>	Tx_Buff_Empty,
		Tx_Buff_Pop						=>	Tx_Buff_Pop,
		--	Tx Config
		Tx_Conf_Top_max					=>	TR_Conf_Top_max,
		Tx_Conf_Clk_Div					=>	TR_Conf_Clk_Div,
		Tx_Conf_Enable					=>	Tx_Conf_Enable,
		--	Tx line
		Tx_Tx							=>	Tx_Tx);
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
end Behavioral;



