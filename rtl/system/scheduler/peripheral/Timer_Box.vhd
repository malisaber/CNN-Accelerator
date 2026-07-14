library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.my_pack_v2.ALL;
	
entity Timer_Box is
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
		
		--	INTERRUPT	HANDLER
		------	INTERRUPT REQUEST
		INT_TIMER						:	OUT	std_logic_vector(7	DOWNTO	0);
		------	INTERRUPT ANSWERED
		ANS_TIMER						:	IN	std_logic_vector(7	DOWNTO	0));
end Timer_Box;

architecture Behavioral of Timer_Box IS
	--------------------------------------------------------------------------
	--		ADDRESS	MAP		8 TIMERs										--
	--------------------------------------------------------------------------
	--		Address						:									--
	--		BA	+	00					:	TIMER	0	CNT		RW			--
	--		BA	+	04					:	TIMER	0	VAL		RO			--
	--		BA	+	08					:	TIMER	1	CNT		RW			--
	--		BA	+	0C					:	TIMER	1	VAL		RO			--
	--		BA	+	10					:	TIMER	2	CNT		RW			--
	--		BA	+	14					:	TIMER	2	VAL		RO			--
	--		BA	+	18					:	TIMER	3	CNT		RW			--
	--		BA	+	1C					:	TIMER	3	VAL		RO			--
	--		BA	+	20					:	TIMER	4	CNT		RW			--
	--		BA	+	24					:	TIMER	4	VAL		RO			--
	--		BA	+	28					:	TIMER	5	CNT		RW			--
	--		BA	+	2C					:	TIMER	5	VAL		RO			--
	--		BA	+	30					:	TIMER	6	CNT		RW			--
	--		BA	+	34					:	TIMER	6	VAL		RO			--
	--		BA	+	38					:	TIMER	7	CNT		RW			--
	--		BA	+	3C					:	TIMER	7	VAL		RO			--
	--------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------------------------------
	--	Control 	(Write Only)
	--	O	|	31	|	30	 |	29	 |	28	 |	27		26		25		24	|	23		22		21	 	20	 | 	19		18		17		16	 |
	--	N	|Enable |= init =| INT E | INT C |========= RESERVED ===========|=========== Clk Div ============|========= TOP(19:16) ==========|
	--	T	
	--	R	
	--	O	|	15		14		13		12		11		10		9		8		7		6		5		4		3		2		1		0	 |
	--	L	|========================================================== TOP(15:0) ===========================================================|
	--
	--------------------------------------------------------------------------------------------------------------------------------------------
	--	Value		(Read Only)
	--	a	|	31	|	30		29		28		27		26		25		24		23		22		21		20	 |	19		18		17		16	 |
	--	l	| INT V |======================================= RESERVED =======================================|========= Val(19:16) ==========|
	--	u	 
	--	e	
	--		|	15		14		13		12		11		10		9		8		7		6		5		4		3		2		1		0	 |
	--		|========================================================== Val(15:0) ===========================================================|
	--
	------------------------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		CONSTANTs
	--------------------------------------------------------------------------
	CONSTANT	NUMB_ints				:	INTEGER	:=	16;
	CONSTANT	ENDx_ADDRESS			:	INTEGER	:=	BASE_ADDRESS + 4*NUMB_ints;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		COMPONENTs
	--------------------------------------------------------------------------
	COMPONENT	TIMER
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		Cnt_Word						:	IN	std_logic_vector(27	DOWNTO	0);
		Cur_Word						:	OUT	std_logic_vector(20	DOWNTO	0);
		INTR							:	OUT	std_logic;
		ANSD							:	IN	std_logic);
	END	COMPONENT;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		TYPEs
	--------------------------------------------------------------------------
	TYPE	Cnt_Type					IS	ARRAY (0 TO 7) OF	std_logic_vector(27	DOWNTO	0);
	TYPE	Val_Type					IS	ARRAY (0 TO 7) OF	std_logic_vector(20	DOWNTO	0);
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		SINGALs
	--------------------------------------------------------------------------
	SIGNAL	Cnt_Word					:	Cnt_Type;
	SIGNAL	Cur_Word					:	Val_Type;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
begin
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	TIMER_GEN							:	FOR i	IN	0	TO	7	GENERATE
		TIMERs							:	TIMER
		PORT	MAP(
			clk							=>	clk,
			rst							=>	rst,
			Cnt_Word					=>	Cnt_Word(i),
			Cur_Word					=>	Cur_Word(i),
			INTR						=>	INT_TIMER(i),
			ANSD						=>	ANS_TIMER(i));
	END GENERATE;
	--------------------------------------------------------------------------
	PROCESS(clk, rst)
		VARIABLE	add					:	INTEGER;
		VARIABLE	Eadd				:	INTEGER;
	BEGIN
		IF rst = '1' THEN
			Cnt_Word					<=	(OTHERS	=>	(OTHERS	=>	'0'));
		ELSIF clk = '1' AND clk'EVENT THEN
			FOR i IN 0 TO 7 LOOP
				Cnt_Word(i)(26)			<=	'0';
				Cnt_Word(i)(24)			<=	'0';
			END LOOP;
			add							:=	to_integer(SIGNED(X_check(MAIN_PORT_Address)));
			Eadd						:=	(add/8) - (BASE_ADDRESS/8);
			IF MAIN_PORT_WEN = '1' AND add >= BASE_ADDRESS AND add < ENDx_ADDRESS THEN
				IF MAIN_PORT_Address(2)	=	'0'	THEN
					Cnt_Word(Eadd)(27	DOWNTO	24)	<=	MAIN_PORT_Data_in(31 DOWNTO	28);
					Cnt_Word(Eadd)(23	DOWNTO	0)	<=	MAIN_PORT_Data_in(23 DOWNTO	0);
				END IF;
			END IF;
		END IF;
		--WAIT ON clk, rst;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS(MAIN_PORT_Address, MAIN_PORT_OEN, Cur_Word, Cnt_Word)
		VARIABLE	add					:	INTEGER;
		VARIABLE	Eadd				:	INTEGER;
	BEGIN
		add								:=	to_integer(SIGNED(X_check(MAIN_PORT_Address)));
		Eadd							:=	(add/8) - (BASE_ADDRESS/8);
		IF MAIN_PORT_OEN = '1' AND add  >= BASE_ADDRESS AND add < ENDx_ADDRESS THEN 
			IF MAIN_PORT_Address(2)		=	'1'	THEN
				MAIN_PORT_Data_out		<=	Cur_Word(Eadd)(20)	&	"00000000000"	&	Cur_Word(Eadd)(19 DOWNTO 0);
			ELSE
				MAIN_PORT_Data_out		<=	Cnt_Word(Eadd)(27	DOWNTO	24)	&	X"0"	&	Cnt_Word(Eadd)(23	DOWNTO	0);
			END IF;
		ELSE
			MAIN_PORT_Data_out			<=	(OTHERS	=>	'Z');
		END IF;
		--WAIT ON	MAIN_PORT_Address, MAIN_PORT_OEN, Cur_Word;
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
end Behavioral;

