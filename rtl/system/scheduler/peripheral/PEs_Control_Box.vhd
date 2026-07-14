library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE work.my_pack_v2.ALL;

entity PEs_Control_Box is
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
		
		--	Control Signals
		------	PEs
		CMD_PEs_start					:	OUT	std_logic_4X4;		--(flip)	simple start
		CMD_PEs_init_inc_Rows			:	OUT	std_logic_4X4V3;	--(flag)	inc row select
		------	STA		
		CMD_STA_ACK						:	OUT	std_logic_4X4;		--(flip)	scheduler tells STA that the DMA transfers data and ready to accept another chunk
		CMD_STA_load					:	OUT	std_logic_4X4;		--(flip)	load a row data from memory
		CMD_STA_MEM_en					:	OUT	std_logic_4X4;		--(flip)	accumulate with internal memory content
		CMD_STA_OBM_en					:	OUT	std_logic_4X4;		--(flip)	accumulate with OBM content
		CMD_STA_BIS_en					:	OUT	std_logic_4X4;		--(flip)	accumulate with BIAS
		CMD_STA_save					:	OUT	std_logic_4X4;		--(flip)	save the result in the internal memory
		CMD_STA_active					:	OUT	std_logic_4X4;		--(flip)	pass through activation function module
		CMD_STA_store					:	OUT	std_logic_4X4;		--(flip)	store the row in memory
		CMD_STA_load_UA					:	OUT	std_logic_4X4;		--(flip)	update BASE ADDRESS of load  pointer 
		CMD_STA_stor_UA					:	OUT	std_logic_4X4;		--(flip)	update BASE ADDRESS of store pointer 
		CMD_STA_done					:	IN	std_logic_4X4;
		------	UPA		
		CMD_UPA_Up_IFM					:	OUT	std_logic_4X4;		--(flip)	update input feature map buffers
		CMD_UPA_Up_WFM					:	OUT	std_logic_4X4;		--(flip)	update weigh buffers
		CMD_UPA_status					:	IN	std_logic_4X4V2;	--			status of UPA
		
		--	CONTROL
		------	PAUSE
		CNT_PEs_PAUSE					:	OUT	std_logic_4X4;		--(flip)
		CNT_STA_PAUSE					:	OUT	std_logic_4X4;		--(flip)
		CNT_UPA_PAUSE					:	OUT	std_logic_4X4);		--(flip)
end PEs_Control_Box;

architecture Behavioral of PEs_Control_Box is
	--------------------------------------------------------------------------
	--		CONSTANTs
	--------------------------------------------------------------------------
	CONSTANT	NUMB_ints				:	INTEGER	:=	16;
	CONSTANT	ENDx_ADDRESS			:	INTEGER	:=	BASE_ADDRESS + 4*NUMB_ints;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--	31					30					29					28					27					26					25					24
	--	RSRVD,				RSRVD,				RSRVD,				PAUSE_PEs,			CMD_PEs_start,		RSRVD,				RSRVD,				RSRVD
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--	23					22					21					20					19					18					17					16
	--	RSRVD,				RSRVD,				RSRVD,				RSRVD,				STA_Atumatic,		CMD_ACK,			PAUSE_STA,			CMD_STA_load	
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--	15					14					13					12					11					10					9					8
	--	CMD_STA_MEM_en,		CMD_STA_OBM_en,		CMD_STA_BIS_en,		CMD_STA_save,		CMD_STA_active,		CMD_STA_store,		CMD_STA_load_UA,	CMD_STA_stor_UA,   	
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--	7					6					5					4					3					2					1					0
	--	RSRVD,				RSRVD,				PAUSE_UPA,			CMD_UPA_Up_IFM,		CMD_UPA_Up_WFM,		RSRVD,				CMD_UPA_status1,	CMD_UPA_status0
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- ASTAAI_Cntr = Automatic STA Acknowledgment ISSUE Counter;
	--------------------------------------------------------------------------
	--		ADDRESS	MAP														--
	--------------------------------------------------------------------------
	--		BASE_ADDRESS	+	00		:	PE(1,1)
	--		BASE_ADDRESS	+	04		:	PE(1,2)
	--		BASE_ADDRESS	+	08		:	PE(1,3)
	--		BASE_ADDRESS	+	0C		:	PE(1,4)
	--		BASE_ADDRESS	+	10		:	PE(2,1)
	--		BASE_ADDRESS	+	14		:	PE(2,2)
	--		BASE_ADDRESS	+	18		:	PE(2,3)
	--		BASE_ADDRESS	+	1C		:	PE(2,4)
	--		BASE_ADDRESS	+	20		:	PE(3,1)
	--		BASE_ADDRESS	+	24		:	PE(3,2)
	--		BASE_ADDRESS	+	28		:	PE(3,3)
	--		BASE_ADDRESS	+	2C		:	PE(3,4)
	--		BASE_ADDRESS	+	30		:	PE(4,1)
	--		BASE_ADDRESS	+	34		:	PE(4,2)
	--		BASE_ADDRESS	+	38		:	PE(4,3)
	--		BASE_ADDRESS	+	3C		:	PE(4,4)
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		TYPEs
	--------------------------------------------------------------------------
	TYPE	mem_type					IS	ARRAY (0 TO NUMB_ints-1)	OF	std_logic_vector(31	DOWNTO	0);
	--mem(Eadd)(31)	:	RSRVD
	--mem(Eadd)(30)	:	RSRVD
	--mem(Eadd)(29)	:	RSRVD
	--mem(Eadd)(28)	:	PAUSE_PEs
	--mem(Eadd)(27)	:	CMD_PEs_start
	--mem(Eadd)(26)	:	CMD_inc_Rows2
	--mem(Eadd)(25)	:	CMD_inc_Rows1
	--mem(Eadd)(24)	:	CMD_inc_Rows0
	--mem(Eadd)(23)	:	RSRVD
	--mem(Eadd)(22)	:	RSRVD	
	--mem(Eadd)(21)	:	RSRVD	
	--mem(Eadd)(20)	:	RSRVD
	--mem(Eadd)(19)	:	STA_Atumatic
	--mem(Eadd)(18)	:	CMD_ACK
	--mem(Eadd)(17)	:	PAUSE_STA
	--mem(Eadd)(16)	:	CMD_STA_load
	--mem(Eadd)(15)	:	CMD_STA_MEM_en
	--mem(Eadd)(14)	:	CMD_STA_OBM_en
	--mem(Eadd)(13)	:	CMD_STA_BIS_en
	--mem(Eadd)(12)	:	CMD_STA_save
	--mem(Eadd)(11)	:	CMD_STA_active
	--mem(Eadd)(10)	:	CMD_STA_store
	--mem(Eadd)(9)	:	CMD_STA_load_UA
	--mem(Eadd)(8)	:	CMD_STA_stor_UA
	--mem(Eadd)(7)	:	RSRVD
	--mem(Eadd)(6)	:	RSRVD
	--mem(Eadd)(5)	:	PAUSE_UPA
	--mem(Eadd)(4)	:	CMD_UPA_Up_IFM
	--mem(Eadd)(3)	:	CMD_UPA_Up_WFM
	--mem(Eadd)(2)	:	RSRVD
	--mem(Eadd)(1)	:	CMD_UPA_status1
	--mem(Eadd)(0)	:	CMD_UPA_status0
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		SIGNALs
	--------------------------------------------------------------------------
	SIGNAL	mem							:	mem_type;
	SIGNAL	Edge_detector				:	std_logic_4X4;
	SIGNAL	past_STA_done				:	std_logic_4X4;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
begin
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	PROCESS(clk, rst)
	BEGIN
		IF rst = '1' THEN
			past_STA_done				<=	(OTHERS	=>	(OTHERS	=>	'0'));
		ELSIF clk = '1' AND clk'EVENT THEN
			past_STA_done				<=	CMD_STA_done;
		END IF;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS(past_STA_done, CMD_STA_done, mem)
	BEGIN
		Edge_detector					<=	(OTHERS	=>	(OTHERS	=>	'0'));
		FOR r IN 1 TO 4		LOOP
			FOR C IN 1 TO 4	LOOP
				Edge_detector(r,c)		<=	CMD_STA_done(r,c) AND (NOT past_STA_done(r,c));
			END LOOP;
		END LOOP;
	END PROCESS;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	PROCESS(clk, rst)
		VARIABLE	add					:	INTEGER;
		VARIABLE	Eadd				:	INTEGER;
	BEGIN
		IF rst = '1' THEN
			mem							<=	(OTHERS	=>	(OTHERS	=>	'0'));
		ELSIF clk = '1' AND clk'EVENT THEN
			FOR r IN 0 TO 3		LOOP
				FOR C IN 0 TO 3	LOOP
					mem(4*r+c)(1		DOWNTO 0)	<=	CMD_UPA_status(r+1,c+1);	--	CMD_UPA_status
					mem(4*r+c)(18)					<=	'0';						--	CMD_ACK
					mem(4*r+c)(26		DOWNTO 24)	<=	"000";						--	CMD_inc_Rows
				END LOOP;
			END LOOP;
			add							:=	to_integer(SIGNED(X_check(MAIN_PORT_Address)));
			Eadd						:=	(add/4) - (BASE_ADDRESS/4);
			IF MAIN_PORT_WEN = '1' AND add >= BASE_ADDRESS AND add < ENDx_ADDRESS THEN 
				mem(Eadd)				<=	MAIN_PORT_Data_in;
			END IF;
		END IF;
		--WAIT ON clk, rst;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS(MAIN_PORT_Address, MAIN_PORT_OEN, mem)
		VARIABLE	add					:	INTEGER;
		VARIABLE	Eadd				:	INTEGER;
	BEGIN
		add								:=	to_integer(SIGNED(X_check(MAIN_PORT_Address)));
		Eadd							:=	(add/4) - (BASE_ADDRESS/4);
		IF MAIN_PORT_OEN = '1' AND add  >= BASE_ADDRESS AND add < ENDx_ADDRESS THEN 
			MAIN_PORT_Data_out			<=	mem(Eadd);
		ELSE
			MAIN_PORT_Data_out			<=	(OTHERS	=>	'Z');
		END IF;
		--WAIT ON	MAIN_PORT_Address, MAIN_PORT_OEN, mem;
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
	CMD_ROW_GEN										:	FOR r IN 1 TO 4	GENERATE
		CMD_COL_GEN									:	FOR c IN 1 TO 4	GENERATE
			CNT_PEs_PAUSE			(r,c)			<=	mem(4*r+c-5)(28);
			CMD_PEs_start			(r,c)			<=	mem(4*r+c-5)(27);
			--CMD_PEs_init_inc_Rows	(r,c)			<=	mem(4*r+c-5)(26	DOWNTO 24);
			CMD_PEs_init_inc_Rows	(r,c)			<=	(OTHERS	=>	'0');
			CMD_STA_ACK				(r,c)			<=	mem(4*r+c-5)(18) OR (mem(4*r+c-5)(19) AND CMD_STA_done(r,c)) ;		-- CMD_ACK | (STA_Atumatic & CMD_STA_done)
			CNT_STA_PAUSE			(r,c)			<=	mem(4*r+c-5)(17);
			CMD_STA_load			(r,c)			<=	mem(4*r+c-5)(16);
			CMD_STA_MEM_en			(r,c)			<=	mem(4*r+c-5)(15);
			CMD_STA_OBM_en			(r,c)			<=	mem(4*r+c-5)(14);
			CMD_STA_BIS_en			(r,c)			<=	mem(4*r+c-5)(13);
			CMD_STA_save			(r,c)			<=	mem(4*r+c-5)(12);
			CMD_STA_active			(r,c)			<=	mem(4*r+c-5)(11);
			CMD_STA_store			(r,c)			<=	mem(4*r+c-5)(10);
			CMD_STA_load_UA			(r,c)			<=	mem(4*r+c-5)(9);
			CMD_STA_stor_UA			(r,c)			<=	mem(4*r+c-5)(8);
			CNT_UPA_PAUSE			(r,c)			<=	mem(4*r+c-5)(5);
			CMD_UPA_Up_IFM			(r,c)			<=	mem(4*r+c-5)(4);
			CMD_UPA_Up_WFM			(r,c)			<=	mem(4*r+c-5)(3);
		END GENERATE;
	END GENERATE;
	--------------------------------------------------------------------------
end Behavioral;

	-- Old:
	--	31					30					29					28					27					26					25					24
	--	RSRVD,				RSRVD,				RSRVD,				PAUSE_PEs,			CMD_PEs_start,		CMD_inc_Rows2,		CMD_inc_Rows1,		CMD_inc_Rows0
