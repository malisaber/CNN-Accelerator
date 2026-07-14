library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.my_pack_v2.ALL;

entity UA_controller is
	PORT(
		clk_w			:	IN	std_logic;
		rst_w			:	IN	std_logic;
		
		
		
		MB_low_lvl_wen	:	OUT	std_logic_vector(3	DOWNTO 0);
		WB_low_lvl_wen	:	OUT	std_logic_vector(8	DOWNTO 0);
		MB_set_flag		:	OUT	std_logic_vector(3	DOWNTO 0);
		MB_status		:	IN	std_logic_vector(3	DOWNTO 0);
		
		
		
		--	config
		Update_IFM		:	IN	std_logic;
		Update_WFM		:	IN	std_logic;
		status			:	OUT	std_logic_vector(1	DOWNTO 0);
		done			:	OUT	std_logic;
		
		
		--	CONTROL
		------	PAUSE
		CNT_UPA_PAUSE	:	IN	std_logic;
		
		
		--	Low Level
		--LL_ready		:	IN	std_logic;
		--LL_wait			:	IN	std_logic;
		LL_push			:	OUT	std_logic;
		LL_ack			:	IN	std_logic;
		LL_read			:	OUT	std_logic;
		LL_write		:	OUT	std_logic;
		LL_data_rdy		:	IN	std_logic;
		LL_data_wen		:	OUT	std_logic;
		
		
		--	Datapath
		------	Input
		Kern_eq			:	IN	std_logic;
		Colm_eq			:	IN	std_logic;
		Chan_eq			:	IN	std_logic;
		Phys_eq			:	IN	std_logic;
		Phys_val		:	IN	std_logic_vector(3						DOWNTO 0);
		------	outputs
		init			:	OUT	std_logic;
		Kern_inc		:	OUT	std_logic;
		Colm_inc		:	OUT	std_logic;
		Chan_inc		:	OUT	std_logic;
		Phys_inc		:	OUT	std_logic;
		Base_Step_en	:	OUT	std_logic;
		BCI_add			:	OUT	std_logic_vector(3						DOWNTO 0));
end UA_controller;

architecture Behavioral of UA_controller is
	------------------------------------------------------------------------
	TYPE	states		IS (sleep,		UM_init,	UM_Wgt,		UM_Chk,		UM_req,		UM_clct,	
										UW_init,							UW_req,		UW_clct,	UW_Phy);	
	------------------------------------------------------------------------
	SIGNAL	P_S			:	states;
	SIGNAL	N_S			:	states;
	------------------------------------------------------------------------
	ATTRIBUTE fsm_encoding : STRING;
	ATTRIBUTE fsm_encoding OF P_S : SIGNAL IS "one-hot";
	--	"auto, compact, gray, johnson, one-hot, sequential, speed1, user" 
	------------------------------------------------------------------------
	SIGNAL	p_reset		:	std_logic; 
	SIGNAL	p_edge		:	std_logic	:=	'1';
	------------------------------------------------------------------------
	SIGNAL	UM_A_clct	:	std_logic;
	SIGNAL	UW_A_clct	:	std_logic;
	SIGNAL	UM_B_Full	:	std_logic;
	------------------------------------------------------------------------
	SIGNAL	MB_wen		:	std_logic;
	SIGNAL	WB_wen		:	std_logic;
	SIGNAL	MB_set		:	std_logic;
	------------------------------------------------------------------------
	SIGNAL	MB_st		:	std_logic;
	------------------------------------------------------------------------
begin
	------------------------------------------------------------------------
	PROCESS (clk_w, rst_w)
	BEGIN
		IF rst_w = '1' THEN
			P_S	<=	sleep;
		ELSIF clk_w = '1' AND clk_w'EVENT THEN
			P_S	<=	N_S;
		END IF;
	END PROCESS;
	------------------------------------------------------------------------
	UM_A_clct			<=	LL_data_rdy		AND		Colm_eq			AND		Chan_eq;
	UW_A_clct			<=	LL_data_rdy		AND		Kern_eq			AND		Chan_eq;
	UM_B_Full			<=	MB_status(0)	AND		MB_status(1)	AND		MB_status(2)	AND		MB_status(3);
	------------------------------------------------------------------------
	PROCESS (	P_S,		Update_IFM,		Update_WFM,		UM_A_clct,		UW_A_clct,		
				p_edge,		MB_status,		LL_ack,			Phys_val,		LL_data_rdy,
				colm_eq,	kern_eq,		phys_eq,		chan_eq,		MB_st,			
				UM_B_Full,	CNT_UPA_PAUSE)
	BEGIN
		N_S				<=	P_S;
		MB_wen			<=	'0';
		WB_wen			<=	'0';
		MB_set			<=	'0';
		LL_push			<=	'0';
		init			<=	'0';
		Kern_inc		<=	'0';
		Colm_inc		<=	'0';
		Chan_inc		<=	'0';
		Phys_inc		<=	'0';
		Base_Step_en	<=	'0';
		BCI_add			<=	"0000";
		status			<=	"00";
		done			<=	'0';
		CASE P_S IS
			WHEN	sleep		=>	IF		CNT_UPA_PAUSE = '1'	THEN	N_S	<=	sleep;
									ELSIF	Update_IFM = '1'	THEN	N_S	<=	UM_init;
									ELSIF	Update_WFM = '1'	THEN	N_S	<=	UW_init;	END IF;
	------------------------------------------------------------------------
			WHEN	UM_init		=>										N_S	<=	UM_Wgt;
			WHEN	UM_Wgt		=>	IF		Update_IFM = '0'	THEN	N_S	<=	sleep;
									ELSIF	UM_B_Full = '0'		THEN	N_S	<=	UM_Chk;		END IF;
			WHEN	UM_Chk		=>	IF		MB_st = '1'			THEN	N_S	<=	UM_Wgt;
									ELSE								N_S	<=	UM_req;		END IF;
			WHEN	UM_req		=>	IF		LL_ack = '1'		THEN	N_S	<=	UM_clct;	END IF;
			WHEN	UM_clct		=>	IF		UM_A_clct = '1'		THEN	N_S	<=	UM_Wgt;		END IF;
	------------------------------------------------------------------------
			WHEN	UW_init		=>										N_S	<=	UW_req;
			WHEN	UW_req		=>	IF		LL_ack = '1'		THEN	N_S	<=	UW_clct;	END IF;
			WHEN	UW_clct		=>	IF		UW_A_clct = '1'		THEN	N_S	<=	UW_Phy;		END IF;
			WHEN	UW_Phy		=>	IF		phys_eq = '1'		THEN	N_S	<=	sleep;
									ELSE								N_S	<=	UW_req;		END IF;
	------------------------------------------------------------------------
			END CASE;
		
		
		CASE P_S IS
			WHEN	sleep		=>	done			<=	'1';
	------------------------------------------------------------------------
			WHEN	UM_init		=>	init			<=	'1';
									BCI_add			<=	"1111";
									status			<=	"10";
			WHEN	UM_Wgt		=>	NULL;
			WHEN	UM_Chk		=>	BCI_add			<=	"1111";
									status			<=	"10";
			WHEN	UM_req		=>	LL_push			<=	'1';
									BCI_add			<=	"1111";
									status			<=	"10";
			WHEN	UM_clct		=>	Colm_inc		<=	LL_data_rdy;
									Chan_inc		<=	LL_data_rdy	AND	Colm_eq;
									BCI_add			<=	"1111";
									MB_wen			<=	LL_data_rdy;
									Base_Step_en	<=	LL_data_rdy	AND	Colm_eq	AND	Chan_eq;
									MB_set			<=	LL_data_rdy	AND	Colm_eq	AND	Chan_eq;
									status			<=	"10";
	------------------------------------------------------------------------
			WHEN	UW_init		=>	init			<=	'1';
									BCI_add			<=	Phys_val;
									status			<=	"11";
			WHEN	UW_req		=>	LL_push			<=	'1';
									BCI_add			<=	Phys_val;
									status			<=	"11";
			WHEN	UW_clct		=>	Kern_inc		<=	LL_data_rdy;
									Chan_inc		<=	LL_data_rdy	AND	Kern_eq;
									BCI_add			<=	Phys_val;
									WB_wen			<=	LL_data_rdy;
									Base_Step_en	<=	LL_data_rdy	AND	Kern_eq	AND	Chan_eq;
									status			<=	"11";
			WHEN	UW_Phy		=>	BCI_add			<=	Phys_val;
									status			<=	"11";
									Phys_inc		<=	'1';
	------------------------------------------------------------------------
			END CASE;
	END PROCESS;
	------------------------------------------------------------------------
	PROCESS(clk_w, rst_w)
	BEGIN
		IF rst_w = '1' THEN
			MB_low_lvl_wen	<=	(OTHERS	=>	'0');
		ELSIF clk_w = '1' AND clk_w'EVENT THEN
			IF MB_wen	=	'1'	THEN
				CASE Phys_val IS 
					WHEN	"0000"	=>	MB_low_lvl_wen	<=	"0001";
					WHEN	"0001"	=>	MB_low_lvl_wen	<=	"0010";
					WHEN	"0010"	=>	MB_low_lvl_wen	<=	"0100";
					WHEN	"0011"	=>	MB_low_lvl_wen	<=	"1000";
					WHEN	OTHERS	=>	MB_low_lvl_wen	<=	(OTHERS	=>	'0');
				END CASE;
			ELSE
				MB_low_lvl_wen	<=	(OTHERS	=>	'0');
			END IF;
		END IF;
	END PROCESS;
	------------------------------------------------------------------------
	PROCESS(clk_w, rst_w)
	BEGIN
		IF rst_w = '1' THEN
			WB_low_lvl_wen	<=	(OTHERS	=>	'0');
		ELSIF clk_w = '1' AND clk_w'EVENT THEN
			IF WB_wen	=	'1'	THEN
				CASE Phys_val IS 
					WHEN	"0000"	=>	WB_low_lvl_wen	<=	"000000001";
					WHEN	"0001"	=>	WB_low_lvl_wen	<=	"000000010";
					WHEN	"0010"	=>	WB_low_lvl_wen	<=	"000000100";
					WHEN	"0011"	=>	WB_low_lvl_wen	<=	"000001000";
					WHEN	"0100"	=>	WB_low_lvl_wen	<=	"000010000";
					WHEN	"0101"	=>	WB_low_lvl_wen	<=	"000100000";
					WHEN	"0110"	=>	WB_low_lvl_wen	<=	"001000000";
					WHEN	"0111"	=>	WB_low_lvl_wen	<=	"010000000";
					WHEN	"1000"	=>	WB_low_lvl_wen	<=	"100000000";
					WHEN	OTHERS	=>	WB_low_lvl_wen	<=	(OTHERS	=>	'0');
				END CASE;
			ELSE
				WB_low_lvl_wen	<=	(OTHERS	=>	'0');
			END IF;
		END IF;
	END PROCESS;
	------------------------------------------------------------------------
	PROCESS(clk_w, rst_w)
	BEGIN
		IF rst_w = '1' THEN
			MB_set_flag		<=	(OTHERS	=>	'0');
		ELSIF clk_w = '1' AND clk_w'EVENT THEN
			IF MB_set	=	'1'	THEN
				CASE Phys_val IS 
					WHEN	"0000"	=>	MB_set_flag		<=	"0001";
					WHEN	"0001"	=>	MB_set_flag		<=	"0010";
					WHEN	"0010"	=>	MB_set_flag		<=	"0100";
					WHEN	"0011"	=>	MB_set_flag		<=	"1000";
					WHEN	OTHERS	=>	MB_set_flag		<=	(OTHERS	=>	'0');
				END CASE;
			ELSE
				MB_set_flag		<=	(OTHERS	=>	'0');
			END IF;
		END IF;
	END PROCESS;
	------------------------------------------------------------------------
	PROCESS(MB_status, Phys_val)
	BEGIN
		CASE Phys_val IS 
			WHEN	"0000"			=>	MB_st			<=	MB_status(0);
			WHEN	"0001"			=>	MB_st			<=	MB_status(1);
			WHEN	"0010"			=>	MB_st			<=	MB_status(2);
			WHEN	"0011"			=>	MB_st			<=	MB_status(3);
			WHEN	OTHERS			=>	MB_st			<=	'0';
		END CASE;
	END PROCESS;
	------------------------------------------------------------------------
	LL_read		<=	'1';
	LL_write	<=	'0';
	LL_data_wen	<=	'0';
	------------------------------------------------------------------------
end Behavioral;	



		
