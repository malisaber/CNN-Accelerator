library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE work.my_pack_v2.ALL;

entity Control_Status_Box is
	GENERIC(
		BASE_ADDRESS					:	INTEGER	:=	to_integer(SIGNED(X_check(X"FFFF0000"))));
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		
		--	MAIN PORT
		MAIN_PORT_Dot_Rdy				:	OUT	std_logic;
		MAIN_PORT_SEL_This				:	OUT	std_logic;
		MAIN_PORT_Address				:	IN	std_logic_vector(31	DOWNTO	0);
		MAIN_PORT_Data_in				:	IN	std_logic_vector(31	DOWNTO	0);
		MAIN_PORT_WEN					:	IN	std_logic;
		MAIN_PORT_OEN					:	IN	std_logic;
		MAIN_PORT_Data_out				:	OUT	std_logic_vector(31	DOWNTO	0);
		
		--	ACCELERATOR
		ACCELERATOR_P0_rstb				:	OUT	std_logic;
		ACCELERATOR_P1_rstb				:	OUT	std_logic;
		ACCELERATOR_P2_rstb				:	OUT	std_logic;
		ACCELERATOR_P3_rstb				:	OUT	std_logic;
		ACCELERATOR_CONNECT				:	OUT	std_logic);
end Control_Status_Box;

architecture Behavioral of Control_Status_Box is
	--------------------------------------------------------------------------
	--		CONSTANTs
	--------------------------------------------------------------------------
	CONSTANT	NUMB_ints				:	INTEGER	:=	4;
	CONSTANT	ENDx_ADDRESS			:	INTEGER	:=	BASE_ADDRESS + 4*NUMB_ints;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		ADDRESS	MAP		8 TIMERs										--
	--------------------------------------------------------------------------
	--		Address						:									--
	--		BA	+	0					:	Status And Control				--
	--		BA	+	4					:	RESERVED						--
	--		BA	+	8					:	RESERVED						--
	--		BA	+	C					:	RESERVED						--
	--------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------------------------
	--	Control 	(Write Only)
	--	O	|	31	|	30		29		28		27		26		25		24		23		22		21	 	20	 	19		18		17		16	|
	--	N	|Connect|======================================================= RESERVED ======================================================|
	--	T	
	--	R	
	--	O	|	15		14		13		12		11		10		9		8		7		6		5		4	|	3	|	2	|	1	|	0	|
	--	L	|========================================================== RESERVED ===========================| RST 3 | RST 2 | RST 1 | RST 0 |
	--
	-----------------------------------------------------------------------------------------------------------------------------------------
	--	RESERVED
	--	E	|	31		30		29		28		27		26		25		24		23		22		21		20		19		18		17		16	|
	--	S	|=========================================================== RESERVED ==========================================================|
	--	E	 
	--	R	
	--	V	|	15		14		13		12		11		10		9		8		7		6		5		4		3		2		1		0	|
	--	E	|=========================================================== RESERVED ==========================================================|
	--	D
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		SIGNALs
	--------------------------------------------------------------------------
	SIGNAL	mem							:	std_logic_vector(4	DOWNTO	0);
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
begin
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	PROCESS(clk, rst)
		VARIABLE	add					:	INTEGER;
		VARIABLE	Eadd				:	INTEGER;
	BEGIN
		IF rst = '1' THEN
			mem							<=	(OTHERS	=>	'0');
		ELSIF clk = '1' AND clk'EVENT THEN
			add							:=	to_integer(SIGNED(X_check(MAIN_PORT_Address)));
			Eadd						:=	(add/4) - (BASE_ADDRESS/4);
			IF MAIN_PORT_WEN = '1' AND add >= BASE_ADDRESS AND add < ENDx_ADDRESS THEN 
				--mem(Eadd)				<=	MAIN_PORT_Data_in(31	DOWNTO	30)	&	MAIN_PORT_Data_in(15);
				IF Eadd = 0 THEN
					mem					<=	MAIN_PORT_Data_in(31) & MAIN_PORT_Data_in(3	DOWNTO	0);
				END IF;
			END IF;
		END IF;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS(MAIN_PORT_Address, MAIN_PORT_OEN, mem)
		VARIABLE	add					:	INTEGER;
		VARIABLE	Eadd				:	INTEGER;
	BEGIN
		add								:=	to_integer(SIGNED(X_check(MAIN_PORT_Address)));
		Eadd							:=	(add/4) - (BASE_ADDRESS/4);
		IF MAIN_PORT_OEN = '1' AND add  >= BASE_ADDRESS AND add < ENDx_ADDRESS THEN 
			IF Eadd = 0 THEN
				MAIN_PORT_Data_out		<=	mem(4) & "000" & "0000" & "0000" & "0000" & "0000" & "0000" & "0000" & mem(3	DOWNTO	0);
			ELSE
				MAIN_PORT_Data_out		<=	(OTHERS	=>	'0');
			END IF;
		ELSE
			MAIN_PORT_Data_out			<=	(OTHERS	=>	'Z');
		END IF;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS(MAIN_PORT_Address, MAIN_PORT_OEN)
		VARIABLE	add					:	INTEGER;
	BEGIN
		add								:=	to_integer(SIGNED(X_check(MAIN_PORT_Address)));
		IF add  >= BASE_ADDRESS AND add < ENDx_ADDRESS THEN
			MAIN_PORT_Dot_Rdy			<=	MAIN_PORT_OEN;
			MAIN_PORT_SEL_This			<=	'1';
		ELSE
			MAIN_PORT_Dot_Rdy			<=	'0';
			MAIN_PORT_SEL_This			<=	'0';
		END IF;
	END PROCESS;
	--------------------------------------------------------------------------
	ACCELERATOR_P0_rstb					<=	mem(0);
	ACCELERATOR_P1_rstb					<=	mem(1);
	ACCELERATOR_P2_rstb					<=	mem(2);
	ACCELERATOR_P3_rstb					<=	mem(3);
	ACCELERATOR_CONNECT					<=	mem(4);
	--------------------------------------------------------------------------
end Behavioral;



