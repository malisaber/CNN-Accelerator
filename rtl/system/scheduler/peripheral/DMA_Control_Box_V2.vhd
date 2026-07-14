library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE work.my_pack_v2.ALL;

entity DMA_Control_Box_V2 is
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
		
		--	DMA
		CMD_DMA_start					:	OUT	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);			--(flag)
		CMD_DMA_R_Add					:	OUT	Unc_2D_P_Addr_array	(3	DOWNTO	0,	3	DOWNTO 0);	--(regs)
		CMD_DMA_R_Cnt					:	OUT	Unc_2D_P_Cont_array	(3	DOWNTO	0,	3	DOWNTO 0);	--(regs)
		CMD_DMA_W_Add					:	OUT	Unc_2D_P_Addr_array	(3	DOWNTO	0,	3	DOWNTO 0);	--(regs)
		CMD_DMA_W_Cnt					:	OUT	Unc_2D_P_Cont_array	(3	DOWNTO	0,	3	DOWNTO 0));	--(regs)
end DMA_Control_Box_V2;

architecture Behavioral of DMA_Control_Box_V2 is
	--------------------------------------------------------------------------
	--		CONSTANTs
	--------------------------------------------------------------------------
	CONSTANT	NUMB_ints				:	INTEGER	:=	4;
	CONSTANT	ENDx_ADDRESS			:	INTEGER	:=	BASE_ADDRESS + 4*NUMB_ints;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--	Control
	--	O	|	31	|	30		29		28		27		26		25		24		23		22		21	 	20	 	19		18		17		16	 |
	--	N	| start |======================================================= RESERVED =======================================================|
	--	T	
	--	R	
	--	O	|	15		14		13		12		11		10		9		8		7		6		5	|	4		3		2		1		0	 |
	--	L	|======================================= RESERVED ======================================|============= DMA Address ==============|
	--
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		ADDRESS	MAP														--
	--------------------------------------------------------------------------
	--		BASE_ADDRESS	+	0		:	DMA	R (TAG & Idx)
	--		BASE_ADDRESS	+	4		:	DMA	W (TAG & Idx)
	--		BASE_ADDRESS	+	8		:	DMA	TR Count
	--		BASE_ADDRESS	+	C		:	CONTROL
	--------------------------------------------------------------------------
	--		DMA Address			TARGET
	--				0			DMA(1,1)
	--				1			DMA(1,2)
	--				2			DMA(1,3)
	--				3			DMA(1,4)
	--				4			DMA(2,1)
	--				5			DMA(2,2)
	--				6			DMA(2,3)
	--				7			DMA(2,4)
	--				8			DMA(3,1)
	--				9			DMA(3,2)
	--				10			DMA(3,3)
	--				11			DMA(3,4)
	--				12			DMA(4,1)
	--				13			DMA(4,2)
	--				14			DMA(4,3)
	--				15			DMA(4,4)
	--	NOTE:
	--		if the actual number of DMAs is less than 4 and 16 in MMNs and GMN
	--		respectively, the starting addresses for each MMNs remain constant.
	--		Additionally, any references or addresses pointing to DMAs beyond
	--		the existing ones won't have any impact on the system.
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		SIGNALs
	--------------------------------------------------------------------------
	SIGNAL	TR_Read						:	std_logic_vector(P_Phy_Add_size-1	DOWNTO	0);
	SIGNAL	TR_Write					:	std_logic_vector(P_Phy_Add_size-1	DOWNTO	0);
	SIGNAL	TR_Count					:	std_logic_vector(P_Phy_Cnt_size-1	DOWNTO	0);
	SIGNAL	TR_Start					:	std_logic;
	SIGNAL	TR_Address					:	std_logic_vector(4	DOWNTO	0);
	--------------------------------------------------------------------------
	SIGNAL	CMD_DMA_start_tmp			:	Unc_1D_array(15	DOWNTO 0);
	--------------------------------------------------------------------------
begin
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	PROCESS(clk, rst)
		VARIABLE	add					:	INTEGER;
	BEGIN
		IF rst = '1' THEN
			TR_Read						<=	(OTHERS	=>	'0');
			TR_Write					<=	(OTHERS	=>	'0');
			TR_Count					<=	(OTHERS	=>	'0');
			TR_Start					<=	'0';
			TR_Address					<=	(OTHERS	=>	'0');
		ELSIF clk = '1' AND clk'EVENT THEN
			add							:=	to_integer(SIGNED(X_check(MAIN_PORT_Address)));
			TR_Start					<=	'0';
			IF MAIN_PORT_WEN = '1' AND add >= BASE_ADDRESS AND add < ENDx_ADDRESS THEN 
				CASE	MAIN_PORT_Address(3	DOWNTO 2)	IS
					WHEN	"00"		=>	TR_Read		<=	MAIN_PORT_Data_in;
					WHEN	"01"		=>	TR_Write	<=	MAIN_PORT_Data_in;
					WHEN	"10"		=>	TR_Count	<=	MAIN_PORT_Data_in(P_Phy_Cnt_size-1	DOWNTO	0);
					WHEN	"11"		=>	TR_Start	<=	MAIN_PORT_Data_in(31);
											TR_Address	<=	MAIN_PORT_Data_in(4	DOWNTO	0);
					WHEN	OTHERS		=>	NULL;
				END CASE;
			END IF;	
		END IF;
		--WAIT ON clk, rst;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS(MAIN_PORT_Address, MAIN_PORT_OEN, TR_Read, TR_Write, TR_Count, TR_Address)
		VARIABLE	add					:	INTEGER;
	BEGIN
		add								:=	to_integer(SIGNED(X_check(MAIN_PORT_Address)));
		IF MAIN_PORT_OEN = '1' AND add >= BASE_ADDRESS AND add < ENDx_ADDRESS THEN 
			CASE	MAIN_PORT_Address(3	DOWNTO 2)	IS
				WHEN	"00"			=>	MAIN_PORT_Data_OUT	<=	TR_Read;
				WHEN	"01"			=>	MAIN_PORT_Data_OUT	<=	TR_Write;
				WHEN	"10"			=>	MAIN_PORT_Data_OUT	<=	(31	DOWNTO	P_Phy_Cnt_size	=>	'0')	&	TR_Count;
				WHEN	"11"			=>	MAIN_PORT_Data_OUT	<=	"000" & X"000000" & TR_Address;
				WHEN	OTHERS			=>	MAIN_PORT_Data_OUT	<=	(OTHERS	=>	'0');
			END CASE;
		ELSE
			MAIN_PORT_Data_out			<=	(OTHERS	=>	'Z');
		END IF;	
		--WAIT ON	MAIN_PORT_Address, MAIN_PORT_OEN, TR_Read, TR_Write, TR_Count, TR_Address;
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
	DMA_CON_GEN_ROW						:	FOR r IN 0 TO 3		GENERATE
		DMA_CON_GEN_COL					:	FOR c IN 0 TO 3		GENERATE
			CMD_DMA_R_Add(r,c)			<=	TR_Read;
			CMD_DMA_W_Add(r,c)			<=	TR_Write;
			CMD_DMA_R_Cnt(r,c)			<=	TR_Count;
			CMD_DMA_W_Cnt(r,c)			<=	TR_Count;
		END GENERATE;
	END GENERATE;
	--------------------------------------------------------------------------
	PROCESS(TR_Address, TR_Start)
	BEGIN
		CMD_DMA_start					<=	(OTHERS	=>	(OTHERS	=>	'0'));
		CASE	TR_Address	IS
			WHEN	"00000"				=>	CMD_DMA_start(	0,	0)	<=	TR_Start;
			WHEN	"00001"				=>	CMD_DMA_start(	0,	1)	<=	TR_Start;
			WHEN	"00010"				=>	CMD_DMA_start(	0,	2)	<=	TR_Start;
			WHEN	"00011"				=>	CMD_DMA_start(	0,	3)	<=	TR_Start;
			WHEN	"00100"				=>	CMD_DMA_start(	1,	0)	<=	TR_Start;
			WHEN	"00101"				=>	CMD_DMA_start(	1,	1)	<=	TR_Start;
			WHEN	"00110"				=>	CMD_DMA_start(	1,	2)	<=	TR_Start;
			WHEN	"00111"				=>	CMD_DMA_start(	1,	3)	<=	TR_Start;
			WHEN	"01000"				=>	CMD_DMA_start(	2,	0)	<=	TR_Start;
			WHEN	"01001"				=>	CMD_DMA_start(	2,	1)	<=	TR_Start;
			WHEN	"01010"				=>	CMD_DMA_start(	2,	2)	<=	TR_Start;
			WHEN	"01011"				=>	CMD_DMA_start(	2,	3)	<=	TR_Start;
			WHEN	"01100"				=>	CMD_DMA_start(	3,	0)	<=	TR_Start;
			WHEN	"01101"				=>	CMD_DMA_start(	3,	1)	<=	TR_Start;
			WHEN	"01110"				=>	CMD_DMA_start(	3,	2)	<=	TR_Start;
			WHEN	"01111"				=>	CMD_DMA_start(	3,	3)	<=	TR_Start;
			WHEN	OTHERS				=>	NULL;
		END CASE;
		--WAIT ON	TR_Address, TR_Start;
	END PROCESS;
	--------------------------------------------------------------------------
end Behavioral;


