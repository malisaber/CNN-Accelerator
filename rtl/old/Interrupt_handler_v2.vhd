


-----------------------------------------------------------
-----------------------------------------------------------
----
----	NEEDs MAJOR CHANGEs
----
-----------------------------------------------------------
-----------------------------------------------------------








library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.my_pack_v2.ALL;
	
entity Interrupt_handler_v2 is				--	217	Interrupt Source
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
		
		--	Accelerator 
		------	Requests
		INT_REQ_SYS_PC					:	IN	std_logic;
		INT_REQ_TBE						:	IN	std_logic;
		INT_REQ_RBF						:	IN	std_logic;
		INT_REQ_SYS_TIMER				:	IN	std_logic_vector	(7	DOWNTO	0);
		INT_REQ_MPDR_Ready				:	IN	std_logic_vector	(15	DOWNTO	0);
		INT_REQ_DMA_Ready				:	IN	std_logic_vector	(15	DOWNTO	0);
		INT_REQ_PSU_Done				:	IN	Plane_std_logic_4X4;
		------	Acknowledge
		INT_ACK_SYS_PC					:	OUT	std_logic;
		INT_ACK_TBE						:	OUT	std_logic;
		INT_ACK_RBF						:	OUT	std_logic;
		INT_ACK_SYS_TIMER				:	OUT	std_logic_vector	(7	DOWNTO	0);
		INT_ACK_MPDR_Ready				:	OUT	std_logic_vector	(15	DOWNTO	0);
		INT_ACK_DMA_Ready				:	OUT	std_logic_vector	(15	DOWNTO	0);
		INT_ACK_PSU_Done				:	OUT	Plane_std_logic_4X4;
		
		
		--	Interrupt Port
        INT_REQ							:	OUT	std_logic_vector(6	DOWNTO	0);
        INT_ACK							:	IN	std_logic_vector(6	DOWNTO	0));
end Interrupt_handler_v2;

ARCHITECTURE Behavioral of Interrupt_handler_v2 IS
	--------------------------------------------------------------------------
	--		CONSTANTs
	--------------------------------------------------------------------------
	CONSTANT	NUMB_ints				:	INTEGER	:=	12;
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
	--	0	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|===== RBF =====|===== TBE =====|=== PC  Req ===|
	--		
	------------------------------------------------------------------------------------------------------------------------------------------
	--	INT ENABLE 1
	--	N	|		31		|		30		|		29		|		28		|		27		|		26		|		25		|		24		|
	--	T	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|
	--		
	--	E	|		23		|		22		|		21		|		20		|		19		|		18		|		17		|		16		|
	--	N	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|
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
	--	L	|= DMA 4,4 Rdy =|= DMA 4,3 Rdy =|= DMA 4,2 Rdy =|= DMA 4,1 Rdy =|= DMA 3,4 Rdy =|= DMA 3,3 Rdy =|= DMA 3,2 Rdy =|= DMA 3,1 Rdy =|
	--	E	
	--		|		7		|		6		|		5		|		4		|		3		|		2		|		1		|		0		|
	--	2	|= DMA 2,4 Rdy =|= DMA 2,3 Rdy =|= DMA 2,2 Rdy =|= DMA 2,1 Rdy =|= DMA 1,4 Rdy =|= DMA 1,3 Rdy =|= DMA 1,2 Rdy =|= DMA 1,1 Rdy =|
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
	--	L	| PE 1,4,4 Done | PE 1,4,3 Done | PE 1,4,2 Done | PE 1,4,1 Done | PE 1,3,4 Done | PE 1,3,3 Done | PE 1,3,2 Done | PE 1,3,1 Done |
	--	E	
	--		|		7		|		6		|		5		|		4		|		3		|		2		|		1		|		0		|
	--	1	| PE 1,2,4 Done | PE 1,2,3 Done | PE 1,2,2 Done | PE 1,2,1 Done | PE 1,1,4 Done | PE 1,1,3 Done | PE 1,1,2 Done | PE 1,1,1 Done |
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
	--	L	| PE 2,4,4 Done | PE 2,4,3 Done | PE 2,4,2 Done | PE 2,4,1 Done | PE 2,3,4 Done | PE 2,3,3 Done | PE 2,3,2 Done | PE 2,3,1 Done |
	--	E	
	--		|		7		|		6		|		5		|		4		|		3		|		2		|		1		|		0		|
	--	3	| PE 2,2,4 Done | PE 2,2,3 Done | PE 2,2,2 Done | PE 2,2,1 Done | PE 2,1,4 Done | PE 2,1,3 Done | PE 2,1,2 Done | PE 2,1,1 Done |
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
	--	L	| PE 3,4,4 Done | PE 3,4,3 Done | PE 3,4,2 Done | PE 3,4,1 Done | PE 3,3,4 Done | PE 3,3,3 Done | PE 3,3,2 Done | PE 3,3,1 Done |
	--	E	
	--		|		7		|		6		|		5		|		4		|		3		|		2		|		1		|		0		|
	--	5	| PE 3,2,4 Done | PE 3,2,3 Done | PE 3,2,2 Done | PE 3,2,1 Done | PE 3,1,4 Done | PE 3,1,3 Done | PE 3,1,2 Done | PE 3,1,1 Done |
	--		
	------------------------------------------------------------------------------------------------------------------------------------------
	--	INT ENABLE 6
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
	------------------------------------------------------------------------------------------------------------------------------------------
	--	INT ENABLE 7	->	RESERVED
	--	N	|		31		|		30		|		29		|		28		|		27		|		26		|		25		|		24		|
	--	T	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|
	--		
	--	E	|		23		|		22		|		21		|		20		|		19		|		18		|		17		|		16		|
	--	N	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|
	--	A	
	--	B	|		15		|		14		|		13		|		12		|		11		|		10		|		9		|		8		|
	--	L	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|
	--	E	
	--		|		7		|		6		|		5		|		4		|		3		|		2		|		1		|		0		|
	--	4	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|
	--		
	------------------------------------------------------------------------------------------------------------------------------------------
	--	INT ENABLE 8	->	RESERVED
	--	N	|		31		|		30		|		29		|		28		|		27		|		26		|		25		|		24		|
	--	T	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|
	--		
	--	E	|		23		|		22		|		21		|		20		|		19		|		18		|		17		|		16		|
	--	N	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|
	--	A	
	--	B	|		15		|		14		|		13		|		12		|		11		|		10		|		9		|		8		|
	--	L	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|
	--	E	
	--		|		7		|		6		|		5		|		4		|		3		|		2		|		1		|		0		|
	--	6	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|
	--		
	------------------------------------------------------------------------------------------------------------------------------------------
	--	INT ENABLE 9	->	RESERVED
	--	N	|		31		|		30		|		29		|		28		|		27		|		26		|		25		|		24		|
	--	T	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|
	--		
	--	E	|		23		|		22		|		21		|		20		|		19		|		18		|		17		|		16		|
	--	N	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|
	--	A	
	--	B	|		15		|		14		|		13		|		12		|		11		|		10		|		9		|		8		|
	--	L	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|
	--	E	
	--		|		7		|		6		|		5		|		4		|		3		|		2		|		1		|		0		|
	--	8	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|
	--		
	--	
	--	Interrupt Priority:
	--		INT_EN_0_b0	> INT_EN_0_b1 > ... > INT_EN_0_b31 > INT_EN_1_b0 > > INT_EN_1_b1 > ... > INT_EN_9_b0 > INT_EN_9_b1 > ... > INT_EN_9_b31
	--		Higher		>																										 > LOWER
	-----------------------------------------------------------------------------------------------------------------------------------------
	--	INT ADDRESS
	--	N	|	31		30		29		28	|	27		26		25		24	|	23		22		21	 	20	| 	19		18		17		16	|
	--	T	|========== INT 7 Add ==========|========== INT 6 Add ==========|========== INT 5 Add ==========|========== INT 4 Add ==========|
	--		
	--	A	
	--	D	|	15		14		13		12	|	11		10		9		8	|	7		6		5		4	|	3		2		1		0	|
	--	D	|========== INT 3 Add ==========|========== INT 2 Add ==========|========== INT 1 Add ==========|========== INT 0 Add ==========|
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
	--		BASE_ADDRESS	+	00		:	INT ENABLE	0
	--		BASE_ADDRESS	+	04		:	INT ENABLE	1
	--		BASE_ADDRESS	+	08		:	INT ENABLE	2
	--		BASE_ADDRESS	+	0C		:	INT ENABLE	3
	--		BASE_ADDRESS	+	10		:	INT ENABLE	4
	--		BASE_ADDRESS	+	14		:	INT ENABLE	5
	--		BASE_ADDRESS	+	18		:	INT ENABLE	6
	--		BASE_ADDRESS	+	1C		:	INT ENABLE	7	->	RESERVED
	--		BASE_ADDRESS	+	20		:	INT ENABLE	8	->	RESERVED
	--		BASE_ADDRESS	+	24		:	INT ENABLE	9	->	RESERVED
	--		BASE_ADDRESS	+	28		:	INT ADDRESS
	--		BASE_ADDRESS	+	2C		:	INT	ACKNOWLEDGE
	--		BASE_ADDRESS	+	30		:	RESERVED
	--		BASE_ADDRESS	+	34		:	RESERVED
	--		BASE_ADDRESS	+	38		:	RESERVED
	--		BASE_ADDRESS	+	3C		:	RESERVED
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		COMPONENTs
	--------------------------------------------------------------------------
	COMPONENT	MiniBatch_Interrupt_handler
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		--	Accelerator
		INT_ACC_REQ						:	IN	std_logic_vector(15	DOWNTO	0);
		INT_ACC_ACK						:	OUT	std_logic_vector(15	DOWNTO	0);
		--	Interrupt Handler
		INT_IHA_Enable					:	IN	std_logic_vector(15	DOWNTO	0);
		INT_IHA_Load					:	OUT	std_logic;
        INT_IHA_REQ						:	OUT	std_logic;
		INT_IHA_REQ_ADD					:	OUT	std_logic_vector(3	DOWNTO	0);
        INT_IHA_ACK						:	IN	std_logic;
		INT_IHA_ACK_ADD					:	IN	std_logic_vector(3	DOWNTO	0));
	END	COMPONENT;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		TYPEs
	--------------------------------------------------------------------------
	TYPE	INT_REQ_EN_TYPE				IS	ARRAY(0 TO 6)	OF std_logic_vector(15	DOWNTO	0);
	TYPE	INT_REQ_ADD_TYPE			IS	ARRAY(0 TO 6)	OF std_logic_vector(3	DOWNTO	0);
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		SINGALs
	--------------------------------------------------------------------------
	SIGNAL	INT_REQs					:	INT_REQ_EN_TYPE;
	SIGNAL	INT_REQ_ENs					:	INT_REQ_EN_TYPE;
	SIGNAL	INT_ACKs					:	INT_REQ_EN_TYPE;
	SIGNAL	INT_APP_ACK					:	std_logic_vector(15	DOWNTO	0);
	SIGNAL	INT_INT_ADD					:	std_logic_vector(31	DOWNTO	0);
	--------------------------------------------------------------------------
	SIGNAL	INT_IHA_Load				:	std_logic_vector(6	DOWNTO	0);
	SIGNAL	INT_IHA_REQ					:	std_logic_vector(6	DOWNTO	0);
	SIGNAL	INT_IHA_REQ_ADD				:	INT_REQ_ADD_TYPE;
	SIGNAL	INT_IHA_ACK					:	std_logic_vector(6	DOWNTO	0);
	SIGNAL	INT_IHA_ACK_ADD				:	INT_REQ_ADD_TYPE;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
begin
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--			Instances													--
	--------------------------------------------------------------------------
	PC_TIMER_MBIH						:	MiniBatch_Interrupt_handler
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		--	Accelerator
		INT_ACC_REQ						=>	INT_REQs		(0),
		INT_ACC_ACK						=>	INT_ACKs		(0),
		--	Interrupt Handler
		INT_IHA_Enable					=>	INT_REQ_ENs		(0),
		INT_IHA_Load					=>	INT_IHA_Load	(0),
        INT_IHA_REQ						=>	INT_IHA_REQ		(0),
		INT_IHA_REQ_ADD					=>	INT_IHA_REQ_ADD	(0),
        INT_IHA_ACK						=>	INT_IHA_ACK		(0),
		INT_IHA_ACK_ADD					=>	INT_IHA_ACK_ADD	(0));
	--------------------------------------------------------------------------
	MPDR_MBIH							:	MiniBatch_Interrupt_handler
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		--	Accelerator
		INT_ACC_REQ						=>	INT_REQs		(1),
		INT_ACC_ACK						=>	INT_ACKs		(1),
		--	Interrupt Handler
		INT_IHA_Enable					=>	INT_REQ_ENs		(1),
		INT_IHA_Load					=>	INT_IHA_Load	(1),
        INT_IHA_REQ						=>	INT_IHA_REQ		(1),
		INT_IHA_REQ_ADD					=>	INT_IHA_REQ_ADD	(1),
        INT_IHA_ACK						=>	INT_IHA_ACK		(1),
		INT_IHA_ACK_ADD					=>	INT_IHA_ACK_ADD	(1));
	--------------------------------------------------------------------------
	DMA_MBIH							:	MiniBatch_Interrupt_handler
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		--	Accelerator
		INT_ACC_REQ						=>	INT_REQs		(2),
		INT_ACC_ACK						=>	INT_ACKs		(2),
		--	Interrupt Handler
		INT_IHA_Enable					=>	INT_REQ_ENs		(2),
		INT_IHA_Load					=>	INT_IHA_Load	(2),
        INT_IHA_REQ						=>	INT_IHA_REQ		(2),
		INT_IHA_REQ_ADD					=>	INT_IHA_REQ_ADD	(2),
        INT_IHA_ACK						=>	INT_IHA_ACK		(2),
		INT_IHA_ACK_ADD					=>	INT_IHA_ACK_ADD	(2));
	--------------------------------------------------------------------------
	PLANE_0_MBIH						:	MiniBatch_Interrupt_handler
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		--	Accelerator
		INT_ACC_REQ						=>	INT_REQs		(3),
		INT_ACC_ACK						=>	INT_ACKs		(3),
		--	Interrupt Handler
		INT_IHA_Enable					=>	INT_REQ_ENs		(3),
		INT_IHA_Load					=>	INT_IHA_Load	(3),
        INT_IHA_REQ						=>	INT_IHA_REQ		(3),
		INT_IHA_REQ_ADD					=>	INT_IHA_REQ_ADD	(3),
        INT_IHA_ACK						=>	INT_IHA_ACK		(3),
		INT_IHA_ACK_ADD					=>	INT_IHA_ACK_ADD	(3));
	--------------------------------------------------------------------------
	PLANE_1_MBIH						:	MiniBatch_Interrupt_handler
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		--	Accelerator
		INT_ACC_REQ						=>	INT_REQs		(4),
		INT_ACC_ACK						=>	INT_ACKs		(4),
		--	Interrupt Handler
		INT_IHA_Enable					=>	INT_REQ_ENs		(4),
		INT_IHA_Load					=>	INT_IHA_Load	(4),
        INT_IHA_REQ						=>	INT_IHA_REQ		(4),
		INT_IHA_REQ_ADD					=>	INT_IHA_REQ_ADD	(4),
        INT_IHA_ACK						=>	INT_IHA_ACK		(4),
		INT_IHA_ACK_ADD					=>	INT_IHA_ACK_ADD	(4));
	--------------------------------------------------------------------------
	PLANE_2_MBIH						:	MiniBatch_Interrupt_handler
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		--	Accelerator
		INT_ACC_REQ						=>	INT_REQs		(5),
		INT_ACC_ACK						=>	INT_ACKs		(5),
		--	Interrupt Handler 
		INT_IHA_Enable					=>	INT_REQ_ENs		(5),
		INT_IHA_Load					=>	INT_IHA_Load	(5),
        INT_IHA_REQ						=>	INT_IHA_REQ		(5),
		INT_IHA_REQ_ADD					=>	INT_IHA_REQ_ADD	(5),
        INT_IHA_ACK						=>	INT_IHA_ACK		(5),
		INT_IHA_ACK_ADD					=>	INT_IHA_ACK_ADD	(5));
	--------------------------------------------------------------------------
	PLANE_3_MBIH						:	MiniBatch_Interrupt_handler
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		--	Accelerator
		INT_ACC_REQ						=>	INT_REQs		(6),
		INT_ACC_ACK						=>	INT_ACKs		(6),
		--	Interrupt Handler
		INT_IHA_Enable					=>	INT_REQ_ENs		(6),
		INT_IHA_Load					=>	INT_IHA_Load	(6),
        INT_IHA_REQ						=>	INT_IHA_REQ		(6),
		INT_IHA_REQ_ADD					=>	INT_IHA_REQ_ADD	(6),
        INT_IHA_ACK						=>	INT_IHA_ACK		(6),
		INT_IHA_ACK_ADD					=>	INT_IHA_ACK_ADD	(6));
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
																INT_REQs(0)							<=	INT_REQ_SYS_TIMER	&	"00000"	&	INT_REQ_TBE	&	INT_REQ_RBF	&	INT_REQ_SYS_PC;
																INT_REQs(1)							<=	INT_REQ_MPDR_Ready;
																INT_REQs(2)							<=	INT_REQ_DMA_Ready;
																INT_REQs(3)							<=	INT_REQ_PSU_Done(0)(4,4) & INT_REQ_PSU_Done(0)(4,3) & INT_REQ_PSU_Done(0)(4,2) & INT_REQ_PSU_Done(0)(4,1) & 
																										INT_REQ_PSU_Done(0)(3,4) & INT_REQ_PSU_Done(0)(3,3) & INT_REQ_PSU_Done(0)(3,2) & INT_REQ_PSU_Done(0)(3,1) & 
																										INT_REQ_PSU_Done(0)(2,4) & INT_REQ_PSU_Done(0)(2,3) & INT_REQ_PSU_Done(0)(2,2) & INT_REQ_PSU_Done(0)(2,1) & 
																										INT_REQ_PSU_Done(0)(1,4) & INT_REQ_PSU_Done(0)(1,3) & INT_REQ_PSU_Done(0)(1,2) & INT_REQ_PSU_Done(0)(1,1);
	REQs_GEN_1:		IF	P_Number_of_Planes	>	1	GENERATE	INT_REQs(4)							<=	INT_REQ_PSU_Done(1)(4,4) & INT_REQ_PSU_Done(1)(4,3) & INT_REQ_PSU_Done(1)(4,2) & INT_REQ_PSU_Done(1)(4,1) & 
																										INT_REQ_PSU_Done(1)(3,4) & INT_REQ_PSU_Done(1)(3,3) & INT_REQ_PSU_Done(1)(3,2) & INT_REQ_PSU_Done(1)(3,1) & 
																										INT_REQ_PSU_Done(1)(2,4) & INT_REQ_PSU_Done(1)(2,3) & INT_REQ_PSU_Done(1)(2,2) & INT_REQ_PSU_Done(1)(2,1) & 
																										INT_REQ_PSU_Done(1)(1,4) & INT_REQ_PSU_Done(1)(1,3) & INT_REQ_PSU_Done(1)(1,2) & INT_REQ_PSU_Done(1)(1,1);	END GENERATE;
	REQs_GEN_2:		IF	P_Number_of_Planes	>	2	GENERATE	INT_REQs(5)							<=	INT_REQ_PSU_Done(2)(4,4) & INT_REQ_PSU_Done(2)(4,3) & INT_REQ_PSU_Done(2)(4,2) & INT_REQ_PSU_Done(2)(4,1) & 
																										INT_REQ_PSU_Done(2)(3,4) & INT_REQ_PSU_Done(2)(3,3) & INT_REQ_PSU_Done(2)(3,2) & INT_REQ_PSU_Done(2)(3,1) & 
																										INT_REQ_PSU_Done(2)(2,4) & INT_REQ_PSU_Done(2)(2,3) & INT_REQ_PSU_Done(2)(2,2) & INT_REQ_PSU_Done(2)(2,1) & 
																										INT_REQ_PSU_Done(2)(1,4) & INT_REQ_PSU_Done(2)(1,3) & INT_REQ_PSU_Done(2)(1,2) & INT_REQ_PSU_Done(2)(1,1);	END GENERATE;
	REQs_GEN_3:		IF	P_Number_of_Planes	>	3	GENERATE	INT_REQs(6)							<=	INT_REQ_PSU_Done(3)(4,4) & INT_REQ_PSU_Done(3)(4,3) & INT_REQ_PSU_Done(3)(4,2) & INT_REQ_PSU_Done(3)(4,1) & 
																										INT_REQ_PSU_Done(3)(3,4) & INT_REQ_PSU_Done(3)(3,3) & INT_REQ_PSU_Done(3)(3,2) & INT_REQ_PSU_Done(3)(3,1) & 
																										INT_REQ_PSU_Done(3)(2,4) & INT_REQ_PSU_Done(3)(2,3) & INT_REQ_PSU_Done(3)(2,2) & INT_REQ_PSU_Done(3)(2,1) & 
																										INT_REQ_PSU_Done(3)(1,4) & INT_REQ_PSU_Done(3)(1,3) & INT_REQ_PSU_Done(3)(1,2) & INT_REQ_PSU_Done(3)(1,1);	END GENERATE;
	Zero_GEN_2:		IF	P_Number_of_Planes	<	2	GENERATE	INT_REQs(4)							<=	(OTHERS	=>	'0');																							END GENERATE;
	Zero_GEN_3:		IF	P_Number_of_Planes	<	3	GENERATE	INT_REQs(5)							<=	(OTHERS	=>	'0');																							END GENERATE;
	Zero_GEN_4:		IF	P_Number_of_Planes	<	4	GENERATE	INT_REQs(6)							<=	(OTHERS	=>	'0');																							END GENERATE;
	--------------------------------------------------------------------------
																INT_ACK_SYS_PC						<=	INT_ACKs(0)(0);
																INT_ACK_TBE							<=	INT_ACKs(0)(1);
																INT_ACK_RBF							<=	INT_ACKs(0)(2);
																INT_ACK_SYS_TIMER					<=	INT_ACKs(0)(15	DOWNTO	8);
																INT_ACK_MPDR_Ready					<=	INT_ACKs(1);
																INT_ACK_DMA_Ready					<=	INT_ACKs(2);
																INT_ACK_PSU_Done(0)(4,4)			<=	INT_ACKs(3)(15);
																INT_ACK_PSU_Done(0)(4,3)			<=	INT_ACKs(3)(14);
																INT_ACK_PSU_Done(0)(4,2)			<=	INT_ACKs(3)(13);
																INT_ACK_PSU_Done(0)(4,1)			<=	INT_ACKs(3)(12);
																INT_ACK_PSU_Done(0)(3,4)			<=	INT_ACKs(3)(11);
																INT_ACK_PSU_Done(0)(3,3)			<=	INT_ACKs(3)(10);
																INT_ACK_PSU_Done(0)(3,2)			<=	INT_ACKs(3)(9);	
																INT_ACK_PSU_Done(0)(3,1)			<=	INT_ACKs(3)(8);	
																INT_ACK_PSU_Done(0)(2,4)			<=	INT_ACKs(3)(7);	
																INT_ACK_PSU_Done(0)(2,3)			<=	INT_ACKs(3)(6);	
																INT_ACK_PSU_Done(0)(2,2)			<=	INT_ACKs(3)(5);	
																INT_ACK_PSU_Done(0)(2,1)			<=	INT_ACKs(3)(4);	
																INT_ACK_PSU_Done(0)(1,4)			<=	INT_ACKs(3)(3);	
																INT_ACK_PSU_Done(0)(1,3)			<=	INT_ACKs(3)(2);	
																INT_ACK_PSU_Done(0)(1,2)			<=	INT_ACKs(3)(1);	
																INT_ACK_PSU_Done(0)(1,1)			<=	INT_ACKs(3)(0);	
	ACKs_GEN_0:		IF	P_Number_of_Planes	>	1	GENERATE	INT_ACK_PSU_Done(1)(4,4)			<=	INT_ACKs(4)(15);																							END GENERATE;
	ACKs_GEN_1:		IF	P_Number_of_Planes	>	1	GENERATE	INT_ACK_PSU_Done(1)(4,3)			<=	INT_ACKs(4)(14);																							END GENERATE;
	ACKs_GEN_2:		IF	P_Number_of_Planes	>	1	GENERATE	INT_ACK_PSU_Done(1)(4,2)			<=	INT_ACKs(4)(13);																							END GENERATE;
	ACKs_GEN_3:		IF	P_Number_of_Planes	>	1	GENERATE	INT_ACK_PSU_Done(1)(4,1)			<=	INT_ACKs(4)(12);																							END GENERATE;
	ACKs_GEN_4:		IF	P_Number_of_Planes	>	1	GENERATE	INT_ACK_PSU_Done(1)(3,4)			<=	INT_ACKs(4)(11);																							END GENERATE;
	ACKs_GEN_5:		IF	P_Number_of_Planes	>	1	GENERATE	INT_ACK_PSU_Done(1)(3,3)			<=	INT_ACKs(4)(10);																							END GENERATE;
	ACKs_GEN_6:		IF	P_Number_of_Planes	>	1	GENERATE	INT_ACK_PSU_Done(1)(3,2)			<=	INT_ACKs(4)(9);																								END GENERATE;
	ACKs_GEN_7:		IF	P_Number_of_Planes	>	1	GENERATE	INT_ACK_PSU_Done(1)(3,1)			<=	INT_ACKs(4)(8);																								END GENERATE;
	ACKs_GEN_8:		IF	P_Number_of_Planes	>	1	GENERATE	INT_ACK_PSU_Done(1)(2,4)			<=	INT_ACKs(4)(7);																								END GENERATE;
	ACKs_GEN_9:		IF	P_Number_of_Planes	>	1	GENERATE	INT_ACK_PSU_Done(1)(2,3)			<=	INT_ACKs(4)(6);																								END GENERATE;
	ACKs_GEN_10:	IF	P_Number_of_Planes	>	1	GENERATE	INT_ACK_PSU_Done(1)(2,2)			<=	INT_ACKs(4)(5);																								END GENERATE;
	ACKs_GEN_11:	IF	P_Number_of_Planes	>	1	GENERATE	INT_ACK_PSU_Done(1)(2,1)			<=	INT_ACKs(4)(4);																								END GENERATE;
	ACKs_GEN_12:	IF	P_Number_of_Planes	>	1	GENERATE	INT_ACK_PSU_Done(1)(1,4)			<=	INT_ACKs(4)(3);																								END GENERATE;
	ACKs_GEN_13:	IF	P_Number_of_Planes	>	1	GENERATE	INT_ACK_PSU_Done(1)(1,3)			<=	INT_ACKs(4)(2);																								END GENERATE;
	ACKs_GEN_14:	IF	P_Number_of_Planes	>	1	GENERATE	INT_ACK_PSU_Done(1)(1,2)			<=	INT_ACKs(4)(1);																								END GENERATE;
	ACKs_GEN_15:	IF	P_Number_of_Planes	>	1	GENERATE	INT_ACK_PSU_Done(1)(1,1)			<=	INT_ACKs(4)(0);																								END GENERATE;
	ACKs_GEN_16:	IF	P_Number_of_Planes	>	2	GENERATE	INT_ACK_PSU_Done(2)(4,4)			<=	INT_ACKs(5)(15);																							END GENERATE;
	ACKs_GEN_17:	IF	P_Number_of_Planes	>	2	GENERATE	INT_ACK_PSU_Done(2)(4,3)			<=	INT_ACKs(5)(14);																							END GENERATE;
	ACKs_GEN_18:	IF	P_Number_of_Planes	>	2	GENERATE	INT_ACK_PSU_Done(2)(4,2)			<=	INT_ACKs(5)(13);																							END GENERATE;
	ACKs_GEN_19:	IF	P_Number_of_Planes	>	2	GENERATE	INT_ACK_PSU_Done(2)(4,1)			<=	INT_ACKs(5)(12);																							END GENERATE;
	ACKs_GEN_20:	IF	P_Number_of_Planes	>	2	GENERATE	INT_ACK_PSU_Done(2)(3,4)			<=	INT_ACKs(5)(11);																							END GENERATE;
	ACKs_GEN_21:	IF	P_Number_of_Planes	>	2	GENERATE	INT_ACK_PSU_Done(2)(3,3)			<=	INT_ACKs(5)(10);																							END GENERATE;
	ACKs_GEN_22:	IF	P_Number_of_Planes	>	2	GENERATE	INT_ACK_PSU_Done(2)(3,2)			<=	INT_ACKs(5)(9);																								END GENERATE;
	ACKs_GEN_23:	IF	P_Number_of_Planes	>	2	GENERATE	INT_ACK_PSU_Done(2)(3,1)			<=	INT_ACKs(5)(8);																								END GENERATE;
	ACKs_GEN_24:	IF	P_Number_of_Planes	>	2	GENERATE	INT_ACK_PSU_Done(2)(2,4)			<=	INT_ACKs(5)(7);																								END GENERATE;
	ACKs_GEN_25:	IF	P_Number_of_Planes	>	2	GENERATE	INT_ACK_PSU_Done(2)(2,3)			<=	INT_ACKs(5)(6);																								END GENERATE;
	ACKs_GEN_26:	IF	P_Number_of_Planes	>	2	GENERATE	INT_ACK_PSU_Done(2)(2,2)			<=	INT_ACKs(5)(5);																								END GENERATE;
	ACKs_GEN_27:	IF	P_Number_of_Planes	>	2	GENERATE	INT_ACK_PSU_Done(2)(2,1)			<=	INT_ACKs(5)(4);																								END GENERATE;
	ACKs_GEN_28:	IF	P_Number_of_Planes	>	2	GENERATE	INT_ACK_PSU_Done(2)(1,4)			<=	INT_ACKs(5)(3);																								END GENERATE;
	ACKs_GEN_29:	IF	P_Number_of_Planes	>	2	GENERATE	INT_ACK_PSU_Done(2)(1,3)			<=	INT_ACKs(5)(2);																								END GENERATE;
	ACKs_GEN_30:	IF	P_Number_of_Planes	>	2	GENERATE	INT_ACK_PSU_Done(2)(1,2)			<=	INT_ACKs(5)(1);																								END GENERATE;
	ACKs_GEN_31:	IF	P_Number_of_Planes	>	2	GENERATE	INT_ACK_PSU_Done(2)(1,1)			<=	INT_ACKs(5)(0);																								END GENERATE;
	ACKs_GEN_32:	IF	P_Number_of_Planes	>	3	GENERATE	INT_ACK_PSU_Done(3)(4,4)			<=	INT_ACKs(6)(15);																							END GENERATE;
	ACKs_GEN_33:	IF	P_Number_of_Planes	>	3	GENERATE	INT_ACK_PSU_Done(3)(4,3)			<=	INT_ACKs(6)(14);																							END GENERATE;
	ACKs_GEN_34:	IF	P_Number_of_Planes	>	3	GENERATE	INT_ACK_PSU_Done(3)(4,2)			<=	INT_ACKs(6)(13);																							END GENERATE;
	ACKs_GEN_35:	IF	P_Number_of_Planes	>	3	GENERATE	INT_ACK_PSU_Done(3)(4,1)			<=	INT_ACKs(6)(12);																							END GENERATE;
	ACKs_GEN_36:	IF	P_Number_of_Planes	>	3	GENERATE	INT_ACK_PSU_Done(3)(3,4)			<=	INT_ACKs(6)(11);																							END GENERATE;
	ACKs_GEN_37:	IF	P_Number_of_Planes	>	3	GENERATE	INT_ACK_PSU_Done(3)(3,3)			<=	INT_ACKs(6)(10);																							END GENERATE;
	ACKs_GEN_38:	IF	P_Number_of_Planes	>	3	GENERATE	INT_ACK_PSU_Done(3)(3,2)			<=	INT_ACKs(6)(9);																								END GENERATE;
	ACKs_GEN_39:	IF	P_Number_of_Planes	>	3	GENERATE	INT_ACK_PSU_Done(3)(3,1)			<=	INT_ACKs(6)(8);																								END GENERATE;
	ACKs_GEN_40:	IF	P_Number_of_Planes	>	3	GENERATE	INT_ACK_PSU_Done(3)(2,4)			<=	INT_ACKs(6)(7);																								END GENERATE;
	ACKs_GEN_41:	IF	P_Number_of_Planes	>	3	GENERATE	INT_ACK_PSU_Done(3)(2,3)			<=	INT_ACKs(6)(6);																								END GENERATE;
	ACKs_GEN_42:	IF	P_Number_of_Planes	>	3	GENERATE	INT_ACK_PSU_Done(3)(2,2)			<=	INT_ACKs(6)(5);																								END GENERATE;
	ACKs_GEN_43:	IF	P_Number_of_Planes	>	3	GENERATE	INT_ACK_PSU_Done(3)(2,1)			<=	INT_ACKs(6)(4);																								END GENERATE;
	ACKs_GEN_44:	IF	P_Number_of_Planes	>	3	GENERATE	INT_ACK_PSU_Done(3)(1,4)			<=	INT_ACKs(6)(3);																								END GENERATE;
	ACKs_GEN_45:	IF	P_Number_of_Planes	>	3	GENERATE	INT_ACK_PSU_Done(3)(1,3)			<=	INT_ACKs(6)(2);																								END GENERATE;
	ACKs_GEN_46:	IF	P_Number_of_Planes	>	3	GENERATE	INT_ACK_PSU_Done(3)(1,2)			<=	INT_ACKs(6)(1);																								END GENERATE;
	ACKs_GEN_47:	IF	P_Number_of_Planes	>	3	GENERATE	INT_ACK_PSU_Done(3)(1,1)			<=	INT_ACKs(6)(0);																								END GENERATE;
	--------------------------------------------------------------------------      
	INT_IHA_ACK_ADD	(0)					<=	INT_INT_ADD	(3	DOWNTO	 0);
	INT_IHA_ACK_ADD	(1)					<=	INT_INT_ADD	(7	DOWNTO	 4);
	INT_IHA_ACK_ADD	(2)					<=	INT_INT_ADD	(11	DOWNTO	 8);
	INT_IHA_ACK_ADD	(3)					<=	INT_INT_ADD	(15	DOWNTO	12);
	INT_IHA_ACK_ADD	(4)					<=	INT_INT_ADD	(19	DOWNTO	16);
	INT_IHA_ACK_ADD	(5)					<=	INT_INT_ADD	(23	DOWNTO	20);
	INT_IHA_ACK_ADD	(6)					<=	INT_INT_ADD	(27	DOWNTO	24);
	--------------------------------------------------------------------------
	INT_IHA_ACK							<=	INT_APP_ACK	(6	DOWNTO	0)	OR	INT_ACK;
	--------------------------------------------------------------------------
	INT_REQ								<=	INT_IHA_REQ;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	PROCESS(clk, rst)
		VARIABLE	add					:	INTEGER;
		VARIABLE	Eadd				:	INTEGER;
	BEGIN
		IF rst = '1' THEN
			INT_REQ_ENs					<=	(OTHERS	=>	(OTHERS	=>	'0'));
		ELSIF clk = '1' AND clk'EVENT THEN
			INT_APP_ACK					<=	(OTHERS	=>	'0');
			add							:=	to_integer(SIGNED(X_check(MAIN_PORT_Address)));
			Eadd						:=	(add/4) - (BASE_ADDRESS/4);
			IF MAIN_PORT_WEN = '1' AND add >= BASE_ADDRESS AND add < ENDx_ADDRESS THEN 
				CASE Eadd	IS
					WHEN	0			=>	INT_REQ_ENs(0)		<=	MAIN_PORT_Data_in	(15	DOWNTO	0);
					WHEN	1			=>	INT_REQ_ENs(1)		<=	MAIN_PORT_Data_in	(15	DOWNTO	0);
					WHEN	2			=>	INT_REQ_ENs(2)		<=	MAIN_PORT_Data_in	(15	DOWNTO	0);
					WHEN	3			=>	INT_REQ_ENs(3)		<=	MAIN_PORT_Data_in	(15	DOWNTO	0);
					WHEN	4			=>	INT_REQ_ENs(4)		<=	MAIN_PORT_Data_in	(15	DOWNTO	0);
					WHEN	5			=>	INT_REQ_ENs(5)		<=	MAIN_PORT_Data_in	(15	DOWNTO	0);
					WHEN	6			=>	INT_REQ_ENs(6)		<=	MAIN_PORT_Data_in	(15	DOWNTO	0);
					WHEN	7			=>	NULL;
					WHEN	8			=>	NULL;
					WHEN	9			=>	NULL;
					WHEN	10			=>	NULL;
					WHEN	11			=>	INT_APP_ACK			<=	MAIN_PORT_Data_in	(15	DOWNTO	0);
					WHEN	OTHERS		=>	NULL;
				END CASE;
			END IF;
		END IF;
		--WAIT ON clk, rst;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS(MAIN_PORT_Address, MAIN_PORT_OEN, INT_REQ_ENs, INT_INT_ADD)
		VARIABLE	add					:	INTEGER;
		VARIABLE	Eadd				:	INTEGER;
	BEGIN
		add								:=	to_integer(SIGNED(X_check(MAIN_PORT_Address)));
		Eadd							:=	(add/4) - (BASE_ADDRESS/4);
		IF MAIN_PORT_OEN = '1' AND add  >= BASE_ADDRESS AND add < ENDx_ADDRESS THEN 
			CASE Eadd	IS
				WHEN	0				=>	MAIN_PORT_Data_out			<=	X"0000"	&	INT_REQ_ENs(0);
				WHEN	1				=>	MAIN_PORT_Data_out			<=	X"0000"	&	INT_REQ_ENs(1);
				WHEN	2				=>	MAIN_PORT_Data_out			<=	X"0000"	&	INT_REQ_ENs(2);
				WHEN	3				=>	MAIN_PORT_Data_out			<=	X"0000"	&	INT_REQ_ENs(3);
				WHEN	4				=>	MAIN_PORT_Data_out			<=	X"0000"	&	INT_REQ_ENs(4);
				WHEN	5				=>	MAIN_PORT_Data_out			<=	X"0000"	&	INT_REQ_ENs(5);
				WHEN	6				=>	MAIN_PORT_Data_out			<=	X"0000"	&	INT_REQ_ENs(6);
				WHEN	7				=>	MAIN_PORT_Data_out			<=	X"00000000";
				WHEN	8				=>	MAIN_PORT_Data_out			<=	X"00000000";
				WHEN	9				=>	MAIN_PORT_Data_out			<=	X"00000000";
				WHEN	10				=>	MAIN_PORT_Data_out			<=	INT_INT_ADD;
				WHEN	11				=>	MAIN_PORT_Data_out			<=	X"00000000";
				WHEN	OTHERS			=>	MAIN_PORT_Data_out			<=	(OTHERS	=>	'Z');
			END CASE;
		ELSE
			MAIN_PORT_Data_out			<=	(OTHERS	=>	'Z');
		END IF;
		--WAIT ON	MAIN_PORT_Address, MAIN_PORT_OEN, INT_ENABLEs, NEXT_INT_ADDRESS;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS(clk, rst)
	BEGIN
		IF rst = '1' THEN
			INT_INT_ADD					<=	(OTHERS	=>	'0');
		ELSIF clk = '1' AND clk'EVENT THEN
			IF	INT_IHA_Load(0)	= '1'	THEN	INT_INT_ADD	(3	DOWNTO	 0)	<=	INT_IHA_REQ_ADD(0);	END IF;
			IF	INT_IHA_Load(1)	= '1'	THEN	INT_INT_ADD	(7	DOWNTO	 4)	<=	INT_IHA_REQ_ADD(1);	END IF;
			IF	INT_IHA_Load(2)	= '1'	THEN	INT_INT_ADD	(11	DOWNTO	 8)	<=	INT_IHA_REQ_ADD(2);	END IF;
			IF	INT_IHA_Load(3)	= '1'	THEN	INT_INT_ADD	(15	DOWNTO	12)	<=	INT_IHA_REQ_ADD(3);	END IF;
			IF	INT_IHA_Load(4)	= '1'	THEN	INT_INT_ADD	(19	DOWNTO	16)	<=	INT_IHA_REQ_ADD(4);	END IF;
			IF	INT_IHA_Load(5)	= '1'	THEN	INT_INT_ADD	(23	DOWNTO	20)	<=	INT_IHA_REQ_ADD(5);	END IF;
			IF	INT_IHA_Load(6)	= '1'	THEN	INT_INT_ADD	(27	DOWNTO	24)	<=	INT_IHA_REQ_ADD(6);	END IF;
		END IF;
		--WAIT ON clk, rst;
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



