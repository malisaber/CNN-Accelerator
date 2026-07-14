
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.my_pack_v2.ALL;
USE IEEE.math_real.ALL;

entity TXDP is
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		
		-- Tx Buff:
		Tx_Buff_Din						:	IN	std_logic_vector(7	DOWNTO	0);
		
		--	Tx Config
		Tx_Conf_Top_Max					:	IN	std_logic_vector(15	DOWNTO	0);
		Tx_Conf_Clk_Div					:	IN	std_logic_vector(3	DOWNTO	0);
		
		--	Tx line
		Tx_Tx							:	OUT	std_logic;
		
		--	Tx Control Signals
		Tx_Cont_All_ini					:	IN	std_logic;
		Tx_Cont_Pip_load				:	IN	std_logic;
		Tx_Cont_Trn_en					:	IN	std_logic;
		Tx_Cont_Trn_end					:	OUT	std_logic);
end TXDP;

architecture Behavioral of TXDP is
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
	SIGNAL	Tx_Sign_Pip_Reg				:	std_logic_vector(7		DOWNTO	0);
	SIGNAL	Tx_Sign_Ser_Reg				:	std_logic_vector(9		DOWNTO	0);
	SIGNAL	Tx_Data_Val					:	std_logic_vector(7		DOWNTO	0);
	--------------------------------------------------------------------------
	SIGNAL	Tx_Sign_Div_Top				:	std_logic_vector(15		DOWNTO	0);
	SIGNAL	Tx_Cont_Bit_Max				:	std_logic_vector(3		DOWNTO	0);
	SIGNAL	Tx_Cont_Ser_load			:	std_logic;
	SIGNAL	Tx_Cont_Ser_load_in			:	std_logic;
	SIGNAL	Tx_Cont_All_ini_Regd		:	std_logic;
	--------------------------------------------------------------------------
	SIGNAL	Tx_Sign_Div_eq				:	std_logic;
	SIGNAL	Tx_Cont_Top_eq				:	std_logic;
	SIGNAL	Tx_Cont_Bit_eq				:	std_logic;
	--------------------------------------------------------------------------
	SIGNAL	Tx_Cont_Div_inc				:	std_logic;
	SIGNAL	Tx_Cont_Top_inc				:	std_logic;
	SIGNAL	Tx_Cont_Bit_inc				:	std_logic;
	--------------------------------------------------------------------------
	SIGNAL	Tx_Cont_Ini_edg				:	std_logic;
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
		ini								=>	Tx_Cont_All_ini,
		inc								=>	Tx_Cont_Div_inc,
		max								=>	Tx_Sign_Div_Top,
		Val								=>	OPEN,
		eq								=>	Tx_Sign_Div_eq);
	--------------------------------------------------------------------------
	Top_cntr							:	incr
	GENERIC	MAP(
		size							=>	16)
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		ini								=>	Tx_Cont_All_ini,
		inc								=>	Tx_Cont_Top_inc,
		max								=>	Tx_Conf_Top_Max,
		Val								=>	OPEN,
		eq								=>	Tx_Cont_Top_eq);
	--------------------------------------------------------------------------
	Bit_cntr							:	incr
	GENERIC	MAP(
		size							=>	4)
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		ini								=>	Tx_Cont_All_ini,
		inc								=>	Tx_Cont_Bit_inc,
		max								=>	Tx_Cont_Bit_Max,
		Val								=>	OPEN,
		eq								=>	Tx_Cont_Bit_eq);
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		Connections
	--------------------------------------------------------------------------
	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			Tx_Sign_Pip_Reg				<=	(OTHERS	=>	'0');
			Tx_Sign_Ser_Reg				<=	(OTHERS	=>	'0');
			Tx_Cont_Ser_load			<=	'0';
			Tx_Cont_All_ini_Regd		<=	'0';
		ELSIF clk = '1' AND clk'EVENT THEN
														Tx_Cont_Ser_load		<=	Tx_Cont_Ser_load_in;
														Tx_Cont_All_ini_Regd	<=	Tx_Cont_All_ini;
			IF Tx_Cont_Pip_load			= '1'	THEN	Tx_Sign_Pip_Reg			<=	Tx_Buff_Din;						END IF;
			IF Tx_Cont_Ser_load			= '1'	THEN	Tx_Sign_Ser_Reg			<=	Tx_Data_Val & "01";					END IF;
			IF Tx_Cont_Bit_inc			= '1'	THEN	Tx_Sign_Ser_Reg			<=	'1' & Tx_Sign_Ser_Reg(9 DOWNTO 1);	END IF;
		END IF;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS (Tx_Conf_Clk_Div)
	BEGIN
		CASE Tx_Conf_Clk_Div IS
			WHEN	"0000"				=>	Tx_Sign_Div_Top	<=	X"0000";
			WHEN	"0001"				=>	Tx_Sign_Div_Top	<=	X"0001";
			WHEN	"0010"				=>	Tx_Sign_Div_Top	<=	X"0003";
			WHEN	"0011"				=>	Tx_Sign_Div_Top	<=	X"0007";
			WHEN	"0100"				=>	Tx_Sign_Div_Top	<=	X"000F";
			WHEN	"0101"				=>	Tx_Sign_Div_Top	<=	X"001F";
			WHEN	"0110"				=>	Tx_Sign_Div_Top	<=	X"003F";
			WHEN	"0111"				=>	Tx_Sign_Div_Top	<=	X"007F";
			WHEN	"1000"				=>	Tx_Sign_Div_Top	<=	X"00FF";
			WHEN	"1001"				=>	Tx_Sign_Div_Top	<=	X"01FF";
			WHEN	"1010"				=>	Tx_Sign_Div_Top	<=	X"03FF";
			WHEN	"1011"				=>	Tx_Sign_Div_Top	<=	X"07FF";
			WHEN	"1100"				=>	Tx_Sign_Div_Top	<=	X"0FFF";
			WHEN	"1101"				=>	Tx_Sign_Div_Top	<=	X"1FFF";
			WHEN	"1110"				=>	Tx_Sign_Div_Top	<=	X"3FFF";
			WHEN	"1111"				=>	Tx_Sign_Div_Top	<=	X"7FFF";
			WHEN	OTHERS				=>	Tx_Sign_Div_Top	<=	X"FFFF";
		END CASE;		
	END PROCESS;
	--------------------------------------------------------------------------
	Tx_Tx								<=	Tx_Sign_Ser_Reg(0);
	--------------------------------------------------------------------------
	Tx_Data_Val							<=	Tx_Sign_Pip_Reg;
	--------------------------------------------------------------------------
	Tx_Cont_Ser_load_in					<=	Tx_Cont_Ini_edg;
	--------------------------------------------------------------------------
	Tx_Cont_Ini_edg						<=	(NOT Tx_Cont_All_ini)	AND Tx_Cont_All_ini_Regd;
	--------------------------------------------------------------------------
	Tx_Cont_Bit_Max						<=	"1001";
	--------------------------------------------------------------------------
	Tx_Cont_Div_inc						<=	Tx_Cont_Trn_en;
	Tx_Cont_Top_inc						<=	Tx_Cont_Trn_en	AND Tx_Sign_Div_eq;
	Tx_Cont_Bit_inc						<=	Tx_Cont_Trn_en	AND Tx_Sign_Div_eq	AND	Tx_Cont_Top_eq;
	Tx_Cont_Trn_end						<=	Tx_Cont_Trn_en	AND Tx_Sign_Div_eq	AND	Tx_Cont_Top_eq	AND	Tx_Cont_Bit_eq;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
end Behavioral;



