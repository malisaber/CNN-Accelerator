
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.my_pack_v2.ALL;
USE IEEE.math_real.ALL;

entity RXDP is
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
end RXDP;

architecture Behavioral of RXDP is
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		COMPONENTs
	--------------------------------------------------------------------------
	COMPONENT	incr
	GENERIC(
		size							:	INTEGER	:=	4);
	PORT(					
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		ini								:	IN	std_logic;
		inc								:	IN	std_logic;
		max								:	IN	std_logic_vector(size-1 DOWNTO 0);
		Val								:	OUT	std_logic_vector(size-1 DOWNTO 0);
		eq								:	OUT	std_logic);
	END COMPONENT;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		SIGNALS
	--------------------------------------------------------------------------
	SIGNAL	Rx_Sign_Ser_Reg				:	std_logic_vector(9		DOWNTO	0);
	--------------------------------------------------------------------------
	SIGNAL	Rx_Sign_Div_Top				:	std_logic_vector(15		DOWNTO	0);
	SIGNAL	Rx_Cont_Bit_Max				:	std_logic_vector(3		DOWNTO	0);
	--------------------------------------------------------------------------
	SIGNAL	Rx_Sign_Div_eq				:	std_logic;
	SIGNAL	Rx_Cont_Top_eq				:	std_logic;
	SIGNAL	Rx_Cont_Bit_eq				:	std_logic;
	--------------------------------------------------------------------------
	SIGNAL	Rx_Cont_Div_inc				:	std_logic;
	SIGNAL	Rx_Cont_Top_inc				:	std_logic;
	SIGNAL	Rx_Cont_Bit_inc				:	std_logic;
	--------------------------------------------------------------------------
	SIGNAL	Rx_Sign_Ser_shift			:	std_logic;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
begin
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		INSTANCES
	--------------------------------------------------------------------------
	Div_cntr							:	incr
	GENERIC	MAP(
		size							=>	16)
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		ini								=>	Rx_Cont_All_ini,
		inc								=>	Rx_Cont_Div_inc,
		max								=>	Rx_Sign_Div_Top,
		Val								=>	OPEN,
		eq								=>	Rx_Sign_Div_eq);
	--------------------------------------------------------------------------
	Top_cntr							:	incr
	GENERIC	MAP(
		size							=>	16)
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		ini								=>	Rx_Cont_All_ini,
		inc								=>	Rx_Cont_Top_inc,
		max								=>	Rx_Conf_Top_Max,
		Val								=>	OPEN,
		eq								=>	Rx_Cont_Top_eq);
	--------------------------------------------------------------------------
	Bit_cntr							:	incr
	GENERIC	MAP(
		size							=>	4)
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		ini								=>	Rx_Cont_All_ini,
		inc								=>	Rx_Cont_Bit_inc,
		max								=>	Rx_Cont_Bit_Max,
		Val								=>	OPEN,
		eq								=>	Rx_Cont_Bit_eq);
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		Connections
	--------------------------------------------------------------------------
	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			Rx_Sign_Ser_Reg				<=	(OTHERS	=>	'0');
		ELSIF clk = '1' AND clk'EVENT THEN
			IF Rx_Sign_Ser_shift		= '1'	THEN	Rx_Sign_Ser_Reg			<=	Rx_Rx & Rx_Sign_Ser_Reg(9 DOWNTO 1);	END IF;
		END IF;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS (Rx_Conf_Clk_Div)
	BEGIN
		CASE Rx_Conf_Clk_Div IS
			WHEN	"0000"				=>	Rx_Sign_Div_Top	<=	X"0000";
			WHEN	"0001"				=>	Rx_Sign_Div_Top	<=	X"0001";
			WHEN	"0010"				=>	Rx_Sign_Div_Top	<=	X"0003";
			WHEN	"0011"				=>	Rx_Sign_Div_Top	<=	X"0007";
			WHEN	"0100"				=>	Rx_Sign_Div_Top	<=	X"000F";
			WHEN	"0101"				=>	Rx_Sign_Div_Top	<=	X"001F";
			WHEN	"0110"				=>	Rx_Sign_Div_Top	<=	X"003F";
			WHEN	"0111"				=>	Rx_Sign_Div_Top	<=	X"007F";
			WHEN	"1000"				=>	Rx_Sign_Div_Top	<=	X"00FF";
			WHEN	"1001"				=>	Rx_Sign_Div_Top	<=	X"01FF";
			WHEN	"1010"				=>	Rx_Sign_Div_Top	<=	X"03FF";
			WHEN	"1011"				=>	Rx_Sign_Div_Top	<=	X"07FF";
			WHEN	"1100"				=>	Rx_Sign_Div_Top	<=	X"0FFF";
			WHEN	"1101"				=>	Rx_Sign_Div_Top	<=	X"1FFF";
			WHEN	"1110"				=>	Rx_Sign_Div_Top	<=	X"3FFF";
			WHEN	"1111"				=>	Rx_Sign_Div_Top	<=	X"7FFF";
			WHEN	OTHERS				=>	Rx_Sign_Div_Top	<=	X"FFFF";
		END CASE;		
	END PROCESS;
	--------------------------------------------------------------------------
	Rx_Cont_Bit_Max						<=	"1001";
	--------------------------------------------------------------------------
	Rx_Cont_Div_inc						<=	Rx_Cont_Res_en;
	Rx_Cont_Top_inc						<=	Rx_Cont_Res_en	AND Rx_Sign_Div_eq;
	Rx_Cont_Bit_inc						<=	Rx_Cont_Res_en	AND Rx_Sign_Div_eq	AND	Rx_Cont_Top_eq;
	Rx_Cont_Res_end						<=	Rx_Cont_Res_en	AND Rx_Sign_Div_eq	AND	Rx_Cont_Top_eq	AND	Rx_Cont_Bit_eq;
	Rx_Sign_Ser_shift					<=	Rx_Cont_Bit_inc;
	--------------------------------------------------------------------------
	Rx_Buff_Dout						<=	Rx_Sign_Ser_Reg(9 DOWNTO 1);
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
end Behavioral;




