library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.my_pack_v2.ALL;

entity TIMER is
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		
		Cnt_Word						:	IN	std_logic_vector(27	DOWNTO	0);
		Cur_Word						:	OUT	std_logic_vector(20	DOWNTO	0);
		
		INTR							:	OUT	std_logic;
		ANSD							:	IN	std_logic);
end TIMER;

architecture Behavioral of TIMER IS
--------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------------------------------
	--	Control 
	--	O	|	31	|	30	 |	29	 |	28	 |	27		26		25		24	|	23		22		21	 	20	 | 	19		18		17		16	 |
	--	N	|Enable |= init =| INT E | INT C |========= RESERVED ===========|=========== Clk Div ============|========= TOP(19:16) ==========|
	--	T	
	--	R	
	--	O	|	15		14		13		12		11		10		9		8		7		6		5		4		3		2		1		0	 |
	--	L	|========================================================== TOP(15:0) ===========================================================|
	--
	--			clk Div
	--				0	:	clk
	--				1	:	clk / 2
	--					:	
	--				i	:	clk / (2**i)
	--					:	
	--				15	:	clk / 65536
	--				
	--------------------------------------------------------------------------------------------------------------------------------------------
	--	Current Timer Value
	--		|	31	|	30		29		28		27		26		25		24		23		22		21		20	 |	19		18		17		16	 |
	--	C	| INT V |======================================= RESERVED =======================================|========= Val(19:16) ==========|
	--	T	 
	--	V	
	--		|	15		14		13		12		11		10		9		8		7		6		5		4		3		2		1		0	 |
	--		|========================================================== Val(15:0) ===========================================================|
	------------------------------------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------
	--		COMPONENTs
	------------------------------------------------------------------------
	COMPONENT	incr
	GENERIC(
		size							:	INTEGER	:=	4);
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		ini								:	IN	std_logic;
		inc								:	IN	std_logic;
		max								:	IN	std_logic_vector(size-1 DOWNTO 0);
		val								:	OUT	std_logic_vector(size-1 DOWNTO 0);
		eq								:	OUT	std_logic);
	END	COMPONENT;
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	--		SIGNALs
	------------------------------------------------------------------------
	SIGNAL	Enable						:	std_logic;
	SIGNAL	initiate					:	std_logic;
	SIGNAL	incr_eq						:	std_logic;
	SIGNAL	incr_clk					:	std_logic;
	SIGNAL	Clk_Select					:	std_logic_vector(3	DOWNTO	0);
	SIGNAL	TOP_Value					:	std_logic_vector(19	DOWNTO	0);
	SIGNAL	CUR_Value					:	std_logic_vector(19	DOWNTO	0);
	SIGNAL	CLK_Freqs					:	std_logic_vector(15	DOWNTO	0);
	------------------------------------------------------------------------
	SIGNAL	int_flag_rst				:	std_logic;
	SIGNAL	int_flag_enb				:	std_logic;
	SIGNAL	int_flag_set				:	std_logic;
	SIGNAL	int_flag_val				:	std_logic;
	------------------------------------------------------------------------
	SIGNAL	delayed_clr					:	std_logic;
	------------------------------------------------------------------------
begin
	------------------------------------------------------------------------
	PROCESS(clk, rst)
	BEGIN
		IF rst = '1' THEN
			delayed_clr					<=	'0';
		ELSIF clk = '1' AND clk'EVENT THEN 
			delayed_clr					<=	Cnt_Word(24) OR (NOT Enable) OR ANSD;
		END IF;
		--WAIT ON clk, rst;
	END PROCESS;
	------------------------------------------------------------------------
	Enable								<=	Cnt_Word(27);
	initiate							<=	Cnt_Word(26);
	int_flag_enb						<=	Cnt_Word(25);
	int_flag_rst						<=	Cnt_Word(24) OR (NOT Enable) OR ANSD OR rst OR delayed_clr;
	Clk_Select							<=	Cnt_Word(23	DOWNTO 20);
	TOP_Value							<=	Cnt_Word(19	DOWNTO 0);
	incr_clk							<=	CLK_Freqs(my_to_uint(Clk_Select));
	int_flag_set						<=	Enable AND int_flag_enb AND incr_eq;
	CLK_Freqs(0)						<=	clk;
	------------------------------------------------------------------------
	clk_Frq_GEN							:	FOR i IN 0 TO 14 GENERATE
		PROCESS(rst, CLK_Freqs(i))
		BEGIN
			IF rst = '1' THEN
				CLK_Freqs(i+1)			<=	'0';
			ELSIF CLK_Freqs(i) = '1' AND CLK_Freqs(i)'EVENT THEN
				IF Enable = '0' OR initiate = '1' THEN
					CLK_Freqs(i+1)		<=	'0';
				ELSE
					CLK_Freqs(i+1)		<=	NOT CLK_Freqs(i+1);
				END IF;
			END IF;
			--WAIT ON rst, CLK_Freqs(i);
		END PROCESS;
	END GENERATE;
	------------------------------------------------------------------------
	Event_counter						:	incr
	GENERIC	MAP(
		size							=>	20)
	PORT	MAP(
		clk								=>	incr_clk,
		rst								=>	rst,
		ini								=>	initiate,
		inc								=>	Enable,
		max								=>	TOP_Value,
		val								=>	CUR_Value,
		eq								=>	incr_eq);
	------------------------------------------------------------------------
	PROCESS(int_flag_rst, incr_clk)
	BEGIN
		IF int_flag_rst = '1' THEN
			int_flag_val				<=	'0';
		ELSIF incr_clk = '1' AND incr_clk'EVENT THEN
			IF int_flag_set = '1' THEN
				int_flag_val			<=	'1';
			END IF;
		END IF;
		--WAIT ON int_flag_rst, incr_clk;
	END PROCESS;
	------------------------------------------------------------------------
	Cur_Word							<=	int_flag_val	&	CUR_Value;
	INTR								<=	int_flag_val;
	------------------------------------------------------------------------
end Behavioral;


