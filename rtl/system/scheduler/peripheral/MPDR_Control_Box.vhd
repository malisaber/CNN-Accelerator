library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE work.my_pack_v2.ALL;

entity MPDR_Control_Box is
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
		
		--	MPDR
		CMD_MPDR_start					:	OUT	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	--(flag)
		CMD_MPDR_load					:	OUT	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	--(flag)
		CMD_MPDR_Addresses				:	OUT	std_logic_vector	(P_USA_Add_size-1	DOWNTO 0);
		CMD_MPDR_Target					:	OUT std_logic_vector	(2					DOWNTO 0);
		CMD_MPDR_Base_Wen				:	OUT	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	--(flag)
		CMD_MPDR_Cont_Wen				:	OUT	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	--(flag)
		CMD_MPDR_IVal_Wen				:	OUT	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	--(flag)
		CMD_MPDR_MAX_Col				:	OUT	std_logic_vector	(P_column_size-1	DOWNTO 0);
		CMD_MPDR_MAX_Chn				:	OUT	std_logic_vector	(P_channel_size-1	DOWNTO 0));
end MPDR_Control_Box;

architecture Behavioral of MPDR_Control_Box is
	--------------------------------------------------------------------------
	--		CONSTANTs
	--------------------------------------------------------------------------
	CONSTANT	NUMB_ints				:	INTEGER	:=	4;
	CONSTANT	ENDx_ADDRESS			:	INTEGER	:=	BASE_ADDRESS + 4*NUMB_ints;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--	Address
	--	d	|	31		30		29		28		27		26		25		24		23		22		21	 	20	 	19		18		17		16	 |
	--	d	|=========================================================== Address ============================================================|
	--	r	
	--	e	
	--	s	|	15		14		13		12		11		10		9		8		7		6		5		4		3		2		1		0	 |
	--	s	|=========================================================== Address ============================================================|
	--
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--	Config Register
	--	N	|	31		30		29		28	|	27		26		25		24		23		22		21	 	20	 	19		18		17		16	 |
	--	F	|========= Unit Address ========|=========================================== RESERVED ===========================================|
	--		
	--	R	
	--	E	|	15		14		13		12		11		10		9		8		7		6	|	5	|	4	|	3	|	2		1		0	 |
	--	G	|=================================== RESERVED ==================================|BA Wen |CA Wen |IA Wen |======= Target =========|
	--
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--	Control
	--	O	|	31		30		29		28	|	27		26		25		24		23		22		21	 	20	 	19		18		17		16	 |
	--	N	|========= Unit Address ========|============================================ RESERVED ==========================================|
	--	T	
	--	R	
	--	O	|	15		14		13		12		11	|	10	|	9	|	8	|	7		6		5		4	|	3		2		1		0	 |
	--	L	|=============== RESERVED ==============| start | Keep  | load  |========== Max  Chan ==========|========== Max  Colm ===========|
	--
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--	Reserved
	--	E	|	31		30		29		28		27		26		25		24		23		22		21	 	20	 	19		18		17		16	 |
	--	S	|=========================================================== RESERVED ===========================================================|
	--	E	
	--	R	
	--	V	|	15		14		13		12		11		10		9		8		7		6		5		4		3		2		1		0	 |
	--	E	|=========================================================== RESERVED ===========================================================|
	--
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		ADDRESS	MAP														--
	--------------------------------------------------------------------------
	--		BASE_ADDRESS	+	0		:	Address
	--		BASE_ADDRESS	+	4		:	Config  Register
	--		BASE_ADDRESS	+	8		:	Control Register
	--		BASE_ADDRESS	+	C		:	Reserved
	--------------------------------------------------------------------------
	--			Unit Address Value		|	Unit
	--			------------------------|------------
	--					0				|	MPDR(1,1)
	--					1				|	MPDR(1,2)
	--					2				|	MPDR(1,3)
	--					3				|	MPDR(1,4)
	--					4				|	MPDR(2,1)
	--					5				|	MPDR(2,2)
	--					6				|	MPDR(2,3)
	--					7				|	MPDR(2,4)
	--					8				|	MPDR(3,1)
	--					9				|	MPDR(3,2)
	--					10				|	MPDR(3,3)
	--					11				|	MPDR(3,4)
	--					12				|	MPDR(4,1)
	--					13				|	MPDR(4,2)
	--					14				|	MPDR(4,3)
	--					15				|	MPDR(4,4)
	--		
	--	
	--			Target Value			|	target
	--			------------------------|---------------------------
	--					0				|	input block 0	-> R1 C1
	--					1				|	input block 1	-> R1 C2
	--					2				|	input block 2	-> R2 C1
	--					3				|	input block 3	-> R2 C2
	--					4				|	Reserved
	--					5				|	Reserved
	--					6				|	Reserved
	--					7				|	output block
	--		
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		SIGNALs
	--------------------------------------------------------------------------
	SIGNAL	Content_Address				:	std_logic_vector(31	DOWNTO	0);
	SIGNAL	Content_Config				:	std_logic_vector(9	DOWNTO	0);
	SIGNAL	Content_Control				:	std_logic_vector(11	DOWNTO	0);
	--------------------------------------------------------------------------
	SIGNAL	CMD_MPDR_start_tmp			:	Unc_1D_array(15	DOWNTO 0);
	SIGNAL	CMD_MPDR_keeps_tmp			:	Unc_1D_array(15	DOWNTO 0);
	SIGNAL	CMD_MPDR_loads_tmp			:	Unc_1D_array(15	DOWNTO 0);
	--------------------------------------------------------------------------
begin
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	PROCESS(clk, rst)
		VARIABLE	add					:	INTEGER;
	BEGIN
		IF rst = '1' THEN
			Content_Address				<=	(OTHERS	=>	'0');
			Content_Config				<=	(OTHERS	=>	'0');
			Content_Control				<=	(OTHERS	=>	'0');
			CMD_MPDR_start_tmp			<=	(OTHERS	=>	'0');
			CMD_MPDR_keeps_tmp			<=	(OTHERS	=>	'0');
			CMD_MPDR_loads_tmp			<=	(OTHERS	=>	'0');
		ELSIF clk = '1' AND clk'EVENT THEN
			add							:=	to_integer(SIGNED(X_check(MAIN_PORT_Address)));
			IF MAIN_PORT_WEN = '1' AND add >= BASE_ADDRESS AND add < ENDx_ADDRESS THEN 
				Content_Config			<=	(OTHERS	=>	'0');
				CMD_MPDR_start_tmp		<=	(OTHERS	=>	'0');
				CMD_MPDR_loads_tmp		<=	(OTHERS	=>	'0');
				CASE	MAIN_PORT_Address(3	DOWNTO 2)	IS
					WHEN	"00"		=>	Content_Address		<=	MAIN_PORT_Data_in;
					WHEN	"01"		=>	Content_Config		<=	MAIN_PORT_Data_in(31 DOWNTO	28)	& MAIN_PORT_Data_in(5	DOWNTO	0);
					WHEN	"10"		=>	CMD_MPDR_MAX_Col	<=	MAIN_PORT_Data_in(P_column_size-1						DOWNTO 0);
											CMD_MPDR_MAX_Chn	<=	MAIN_PORT_Data_in(P_channel_size + P_column_size-1		DOWNTO P_column_size);
											CMD_MPDR_start_tmp(to_integer(SIGNED(X_check(MAIN_PORT_Data_in(31	DOWNTO	28)))))	<=	MAIN_PORT_Data_in(10);
											CMD_MPDR_keeps_tmp(to_integer(SIGNED(X_check(MAIN_PORT_Data_in(31	DOWNTO	28)))))	<=	MAIN_PORT_Data_in(9);
											CMD_MPDR_loads_tmp(to_integer(SIGNED(X_check(MAIN_PORT_Data_in(31	DOWNTO	28)))))	<=	MAIN_PORT_Data_in(8);
					WHEN	OTHERS		=>	NULL;
				END CASE;
			END IF;	
		END IF;
		--WAIT ON clk, rst;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS(MAIN_PORT_Address, MAIN_PORT_OEN)
		VARIABLE	add					:	INTEGER;
	BEGIN
		add								:=	to_integer(SIGNED(X_check(MAIN_PORT_Address)));
		IF MAIN_PORT_OEN = '1' AND add >= BASE_ADDRESS AND add < ENDx_ADDRESS THEN 
			MAIN_PORT_Data_OUT			<=	"00000000000000000000000000000000";
		ELSE
			MAIN_PORT_Data_out			<=	(OTHERS	=>	'Z');
		END IF;	
		--WAIT ON	MAIN_PORT_Address, MAIN_PORT_OEN;
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
		--WAIT ON	MAIN_PORT_Address, MAIN_PORT_OEN;
	END PROCESS;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	CMD_MPDR_Addresses					<=	Content_Address;
	CMD_MPDR_Target						<=	Content_Config(2 DOWNTO 0);
	--------------------------------------------------------------------------
	PROCESS(CMD_MPDR_start_tmp,	CMD_MPDR_keeps_tmp,	CMD_MPDR_loads_tmp)
	BEGIN
		FOR i IN 0 TO 3 LOOP
			FOR j IN 0 TO 3 LOOP
				CMD_MPDR_start	(i,j)	<=	CMD_MPDR_start_tmp(4*i+j)	AND		CMD_MPDR_keeps_tmp(4*i+j);
				CMD_MPDR_load	(i,j)	<=	CMD_MPDR_loads_tmp(4*i+j);
			END LOOP;
		END LOOP;
	END PROCESS;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	PROCESS(Content_Config)
	BEGIN
		CMD_MPDR_Base_Wen				<=	(OTHERS	=>	(OTHERS	=>	'0'));
		CMD_MPDR_Cont_Wen				<=	(OTHERS	=>	(OTHERS	=>	'0'));
		CMD_MPDR_IVal_Wen				<=	(OTHERS	=>	(OTHERS	=>	'0'));
		CASE	Content_Config(9	DOWNTO	6)	IS
			WHEN	"0000"				=>	CMD_MPDR_Base_Wen(0, 0)	<=	Content_Config(5);
											CMD_MPDR_Cont_Wen(0, 0)	<=	Content_Config(4);
											CMD_MPDR_IVal_Wen(0, 0)	<=	Content_Config(3);
			WHEN	"0001"				=>	CMD_MPDR_Base_Wen(0, 1)	<=	Content_Config(5);
											CMD_MPDR_Cont_Wen(0, 1)	<=	Content_Config(4);
											CMD_MPDR_IVal_Wen(0, 1)	<=	Content_Config(3);
			WHEN	"0010"				=>	CMD_MPDR_Base_Wen(0, 2)	<=	Content_Config(5);
											CMD_MPDR_Cont_Wen(0, 2)	<=	Content_Config(4);
											CMD_MPDR_IVal_Wen(0, 2)	<=	Content_Config(3);
			WHEN	"0011"				=>	CMD_MPDR_Base_Wen(0, 3)	<=	Content_Config(5);
											CMD_MPDR_Cont_Wen(0, 3)	<=	Content_Config(4);
											CMD_MPDR_IVal_Wen(0, 3)	<=	Content_Config(3);
			WHEN	"0100"				=>	CMD_MPDR_Base_Wen(1, 0)	<=	Content_Config(5);
											CMD_MPDR_Cont_Wen(1, 0)	<=	Content_Config(4);
											CMD_MPDR_IVal_Wen(1, 0)	<=	Content_Config(3);
			WHEN	"0101"				=>	CMD_MPDR_Base_Wen(1, 1)	<=	Content_Config(5);
											CMD_MPDR_Cont_Wen(1, 1)	<=	Content_Config(4);
											CMD_MPDR_IVal_Wen(1, 1)	<=	Content_Config(3);
			WHEN	"0110"				=>	CMD_MPDR_Base_Wen(1, 2)	<=	Content_Config(5);
											CMD_MPDR_Cont_Wen(1, 2)	<=	Content_Config(4);
											CMD_MPDR_IVal_Wen(1, 2)	<=	Content_Config(3);
			WHEN	"0111"				=>	CMD_MPDR_Base_Wen(1, 3)	<=	Content_Config(5);
											CMD_MPDR_Cont_Wen(1, 3)	<=	Content_Config(4);
											CMD_MPDR_IVal_Wen(1, 3)	<=	Content_Config(3);
			WHEN	"1000"				=>	CMD_MPDR_Base_Wen(2, 0)	<=	Content_Config(5);
											CMD_MPDR_Cont_Wen(2, 0)	<=	Content_Config(4);
											CMD_MPDR_IVal_Wen(2, 0)	<=	Content_Config(3);
			WHEN	"1001"				=>	CMD_MPDR_Base_Wen(2, 1)	<=	Content_Config(5);
											CMD_MPDR_Cont_Wen(2, 1)	<=	Content_Config(4);
											CMD_MPDR_IVal_Wen(2, 1)	<=	Content_Config(3);
			WHEN	"1010"				=>	CMD_MPDR_Base_Wen(2, 2)	<=	Content_Config(5);
											CMD_MPDR_Cont_Wen(2, 2)	<=	Content_Config(4);
											CMD_MPDR_IVal_Wen(2, 2)	<=	Content_Config(3);
			WHEN	"1011"				=>	CMD_MPDR_Base_Wen(2, 3)	<=	Content_Config(5);
											CMD_MPDR_Cont_Wen(2, 3)	<=	Content_Config(4);
											CMD_MPDR_IVal_Wen(2, 3)	<=	Content_Config(3);
			WHEN	"1100"				=>	CMD_MPDR_Base_Wen(3, 0)	<=	Content_Config(5);
											CMD_MPDR_Cont_Wen(3, 0)	<=	Content_Config(4);
											CMD_MPDR_IVal_Wen(3, 0)	<=	Content_Config(3);
			WHEN	"1101"				=>	CMD_MPDR_Base_Wen(3, 1)	<=	Content_Config(5);
											CMD_MPDR_Cont_Wen(3, 1)	<=	Content_Config(4);
											CMD_MPDR_IVal_Wen(3, 1)	<=	Content_Config(3);
			WHEN	"1110"				=>	CMD_MPDR_Base_Wen(3, 2)	<=	Content_Config(5);
											CMD_MPDR_Cont_Wen(3, 2)	<=	Content_Config(4);
											CMD_MPDR_IVal_Wen(3, 2)	<=	Content_Config(3);
			WHEN	"1111"				=>	CMD_MPDR_Base_Wen(3, 3)	<=	Content_Config(5);
											CMD_MPDR_Cont_Wen(3, 3)	<=	Content_Config(4);
											CMD_MPDR_IVal_Wen(3, 3)	<=	Content_Config(3);
			WHEN	OTHERS				=>	NULL;
		END CASE;
		--WAIT ON	TR_Address, TR_Start;
	END PROCESS;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
end Behavioral;


