
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.my_pack_v2.ALL;
USE IEEE.numeric_std.ALL;

entity TRx_Box is
	GENERIC(
		BASE_ADDRESS					:	INTEGER	:=	to_integer(SIGNED(X_check(X"FFFF0000"))));
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		
		--	MAIN PORT
		MAIN_PORT_Dot_Rdy				:	OUT	std_logic;
		MAIN_PORT_SEL_This				:	OUT	std_logic;
		MAIN_PORT_Address				:	IN	std_logic_vector	(31	DOWNTO	0);
		MAIN_PORT_Data_in				:	IN	std_logic_vector	(31	DOWNTO	0);
		MAIN_PORT_WEN					:	IN	std_logic;
		MAIN_PORT_OEN					:	IN	std_logic;
		MAIN_PORT_Data_out				:	OUT	std_logic_vector	(31	DOWNTO	0);
		
		
		--	Tx line
		Rx_Rx							:	IN	std_logic;
		Tx_Tx							:	OUT	std_logic;
		
		--	INTERRUPT	HANDLER
		------	INTERRUPT REQUEST
		INT_Tx_Buff_Empty				:	OUT	std_logic;
		INT_Tx_Sent						:	OUT	std_logic;
		INT_Rx_Buff_Full				:	OUT	std_logic;
		INT_Rx_Received					:	OUT	std_logic;
		------	INTERRUPT ANSWERED
		ANS_Tx_Buff_Empty				:	IN	std_logic;
		ANS_Tx_Sent						:	IN	std_logic;
		ANS_Rx_Buff_Full				:	IN	std_logic;
		ANS_Rx_Received					:	IN	std_logic);
end TRx_Box;

architecture Behavioral of TRx_Box is
	--------------------------------------------------------------------------
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
	--		BA	+	00					:	Data	Word					--
	--		BA	+	04					:	Control Word					--
	--		BA	+	08					:	RESERVED						--
	--		BA	+	0C					:	RESERVED						--
	--------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------------------------------
	--	Data Word	(Write Mode)
	--	a	|	31		30		29		28		27		26		25		24		23		22		21		20	 	19		18		17		16	|
	--	t	|========================================================== RESERVED ===========================================================|
	--	a	 
	--		
	--	W	|	15		14		13		12		11		10		9		8	|	7		6		5		4		3		2		1		0	|
	--	M	|=========================== RESERVED ==========================|============================ Data =============================|
	--
	------------------------------------------------------------------------------------------------------------------------------------------
	--	Data Word	(Read Mode)
	--	a	|	31	|	30		29		28		27		26		25		24		23		22		21		20	 	19		18		17		16	|
	--	t	| DORE  |====================================================== RESERVED =======================================================|
	--	a	 
	--		
	--	R	|	15		14		13		12		11		10		9		8	|	7		6		5		4		3		2		1		0	|
	--	M	|=========================== RESERVED ==========================|============================ Data =============================|
	--	
	------------------------------------------------------------------------------------------------------------------------------------------
	--	Control Word
	--	O	|		31		|		30		|		29		|		28		|		27		|		26		|		25		|		24		|
	--	N	|== Tx Enable ==|== Rx Enable ==| TB Emty INT E | RB Full INT E | Tx Done INT E | Rx Done INT E |== INT Clear ==|== RESERVED ===|
	--	T	
	--	R	|		23				22				21				20		|		19		|		18		|		17		|		16		|
	--	O	|=========================== Clk Div ===========================|=== TBE flg ===|=== TBF flg ===|=== RBE flg ===|=== RBF flg ===|
	--	L	
	--		|		15				14				13				12				11				10				9				8		|
	--	W	|====================================================== TOP (15 DOWNTO 8) ======================================================|
	--	o	
	--	r	|		7				6				5				4				3				2				1				0		|
	--	d	|====================================================== TOP (7 DOWNTO 0) =======================================================|
	--	
	------------------------------------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		COMPONENTS
	--------------------------------------------------------------------------
	COMPONENT							TRx
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		-- Tx Buff:
		------	OUT
		Rx_Buff_Dout					:	OUT	std_logic_vector(8	DOWNTO	0);
		Rx_Buff_Push					:	OUT	std_logic;
		------	IN
		Tx_Buff_Din						:	IN	std_logic_vector(7	DOWNTO	0);
		Tx_Buff_Empty					:	IN	std_logic;
		Tx_Buff_Pop						:	OUT	std_logic;
		--	Tx Config
		TR_Conf_Top_max					:	IN	std_logic_vector(15	DOWNTO	0);
		TR_Conf_Clk_Div					:	IN	std_logic_vector(3	DOWNTO	0);
		Tx_Conf_Enable					:	IN	std_logic;
		Rx_Conf_Enable					:	IN	std_logic;
		--	Tx line
		Rx_Rx							:	IN	std_logic;
		Tx_Tx							:	OUT	std_logic);
	END	COMPONENT;
	--------------------------------------------------------------------------
	COMPONENT							FIFO_v2
	GENERIC(
		depth							:	INTEGER	:=	32; 
		word_size						:	INTEGER	:=	4;
		reged_output					:	INTEGER	:=	0);
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		-- input
		push							:	IN std_logic;
		data_in							:	IN	std_logic_vector(word_size -1 DOWNTO 0);
		full							:	OUT	std_logic;
		-- output
		pop								:	IN	std_logic;
		data_out						:	OUT	std_logic_vector(word_size -1 DOWNTO 0);
		empty							:	OUT	std_logic);
	END	COMPONENT;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		SIGNALs
	--------------------------------------------------------------------------
	SIGNAL	TRx_Enables					:	std_logic_vector(5	DOWNTO	0);
	SIGNAL	TRx_Buf_Flg					:	std_logic_vector(3	DOWNTO	0);
	SIGNAL	TRx_Clk_Div					:	std_logic_vector(3	DOWNTO	0);
	SIGNAL	TRx_Top_Val					:	std_logic_vector(15	DOWNTO	0);
	SIGNAL	TRx_INT_Clear				:	std_logic;
	--------------------------------------------------------------------------
	SIGNAL	TRx_Tx_Buff_Push			:	std_logic;
	SIGNAL	TRx_Tx_Buff_Din				:	std_logic_vector(7	DOWNTO	0);
	SIGNAL	TRx_Tx_Buff_Full			:	std_logic;
	--------------------------------------------------------------------------
	SIGNAL	TRx_Tx_Buff_Pop				:	std_logic;
	SIGNAL	TRx_Tx_Buff_Dout			:	std_logic_vector(7	DOWNTO	0);
	SIGNAL	TRx_Tx_Buff_Empty			:	std_logic;
	--------------------------------------------------------------------------
	SIGNAL	TRx_Rx_Buff_Push			:	std_logic;
	SIGNAL	TRx_Rx_Buff_Din				:	std_logic_vector(8	DOWNTO	0);
	SIGNAL	TRx_Rx_Buff_Full			:	std_logic;
	--------------------------------------------------------------------------
	SIGNAL	TRx_Rx_Buff_Pop				:	std_logic;
	SIGNAL	TRx_Rx_Buff_Dout			:	std_logic_vector(8	DOWNTO	0);
	SIGNAL	TRx_Rx_Buff_Empty			:	std_logic;
	--------------------------------------------------------------------------
	SIGNAL	TRx_MM_Din					:	std_logic_vector(7	DOWNTO	0);
	SIGNAL	TRx_MM_Wen					:	std_logic;
	SIGNAL	TRx_MM_Dout					:	std_logic_vector(8	DOWNTO	0);
	SIGNAL	TRx_MM_Ren					:	std_logic;
	--------------------------------------------------------------------------
	SIGNAL	TBE_int_set					:	std_logic;
	SIGNAL	TBE_int_rst					:	std_logic;
	SIGNAL	TBE_int						:	std_logic;
	--------------------------------------------------------------------------
	SIGNAL	RBF_int_set					:	std_logic;
	SIGNAL	RBF_int_rst					:	std_logic;
	SIGNAL	RBF_int						:	std_logic;
	--------------------------------------------------------------------------
	SIGNAL	TXD_int_set					:	std_logic;
	SIGNAL	TXD_int_rst					:	std_logic;
	SIGNAL	TXD_int						:	std_logic;
	--------------------------------------------------------------------------
	SIGNAL	RXD_int_set					:	std_logic;
	SIGNAL	RXD_int_rst					:	std_logic;
	SIGNAL	RXD_int						:	std_logic;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
begin
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		INSTANCEs
	--------------------------------------------------------------------------
	Transiver							:	TRx
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		-- Tx Buff:
		------	OUT
		Rx_Buff_Dout					=>	TRx_Rx_Buff_Din,
		Rx_Buff_Push					=>	TRx_Rx_Buff_Push,
		------	IN
		Tx_Buff_Din						=>	TRx_Tx_Buff_Dout,
		Tx_Buff_Empty					=>	TRx_Tx_Buff_Empty,
		Tx_Buff_Pop						=>	TRx_Tx_Buff_Pop,
		--	Tx Config
		TR_Conf_Top_max					=>	TRx_Top_Val,
		TR_Conf_Clk_Div					=>	TRx_Clk_Div,
		Tx_Conf_Enable					=>	TRx_Enables(5),
		Rx_Conf_Enable					=>	TRx_Enables(4),
		--	Tx line
		Rx_Rx							=>	Rx_Rx,
		Tx_Tx							=>	Tx_Tx);
	--------------------------------------------------------------------------
	TX_Fifo								:	FIFO_v2
	GENERIC	MAP(
		depth							=>	P_Transiver_Word_size,
		word_size						=>	8,
		reged_output					=>	0)
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		-- input
		push							=>	TRx_Tx_Buff_Push,
		data_in							=>	TRx_Tx_Buff_Din,
		full							=>	TRx_Tx_Buff_Full,
		-- output
		pop								=>	TRx_Tx_Buff_Pop,
		data_out						=>	TRx_Tx_Buff_Dout,
		empty							=>	TRx_Tx_Buff_Empty);
	--------------------------------------------------------------------------
	RX_Fifo								:	FIFO_v2
	GENERIC	MAP(
		depth							=>	P_Transiver_Word_size,
		word_size						=>	9,
		reged_output					=>	0)
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		-- input
		push							=>	TRx_Rx_Buff_Push,
		data_in							=>	TRx_Rx_Buff_Din,
		full							=>	TRx_Rx_Buff_Full,
		-- output
		pop								=>	TRx_Rx_Buff_Pop,
		data_out						=>	TRx_Rx_Buff_Dout,
		empty							=>	TRx_Rx_Buff_Empty);
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		Connections
	--------------------------------------------------------------------------
	TRx_Buf_Flg							<=	TRx_Tx_Buff_Empty	&	TRx_Tx_Buff_Full	&	TRx_Rx_Buff_Empty	&	TRx_Rx_Buff_Full;
	--------------------------------------------------------------------------
	TRx_Tx_Buff_Push					<=	TRx_MM_Wen;
	TRx_Tx_Buff_Din						<=	TRx_MM_Din;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		Interrupts
	--------------------------------------------------------------------------
	TBE_int_rst							<=	(NOT TRx_Enables(3))	OR	ANS_Tx_Buff_Empty	OR	rst;
	RBF_int_rst							<=	(NOT TRx_Enables(2))	OR	ANS_Rx_Buff_Full	OR	rst;
	TXD_int_rst							<=	(NOT TRx_Enables(1))	OR	ANS_Tx_Sent			OR	rst;
	RXD_int_rst							<=	(NOT TRx_Enables(0))	OR	ANS_Rx_Received		OR	rst;
	TBE_int_set							<=	TRx_Enables(3)			AND	TRx_Tx_Buff_Empty;
	RBF_int_set							<=	TRx_Enables(2)			AND	TRx_Rx_Buff_Full;
	TXD_int_set							<=	TRx_Enables(1)			AND	TRx_Tx_Buff_Pop;
	RXD_int_set							<=	TRx_Enables(0)			AND	TRx_Rx_Buff_Push;
	--------------------------------------------------------------------------
	INT_Tx_Buff_Empty					<=	TBE_int;
	INT_Tx_Sent							<=	TXD_int;
	INT_Rx_Buff_Full					<=	RBF_int;
	INT_Rx_Received						<=	RXD_int;
	--------------------------------------------------------------------------
	PROCESS	(clk, TBE_int_rst)
	BEGIN
		IF	TBE_int_rst	= '1'	THEN
			TBE_int		<=	'0';
		ELSIF clk = '1' AND clk'EVENT THEN
			IF TBE_int_set = '1' THEN
				TBE_int	<=	'1';
			END IF;
		END IF;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS	(clk, RBF_int_rst)
	BEGIN
		IF	RBF_int_rst	= '1'	THEN
			RBF_int		<=	'0';
		ELSIF clk = '1' AND clk'EVENT THEN
			IF RBF_int_set = '1' THEN
				RBF_int	<=	'1';
			END IF;
		END IF;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS	(clk, TXD_int_rst)
	BEGIN
		IF	TXD_int_rst	= '1'	THEN
			TXD_int		<=	'0';
		ELSIF clk = '1' AND clk'EVENT THEN
			IF TXD_int_set = '1' THEN
				TXD_int	<=	'1';
			END IF;
		END IF;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS	(clk, RXD_int_rst)
	BEGIN
		IF	RXD_int_rst	= '1'	THEN
			RXD_int		<=	'0';
		ELSIF clk = '1' AND clk'EVENT THEN
			IF RXD_int_set = '1' THEN
				RXD_int	<=	'1';
			END IF;
		END IF;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS (clk, rst)
		VARIABLE	add					:	INTEGER;
		VARIABLE	Eadd				:	INTEGER;
	BEGIN
		IF rst = '1' THEN
			TRx_MM_Din					<=	(OTHERS	=>	'0');
			TRx_MM_Wen					<=	'0';
			TRx_MM_Dout					<=	(OTHERS	=>	'0');
			TRx_Rx_Buff_Pop				<=	'0';
		ELSIF clk = '1' AND clk'EVENT THEN
			TRx_MM_Wen					<=	'0';
			TRx_MM_Dout					<=	TRx_Rx_Buff_Dout;
			TRx_Rx_Buff_Pop				<=	TRx_MM_Ren;
			add							:=	to_integer(SIGNED(X_check(MAIN_PORT_Address)));
			Eadd						:=	(add - BASE_ADDRESS)/4;
			IF MAIN_PORT_WEN = '1' AND add >= BASE_ADDRESS AND add < ENDx_ADDRESS THEN
				CASE	Eadd			IS
					WHEN	0			=>	TRx_MM_Din		<=	MAIN_PORT_Data_in(7		DOWNTO	0);
											TRx_MM_Wen		<=	'1';
					WHEN	1			=>	TRx_Enables		<=	MAIN_PORT_Data_in(31	DOWNTO	26);
											TRx_INT_Clear	<=	MAIN_PORT_Data_in(25);
											TRx_Clk_Div		<=	MAIN_PORT_Data_in(23	DOWNTO	20);
											TRx_Top_Val		<=	MAIN_PORT_Data_in(15	DOWNTO	0);
					WHEN	OTHERS		=>	NULL;
				END CASE;
			END IF;
		END IF;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS(MAIN_PORT_Address, MAIN_PORT_OEN, TRx_MM_Dout, TRx_Enables, TRx_Clk_Div, TRx_Buf_Flg, TRx_Top_Val)
		VARIABLE	add					:	INTEGER;
		VARIABLE	Eadd				:	INTEGER;
	BEGIN
		TRx_MM_Ren						<=	'0';
		add								:=	to_integer(SIGNED(X_check(MAIN_PORT_Address)));
		Eadd							:=	(add/4) - (BASE_ADDRESS/4);
		IF MAIN_PORT_OEN = '1' AND add  >= BASE_ADDRESS AND add < ENDx_ADDRESS THEN
			CASE	Eadd			IS
					WHEN	0			=>	MAIN_PORT_Data_out	<=	TRx_MM_Dout(8)	&	"000"	&	X"00000"	&	TRx_MM_Dout(7 DOWNTO 0);
											TRx_MM_Ren			<=	'1';
					WHEN	1			=>	MAIN_PORT_Data_out	<=	TRx_Enables		&	"00"	&	TRx_Clk_Div	&	TRx_Buf_Flg		&	TRx_Top_Val;
					WHEN	OTHERS		=>	MAIN_PORT_Data_out	<=	(OTHERS	=>	'0');
				END CASE;
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
	--------------------------------------------------------------------------
end Behavioral;



	
	
	
	