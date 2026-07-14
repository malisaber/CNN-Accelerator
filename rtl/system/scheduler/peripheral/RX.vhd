
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.my_pack_v2.ALL;
USE IEEE.math_real.ALL;

entity RX is
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
end RX;

architecture Behavioral of RX is
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		COMPONENTS
	--------------------------------------------------------------------------
	COMPONENT							RXDP
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		-- Tx Buff:
		Rx_Buff_Dout					:	OUT	std_logic_vector(8	DOWNTO	0);
		--	Tx Config
		Rx_Conf_Top_Max					:	IN	std_logic_vector(15	DOWNTO	0);
		Rx_Conf_Clk_Div					:	IN	std_logic_vector(3	DOWNTO	0);
		--	Tx line
		Rx_Rx							:	IN	std_logic;
		--	Tx Control Signals
		Rx_Cont_All_ini					:	IN	std_logic;
		Rx_Cont_Res_en					:	IN	std_logic;
		Rx_Cont_Res_end					:	OUT	std_logic);
	END	COMPONENT;
	--------------------------------------------------------------------------
	COMPONENT							RXCU
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
	END	COMPONENT;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		SIGNALS
	--------------------------------------------------------------------------
	SIGNAL	Rx_Cont_All_ini				:	std_logic;
	SIGNAL	Rx_Cont_Res_en				:	std_logic;
	SIGNAL	Rx_Cont_Res_end				:	std_logic;
	SIGNAL	Rx_Cont_Stp_bit				:	std_logic;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
begin
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		INSTANCEs
	--------------------------------------------------------------------------
	RXDP_unit							:	RXDP
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		-- Tx Buff:
		Rx_Buff_Dout					=>	Rx_Buff_Dout,
		--	Tx Config
		Rx_Conf_Top_Max					=>	Rx_Conf_Top_Max,
		Rx_Conf_Clk_Div					=>	Rx_Conf_Clk_Div,
		--	Tx line
		Rx_Rx							=>	Rx_Rx,
		--	Tx Control Signals
		Rx_Cont_All_ini					=>	Rx_Cont_All_ini,
		Rx_Cont_Res_en					=>	Rx_Cont_Res_en,
		Rx_Cont_Res_end					=>	Rx_Cont_Res_end);
	--------------------------------------------------------------------------
	RXCU_unit							:	RXCU
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		-- Tx Buff:
		Rx_Buff_Push					=>	Rx_Buff_Push,
		--	Tx Config
		Rx_Conf_Enable					=>	Rx_Conf_Enable,
		--	Tx line
		Rx_Rx							=>	Rx_Rx,
		--	Tx Control Signals
		Rx_Cont_All_ini					=>	Rx_Cont_All_ini,
		Rx_Cont_Res_en					=>	Rx_Cont_Res_en,
		Rx_Cont_Res_end					=>	Rx_Cont_Res_end);
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
end Behavioral;



