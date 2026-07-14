library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.my_pack_v2.ALL;
	
entity Interrupt_handler is				--	217	Interrupt Source
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
		
		--	Accelerator 
		------	Requests
		INT_REQ_SYS_PC					:	IN	std_logic;
		INT_REQ_TBE						:	IN	std_logic;
		INT_REQ_RBF						:	IN	std_logic;
		INT_REQ_TXD						:	IN	std_logic;
		INT_REQ_RXD						:	IN	std_logic;
		INT_REQ_SYS_TIMER				:	IN	std_logic_vector(7	DOWNTO	0);
		INT_REQ_MPDR_Ready				:	IN	Unc_1D_array	(15	DOWNTO	0);
		INT_REQ_DMA_Ready				:	IN	Unc_1D_array	(15	DOWNTO	0);
		INT_REQ_PSU_Done				:	IN	Plane_std_logic_4X4;
		------	Acknowledge
		INT_ACK_SYS_PC					:	OUT	std_logic;
		INT_ACK_TBE						:	OUT	std_logic;
		INT_ACK_RBF						:	OUT	std_logic;
		INT_ACK_TXD						:	OUT	std_logic;
		INT_ACK_RXD						:	OUT	std_logic;
		INT_ACK_SYS_TIMER				:	OUT	std_logic_vector(7	DOWNTO	0);
		INT_ACK_MPDR_Ready				:	OUT	Unc_1D_array	(15	DOWNTO	0);
		INT_ACK_DMA_Ready				:	OUT	Unc_1D_array	(15	DOWNTO	0);
		INT_ACK_PSU_Done				:	OUT	Plane_std_logic_4X4;
		
		
		--	Interrupt Port
        INT_REQ							:	OUT	std_logic;
        INT_ACK							:	IN	std_logic);
end Interrupt_handler;

architecture Behavioral of Interrupt_handler IS
--------------------------------------------------------------------------
	--		CONSTANTs
	--------------------------------------------------------------------------
	CONSTANT	NUMB_ints				:	INTEGER	:=	8;
	CONSTANT	ENDx_ADDRESS			:	INTEGER	:=	(BASE_ADDRESS + 4*NUMB_ints);
	--------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------------------------------
	--	INT ENABLE 0
	--	N	|		31		|		30		|		29		|		28		|		27		|		26		|		25		|		24		|
	--	T	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|
	--		
	--	E	|		23		|		22		|		21		|		20		|		19		|		18		|		17		|		16		|
	--	N	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|
	--	A
	--	B	|		15		|		14		|		13		|		12		|		11		|		10		|		9		|		8		|
	--	L	|=== TIMER 7 ===|=== TIMER 6 ===|=== TIMER 5 ===|=== TIMER 4 ===|=== TIMER 3 ===|=== TIMER 2 ===|=== TIMER 1 ===|=== TIMER 0 ===|
	--	E	
	--		|		7		|		6		|		5		|		4		|		3		|		2		|		1		|		0		|
	--	0	|== RESERVED ===|== RESERVED ===|== RESERVED ===|===== RXD =====|===== TXD =====|===== RBF =====|===== TBE =====|=== PC  Req ===|
	--		
	------------------------------------------------------------------------------------------------------------------------------------------
	--	INT ENABLE 1
	--	N	|		31		|		30		|		29		|		28		|		27		|		26		|		25		|		24		|
	--	T	|= DMA 4,4 Rdy =|= DMA 4,3 Rdy =|= DMA 4,2 Rdy =|= DMA 4,1 Rdy =|= DMA 3,4 Rdy =|= DMA 3,3 Rdy =|= DMA 3,2 Rdy =|= DMA 3,1 Rdy =|
	--		
	--	E	|		23		|		22		|		21		|		20		|		19		|		18		|		17		|		16		|
	--	N	|= DMA 2,4 Rdy =|= DMA 2,3 Rdy =|= DMA 2,2 Rdy =|= DMA 2,1 Rdy =|= DMA 1,4 Rdy =|= DMA 1,3 Rdy =|= DMA 1,2 Rdy =|= DMA 1,1 Rdy =|
	--	A
	--	B	|		15		|		14		|		13		|		12		|		11		|		10		|		9		|		8		|
	--	L	|=MPDR 4,4 Rdy =|=MPDR 4,3 Rdy =|=MPDR 4,2 Rdy =|=MPDR 4,1 Rdy =|=MPDR 3,4 Rdy =|=MPDR 3,3 Rdy =|=MPDR 3,2 Rdy =|=MPDR 3,1 Rdy =|
	--	E	
	--		|		7		|		6		|		5		|		4		|		3		|		2		|		1		|		0		|
	--	0	|=MPDR 2,4 Rdy =|=MPDR 2,3 Rdy =|=MPDR 2,2 Rdy =|=MPDR 2,1 Rdy =|=MPDR 1,4 Rdy =|=MPDR 1,3 Rdy =|=MPDR 1,2 Rdy =|=MPDR 1,1 Rdy =|
	--		
	------------------------------------------------------------------------------------------------------------------------------------------
	--	INT ENABLE 2
	--	N	|		31		|		30		|		29		|		28		|		27		|		26		|		25		|		24		|
	--	T	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|
	--		
	--	E	|		23		|		22		|		21		|		20		|		19		|		18		|		17		|		16		|
	--	N	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|
	--	A	
	--	B	|		15		|		14		|		13		|		12		|		11		|		10		|		9		|		8		|
	--	L	| PE 1,4,4 Done | PE 1,4,3 Done | PE 1,4,2 Done | PE 1,4,1 Done | PE 1,3,4 Done | PE 1,3,3 Done | PE 1,3,2 Done | PE 1,3,1 Done |
	--	E	
	--		|		7		|		6		|		5		|		4		|		3		|		2		|		1		|		0		|
	--	1	| PE 1,2,4 Done | PE 1,2,3 Done | PE 1,2,2 Done | PE 1,2,1 Done | PE 1,1,4 Done | PE 1,1,3 Done | PE 1,1,2 Done | PE 1,1,1 Done |
	--		
	------------------------------------------------------------------------------------------------------------------------------------------
	--	INT ENABLE 3
	--	N	|		31		|		30		|		29		|		28		|		27		|		26		|		25		|		24		|
	--	T	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|
	--		
	--	E	|		23		|		22		|		21		|		20		|		19		|		18		|		17		|		16		|
	--	N	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|
	--	A	
	--	B	|		15		|		14		|		13		|		12		|		11		|		10		|		9		|		8		|
	--	L	| PE 2,4,4 Done | PE 2,4,3 Done | PE 2,4,2 Done | PE 2,4,1 Done | PE 2,3,4 Done | PE 2,3,3 Done | PE 2,3,2 Done | PE 2,3,1 Done |
	--	E	
	--		|		7		|		6		|		5		|		4		|		3		|		2		|		1		|		0		|
	--	3	| PE 2,2,4 Done | PE 2,2,3 Done | PE 2,2,2 Done | PE 2,2,1 Done | PE 2,1,4 Done | PE 2,1,3 Done | PE 2,1,2 Done | PE 2,1,1 Done |
	--		
	------------------------------------------------------------------------------------------------------------------------------------------
	--	INT ENABLE 4
	--	N	|		31		|		30		|		29		|		28		|		27		|		26		|		25		|		24		|
	--	T	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|
	--		
	--	E	|		23		|		22		|		21		|		20		|		19		|		18		|		17		|		16		|
	--	N	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|
	--	A	
	--	B	|		15		|		14		|		13		|		12		|		11		|		10		|		9		|		8		|
	--	L	| PE 3,4,4 Done | PE 3,4,3 Done | PE 3,4,2 Done | PE 3,4,1 Done | PE 3,3,4 Done | PE 3,3,3 Done | PE 3,3,2 Done | PE 3,3,1 Done |
	--	E	
	--		|		7		|		6		|		5		|		4		|		3		|		2		|		1		|		0		|
	--	5	| PE 3,2,4 Done | PE 3,2,3 Done | PE 3,2,2 Done | PE 3,2,1 Done | PE 3,1,4 Done | PE 3,1,3 Done | PE 3,1,2 Done | PE 3,1,1 Done |
	--		
	------------------------------------------------------------------------------------------------------------------------------------------
	--	INT ENABLE 5
	--	N	|		31		|		30		|		29		|		28		|		27		|		26		|		25		|		24		|
	--	T	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|
	--		
	--	E	|		23		|		22		|		21		|		20		|		19		|		18		|		17		|		16		|
	--	N	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|
	--	A	
	--	B	|		15		|		14		|		13		|		12		|		11		|		10		|		9		|		8		|
	--	L	| PE 4,4,4 Done | PE 4,4,3 Done | PE 4,4,2 Done | PE 4,4,1 Done | PE 4,3,4 Done | PE 4,3,3 Done | PE 4,3,2 Done | PE 4,3,1 Done |
	--	E	
	--		|		7		|		6		|		5		|		4		|		3		|		2		|		1		|		0		|
	--	7	| PE 4,2,4 Done | PE 4,2,3 Done | PE 4,2,2 Done | PE 4,2,1 Done | PE 4,1,4 Done | PE 4,1,3 Done | PE 4,1,2 Done | PE 4,1,1 Done |
	--		
	--		
	--	
	--	Interrupt Priority:
	--		INT_EN_0_b0	> INT_EN_0_b1 > ... > INT_EN_0_b31 > INT_EN_1_b0 > > INT_EN_1_b1 > ... > INT_EN_9_b0 > INT_EN_9_b1 > ... > INT_EN_9_b31
	--		Higher		>																										 > LOWER
	-----------------------------------------------------------------------------------------------------------------------------------------
	--	INT ADDRESS
	--	N	|	31		30		29		28		27		26		25		24	|	23		22		21	 	20	 	19		18		17		16	|
	--	T	|====================== THIS INT Address =======================|======================= NEXT INT Address ======================|
	--		
	--	A	
	--	D	|	15		14		13		12	|	11		10		9		8	|	7		6		5		4	|	3		2		1		0	|
	--	D	|=============== RESERVED ======|====== THIS INT Add Code ======|============== RESERVED =======|====== Next INT Add Code ======|
	--
	-----------------------------------------------------------------------------------------------------------------------------------------
	--	INT ACKNOWLEDGE
	--	N	|	31		30		29		28		27		26		25		24		23		22		21	 	20	 	19		18		17		16	|
	--	T	|========================================================== RESERVED ===========================================================|
	--		
	--	A	
	--	C	|	15		14		13		12		11		10		9		8		7		6		5		4		3		2		1	|	0	|
	--	K	|====================================================== RESERVED =======================================================|= ACK =|
	--
	-----------------------------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		ADDRESS	MAP														--
	--------------------------------------------------------------------------
	--		BASE_ADDRESS	+	00		:	INT ENABLE	0	(PC - TBE - RBF)
	--		BASE_ADDRESS	+	04		:	INT ENABLE	1	(MPDR - DMA)
	--		BASE_ADDRESS	+	08		:	INT ENABLE	2	(PSU Plane 0)
	--		BASE_ADDRESS	+	0C		:	INT ENABLE	3	(PSU Plane 1)
	--		BASE_ADDRESS	+	10		:	INT ENABLE	4	(PSU Plane 2)
	--		BASE_ADDRESS	+	14		:	INT ENABLE	5	(PSU Plane 3)
	--		BASE_ADDRESS	+	18		:	INT ADDRESS
	--		BASE_ADDRESS	+	1C		:	INT	ACKNOWLEDGE
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		TYPEs
	--------------------------------------------------------------------------
	TYPE	INT_ARR_T					IS	ARRAY(0 TO 6)	OF std_logic_vector(15	DOWNTO	0);
	TYPE	INT_ARR_LOC_T				IS	ARRAY(0 TO 6)	OF std_logic_vector(4	DOWNTO	0);
	TYPE	states						IS	(reset, get_req, put_req, put_ack);
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		SINGALs
	--------------------------------------------------------------------------
	SIGNAL	INT_REQ_ALL					:	std_logic_vector(111	DOWNTO	0);
	SIGNAL	INT_ACK_ALL					:	std_logic_vector(111	DOWNTO	0);
	SIGNAL	INT_REQ_ARR					:	INT_ARR_T;
	SIGNAL	INT_REQ_ARR_LOC				:	INT_ARR_LOC_T;
	--------------------------------------------------------------------------
	SIGNAL	P_State						:	states;
	SIGNAL	N_State						:	states;
	SIGNAL	INT_ADD_L					:	std_logic_vector(7	DOWNTO	0);
	SIGNAL	INT_DEC_L					:	std_logic_vector(3	DOWNTO	0);
	SIGNAL	THIS_INT_Load				:	std_logic;
	SIGNAL	INT_ADD_load				:	std_logic;
	SIGNAL	INT_APP_ACK					:	std_logic;
	--------------------------------------------------------------------------
	SIGNAL	INT_ENABLEs					:	std_logic_vector(111	DOWNTO	0);
	SIGNAL	NEXT_INT_ADDRESS			:	std_logic_vector(7		DOWNTO	0);
	SIGNAL	THIS_INT_ADDRESS			:	std_logic_vector(7		DOWNTO	0);
	SIGNAL	NEXT_INT_Code				:	std_logic_vector(3		DOWNTO	0);
	SIGNAL	THIS_INT_Code				:	std_logic_vector(3		DOWNTO	0);
	--------------------------------------------------------------------------
begin
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--			INTERRUPT Vectors, Base on order							--
	--------------------------------------------------------------------------
	
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
																		------------------------------------------------------------------------------------------------------------
																		--		INT ENABLE	0
																		------------------------------------------------------------------------------------------------------------
																		INT_REQ_ALL(0)						<=	INT_ENABLEs(0)		AND		INT_REQ_SYS_PC;
																		INT_REQ_ALL(1)						<=	INT_ENABLEs(1)		AND		INT_REQ_TBE;
																		INT_REQ_ALL(2)						<=	INT_ENABLEs(2)		AND		INT_REQ_RBF;
																		INT_REQ_ALL(3)						<=	INT_ENABLEs(3)		AND		INT_REQ_TXD;
																		INT_REQ_ALL(4)						<=	INT_ENABLEs(4)		AND		INT_REQ_RXD;
																		INT_REQ_ALL(5)						<=	'0';
																		INT_REQ_ALL(6)						<=	'0';
																		INT_REQ_ALL(7)						<=	'0';
																		INT_REQ_ALL(8)						<=	INT_ENABLEs(8)		AND		INT_REQ_SYS_TIMER	(0);
																		INT_REQ_ALL(9)						<=	INT_ENABLEs(9)		AND		INT_REQ_SYS_TIMER	(1);
																		INT_REQ_ALL(10)						<=	INT_ENABLEs(10)		AND		INT_REQ_SYS_TIMER	(2);
																		INT_REQ_ALL(11)						<=	INT_ENABLEs(11)		AND		INT_REQ_SYS_TIMER	(3);
																		INT_REQ_ALL(12)						<=	INT_ENABLEs(12)		AND		INT_REQ_SYS_TIMER	(4);
																		INT_REQ_ALL(13)						<=	INT_ENABLEs(13)		AND		INT_REQ_SYS_TIMER	(5);
																		INT_REQ_ALL(14)						<=	INT_ENABLEs(14)		AND		INT_REQ_SYS_TIMER	(6);
																		INT_REQ_ALL(15)						<=	INT_ENABLEs(15)		AND		INT_REQ_SYS_TIMER	(7);
																		------------------------------------------------------------------------------------------------------------
																		--		INT ENABLE	1
																		------------------------------------------------------------------------------------------------------------
																		INT_REQ_ALL(16)						<=	INT_ENABLEs(16)		AND		INT_REQ_MPDR_Ready	(0);
																		INT_REQ_ALL(17)						<=	INT_ENABLEs(17)		AND		INT_REQ_MPDR_Ready	(1);
																		INT_REQ_ALL(18)						<=	INT_ENABLEs(18)		AND		INT_REQ_MPDR_Ready	(2);
																		INT_REQ_ALL(19)						<=	INT_ENABLEs(19)		AND		INT_REQ_MPDR_Ready	(3);
																		INT_REQ_ALL(20)						<=	INT_ENABLEs(20)		AND		INT_REQ_MPDR_Ready	(4);
																		INT_REQ_ALL(21)						<=	INT_ENABLEs(21)		AND		INT_REQ_MPDR_Ready	(5);
																		INT_REQ_ALL(22)						<=	INT_ENABLEs(22)		AND		INT_REQ_MPDR_Ready	(6);
																		INT_REQ_ALL(23)						<=	INT_ENABLEs(23)		AND		INT_REQ_MPDR_Ready	(7);
																		INT_REQ_ALL(24)						<=	INT_ENABLEs(24)		AND		INT_REQ_MPDR_Ready	(8);
																		INT_REQ_ALL(25)						<=	INT_ENABLEs(25)		AND		INT_REQ_MPDR_Ready	(9);
																		INT_REQ_ALL(26)						<=	INT_ENABLEs(26)		AND		INT_REQ_MPDR_Ready	(10);
																		INT_REQ_ALL(27)						<=	INT_ENABLEs(27)		AND		INT_REQ_MPDR_Ready	(11);
																		INT_REQ_ALL(28)						<=	INT_ENABLEs(28)		AND		INT_REQ_MPDR_Ready	(12);
																		INT_REQ_ALL(29)						<=	INT_ENABLEs(29)		AND		INT_REQ_MPDR_Ready	(13);
																		INT_REQ_ALL(30)						<=	INT_ENABLEs(30)		AND		INT_REQ_MPDR_Ready	(14);
																		INT_REQ_ALL(31)						<=	INT_ENABLEs(31)		AND		INT_REQ_MPDR_Ready	(15);
																		INT_REQ_ALL(32)						<=	INT_ENABLEs(32)		AND		INT_REQ_DMA_Ready	(0);
																		INT_REQ_ALL(33)						<=	INT_ENABLEs(33)		AND		INT_REQ_DMA_Ready	(1);
																		INT_REQ_ALL(34)						<=	INT_ENABLEs(34)		AND		INT_REQ_DMA_Ready	(2);
																		INT_REQ_ALL(35)						<=	INT_ENABLEs(35)		AND		INT_REQ_DMA_Ready	(3);
																		INT_REQ_ALL(36)						<=	INT_ENABLEs(36)		AND		INT_REQ_DMA_Ready	(4);
																		INT_REQ_ALL(37)						<=	INT_ENABLEs(37)		AND		INT_REQ_DMA_Ready	(5);
																		INT_REQ_ALL(38)						<=	INT_ENABLEs(38)		AND		INT_REQ_DMA_Ready	(6);
																		INT_REQ_ALL(39)						<=	INT_ENABLEs(39)		AND		INT_REQ_DMA_Ready	(7);
																		INT_REQ_ALL(40)						<=	INT_ENABLEs(40)		AND		INT_REQ_DMA_Ready	(8);
																		INT_REQ_ALL(41)						<=	INT_ENABLEs(41)		AND		INT_REQ_DMA_Ready	(9);
																		INT_REQ_ALL(42)						<=	INT_ENABLEs(42)		AND		INT_REQ_DMA_Ready	(10);
																		INT_REQ_ALL(43)						<=	INT_ENABLEs(43)		AND		INT_REQ_DMA_Ready	(11);
																		INT_REQ_ALL(44)						<=	INT_ENABLEs(44)		AND		INT_REQ_DMA_Ready	(12);
																		INT_REQ_ALL(45)						<=	INT_ENABLEs(45)		AND		INT_REQ_DMA_Ready	(13);
																		INT_REQ_ALL(46)						<=	INT_ENABLEs(46)		AND		INT_REQ_DMA_Ready	(14);
																		INT_REQ_ALL(47)						<=	INT_ENABLEs(47)		AND		INT_REQ_DMA_Ready	(15);
																		------------------------------------------------------------------------------------------------------------
																		--		INT ENABLE	2
																		------------------------------------------------------------------------------------------------------------
																		INT_REQ_ALL(48)						<=	INT_ENABLEs(48)		AND		INT_REQ_PSU_Done	(0)(1,1);
																		INT_REQ_ALL(49)						<=	INT_ENABLEs(49)		AND		INT_REQ_PSU_Done	(0)(1,2);
																		INT_REQ_ALL(50)						<=	INT_ENABLEs(50)		AND		INT_REQ_PSU_Done	(0)(1,3);
																		INT_REQ_ALL(51)						<=	INT_ENABLEs(51)		AND		INT_REQ_PSU_Done	(0)(1,4);
																		INT_REQ_ALL(52)						<=	INT_ENABLEs(52)		AND		INT_REQ_PSU_Done	(0)(2,1);
																		INT_REQ_ALL(53)						<=	INT_ENABLEs(53)		AND		INT_REQ_PSU_Done	(0)(2,2);
																		INT_REQ_ALL(54)						<=	INT_ENABLEs(54)		AND		INT_REQ_PSU_Done	(0)(2,3);
																		INT_REQ_ALL(55)						<=	INT_ENABLEs(55)		AND		INT_REQ_PSU_Done	(0)(2,4);
																		INT_REQ_ALL(56)						<=	INT_ENABLEs(56)		AND		INT_REQ_PSU_Done	(0)(3,1);
																		INT_REQ_ALL(57)						<=	INT_ENABLEs(57)		AND		INT_REQ_PSU_Done	(0)(3,2);
																		INT_REQ_ALL(58)						<=	INT_ENABLEs(58)		AND		INT_REQ_PSU_Done	(0)(3,3);
																		INT_REQ_ALL(59)						<=	INT_ENABLEs(59)		AND		INT_REQ_PSU_Done	(0)(3,4);
																		INT_REQ_ALL(60)						<=	INT_ENABLEs(60)		AND		INT_REQ_PSU_Done	(0)(4,1);
																		INT_REQ_ALL(61)						<=	INT_ENABLEs(61)		AND		INT_REQ_PSU_Done	(0)(4,2);
																		INT_REQ_ALL(62)						<=	INT_ENABLEs(62)		AND		INT_REQ_PSU_Done	(0)(4,3);
																		INT_REQ_ALL(63)						<=	INT_ENABLEs(63)		AND		INT_REQ_PSU_Done	(0)(4,4);
																		------------------------------------------------------------------------------------------------------------
																		--		INT ENABLE	3
																		------------------------------------------------------------------------------------------------------------
	PLANE_REQ_CHECK_64	:	IF	P_Number_of_Planes	>	1	GENERATE	INT_REQ_ALL(64)						<=	INT_ENABLEs(64)		AND		INT_REQ_PSU_Done	(1)(1,1);	END GENERATE;
	PLANE_REQ_CHECK_65	:	IF	P_Number_of_Planes	>	1	GENERATE	INT_REQ_ALL(65)						<=	INT_ENABLEs(65)		AND		INT_REQ_PSU_Done	(1)(1,2);	END GENERATE;
	PLANE_REQ_CHECK_66	:	IF	P_Number_of_Planes	>	1	GENERATE	INT_REQ_ALL(66)						<=	INT_ENABLEs(66)		AND		INT_REQ_PSU_Done	(1)(1,3);	END GENERATE;
	PLANE_REQ_CHECK_67	:	IF	P_Number_of_Planes	>	1	GENERATE	INT_REQ_ALL(67)						<=	INT_ENABLEs(67)		AND		INT_REQ_PSU_Done	(1)(1,4);	END GENERATE;
	PLANE_REQ_CHECK_68	:	IF	P_Number_of_Planes	>	1	GENERATE	INT_REQ_ALL(68)						<=	INT_ENABLEs(68)		AND		INT_REQ_PSU_Done	(1)(2,1);	END GENERATE;
	PLANE_REQ_CHECK_69	:	IF	P_Number_of_Planes	>	1	GENERATE	INT_REQ_ALL(69)						<=	INT_ENABLEs(69)		AND		INT_REQ_PSU_Done	(1)(2,2);	END GENERATE;
	PLANE_REQ_CHECK_70	:	IF	P_Number_of_Planes	>	1	GENERATE	INT_REQ_ALL(70)						<=	INT_ENABLEs(70)		AND		INT_REQ_PSU_Done	(1)(2,3);	END GENERATE;
	PLANE_REQ_CHECK_71	:	IF	P_Number_of_Planes	>	1	GENERATE	INT_REQ_ALL(71)						<=	INT_ENABLEs(71)		AND		INT_REQ_PSU_Done	(1)(2,4);	END GENERATE;
	PLANE_REQ_CHECK_72	:	IF	P_Number_of_Planes	>	1	GENERATE	INT_REQ_ALL(72)						<=	INT_ENABLEs(72)		AND		INT_REQ_PSU_Done	(1)(3,1);	END GENERATE;
	PLANE_REQ_CHECK_73	:	IF	P_Number_of_Planes	>	1	GENERATE	INT_REQ_ALL(73)						<=	INT_ENABLEs(73)		AND		INT_REQ_PSU_Done	(1)(3,2);	END GENERATE;
	PLANE_REQ_CHECK_74	:	IF	P_Number_of_Planes	>	1	GENERATE	INT_REQ_ALL(74)						<=	INT_ENABLEs(74)		AND		INT_REQ_PSU_Done	(1)(3,3);	END GENERATE;
	PLANE_REQ_CHECK_75	:	IF	P_Number_of_Planes	>	1	GENERATE	INT_REQ_ALL(75)						<=	INT_ENABLEs(75)		AND		INT_REQ_PSU_Done	(1)(3,4);	END GENERATE;
	PLANE_REQ_CHECK_76	:	IF	P_Number_of_Planes	>	1	GENERATE	INT_REQ_ALL(76)						<=	INT_ENABLEs(76)		AND		INT_REQ_PSU_Done	(1)(4,1);	END GENERATE;
	PLANE_REQ_CHECK_77	:	IF	P_Number_of_Planes	>	1	GENERATE	INT_REQ_ALL(77)						<=	INT_ENABLEs(77)		AND		INT_REQ_PSU_Done	(1)(4,2);	END GENERATE;
	PLANE_REQ_CHECK_78	:	IF	P_Number_of_Planes	>	1	GENERATE	INT_REQ_ALL(78)						<=	INT_ENABLEs(78)		AND		INT_REQ_PSU_Done	(1)(4,3);	END GENERATE;
	PLANE_REQ_CHECK_79	:	IF	P_Number_of_Planes	>	1	GENERATE	INT_REQ_ALL(79)						<=	INT_ENABLEs(79)		AND		INT_REQ_PSU_Done	(1)(4,4);	END GENERATE;
																		------------------------------------------------------------------------------------------------------------
																		--		INT ENABLE	4
																		------------------------------------------------------------------------------------------------------------
	PLANE_REQ_CHECK_80	:	IF	P_Number_of_Planes	>	2	GENERATE	INT_REQ_ALL(80)						<=	INT_ENABLEs(80)		AND		INT_REQ_PSU_Done	(2)(1,1);	END GENERATE;
	PLANE_REQ_CHECK_81	:	IF	P_Number_of_Planes	>	2	GENERATE	INT_REQ_ALL(81)						<=	INT_ENABLEs(81)		AND		INT_REQ_PSU_Done	(2)(1,2);	END GENERATE;
	PLANE_REQ_CHECK_82	:	IF	P_Number_of_Planes	>	2	GENERATE	INT_REQ_ALL(82)						<=	INT_ENABLEs(82)		AND		INT_REQ_PSU_Done	(2)(1,3);	END GENERATE;
	PLANE_REQ_CHECK_83	:	IF	P_Number_of_Planes	>	2	GENERATE	INT_REQ_ALL(83)						<=	INT_ENABLEs(83)		AND		INT_REQ_PSU_Done	(2)(1,4);	END GENERATE;
	PLANE_REQ_CHECK_84	:	IF	P_Number_of_Planes	>	2	GENERATE	INT_REQ_ALL(84)						<=	INT_ENABLEs(84)		AND		INT_REQ_PSU_Done	(2)(2,1);	END GENERATE;
	PLANE_REQ_CHECK_85	:	IF	P_Number_of_Planes	>	2	GENERATE	INT_REQ_ALL(85)						<=	INT_ENABLEs(85)		AND		INT_REQ_PSU_Done	(2)(2,2);	END GENERATE;
	PLANE_REQ_CHECK_86	:	IF	P_Number_of_Planes	>	2	GENERATE	INT_REQ_ALL(86)						<=	INT_ENABLEs(86)		AND		INT_REQ_PSU_Done	(2)(2,3);	END GENERATE;
	PLANE_REQ_CHECK_87	:	IF	P_Number_of_Planes	>	2	GENERATE	INT_REQ_ALL(87)						<=	INT_ENABLEs(87)		AND		INT_REQ_PSU_Done	(2)(2,4);	END GENERATE;
	PLANE_REQ_CHECK_88	:	IF	P_Number_of_Planes	>	2	GENERATE	INT_REQ_ALL(88)						<=	INT_ENABLEs(88)		AND		INT_REQ_PSU_Done	(2)(3,1);	END GENERATE;
	PLANE_REQ_CHECK_89	:	IF	P_Number_of_Planes	>	2	GENERATE	INT_REQ_ALL(89)						<=	INT_ENABLEs(89)		AND		INT_REQ_PSU_Done	(2)(3,2);	END GENERATE;
	PLANE_REQ_CHECK_90	:	IF	P_Number_of_Planes	>	2	GENERATE	INT_REQ_ALL(90)						<=	INT_ENABLEs(90)		AND		INT_REQ_PSU_Done	(2)(3,3);	END GENERATE;
	PLANE_REQ_CHECK_91	:	IF	P_Number_of_Planes	>	2	GENERATE	INT_REQ_ALL(91)						<=	INT_ENABLEs(91)		AND		INT_REQ_PSU_Done	(2)(3,4);	END GENERATE;
	PLANE_REQ_CHECK_92	:	IF	P_Number_of_Planes	>	2	GENERATE	INT_REQ_ALL(92)						<=	INT_ENABLEs(92)		AND		INT_REQ_PSU_Done	(2)(4,1);	END GENERATE;
	PLANE_REQ_CHECK_93	:	IF	P_Number_of_Planes	>	2	GENERATE	INT_REQ_ALL(93)						<=	INT_ENABLEs(93)		AND		INT_REQ_PSU_Done	(2)(4,2);	END GENERATE;
	PLANE_REQ_CHECK_94	:	IF	P_Number_of_Planes	>	2	GENERATE	INT_REQ_ALL(94)						<=	INT_ENABLEs(94)		AND		INT_REQ_PSU_Done	(2)(4,3);	END GENERATE;
	PLANE_REQ_CHECK_95	:	IF	P_Number_of_Planes	>	2	GENERATE	INT_REQ_ALL(95)						<=	INT_ENABLEs(95)		AND		INT_REQ_PSU_Done	(2)(4,4);	END GENERATE;
																		------------------------------------------------------------------------------------------------------------
																		--		INT ENABLE	5
																		------------------------------------------------------------------------------------------------------------
	PLANE_REQ_CHECK_96	:	IF	P_Number_of_Planes	>	3	GENERATE	INT_REQ_ALL(96)						<=	INT_ENABLEs(96)		AND		INT_REQ_PSU_Done	(3)(1,1);	END GENERATE;
	PLANE_REQ_CHECK_97	:	IF	P_Number_of_Planes	>	3	GENERATE	INT_REQ_ALL(97)						<=	INT_ENABLEs(97)		AND		INT_REQ_PSU_Done	(3)(1,2);	END GENERATE;
	PLANE_REQ_CHECK_98	:	IF	P_Number_of_Planes	>	3	GENERATE	INT_REQ_ALL(98)						<=	INT_ENABLEs(98)		AND		INT_REQ_PSU_Done	(3)(1,3);	END GENERATE;
	PLANE_REQ_CHECK_99	:	IF	P_Number_of_Planes	>	3	GENERATE	INT_REQ_ALL(99)						<=	INT_ENABLEs(99)		AND		INT_REQ_PSU_Done	(3)(1,4);	END GENERATE;
	PLANE_REQ_CHECK_100	:	IF	P_Number_of_Planes	>	3	GENERATE	INT_REQ_ALL(100)					<=	INT_ENABLEs(100)	AND		INT_REQ_PSU_Done	(3)(2,1);	END GENERATE;
	PLANE_REQ_CHECK_101	:	IF	P_Number_of_Planes	>	3	GENERATE	INT_REQ_ALL(101)					<=	INT_ENABLEs(101)	AND		INT_REQ_PSU_Done	(3)(2,2);	END GENERATE;
	PLANE_REQ_CHECK_102	:	IF	P_Number_of_Planes	>	3	GENERATE	INT_REQ_ALL(102)					<=	INT_ENABLEs(102)	AND		INT_REQ_PSU_Done	(3)(2,3);	END GENERATE;
	PLANE_REQ_CHECK_103	:	IF	P_Number_of_Planes	>	3	GENERATE	INT_REQ_ALL(103)					<=	INT_ENABLEs(103)	AND		INT_REQ_PSU_Done	(3)(2,4);	END GENERATE;
	PLANE_REQ_CHECK_104	:	IF	P_Number_of_Planes	>	3	GENERATE	INT_REQ_ALL(104)					<=	INT_ENABLEs(104)	AND		INT_REQ_PSU_Done	(3)(3,1);	END GENERATE;
	PLANE_REQ_CHECK_105	:	IF	P_Number_of_Planes	>	3	GENERATE	INT_REQ_ALL(105)					<=	INT_ENABLEs(105)	AND		INT_REQ_PSU_Done	(3)(3,2);	END GENERATE;
	PLANE_REQ_CHECK_106	:	IF	P_Number_of_Planes	>	3	GENERATE	INT_REQ_ALL(106)					<=	INT_ENABLEs(106)	AND		INT_REQ_PSU_Done	(3)(3,3);	END GENERATE;
	PLANE_REQ_CHECK_107	:	IF	P_Number_of_Planes	>	3	GENERATE	INT_REQ_ALL(107)					<=	INT_ENABLEs(107)	AND		INT_REQ_PSU_Done	(3)(3,4);	END GENERATE;
	PLANE_REQ_CHECK_108	:	IF	P_Number_of_Planes	>	3	GENERATE	INT_REQ_ALL(108)					<=	INT_ENABLEs(108)	AND		INT_REQ_PSU_Done	(3)(4,1);	END GENERATE;
	PLANE_REQ_CHECK_109	:	IF	P_Number_of_Planes	>	3	GENERATE	INT_REQ_ALL(109)					<=	INT_ENABLEs(109)	AND		INT_REQ_PSU_Done	(3)(4,2);	END GENERATE;
	PLANE_REQ_CHECK_110	:	IF	P_Number_of_Planes	>	3	GENERATE	INT_REQ_ALL(110)					<=	INT_ENABLEs(110)	AND		INT_REQ_PSU_Done	(3)(4,3);	END GENERATE;
	PLANE_REQ_CHECK_111	:	IF	P_Number_of_Planes	>	3	GENERATE	INT_REQ_ALL(111)					<=	INT_ENABLEs(111)	AND		INT_REQ_PSU_Done	(3)(4,4);	END GENERATE;
	--------------------------------------------------------------------------      
	--------------------------------------------------------------------------      
	--------------------------------------------------------------------------      
	--	Zero Connections  
	--------------------------------------------------------------------------    
	PLANE_REQ_ZERO_64	:	IF	P_Number_of_Planes	<=	1	GENERATE	INT_REQ_ALL(64)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_65	:	IF	P_Number_of_Planes	<=	1	GENERATE	INT_REQ_ALL(65)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_66	:	IF	P_Number_of_Planes	<=	1	GENERATE	INT_REQ_ALL(66)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_67	:	IF	P_Number_of_Planes	<=	1	GENERATE	INT_REQ_ALL(67)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_68	:	IF	P_Number_of_Planes	<=	1	GENERATE	INT_REQ_ALL(68)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_69	:	IF	P_Number_of_Planes	<=	1	GENERATE	INT_REQ_ALL(69)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_70	:	IF	P_Number_of_Planes	<=	1	GENERATE	INT_REQ_ALL(70)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_71	:	IF	P_Number_of_Planes	<=	1	GENERATE	INT_REQ_ALL(71)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_72	:	IF	P_Number_of_Planes	<=	1	GENERATE	INT_REQ_ALL(72)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_73	:	IF	P_Number_of_Planes	<=	1	GENERATE	INT_REQ_ALL(73)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_74	:	IF	P_Number_of_Planes	<=	1	GENERATE	INT_REQ_ALL(74)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_75	:	IF	P_Number_of_Planes	<=	1	GENERATE	INT_REQ_ALL(75)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_76	:	IF	P_Number_of_Planes	<=	1	GENERATE	INT_REQ_ALL(76)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_77	:	IF	P_Number_of_Planes	<=	1	GENERATE	INT_REQ_ALL(77)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_78	:	IF	P_Number_of_Planes	<=	1	GENERATE	INT_REQ_ALL(78)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_79	:	IF	P_Number_of_Planes	<=	1	GENERATE	INT_REQ_ALL(79)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_80	:	IF	P_Number_of_Planes	<=	2	GENERATE	INT_REQ_ALL(80)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_81	:	IF	P_Number_of_Planes	<=	2	GENERATE	INT_REQ_ALL(81)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_82	:	IF	P_Number_of_Planes	<=	2	GENERATE	INT_REQ_ALL(82)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_83	:	IF	P_Number_of_Planes	<=	2	GENERATE	INT_REQ_ALL(83)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_84	:	IF	P_Number_of_Planes	<=	2	GENERATE	INT_REQ_ALL(84)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_85	:	IF	P_Number_of_Planes	<=	2	GENERATE	INT_REQ_ALL(85)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_86	:	IF	P_Number_of_Planes	<=	2	GENERATE	INT_REQ_ALL(86)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_87	:	IF	P_Number_of_Planes	<=	2	GENERATE	INT_REQ_ALL(87)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_88	:	IF	P_Number_of_Planes	<=	2	GENERATE	INT_REQ_ALL(88)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_89	:	IF	P_Number_of_Planes	<=	2	GENERATE	INT_REQ_ALL(89)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_90	:	IF	P_Number_of_Planes	<=	2	GENERATE	INT_REQ_ALL(90)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_91	:	IF	P_Number_of_Planes	<=	2	GENERATE	INT_REQ_ALL(91)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_92	:	IF	P_Number_of_Planes	<=	2	GENERATE	INT_REQ_ALL(92)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_93	:	IF	P_Number_of_Planes	<=	2	GENERATE	INT_REQ_ALL(93)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_94	:	IF	P_Number_of_Planes	<=	2	GENERATE	INT_REQ_ALL(94)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_95	:	IF	P_Number_of_Planes	<=	2	GENERATE	INT_REQ_ALL(95)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_96	:	IF	P_Number_of_Planes	<=	3	GENERATE	INT_REQ_ALL(96)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_97	:	IF	P_Number_of_Planes	<=	3	GENERATE	INT_REQ_ALL(97)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_98	:	IF	P_Number_of_Planes	<=	3	GENERATE	INT_REQ_ALL(98)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_99	:	IF	P_Number_of_Planes	<=	3	GENERATE	INT_REQ_ALL(99)						<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_100	:	IF	P_Number_of_Planes	<=	3	GENERATE	INT_REQ_ALL(100)					<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_101	:	IF	P_Number_of_Planes	<=	3	GENERATE	INT_REQ_ALL(101)					<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_102	:	IF	P_Number_of_Planes	<=	3	GENERATE	INT_REQ_ALL(102)					<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_103	:	IF	P_Number_of_Planes	<=	3	GENERATE	INT_REQ_ALL(103)					<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_104	:	IF	P_Number_of_Planes	<=	3	GENERATE	INT_REQ_ALL(104)					<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_105	:	IF	P_Number_of_Planes	<=	3	GENERATE	INT_REQ_ALL(105)					<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_106	:	IF	P_Number_of_Planes	<=	3	GENERATE	INT_REQ_ALL(106)					<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_107	:	IF	P_Number_of_Planes	<=	3	GENERATE	INT_REQ_ALL(107)					<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_108	:	IF	P_Number_of_Planes	<=	3	GENERATE	INT_REQ_ALL(108)					<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_109	:	IF	P_Number_of_Planes	<=	3	GENERATE	INT_REQ_ALL(109)					<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_110	:	IF	P_Number_of_Planes	<=	3	GENERATE	INT_REQ_ALL(110)					<=	'0';														END GENERATE;
	PLANE_REQ_ZERO_111	:	IF	P_Number_of_Planes	<=	3	GENERATE	INT_REQ_ALL(111)					<=	'0';														END GENERATE;
	--------------------------------------------------------------------------
																		INT_ACK_SYS_PC						<=	INT_ACK_ALL(0);
																		INT_ACK_TBE							<=	INT_ACK_ALL(1);
																		INT_ACK_RBF							<=	INT_ACK_ALL(2);
																		INT_ACK_TXD							<=	INT_ACK_ALL(3);
																		INT_ACK_RXD							<=	INT_ACK_ALL(4);
																		INT_ACK_SYS_TIMER(0)				<=	INT_ACK_ALL(8);
																		INT_ACK_SYS_TIMER(1)				<=	INT_ACK_ALL(9);
																		INT_ACK_SYS_TIMER(2)				<=	INT_ACK_ALL(10);
																		INT_ACK_SYS_TIMER(3)				<=	INT_ACK_ALL(11);
																		INT_ACK_SYS_TIMER(4)				<=	INT_ACK_ALL(12);
																		INT_ACK_SYS_TIMER(5)				<=	INT_ACK_ALL(13);
																		INT_ACK_SYS_TIMER(6)				<=	INT_ACK_ALL(14);
																		INT_ACK_SYS_TIMER(7)				<=	INT_ACK_ALL(15);
																		
																		INT_ACK_MPDR_Ready(0)				<=	INT_ACK_ALL(16);
																		INT_ACK_MPDR_Ready(1)				<=	INT_ACK_ALL(17);
																		INT_ACK_MPDR_Ready(2)				<=	INT_ACK_ALL(18);
																		INT_ACK_MPDR_Ready(3)				<=	INT_ACK_ALL(19);
																		INT_ACK_MPDR_Ready(4)				<=	INT_ACK_ALL(20);
																		INT_ACK_MPDR_Ready(5)				<=	INT_ACK_ALL(21);
																		INT_ACK_MPDR_Ready(6)				<=	INT_ACK_ALL(22);
																		INT_ACK_MPDR_Ready(7)				<=	INT_ACK_ALL(23);
																		INT_ACK_MPDR_Ready(8)				<=	INT_ACK_ALL(24);
																		INT_ACK_MPDR_Ready(9)				<=	INT_ACK_ALL(25);
																		INT_ACK_MPDR_Ready(10)				<=	INT_ACK_ALL(26);
																		INT_ACK_MPDR_Ready(11)				<=	INT_ACK_ALL(27);
																		INT_ACK_MPDR_Ready(12)				<=	INT_ACK_ALL(28);
																		INT_ACK_MPDR_Ready(13)				<=	INT_ACK_ALL(29);
																		INT_ACK_MPDR_Ready(14)				<=	INT_ACK_ALL(30);
																		INT_ACK_MPDR_Ready(15)				<=	INT_ACK_ALL(31);
																		INT_ACK_DMA_Ready(0)				<=	INT_ACK_ALL(32);
																		INT_ACK_DMA_Ready(1)				<=	INT_ACK_ALL(33);
																		INT_ACK_DMA_Ready(2)				<=	INT_ACK_ALL(34);
																		INT_ACK_DMA_Ready(3)				<=	INT_ACK_ALL(35);
																		INT_ACK_DMA_Ready(4)				<=	INT_ACK_ALL(36);
																		INT_ACK_DMA_Ready(5)				<=	INT_ACK_ALL(37);
																		INT_ACK_DMA_Ready(6)				<=	INT_ACK_ALL(38);
																		INT_ACK_DMA_Ready(7)				<=	INT_ACK_ALL(39);
																		INT_ACK_DMA_Ready(8)				<=	INT_ACK_ALL(40);
																		INT_ACK_DMA_Ready(9)				<=	INT_ACK_ALL(41);
																		INT_ACK_DMA_Ready(10)				<=	INT_ACK_ALL(42);
																		INT_ACK_DMA_Ready(11)				<=	INT_ACK_ALL(43);
																		INT_ACK_DMA_Ready(12)				<=	INT_ACK_ALL(44);
																		INT_ACK_DMA_Ready(13)				<=	INT_ACK_ALL(45);
																		INT_ACK_DMA_Ready(14)				<=	INT_ACK_ALL(46);
																		INT_ACK_DMA_Ready(15)				<=	INT_ACK_ALL(47);
																		
																		INT_ACK_PSU_Done(0)(1,1)			<=	INT_ACK_ALL(48);
																		INT_ACK_PSU_Done(0)(1,2)			<=	INT_ACK_ALL(49);
																		INT_ACK_PSU_Done(0)(1,3)			<=	INT_ACK_ALL(50);
																		INT_ACK_PSU_Done(0)(1,4)			<=	INT_ACK_ALL(51);
																		INT_ACK_PSU_Done(0)(2,1)			<=	INT_ACK_ALL(52);
																		INT_ACK_PSU_Done(0)(2,2)			<=	INT_ACK_ALL(53);
																		INT_ACK_PSU_Done(0)(2,3)			<=	INT_ACK_ALL(54);
																		INT_ACK_PSU_Done(0)(2,4)			<=	INT_ACK_ALL(55);
																		INT_ACK_PSU_Done(0)(3,1)			<=	INT_ACK_ALL(56);
																		INT_ACK_PSU_Done(0)(3,2)			<=	INT_ACK_ALL(57);
																		INT_ACK_PSU_Done(0)(3,3)			<=	INT_ACK_ALL(58);
																		INT_ACK_PSU_Done(0)(3,4)			<=	INT_ACK_ALL(59);
																		INT_ACK_PSU_Done(0)(4,1)			<=	INT_ACK_ALL(60);
																		INT_ACK_PSU_Done(0)(4,2)			<=	INT_ACK_ALL(61);
																		INT_ACK_PSU_Done(0)(4,3)			<=	INT_ACK_ALL(62);
																		INT_ACK_PSU_Done(0)(4,4)			<=	INT_ACK_ALL(63);
																		
	PLANE_ACK_CHECK_64	:	IF	P_Number_of_Planes	>	1	GENERATE	INT_ACK_PSU_Done(1)(1,1)			<=	INT_ACK_ALL(64);											END GENERATE;
	PLANE_ACK_CHECK_65	:	IF	P_Number_of_Planes	>	1	GENERATE	INT_ACK_PSU_Done(1)(1,2)			<=	INT_ACK_ALL(65);											END GENERATE;
	PLANE_ACK_CHECK_66	:	IF	P_Number_of_Planes	>	1	GENERATE	INT_ACK_PSU_Done(1)(1,3)			<=	INT_ACK_ALL(66);											END GENERATE;
	PLANE_ACK_CHECK_67	:	IF	P_Number_of_Planes	>	1	GENERATE	INT_ACK_PSU_Done(1)(1,4)			<=	INT_ACK_ALL(67);											END GENERATE;
	PLANE_ACK_CHECK_68	:	IF	P_Number_of_Planes	>	1	GENERATE	INT_ACK_PSU_Done(1)(2,1)			<=	INT_ACK_ALL(68);											END GENERATE;
	PLANE_ACK_CHECK_69	:	IF	P_Number_of_Planes	>	1	GENERATE	INT_ACK_PSU_Done(1)(2,2)			<=	INT_ACK_ALL(69);											END GENERATE;
	PLANE_ACK_CHECK_70	:	IF	P_Number_of_Planes	>	1	GENERATE	INT_ACK_PSU_Done(1)(2,3)			<=	INT_ACK_ALL(70);											END GENERATE;
	PLANE_ACK_CHECK_71	:	IF	P_Number_of_Planes	>	1	GENERATE	INT_ACK_PSU_Done(1)(2,4)			<=	INT_ACK_ALL(71);											END GENERATE;
	PLANE_ACK_CHECK_72	:	IF	P_Number_of_Planes	>	1	GENERATE	INT_ACK_PSU_Done(1)(3,1)			<=	INT_ACK_ALL(72);											END GENERATE;
	PLANE_ACK_CHECK_73	:	IF	P_Number_of_Planes	>	1	GENERATE	INT_ACK_PSU_Done(1)(3,2)			<=	INT_ACK_ALL(73);											END GENERATE;
	PLANE_ACK_CHECK_74	:	IF	P_Number_of_Planes	>	1	GENERATE	INT_ACK_PSU_Done(1)(3,3)			<=	INT_ACK_ALL(74);											END GENERATE;
	PLANE_ACK_CHECK_75	:	IF	P_Number_of_Planes	>	1	GENERATE	INT_ACK_PSU_Done(1)(3,4)			<=	INT_ACK_ALL(75);											END GENERATE;
	PLANE_ACK_CHECK_76	:	IF	P_Number_of_Planes	>	1	GENERATE	INT_ACK_PSU_Done(1)(4,1)			<=	INT_ACK_ALL(76);											END GENERATE;
	PLANE_ACK_CHECK_77	:	IF	P_Number_of_Planes	>	1	GENERATE	INT_ACK_PSU_Done(1)(4,2)			<=	INT_ACK_ALL(77);											END GENERATE;
	PLANE_ACK_CHECK_78	:	IF	P_Number_of_Planes	>	1	GENERATE	INT_ACK_PSU_Done(1)(4,3)			<=	INT_ACK_ALL(78);											END GENERATE;
	PLANE_ACK_CHECK_79	:	IF	P_Number_of_Planes	>	1	GENERATE	INT_ACK_PSU_Done(1)(4,4)			<=	INT_ACK_ALL(79);											END GENERATE;
					
	PLANE_ACK_CHECK_80	:	IF	P_Number_of_Planes	>	2	GENERATE	INT_ACK_PSU_Done(2)(1,1)			<=	INT_ACK_ALL(80);											END GENERATE;
	PLANE_ACK_CHECK_81	:	IF	P_Number_of_Planes	>	2	GENERATE	INT_ACK_PSU_Done(2)(1,2)			<=	INT_ACK_ALL(81);											END GENERATE;
	PLANE_ACK_CHECK_82	:	IF	P_Number_of_Planes	>	2	GENERATE	INT_ACK_PSU_Done(2)(1,3)			<=	INT_ACK_ALL(82);											END GENERATE;
	PLANE_ACK_CHECK_83	:	IF	P_Number_of_Planes	>	2	GENERATE	INT_ACK_PSU_Done(2)(1,4)			<=	INT_ACK_ALL(83);											END GENERATE;
	PLANE_ACK_CHECK_84	:	IF	P_Number_of_Planes	>	2	GENERATE	INT_ACK_PSU_Done(2)(2,1)			<=	INT_ACK_ALL(84);											END GENERATE;
	PLANE_ACK_CHECK_85	:	IF	P_Number_of_Planes	>	2	GENERATE	INT_ACK_PSU_Done(2)(2,2)			<=	INT_ACK_ALL(85);											END GENERATE;
	PLANE_ACK_CHECK_86	:	IF	P_Number_of_Planes	>	2	GENERATE	INT_ACK_PSU_Done(2)(2,3)			<=	INT_ACK_ALL(86);											END GENERATE;
	PLANE_ACK_CHECK_87	:	IF	P_Number_of_Planes	>	2	GENERATE	INT_ACK_PSU_Done(2)(2,4)			<=	INT_ACK_ALL(87);											END GENERATE;
	PLANE_ACK_CHECK_88	:	IF	P_Number_of_Planes	>	2	GENERATE	INT_ACK_PSU_Done(2)(3,1)			<=	INT_ACK_ALL(88);											END GENERATE;
	PLANE_ACK_CHECK_89	:	IF	P_Number_of_Planes	>	2	GENERATE	INT_ACK_PSU_Done(2)(3,2)			<=	INT_ACK_ALL(89);											END GENERATE;
	PLANE_ACK_CHECK_90	:	IF	P_Number_of_Planes	>	2	GENERATE	INT_ACK_PSU_Done(2)(3,3)			<=	INT_ACK_ALL(90);											END GENERATE;
	PLANE_ACK_CHECK_91	:	IF	P_Number_of_Planes	>	2	GENERATE	INT_ACK_PSU_Done(2)(3,4)			<=	INT_ACK_ALL(91);											END GENERATE;
	PLANE_ACK_CHECK_92	:	IF	P_Number_of_Planes	>	2	GENERATE	INT_ACK_PSU_Done(2)(4,1)			<=	INT_ACK_ALL(92);											END GENERATE;
	PLANE_ACK_CHECK_93	:	IF	P_Number_of_Planes	>	2	GENERATE	INT_ACK_PSU_Done(2)(4,2)			<=	INT_ACK_ALL(93);											END GENERATE;
	PLANE_ACK_CHECK_94	:	IF	P_Number_of_Planes	>	2	GENERATE	INT_ACK_PSU_Done(2)(4,3)			<=	INT_ACK_ALL(94);											END GENERATE;
	PLANE_ACK_CHECK_95	:	IF	P_Number_of_Planes	>	2	GENERATE	INT_ACK_PSU_Done(2)(4,4)			<=	INT_ACK_ALL(95);											END GENERATE;
					
	PLANE_ACK_CHECK_96	:	IF	P_Number_of_Planes	>	3	GENERATE	INT_ACK_PSU_Done(3)(1,1)			<=	INT_ACK_ALL(96);											END GENERATE;
	PLANE_ACK_CHECK_97	:	IF	P_Number_of_Planes	>	3	GENERATE	INT_ACK_PSU_Done(3)(1,2)			<=	INT_ACK_ALL(97);											END GENERATE;
	PLANE_ACK_CHECK_98	:	IF	P_Number_of_Planes	>	3	GENERATE	INT_ACK_PSU_Done(3)(1,3)			<=	INT_ACK_ALL(98);											END GENERATE;
	PLANE_ACK_CHECK_99	:	IF	P_Number_of_Planes	>	3	GENERATE	INT_ACK_PSU_Done(3)(1,4)			<=	INT_ACK_ALL(99);											END GENERATE;
	PLANE_ACK_CHECK_100	:	IF	P_Number_of_Planes	>	3	GENERATE	INT_ACK_PSU_Done(3)(2,1)			<=	INT_ACK_ALL(100);											END GENERATE;
	PLANE_ACK_CHECK_101	:	IF	P_Number_of_Planes	>	3	GENERATE	INT_ACK_PSU_Done(3)(2,2)			<=	INT_ACK_ALL(101);											END GENERATE;
	PLANE_ACK_CHECK_102	:	IF	P_Number_of_Planes	>	3	GENERATE	INT_ACK_PSU_Done(3)(2,3)			<=	INT_ACK_ALL(102);											END GENERATE;
	PLANE_ACK_CHECK_103	:	IF	P_Number_of_Planes	>	3	GENERATE	INT_ACK_PSU_Done(3)(2,4)			<=	INT_ACK_ALL(103);											END GENERATE;
	PLANE_ACK_CHECK_104	:	IF	P_Number_of_Planes	>	3	GENERATE	INT_ACK_PSU_Done(3)(3,1)			<=	INT_ACK_ALL(104);											END GENERATE;
	PLANE_ACK_CHECK_105	:	IF	P_Number_of_Planes	>	3	GENERATE	INT_ACK_PSU_Done(3)(3,2)			<=	INT_ACK_ALL(105);											END GENERATE;
	PLANE_ACK_CHECK_106	:	IF	P_Number_of_Planes	>	3	GENERATE	INT_ACK_PSU_Done(3)(3,3)			<=	INT_ACK_ALL(106);											END GENERATE;
	PLANE_ACK_CHECK_107	:	IF	P_Number_of_Planes	>	3	GENERATE	INT_ACK_PSU_Done(3)(3,4)			<=	INT_ACK_ALL(107);											END GENERATE;
	PLANE_ACK_CHECK_108	:	IF	P_Number_of_Planes	>	3	GENERATE	INT_ACK_PSU_Done(3)(4,1)			<=	INT_ACK_ALL(108);											END GENERATE;
	PLANE_ACK_CHECK_109	:	IF	P_Number_of_Planes	>	3	GENERATE	INT_ACK_PSU_Done(3)(4,2)			<=	INT_ACK_ALL(109);											END GENERATE;
	PLANE_ACK_CHECK_110	:	IF	P_Number_of_Planes	>	3	GENERATE	INT_ACK_PSU_Done(3)(4,3)			<=	INT_ACK_ALL(110);											END GENERATE;
	PLANE_ACK_CHECK_111	:	IF	P_Number_of_Planes	>	3	GENERATE	INT_ACK_PSU_Done(3)(4,4)			<=	INT_ACK_ALL(111);											END GENERATE;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	INT_REQ_ARR(0)						<=	INT_REQ_ALL(15	DOWNTO	0);
	INT_REQ_ARR(1)						<=	INT_REQ_ALL(31	DOWNTO	16);
	INT_REQ_ARR(2)						<=	INT_REQ_ALL(47	DOWNTO	32);
	INT_REQ_ARR(3)						<=	INT_REQ_ALL(63	DOWNTO	48);
	INT_REQ_ARR(4)						<=	INT_REQ_ALL(79	DOWNTO	64);
	INT_REQ_ARR(5)						<=	INT_REQ_ALL(95	DOWNTO	80);
	INT_REQ_ARR(6)						<=	INT_REQ_ALL(111	DOWNTO	96);
	--------------------------------------------------------------------------
	INT_REQ_LOC_GEN						:	FOR i IN 0 TO 6 GENERATE
		PROCESS(INT_REQ_ARR(i))
		BEGIN
			IF		INT_REQ_ARR(i)(0)	= '1'	THEN	INT_REQ_ARR_LOC(i)	<=	"00000";
			ELSIF	INT_REQ_ARR(i)(1)	= '1'	THEN	INT_REQ_ARR_LOC(i)	<=	"00001";
			ELSIF	INT_REQ_ARR(i)(2)	= '1'	THEN	INT_REQ_ARR_LOC(i)	<=	"00010";
			ELSIF	INT_REQ_ARR(i)(3)	= '1'	THEN	INT_REQ_ARR_LOC(i)	<=	"00011";
			ELSIF	INT_REQ_ARR(i)(4)	= '1'	THEN	INT_REQ_ARR_LOC(i)	<=	"00100";
			ELSIF	INT_REQ_ARR(i)(5)	= '1'	THEN	INT_REQ_ARR_LOC(i)	<=	"00101";
			ELSIF	INT_REQ_ARR(i)(6)	= '1'	THEN	INT_REQ_ARR_LOC(i)	<=	"00110";
			ELSIF	INT_REQ_ARR(i)(7)	= '1'	THEN	INT_REQ_ARR_LOC(i)	<=	"00111";
			ELSIF	INT_REQ_ARR(i)(8)	= '1'	THEN	INT_REQ_ARR_LOC(i)	<=	"01000";
			ELSIF	INT_REQ_ARR(i)(9)	= '1'	THEN	INT_REQ_ARR_LOC(i)	<=	"01001";
			ELSIF	INT_REQ_ARR(i)(10)	= '1'	THEN	INT_REQ_ARR_LOC(i)	<=	"01010";
			ELSIF	INT_REQ_ARR(i)(11)	= '1'	THEN	INT_REQ_ARR_LOC(i)	<=	"01011";
			ELSIF	INT_REQ_ARR(i)(12)	= '1'	THEN	INT_REQ_ARR_LOC(i)	<=	"01100";
			ELSIF	INT_REQ_ARR(i)(13)	= '1'	THEN	INT_REQ_ARR_LOC(i)	<=	"01101";
			ELSIF	INT_REQ_ARR(i)(14)	= '1'	THEN	INT_REQ_ARR_LOC(i)	<=	"01110";
			ELSIF	INT_REQ_ARR(i)(15)	= '1'	THEN	INT_REQ_ARR_LOC(i)	<=	"01111";
			ELSE										INT_REQ_ARR_LOC(i)	<=	"10000";
			END IF;
			--WAIT ON INT_REQ_ARR(i);
		END PROCESS;
	END GENERATE;
	--------------------------------------------------------------------------
	PROCESS(clk, rst)
	BEGIN
		IF rst = '1' THEN
			P_State	<=	reset;
		ELSIF clk = '1' AND clk'EVENT THEN
			P_State	<=	N_State;
		END IF;
		--WAIT ON clk, rst;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS(P_State, INT_REQ_ARR_LOC, NEXT_INT_ADDRESS, INT_ACK, INT_APP_ACK)
		VARIABLE	add					:	INTEGER;
	BEGIN
		INT_DEC_L						<=	(OTHERS	=>	'0');
		INT_ACK_ALL						<=	(OTHERS	=>	'0');
		INT_ADD_L						<=	(OTHERS	=>	'0');
		THIS_INT_Load					<=	'0';
		INT_ADD_load					<=	'0';
		INT_REQ							<=	'0';
		N_State							<=	P_State;
		add								:=	my_to_uint(NEXT_INT_ADDRESS);
		CASE	P_State	IS
			WHEN	reset				=>	N_State		<=	get_req;
			WHEN	get_req				=>	IF		INT_REQ_ARR_LOC(0)	/=	"10000" THEN
													INT_ADD_L			<=	"0000" & INT_REQ_ARR_LOC(0)(3 DOWNTO 0);
													INT_ADD_load		<=	'1';
													N_State				<=	put_req;
													CASE	INT_REQ_ARR_LOC(0)(3 DOWNTO 0)	IS
														WHEN	X"0"	=>	INT_DEC_L	<=	X"0";
														WHEN	X"1"	=>	INT_DEC_L	<=	X"1";
														WHEN	X"2"	=>	INT_DEC_L	<=	X"2";
														WHEN	X"3"	=>	INT_DEC_L	<=	X"3";
														WHEN	X"4"	=>	INT_DEC_L	<=	X"4";
														WHEN	X"8"	=>	INT_DEC_L	<=	X"5";
														WHEN	X"9"	=>	INT_DEC_L	<=	X"5";
														WHEN	X"A"	=>	INT_DEC_L	<=	X"5";
														WHEN	X"B"	=>	INT_DEC_L	<=	X"5";
														WHEN	X"C"	=>	INT_DEC_L	<=	X"5";
														WHEN	X"D"	=>	INT_DEC_L	<=	X"5";
														WHEN	X"E"	=>	INT_DEC_L	<=	X"5";
														WHEN	X"F"	=>	INT_DEC_L	<=	X"5";
														WHEN	OTHERS	=>	INT_DEC_L	<=	X"0";
													END CASE;
											ELSIF	INT_REQ_ARR_LOC(1)	/=	"10000" THEN
													INT_ADD_L			<=	"0001" & INT_REQ_ARR_LOC(1)(3 DOWNTO 0);
													INT_ADD_load		<=	'1';
													N_State				<=	put_req;
													INT_DEC_L			<=	X"6";
											ELSIF	INT_REQ_ARR_LOC(2)	/=	"10000" THEN
													INT_ADD_L			<=	"0010" & INT_REQ_ARR_LOC(2)(3 DOWNTO 0);
													INT_ADD_load		<=	'1';
													N_State				<=	put_req;
													INT_DEC_L			<=	X"7";
											ELSIF	INT_REQ_ARR_LOC(3)	/=	"10000" THEN
													INT_ADD_L			<=	"0011" & INT_REQ_ARR_LOC(3)(3 DOWNTO 0);
													INT_ADD_load		<=	'1';
													N_State				<=	put_req;
													INT_DEC_L			<=	X"8";
											ELSIF	INT_REQ_ARR_LOC(4)	/=	"10000" THEN
													INT_ADD_L			<=	"0100" & INT_REQ_ARR_LOC(4)(3 DOWNTO 0);
													INT_ADD_load		<=	'1';
													N_State				<=	put_req;
													INT_DEC_L			<=	X"9";
											ELSIF	INT_REQ_ARR_LOC(5)  /=	"10000" THEN
													INT_ADD_L			<=	"0101" & INT_REQ_ARR_LOC(5)(3 DOWNTO 0);
													INT_ADD_load		<=	'1';
													N_State				<=	put_req;
													INT_DEC_L			<=	X"A";
											ELSIF	INT_REQ_ARR_LOC(6)  /=	"10000" THEN
													INT_ADD_L			<=	"0110" & INT_REQ_ARR_LOC(6)(3 DOWNTO 0);
													INT_ADD_load		<=	'1';
													N_State				<=	put_req;
													INT_DEC_L			<=	X"B";
											END IF;
			WHEN	put_req				=>	IF		INT_ACK				=	'1'		OR
													INT_APP_ACK			=	'1'		THEN
													THIS_INT_Load		<=	'1';
													N_State				<=	put_ack;
											END IF;
													INT_REQ				<=	'1';
			WHEN	put_ack				=>	IF		INT_ACK				=	'0'	THEN
													N_State				<=	get_req;
											END IF;
													INT_ACK_ALL(add)	<=	'1';
											
		END CASE;
		--WAIT ON P_State, INT_REQ_ARR_LOC, NEXT_INT_ADDRESS, INT_ACK;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS(clk, rst)
	BEGIN
		IF rst = '1' THEN
				NEXT_INT_ADDRESS		<=	(OTHERS	=>	'0');
				THIS_INT_ADDRESS		<=	(OTHERS	=>	'0');
		ELSIF clk = '1' AND clk'EVENT THEN
			IF INT_ADD_load = '1' THEN
				NEXT_INT_ADDRESS		<=	INT_ADD_L;
				NEXT_INT_Code			<=	INT_DEC_L;
			END IF;
			IF THIS_INT_Load = '1' THEN
				THIS_INT_ADDRESS		<=	NEXT_INT_ADDRESS;
				THIS_INT_Code			<=	NEXT_INT_Code;
			END IF;
		END IF;
		--WAIT ON  clk, rst;
	END PROCESS;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	PROCESS(clk, rst)
		VARIABLE	add					:	INTEGER;
		VARIABLE	Eadd				:	INTEGER;
	BEGIN
		IF rst = '1' THEN
			INT_ENABLEs					<=	(OTHERS	=>	'0');
		ELSIF clk = '1' AND clk'EVENT THEN
			INT_APP_ACK					<=	'0';
			add							:=	to_integer(SIGNED(X_check(MAIN_PORT_Address)));
			Eadd						:=	(add/4) - (BASE_ADDRESS/4);
			IF MAIN_PORT_WEN = '1' AND add >= BASE_ADDRESS AND add < ENDx_ADDRESS THEN 
				CASE Eadd	IS
					WHEN	0			=>	INT_ENABLEs(15	DOWNTO	0)		<=	MAIN_PORT_Data_in(15	DOWNTO	0);
					WHEN	1			=>	INT_ENABLEs(47	DOWNTO	16)		<=	MAIN_PORT_Data_in;
					WHEN	2			=>	INT_ENABLEs(63	DOWNTO	48)		<=	MAIN_PORT_Data_in(15	DOWNTO	0);
					WHEN	3			=>	INT_ENABLEs(79	DOWNTO	64)		<=	MAIN_PORT_Data_in(15	DOWNTO	0);
					WHEN	4			=>	INT_ENABLEs(95	DOWNTO	80)		<=	MAIN_PORT_Data_in(15	DOWNTO	0);
					WHEN	5			=>	INT_ENABLEs(111	DOWNTO	96)		<=	MAIN_PORT_Data_in(15	DOWNTO	0);
					WHEN	7			=>	INT_APP_ACK						<=	MAIN_PORT_Data_in(0);
					WHEN	OTHERS		=>	NULL;
				END CASE;
			END IF;
		END IF;
		--WAIT ON clk, rst;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS(MAIN_PORT_Address, MAIN_PORT_OEN, INT_ENABLEs, NEXT_INT_ADDRESS, THIS_INT_ADDRESS, THIS_INT_Code, NEXT_INT_Code)
		VARIABLE	add					:	INTEGER;
		VARIABLE	Eadd				:	INTEGER;
	BEGIN
		add								:=	to_integer(SIGNED(X_check(MAIN_PORT_Address)));
		Eadd							:=	(add/4) - (BASE_ADDRESS/4);
		IF MAIN_PORT_OEN = '1' AND add  >= BASE_ADDRESS AND add < ENDx_ADDRESS THEN 
			CASE Eadd	IS
				WHEN	0				=>	MAIN_PORT_Data_out			<=	X"0000"	&	INT_ENABLEs(15	DOWNTO	0);
				WHEN	1				=>	MAIN_PORT_Data_out			<=				INT_ENABLEs(47	DOWNTO	16);
				WHEN	2				=>	MAIN_PORT_Data_out			<=	X"0000"	&	INT_ENABLEs(63	DOWNTO	48);
				WHEN	3				=>	MAIN_PORT_Data_out			<=	X"0000"	&	INT_ENABLEs(79	DOWNTO	64);
				WHEN	4				=>	MAIN_PORT_Data_out			<=	X"0000"	&	INT_ENABLEs(95	DOWNTO	80);
				WHEN	5				=>	MAIN_PORT_Data_out			<=	X"0000"	&	INT_ENABLEs(111	DOWNTO	96);
				WHEN	6				=>	MAIN_PORT_Data_out			<=	THIS_INT_ADDRESS	& NEXT_INT_ADDRESS	&	"0000"		&	THIS_INT_Code		&	"0000"		&	NEXT_INT_Code;
				WHEN	7				=>	MAIN_PORT_Data_out			<=	(OTHERS	=>	'0');
				WHEN	OTHERS			=>	MAIN_PORT_Data_out			<=	(OTHERS	=>	'Z');
			END CASE;
		ELSE
			MAIN_PORT_Data_out			<=	(OTHERS	=>	'Z');
		END IF;
		--WAIT ON	MAIN_PORT_Address, MAIN_PORT_OEN, INT_ENABLEs, NEXT_INT_ADDRESS;
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
	--------------------------------------------------------------------------
end Behavioral;


