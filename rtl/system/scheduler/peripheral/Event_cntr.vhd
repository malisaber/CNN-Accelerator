library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity Event_cntr is
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		
		Cnt_Word						:	IN	std_logic_vector(16	DOWNTO	0);
		Cur_Word						:	OUT	std_logic_vector(31	DOWNTO	0);
		
		EVNT							:	IN	std_logic;
		INTR							:	OUT	std_logic;
		ANSD							:	IN	std_logic);
end Event_cntr;

architecture Behavioral of Event_cntr IS
	------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------------------------------
	--	Control
	--	O	|	31	|	30	 |	29	 |	28	 |	27	 |	26	|	25	|	24	 |	23		22	|	21	 	20	 	19		18		17		16	 |
	--	N	|Enable |= init =| Stuck | INT E | INT C | SENS | INT V | Evnt V |===== Src ====|=========== MAX(10:5) ==========================|
	--	T	
	--	R	
	--	O	|	15		14		13		12		11	|	10		9		8		7		6		5		4		3		2		1		0	 |
	--	L	|=============== MAX(4:0) ==============|========================================= VAL ==========================================|
	--
	------------------------------------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------
	--					Sensitivity		:		sensitive to
	--							0		:		falling edge
	--							1		:		rising edge
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	--	COMPONENTs
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
	--	SIGNALs
	------------------------------------------------------------------------
	SIGNAL	Enable						:	std_logic;
	SIGNAL	initiate					:	std_logic;
	SIGNAL	stuck						:	std_logic;
	SIGNAL	sensitivity					:	std_logic;
	SIGNAL	incr_eq						:	std_logic;
	SIGNAL	incr_inc					:	std_logic;
	SIGNAL	incr_ini					:	std_logic;
	SIGNAL	occured						:	std_logic;
	SIGNAL	TOP_Value					:	std_logic_vector(10	DOWNTO	0);
	SIGNAL	CUR_Value					:	std_logic_vector(10	DOWNTO	0);
	SIGNAL	int_flag_clr				:	std_logic;
	------------------------------------------------------------------------
	SIGNAL	int_flag_enb				:	std_logic;
	SIGNAL	int_flag_rst				:	std_logic;
	SIGNAL	int_flag_set				:	std_logic;
	SIGNAL	int_flag_val				:	std_logic;
	------------------------------------------------------------------------
	SIGNAL	int_flag_rst_delayed		:	std_logic;
	SIGNAL	EVENT_HIST					:	std_logic;
	------------------------------------------------------------------------
begin
	------------------------------------------------------------------------
	Enable								<=	Cnt_Word(16);
	initiate							<=	Cnt_Word(15);
	stuck								<=	Cnt_Word(14);
	int_flag_enb						<=	Cnt_Word(13);
	int_flag_clr						<=	Cnt_Word(12);
	sensitivity							<=	Cnt_Word(11);
	TOP_Value							<=	Cnt_Word(10	DOWNTO	0);
	int_flag_rst						<=	int_flag_clr OR ANSD OR int_flag_rst_delayed;
	int_flag_set						<=	Enable AND int_flag_enb AND incr_eq;
	incr_inc							<=	Enable AND occured AND NOT (stuck AND incr_eq);
	incr_ini							<=	initiate OR (ANSD AND stuck AND incr_eq);
	------------------------------------------------------------------------
	PROCESS(sensitivity, EVENT_HIST,	EVNT)
	BEGIN
		occured							<=	((NOT	sensitivity)	AND (		EVENT_HIST	AND (NOT	EVNT)))	OR
											(		sensitivity		AND ((NOT	EVENT_HIST)	AND			EVNT));
		--WAIT ON	sensitivity, EVENT_HIST,	EVNT;
	END PROCESS;
	------------------------------------------------------------------------
	PROCESS(clk, rst)
	BEGIN
		IF rst = '1' THEN
			EVENT_HIST					<=	'0';
			int_flag_rst_delayed		<=	'0';
		ELSIF clk = '1' AND clk'EVENT THEN
			EVENT_HIST					<=	EVNT;
			int_flag_rst_delayed		<=	int_flag_clr OR (NOT Enable) OR ANSD;
		END IF;
		--WAIT ON	clk, rst;
	END PROCESS;
	------------------------------------------------------------------------
	EVENT_COUNTER						:	incr
	GENERIC	MAP(
		size							=>	11)
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		ini								=>	incr_ini,
		inc								=>	incr_inc,
		max								=>	TOP_Value,
		val								=>	CUR_Value,
		eq								=>	incr_eq);
	------------------------------------------------------------------------
	PROCESS(int_flag_rst, clk)
	BEGIN
		IF int_flag_rst = '1' THEN
			int_flag_val				<=	'0';
		ELSIF clk = '1' AND clk'EVENT THEN
			IF int_flag_set = '1' THEN
				int_flag_val			<=	'1';
			END IF;
		END IF;
		--WAIT ON int_flag_rst, clk;
	END PROCESS;
	------------------------------------------------------------------------
	Cur_Word							<=	Cnt_Word(16	DOWNTO	11)	&	int_flag_val	&	EVENT_HIST	&	"00"	&	Cnt_Word(10	DOWNTO	0)	&	CUR_Value;
	INTR								<=	int_flag_val;
	------------------------------------------------------------------------
end Behavioral;

