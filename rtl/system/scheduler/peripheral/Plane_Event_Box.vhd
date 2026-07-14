library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.my_pack_v2.ALL;
	
entity Plane_Event_Box is
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
		
		--	EVENTS
		CMD_PEs_done					:	IN	std_logic_4X4;
		CMD_STA_done					:	IN	std_logic_4X4;
		CMD_UPA_done					:	IN	std_logic_4X4;
		
		--	INTERRUPT	HANDLER
		------	INTERRUPT REQUEST
		INT_EVNT_Done					:	OUT	std_logic_4X4;
		------	INTERRUPT ANSWERED
		ANS_EVNT_Done					:	IN	std_logic_4X4);
end Plane_Event_Box;

architecture Behavioral of Plane_Event_Box IS
	--------------------------------------------------------------------------
	--		ADDRESS	MAP		(#MMN_DMA=2, #GMN_DMA=4)						--
	--------------------------------------------------------------------------
	--		Address						:				  (r,c)				--
	--		BA	+	00					:	Event Counter (1,1)				--
	--		BA	+	04					:	Event Counter (1,2)				--
	--		BA	+	08					:	Event Counter (1,3)				--
	--		BA	+	0C					:	Event Counter (1,4)				--
	--		BA	+	10					:	Event Counter (2,1)				--
	--		BA	+	14					:	Event Counter (2,2)				--
	--		BA	+	18					:	Event Counter (2,3)				--
	--		BA	+	1C					:	Event Counter (2,4)				--
	--		BA	+	20					:	Event Counter (3,1)				--
	--		BA	+	24					:	Event Counter (3,2)				--
	--		BA	+	28					:	Event Counter (3,3)				--
	--		BA	+	2C					:	Event Counter (3,4)				--
	--		BA	+	30					:	Event Counter (4,1)				--
	--		BA	+	34					:	Event Counter (4,2)				--
	--		BA	+	38					:	Event Counter (4,3)				--
	--		BA	+	3C					:	Event Counter (4,4)				--
	--------------------------------------------------------------------------	
	--------------------------------------------------------------------------
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
	--						Source		:		sensitive to
	--							0		:		PE	DONE
	--							1		:		STA	DONE
	--							2		:		UPA	DONE
	--							3		:		RESERVED
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
	COMPONENT	Event_cntr
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		Cnt_Word						:	IN	std_logic_vector(16	DOWNTO	0);
		Cur_Word						:	OUT	std_logic_vector(31	DOWNTO	0);
		EVNT							:	IN	std_logic;
		INTR							:	OUT	std_logic;
		ANSD							:	IN	std_logic);
	END	COMPONENT;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		TYPEs
	--------------------------------------------------------------------------
	TYPE	PSU_Done_Control_Type		IS	ARRAY (3 DOWNTO 0, 3 DOWNTO 0)											OF	std_logic_vector(16	DOWNTO	0);
	TYPE	PSU_Done_Current_Type		IS	ARRAY (3 DOWNTO 0, 3 DOWNTO 0)											OF	std_logic_vector(31	DOWNTO	0);
	TYPE	PSU_Done_Sources_Type		IS	ARRAY (3 DOWNTO 0, 3 DOWNTO 0)											OF	std_logic_vector(1	DOWNTO	0);
	TYPE	PSU_EVENT_Type				IS	ARRAY (3 DOWNTO 0, 3 DOWNTO 0)											OF	std_logic;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		SINGALs
	--------------------------------------------------------------------------
	SIGNAL	PEs_Done_Control			:	PSU_Done_Control_Type;
	SIGNAL	PEs_Done_Current			:	PSU_Done_Current_Type;
	SIGNAL	PEs_Done_Sources			:	PSU_Done_Sources_Type;
	SIGNAL	PEs_EVENT					:	PSU_EVENT_Type;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
begin
	--------------------------------------------------------------------------
	PROCESS(clk, rst)
		VARIABLE	add					:	INTEGER;
		VARIABLE	r_add				:	INTEGER;
		VARIABLE	c_add				:	INTEGER;
	BEGIN
		IF rst = '1' THEN
			PEs_Done_Control			<=	(OTHERS	=>	(OTHERS	=>	(OTHERS	=>	'0')));
			PEs_Done_Sources			<=	(OTHERS	=>	(OTHERS	=>	(OTHERS	=>	'0')));
		ELSIF clk = '1' AND clk'EVENT THEN
			FOR r IN 3 DOWNTO 0 LOOP
				FOR c IN 3 DOWNTO 0 LOOP
					PEs_Done_Control(r,c)(16)	<=	'0';
					PEs_Done_Control(r,c)(13)	<=	'0';
				END LOOP;
			END LOOP;
			add							:=	to_integer(SIGNED(X_check(MAIN_PORT_Address)));
			r_add						:=	my_to_uint(MAIN_PORT_Address(5	DOWNTO	4));
			c_add						:=	my_to_uint(MAIN_PORT_Address(3	DOWNTO	2));
			IF MAIN_PORT_WEN = '1' AND add >= BASE_ADDRESS AND add < ENDx_ADDRESS THEN
				--	PEs Done
				PEs_Done_Control(r_add,c_add)(16	DOWNTO	11)	<=	MAIN_PORT_Data_in(31	DOWNTO	26);
				PEs_Done_Sources(r_add,c_add)					<=	MAIN_PORT_Data_in(23	DOWNTO	22);
				PEs_Done_Control(r_add,c_add)(10	DOWNTO	0)	<=	MAIN_PORT_Data_in(21	DOWNTO	11);
			END IF;
		END IF;
		--WAIT ON clk, rst;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS(MAIN_PORT_Address, MAIN_PORT_OEN, PEs_Done_Current, PEs_Done_Sources)
		VARIABLE	add					:	INTEGER;
		VARIABLE	r_add				:	INTEGER;
		VARIABLE	c_add				:	INTEGER;
		--VARIABLE	M_add				:	INTEGER;
		--VARIABLE	G_add				:	INTEGER;
	BEGIN
		add								:=	to_integer(SIGNED(X_check(MAIN_PORT_Address)));
		r_add							:=	my_to_uint(MAIN_PORT_Address(5	DOWNTO	4));
		c_add							:=	my_to_uint(MAIN_PORT_Address(3	DOWNTO	2));
		IF MAIN_PORT_OEN = '1' AND add	>= BASE_ADDRESS AND add < ENDx_ADDRESS THEN
			MAIN_PORT_Data_out			<=	PEs_Done_Current(r_add,c_add) OR (X"00" & PEs_Done_Sources(r_add,c_add) & "00" & X"00000");
		ELSE
			MAIN_PORT_Data_out			<=	(OTHERS	=>	'Z');
		END IF;
		--WAIT ON MAIN_PORT_Address, MAIN_PORT_OEN, PEs_Done_Current, STA_Done_Current, UPA_Done_Current, MMN_Done_Current, GMN_Done_Current;
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
	Done_Events_row_gen					:	FOR r	IN	0	TO	3	GENERATE
		Done_Events_col_gen				:	FOR c	IN	0	TO	3	GENERATE
			PEs_EVENT	(r,c)			<=	CMD_PEs_done(r+1,c+1)	WHEN	PEs_Done_Sources(r,c) = "00"	ELSE
											CMD_STA_done(r+1,c+1)	WHEN	PEs_Done_Sources(r,c) = "01"	ELSE
											CMD_UPA_done(r+1,c+1)	WHEN	PEs_Done_Sources(r,c) = "01"	ELSE	'0';
			Done_Event_cntr				:	Event_cntr
			PORT	MAP(
				clk						=>	clk,
				rst						=>	rst,
				Cnt_Word				=>	PEs_Done_Control	(r,c),
				Cur_Word				=>	PEs_Done_Current	(r,c),
				EVNT					=>	PEs_EVENT			(r,c),
				INTR					=>	INT_EVNT_Done		(r+1,c+1),
				ANSD					=>	ANS_EVNT_Done		(r+1,c+1));
		END GENERATE;
	END GENERATE;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
end Behavioral;



