library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.math_real.ALL;
USE work.my_pack_v2.ALL;

entity MPDR_Controller is
	PORT(
		clk_w					:	IN	std_logic;
		rst_w					:	IN	std_logic;
		
		
		--		Control	(Scheduler)
		CNT_start				:	IN	std_logic;
		CNT_done				:	OUT	std_logic;
		CNT_load				:	IN	std_logic;
				
				
		--	TO LMN		
		LL_ready				:	IN	std_logic;
		LL_wait					:	IN	std_logic;
		LL_push					:	OUT	std_logic;
		LL_ack					:	IN	std_logic;
		LL_read					:	OUT	std_logic;
		LL_write				:	OUT	std_logic;
		LL_data_rdy				:	IN	std_logic;
		LL_data_wen				:	OUT	std_logic;
		
		
		
		--	Controller
		init					:	OUT	std_logic;
		BA_wen					:	OUT	std_logic;
		Block_Address			:	OUT	std_logic_vector(2						DOWNTO 0);
		second_DataBlock		:	OUT	std_logic;
		main_wen				:	OUT	std_logic;
		Hand_wen				:	OUT	std_logic;
		Pass_Hand				:	OUT	std_logic;
		load_mxes				:	OUT	std_logic;
		
		LMNs_Colm_inc			:	OUT	std_logic;
		LMNs_Chan_inc			:	OUT	std_logic;
		MPUs_Colm_inc			:	OUT	std_logic;
		MPUs_Chan_inc			:	OUT	std_logic;
		
		LMNs_Colm_eq			:	IN	std_logic;
		LMNs_Chan_eq			:	IN	std_logic;
		MPUs_Colm_eq			:	IN	std_logic;
		MPUs_Chan_eq			:	IN	std_logic);
end MPDR_Controller;

architecture Behavioral of MPDR_Controller is
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	--	TYPEs 
	------------------------------------------------------------------------
	TYPE	states	IS			(	sleep,		Initiate,
									R1C1_Requ,	R1C1_Clct,	R1C1_Pool,
									R1C2_Requ,	R1C2_Clct,	R1C2_Pool,
									R2C1_Requ,	R2C1_Clct,	R2C1_Pool,
									R2C2_Requ,	R2C2_Clct,	R2C2_Pool,
									WBak_Requ,	Write_Back);	
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	--	SIGNALs 
	------------------------------------------------------------------------
	SIGNAL	P_S					:	states;
	SIGNAL	N_S					:	states;
	------------------------------------------------------------------------
	SIGNAL	All_Clctd			:	std_logic;
	SIGNAL	All_Pooled			:	std_logic;
	SIGNAL	All_Written			:	std_logic;
	------------------------------------------------------------------------
	------------------------------------------------------------------------
begin
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	--	State Transition 
	------------------------------------------------------------------------
	PROCESS	(clk_w, rst_w)
	BEGIN
		IF rst_w = '1' THEN
			P_S	<=	sleep;
		ELSIF clk_w = '1' AND clk_w'EVENT THEN
			P_S	<=	N_S;
		END IF;
	END PROCESS;
	------------------------------------------------------------------------
	PROCESS (	P_S,			
				CNT_start,		All_Clctd,		All_Pooled,		All_Written,
				LL_wait,		LL_data_rdy,	LL_ready,		LL_ack,
				LMNs_Colm_eq,	LMNs_Chan_eq,	MPUs_Colm_eq,	MPUs_Chan_eq)
	BEGIN
		N_S				<=	P_S;
		CASE P_S IS
			WHEN	sleep		=>	IF		CNT_start = '1'		THEN	N_S	<=	Initiate;		END IF;
			WHEN	Initiate	=>	IF		LL_ready = '1'		THEN	N_S	<=	R1C1_Requ;		END IF;
	------------------------------------------------------------------------------------------------------
			WHEN	R1C1_Requ	=>	IF		LL_ack = '1'		THEN	N_S	<=	R1C1_Clct;		END IF;
			WHEN	R1C1_Clct	=>	IF		All_Clctd = '1'		THEN	N_S	<=	R1C1_Pool;		END IF;
			WHEN	R1C1_Pool	=>	IF		All_Pooled = '1'	THEN	N_S	<=	R1C2_Requ;		END IF;
	------------------------------------------------------------------------------------------------------
			WHEN	R1C2_Requ	=>	IF		LL_ack = '1'		THEN	N_S	<=	R1C2_Clct;		END IF;
			WHEN	R1C2_Clct	=>	IF		All_Clctd = '1'		THEN	N_S	<=	R1C2_Pool;		END IF;
			WHEN	R1C2_Pool	=>	IF		All_Pooled = '1'	THEN	N_S	<=	R2C1_Requ;		END IF;
	------------------------------------------------------------------------------------------------------
			WHEN	R2C1_Requ	=>	IF		LL_ack = '1'		THEN	N_S	<=	R2C1_Clct;		END IF;
			WHEN	R2C1_Clct	=>	IF		All_Clctd = '1'		THEN	N_S	<=	R2C1_Pool;		END IF;
			WHEN	R2C1_Pool	=>	IF		All_Pooled = '1'	THEN	N_S	<=	R2C2_Requ;		END IF;
	------------------------------------------------------------------------------------------------------
			WHEN	R2C2_Requ	=>	IF		LL_ack = '1'		THEN	N_S	<=	R2C2_Clct;		END IF;
			WHEN	R2C2_Clct	=>	IF		All_Clctd = '1'		THEN	N_S	<=	R2C2_Pool;		END IF;
			WHEN	R2C2_Pool	=>	IF		All_Pooled = '1'	THEN	N_S	<=	WBak_Requ;		END IF;
	------------------------------------------------------------------------------------------------------
			WHEN	WBak_Requ	=>	IF		LL_ack = '1'		THEN	N_S	<=	Write_Back;		END IF;
			WHEN	Write_Back	=>	IF		All_Written = '1'	THEN	N_S	<=	sleep;			END IF;
			END CASE;
	END PROCESS;
	------------------------------------------------------------------------
	PROCESS (	P_S,			
				CNT_start,		All_Clctd,		All_Pooled,		All_Written,
				LL_wait,		LL_data_rdy,	LL_ready,		LL_ack,
				LMNs_Colm_eq,	LMNs_Chan_eq,	MPUs_Colm_eq,	MPUs_Chan_eq)
	BEGIN
		CNT_done				<=	'0';
		LL_push					<=	'0';
		LL_read					<=	'0';
		LL_write				<=	'0';
		LL_data_wen				<=	'0';
		init					<=	'0';
		BA_wen					<=	'0';
		Block_Address			<=	"000";
		second_DataBlock		<=	'0';
		main_wen				<=	'0';
		Hand_wen				<=	'0';
		Pass_Hand				<=	'0';
		LMNs_Colm_inc			<=	'0';
		LMNs_Chan_inc			<=	'0';
		MPUs_Colm_inc			<=	'0';
		MPUs_Chan_inc			<=	'0';
		CASE P_S IS
			WHEN	sleep		=>	CNT_done			<=	'1';
			WHEN	Initiate	=>	init				<=	'1';
									Block_Address		<=	"000";
	------------------------------------------------------------------------------------------------------
			WHEN	R1C1_Requ	=>	Block_Address		<=	"000";
									LL_push				<=	'1';
									LL_read				<=	'1';
									BA_wen				<=	LL_ack;
			WHEN	R1C1_Clct	=>	Hand_wen			<=	LL_data_rdy;
									LMNs_Colm_inc		<=	LL_data_rdy;
									LMNs_Chan_inc		<=	LMNs_Colm_eq	AND	LL_data_rdy;
			WHEN	R1C1_Pool	=>	Block_Address		<=	"001";
									MPUs_Colm_inc		<=	'1';
									MPUs_Chan_inc		<=	MPUs_Colm_eq;
									Pass_Hand			<=	'1';
	------------------------------------------------------------------------------------------------------
			WHEN	R1C2_Requ	=>	Block_Address		<=	"001";
									LL_push				<=	'1';
									LL_read				<=	'1';
									BA_wen				<=	LL_ack;
			WHEN	R1C2_Clct	=>	Hand_wen			<=	LL_data_rdy;
									LMNs_Colm_inc		<=	LL_data_rdy;
									LMNs_Chan_inc		<=	LMNs_Colm_eq	AND	LL_data_rdy;
			WHEN	R1C2_Pool	=>	Block_Address		<=	"010";
									MPUs_Colm_inc		<=	'1';
									MPUs_Chan_inc		<=	MPUs_Colm_eq;
									second_DataBlock	<=	'1';
	------------------------------------------------------------------------------------------------------
			WHEN	R2C1_Requ	=>	Block_Address		<=	"010";
									LL_push				<=	'1';
									LL_read				<=	'1';
									BA_wen				<=	LL_ack;
			WHEN	R2C1_Clct	=>	Hand_wen			<=	LL_data_rdy;
									LMNs_Colm_inc		<=	LL_data_rdy;
									LMNs_Chan_inc		<=	LMNs_Colm_eq	AND	LL_data_rdy;
			WHEN	R2C1_Pool	=>	Block_Address		<=	"011";
									MPUs_Colm_inc		<=	'1';
									MPUs_Chan_inc		<=	MPUs_Colm_eq;
	------------------------------------------------------------------------------------------------------
			WHEN	R2C2_Requ	=>	Block_Address		<=	"011";
									LL_push				<=	'1';
									LL_read				<=	'1';
									BA_wen				<=	LL_ack;
			WHEN	R2C2_Clct	=>	Hand_wen			<=	LL_data_rdy;
									LMNs_Colm_inc		<=	LL_data_rdy;
									LMNs_Chan_inc		<=	LMNs_Colm_eq	AND	LL_data_rdy;
			WHEN	R2C2_Pool	=>	Block_Address		<=	"111";
									MPUs_Colm_inc		<=	'1';
									MPUs_Chan_inc		<=	MPUs_Colm_eq;
									second_DataBlock	<=	'1';
	------------------------------------------------------------------------------------------------------
			WHEN	WBak_Requ	=>	Block_Address		<=	"111";
									LL_push				<=	'1';
									LL_write			<=	'1';
									BA_wen				<=	LL_ack;
			WHEN	Write_Back	=>	LMNs_Colm_inc		<=	(NOT	LL_wait);
									LMNs_Chan_inc		<=	LMNs_Colm_eq	AND	(NOT	LL_wait);
									LL_data_wen			<=	'1';
			END CASE;
	END PROCESS;
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	--	Connections 
	------------------------------------------------------------------------
	All_Clctd					<=	LMNs_Chan_eq	AND		LMNs_Colm_eq	AND		LL_data_rdy;
	All_Pooled					<=	MPUs_Chan_eq	AND		MPUs_Colm_eq;
	All_Written					<=	LMNs_Chan_eq	AND		LMNs_Colm_eq	AND		(NOT	LL_wait);
	load_mxes					<=	CNT_load;
	------------------------------------------------------------------------
	------------------------------------------------------------------------
end Behavioral;

