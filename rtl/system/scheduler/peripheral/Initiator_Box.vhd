library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.my_pack_v2.ALL;
	
entity Initiator_Box is
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
		
		
		--	Initiation
		------	STA	 &	UPA
		INI_Bias_val					:	OUT	std_logic_vector(P_word_size-1						DOWNTO 0);	--			Store Agent Only
		INI_Bias_Add					:	OUT	std_logic_vector(P_kernel_size-1					DOWNTO 0);	--			Store Agent Only
		INI_Bias_Wen					:	OUT	std_logic;														--	flag	Store Agent Only
		INI_Addresses					:	OUT	std_logic_vector(P_Phy_Add_size-1					DOWNTO 0);	--			shared
		INI_Target_add					:	OUT	std_logic_vector(3									DOWNTO 0);	--			shared
		INI_Base_Wen					:	OUT	std_logic;														--	flag	shared
		INI_Count_Wen					:	OUT	std_logic;														--	flag	shared
		INI_IntVal_Wen					:	OUT	std_logic;														--	flag	shared
		INI_SA_UAbar					:	OUT	std_logic;														--			SA ~UA Selector
		INI_SLU_unit_add				:	OUT	std_logic_vector(3 									DOWNTO 0));	--			PE address r,c
end Initiator_Box;

architecture Behavioral of Initiator_Box IS
	--------------------------------------------------------------------------
	--			INITIATOR													--
	--------------------------------------------------------------------------
	--		Address						:									--
	--		BA	+	0					:	Store Agent BIASes Value	WO	--
	--		BA	+	4					:	Store Agent BIASes Control	WO	--
	--		BA	+	8					:	Address Point				WO	--
	--		BA	+	C					:	Address Point Control		WO	--
	--------------------------------------------------------------------------
	--	this Sizes are conceptional and are not based on their true signal length (for the sake of start positioning, to see actual sizees visit MY_PACK_V2.VHD)
	------------------------------------------------------------------------------------------------------------------------------------------
	--	Store Agent BIAS Value
	--	A	|	31		30		29		28		27		26		25		24		23		22		21	 	20	 	19		18		17		16	 |
	--	B	|=========================================================== RESERVED ===========================================================|
	--	V	
	--		
	--		|	15		14		13		12		11		10		9		8		7		6		5		4		3		2		1		0	 |
	--		|========================================================= Bias Value ===========================================================|
	--
	--------------------------------------------------------------------------------------------------------------------------------------------
	--	Store Agent BIAS Control
	--	A	|	31	|	30		29		28		27		26		25		24		23		22		21		20		19		18		17		16	 |
	--	B	|= Wen =|======================================================= RESERVED =======================================================|
	--	C	 
	--		
	--		|	15		14		13		12		11		10		9		8		7		6		5		4	|	3		2		1		0	 |
	--		|========================================== RESERVED ===========================================|======== Kernel Address ========|
	------------------------------------------------------------------------------------------------------------------------------------------
	--	Address Point
	--	P	|	31		30		29		28		27		26		25		24		23		22		21	 	20	 	19		18		17		16	 |
	--		|=========================================================== RESERVED ===========================================================|
	--		
	--		
	--		|	15		14		13		12		11		10		9		8		7		6		5		4		3		2		1		0	 |
	--		|======================================================== Address Value =========================================================|
	--
	--------------------------------------------------------------------------------------------------------------------------------------------
	--	Address Point Control
	--	P	|	31	|	30	|	29	|	28	|	27		26		25		24		23		22		21		20	 |	19		18		17		16	 |
	--	C	| B Wen | C Wen | I Wen |SA/ ~UA|=========================== RESERVED ===========================|======== Unit Address =========|
	--		
	--		
	--		|	15		14		13		12		11		10		9		8		7		6		5		4	 |	3		2		1		0	 |
	--		|================================================== RESERVED ====================================|======= Target Address ========|
	--
	------------------------------------------------------------------------------------------------------------------------------------------
	--			TARGGET	ADDRESS	(Update Agent)
	--						0		:	WEIGHT MEMORY BANK #(1,1)
	--						1		:	WEIGHT MEMORY BANK #(1,2)
	--						2		:	WEIGHT MEMORY BANK #(1,3)
	--						3		:	WEIGHT MEMORY BANK #(2,1)
	--						4		:	WEIGHT MEMORY BANK #(2,2)
	--						5		:	WEIGHT MEMORY BANK #(2,3)
	--						6		:	WEIGHT MEMORY BANK #(3,1)
	--						7		:	WEIGHT MEMORY BANK #(3,2)
	--						8		:	WEIGHT MEMORY BANK #(3,3)
	--						9		:	RESERVED
	--						10		:	CONTROL UNIT MEMORY
	--						11		:	RESERVED
	--						12		:	INPUT MEMORY BANK #4
	--						13		:	INPUT MEMORY BANK #3
	--						14		:	INPUT MEMORY BANK #2
	--						15		:	INPUT MEMORY BANK #1
	--------------------------------------------------------------------------
	--			TARGGET	ADDRESS	(Store Agent)
	--						0		:	LOAD	ROW from
	--						1		:	STORE	ROW at
	--						2		:	RESERVED
	--						3		:	RESERVED
	--						4		:	RESERVED
	--						5		:	RESERVED
	--						6		:	RESERVED
	--						7		:	RESERVED
	--						8		:	RESERVED
	--						9		:	RESERVED
	--						10		:	RESERVED
	--						11		:	RESERVED
	--						12		:	RESERVED
	--						13		:	RESERVED
	--						14		:	RESERVED
	--						15		:	RESERVED
	--------------------------------------------------------------------------
	--			Unit Address			row		col
	--						0000	:	1		1
	--						0001	:	1		2
	--						0010	:	1		3
	--						0011	:	1		4
	--						0100	:	2		1
	--						0101	:	2		2
	--						0110	:	2		3
	--						0111	:	2		4
	--						1000	:	3		1
	--						1001	:	3		2
	--						1010	:	3		3
	--						1011	:	3		4
	--						1100	:	4		1
	--						1101	:	4		2
	--						1110	:	4		3
	--						1111	:	4		4
	--------------------------------------------------------------------------
	--	Initialization procedure:
	--		BIASes:
	--			1)	SET		Unit Address					@		C_PERIPHERAL_REG_SAU_INITIATE_ADDRESS_POINT_CNTR
	--			2)	PUT		Bias Value						@		C_PERIPHERAL_REG_SAU_INITIATE_BIAS_VALUE
	--			3)	SET		Kernel Address &	Wen			@		C_PERIPHERAL_REG_SAU_INITIATE_BIAS_CONTROL
	--			4)	repeat 2 and 3			until you initiate all kernel biases for unit r,c
	--			5)	repeat 1, 2, 3 and 4	until you initiate all kernel biases for all units
	--			
	--		ASSRESSes:
	--			1)	PUT		Address Value					@		C_PERIPHERAL_REG_SAU_INITIATE_ADDRESS_POINT
	--			2)	SET		different part of				@		C_PERIPHERAL_REG_SAU_INITIATE_ADDRESS_POINT_CNTR
	--			3)	repeat 1 and 2 for all Target Address of SU and CU in each Unit Address. (total of 64 times)
	--			
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		CONSTANTs
	--------------------------------------------------------------------------
	CONSTANT	NUMB_ints				:	INTEGER	:=	4;
	CONSTANT	ENDx_ADDRESS			:	INTEGER	:=	BASE_ADDRESS + 4*NUMB_ints;
	CONSTANT	ADDRESS_SIZE			:	INTEGER	:=	P_Phy_Add_size;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		SINGALs
	--------------------------------------------------------------------------
	SIGNAL	SAB_Value					:	std_logic_vector(P_word_size-1	DOWNTO 0);
	SIGNAL	SAB_Control					:	std_logic_vector(P_kernel_size	DOWNTO 0);
	SIGNAL	APo_Value					:	std_logic_vector(ADDRESS_SIZE-1	DOWNTO 0);
	SIGNAL	APo_Control					:	std_logic_vector(11				DOWNTO 0);
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
begin
	--------------------------------------------------------------------------
	PROCESS(clk, rst)
		VARIABLE	add					:	INTEGER;
	BEGIN
		IF rst = '1' THEN
			SAB_Value					<=	(OTHERS	=>	'0');
			SAB_Control					<=	(OTHERS	=>	'0');
			APo_Value					<=	(OTHERS	=>	'0');
			APo_Control					<=	(OTHERS	=>	'0');
		ELSIF clk = '1' AND clk'EVENT THEN
			SAB_Control(P_kernel_size)	<=	'0';
			APo_Control(11)				<=	'0';
			APo_Control(10)				<=	'0';
			APo_Control(9)				<=	'0';
			add							:=	to_integer(SIGNED(X_check(MAIN_PORT_Address)));
			IF MAIN_PORT_WEN = '1' AND add >= BASE_ADDRESS AND add < ENDx_ADDRESS THEN
				CASE MAIN_PORT_Address(3 DOWNTO 2)	IS
					WHEN	"00"		=>	SAB_Value								<=	MAIN_PORT_Data_in(P_word_size-1		DOWNTO	0);
					WHEN	"01"		=>	SAB_Control(P_kernel_size)				<=	MAIN_PORT_Data_in(P_kernel_size);
											SAB_Control(P_kernel_size-1	DOWNTO	0)	<=	MAIN_PORT_Data_in(P_kernel_size-1	DOWNTO	0);
					WHEN	"10"		=>	APo_Value								<=	MAIN_PORT_Data_in(ADDRESS_SIZE-1	DOWNTO	0);
					WHEN	"11"		=>	APo_Control(11				DOWNTO	8)	<=	MAIN_PORT_Data_in(31				DOWNTO	28);
											APo_Control(7				DOWNTO	4)	<=	MAIN_PORT_Data_in(19				DOWNTO	16);
											APo_Control(3				DOWNTO	0)	<=	MAIN_PORT_Data_in(3					DOWNTO	0);
					WHEN	OTHERS		=>	NULL;
				END CASE;
			END IF;
		END IF;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS(MAIN_PORT_Address, MAIN_PORT_OEN)
		VARIABLE	add					:	INTEGER;
	BEGIN
		add								:=	to_integer(SIGNED(X_check(MAIN_PORT_Address)));
		IF MAIN_PORT_OEN = '1' AND add  >= BASE_ADDRESS AND add < ENDx_ADDRESS THEN 
			MAIN_PORT_Data_out			<=	(OTHERS	=>	'0');
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
	INI_Bias_val						<=	SAB_Value;
	INI_Bias_Add						<=	SAB_Control(P_kernel_size-1	DOWNTO	0);
	INI_Bias_Wen						<=	SAB_Control(P_kernel_size);
	INI_Addresses						<=	APo_Value;
	INI_Target_add						<=	APo_Control(3				DOWNTO	0);
	INI_Base_Wen						<=	APo_Control(11);
	INI_Count_Wen						<=	APo_Control(10);
	INI_IntVal_Wen						<=	APo_Control(9);
	INI_SA_UAbar						<=	APo_Control(8);
	INI_SLU_unit_add					<=	APo_Control(7				DOWNTO	4);
	--------------------------------------------------------------------------
end Behavioral;

