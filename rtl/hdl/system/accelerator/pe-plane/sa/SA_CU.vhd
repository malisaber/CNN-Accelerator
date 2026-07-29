library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SA_CU is
	PORT(
		clk_w			:	IN	std_logic;
		rst_w			:	IN	std_logic;
		
		
		-- COMMANDS
		CMD_start		:	IN	std_logic;
		CMD_ACK			:	IN	std_logic;
		CMD_load		:	IN	std_logic;
		CMD_MEM_en		:	IN	std_logic;
		CMD_OBM_en		:	IN	std_logic;
		CMD_BIS_en		:	IN	std_logic;
		CMD_save		:	IN	std_logic;
		CMD_active		:	IN	std_logic;
		CMD_store		:	IN	std_logic;
		CMD_load_UA		:	IN	std_logic;
		CMD_stor_UA		:	IN	std_logic;
		CMD_done		:	OUT	std_logic;
		
		
		--	CONTROL
		------	PAUSE
		CNT_STA_PAUSE	:	IN	std_logic;
		
		
		--	TO LMN
		--LMN_ready		:	IN	std_logic;
		LMN_wait		:	IN	std_logic;
		LMN_push		:	OUT	std_logic;
		LMN_ack			:	IN	std_logic;
		LMN_read		:	OUT	std_logic;
		LMN_write		:	OUT	std_logic;
		LMN_data_rdy	:	IN	std_logic;
		LMN_data_wen	:	OUT	std_logic;
		
		
		--	Controller 
		------	Output
		CNU_init		:	OUT	std_logic;
		CNU_Kern_inc	:	OUT	std_logic;
		CNU_Colm_inc	:	OUT	std_logic;
		CNU_MEM_en		:	OUT	std_logic;
		CNU_OFM_en		:	OUT	std_logic;
		CNU_BIS_en		:	OUT	std_logic;
		CNU_Stat_Wen	:	OUT	std_logic;
		CNU_ACT_en		:	OUT	std_logic;
		CNU_LSbar		:	OUT	std_logic;
		CNU_Load_UA_en	:	OUT	std_logic;
		CNU_Stor_UA_en	:	OUT	std_logic;
		------	input
		CNU_Kern_eq		:	IN	std_logic;
		CNU_Colm_eq		:	IN	std_logic);
end SA_CU;

architecture Behavioral of SA_CU is
	
	TYPE	states		IS (sleep,		L_check,	L_req,		L_clct,		S_check,	
							S_req,		S_wait,		ACC,		wgt_ack,	comp);
	
	SIGNAL	P_S			:	states;
	SIGNAL	N_S			:	states;
	
	SIGNAL	All_Clcted	:	std_logic;
	SIGNAL	All_Acced	:	std_logic;
	
	SIGNAL	SIG_wen		:	std_logic;
	SIGNAL	SIG_wen_R	:	std_logic;
	SIGNAL	SIG_wen_RR	:	std_logic;
	
	SIGNAL	SIG_MEM_en	:	std_logic;
	SIGNAL	SIG_OFM_en	:	std_logic;
	SIGNAL	SIG_BIS_en	:	std_logic;
	SIGNAL	SIG_Stat_Wen:	std_logic;
	SIGNAL	SIG_ACT_en	:	std_logic;
	
	SIGNAL	CON_start	:	std_logic;
BEGIN
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	PROCESS (clk_w, rst_w)
	BEGIN
		IF rst_w = '1' THEN
			P_S			<=	sleep;
		ELSIF clk_w = '1' AND clk_w'EVENT THEN
			P_S			<=	N_S;
		END IF;
	END PROCESS;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	PROCESS (	P_S,			CON_start,		CMD_ACK,		CMD_load,
				CMD_MEM_en,		CMD_OBM_en,		CMD_BIS_en,		CMD_save,		
				CMD_active,		CMD_store,		CMD_load_UA,	CMD_stor_UA,	
				LMN_ack,		LMN_wait,		LMN_data_rdy,	CNU_Kern_eq,
				CNU_Colm_eq,	All_Clcted,		All_Acced)
	BEGIN	
		CMD_done		<=	'0';
		LMN_push		<=	'0';
		LMN_read		<=	'0';
		LMN_write		<=	'0';
		SIG_wen			<=	'0';
		CNU_init		<=	'0';
		CNU_Kern_inc	<=	'0';
		CNU_Colm_inc	<=	'0';
		SIG_MEM_en		<=	'0';
		SIG_OFM_en		<=	'0';
		SIG_BIS_en		<=	'0';
		SIG_Stat_Wen	<=	'0';
		SIG_ACT_en		<=	'0';
		CNU_LSbar		<=	'0';
		CNU_Load_UA_en	<=	'0';
		CNU_Stor_UA_en	<=	'0';
		
		
		CASE P_S IS 
			WHEN	sleep		=>	IF	CON_start = '1'		THEN	N_S	<=	L_check;	ELSE	N_S	<=	sleep;		END IF;
			WHEN	L_check		=>	IF	CMD_load = '1'		THEN	N_S	<=	L_req;		ELSE	N_S	<=	S_check;	END IF;
			WHEN	L_req		=>	IF	LMN_ack = '1'		THEN	N_S	<=	L_clct;		ELSE	N_S	<=	L_req;		END IF;
			WHEN	L_clct		=>	IF	All_Clcted = '1'	THEN	N_S	<=	S_check;	ELSE	N_S	<=	L_clct;		END IF;
			WHEN	S_check		=>	IF	CMD_store = '1'		THEN	N_S	<=	S_req;		ELSE	N_S	<=	ACC;		END IF;
			WHEN	S_req		=>	IF	LMN_ack = '1'		THEN	N_S	<=	S_wait;		ELSE	N_S	<=	S_req;		END IF;
			WHEN	S_wait		=>	IF	LMN_wait = '0'		THEN	N_S	<=	ACC;		ELSE	N_S	<=	S_wait;		EnD IF;
			WHEN	ACC			=>	IF	All_Acced = '1'		THEN	N_S	<=	wgt_ack;	ELSE	N_S	<=	ACC;		END IF;
			WHEN	wgt_ack		=>	IF	CMD_ACK = '1'		THEN	N_S	<=	comp;		ELSE	N_S	<=	wgt_ack;	END IF;
			WHEN	comp		=>									N_S	<=	sleep;
			END CASE;
		
		CASE P_S IS 
			WHEN	sleep		=>	CMD_done		<=	'1';
			WHEN	L_check		=>	CNU_init		<=	'1';
									CNU_LSbar		<=	'1';
			WHEN	L_req		=>	LMN_read		<=	'1';
									LMN_push		<=	'1';
									CNU_LSbar		<=	'1';
			WHEN	L_clct		=>	SIG_Stat_Wen	<=	LMN_data_rdy;
									CNU_Colm_inc	<=	LMN_data_rdy;
									CNU_Kern_inc	<=	LMN_data_rdy	AND	CNU_Colm_eq;
									CNU_Load_UA_en	<=	LMN_data_rdy	AND	CNU_Colm_eq		AND	CNU_Kern_eq	AND	CMD_load_UA;
									CNU_LSbar		<=	'1';
			WHEN	S_check		=>	CNU_init		<=	'1';
			WHEN	S_req		=>	LMN_write		<=	'1';
									LMN_push		<=	'1';
			WHEN	S_wait		=>	NULL;
			WHEN	ACC			=>	SIG_ACT_en		<=	CMD_active;
									SIG_MEM_en		<=	CMD_MEM_en;
									SIG_OFM_en		<=	CMD_OBM_en;
									SIG_BIS_en		<=	CMD_BIS_en;
									SIG_Stat_Wen	<=	CMD_save;
									SIG_wen			<=	CMD_store;
									CNU_Colm_inc	<=	'1';
									CNU_Kern_inc	<=	CNU_Colm_eq;
									CNU_Stor_UA_en	<=	CNU_Colm_eq		AND	CNU_Kern_eq	AND	CMD_stor_UA;
			WHEN	wgt_ack		=>	CMD_done		<=	'1';
			WHEN	comp		=>	CMD_done		<=	'1';
			END CASE;
	END PROCESS;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	All_Clcted			<=	LMN_data_rdy	AND			CNU_Colm_eq		AND	CNU_Kern_eq;
	All_Acced			<=								CNU_Colm_eq		AND	CNU_Kern_eq;
	CON_start			<=	CMD_start		AND	(NOT	CNT_STA_PAUSE);
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	PROCESS(clk_w, rst_w)
	BEGIN
		IF rst_w = '1' THEN
			SIG_wen_R	<=	'0';
			SIG_wen_RR	<=	'0';
		ELSIF clk_w = '1' AND clk_w'EVENT THEN
			SIG_wen_R	<=	SIG_wen;
			SIG_wen_RR	<=	SIG_wen_R;
		END IF;
	END PROCESS;
	LMN_data_wen		<=	SIG_wen_RR;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	PROCESS(clk_w, rst_w)
	BEGIN
		IF rst_w = '1' THEN
			CNU_MEM_en	<=	'0';
			CNU_OFM_en	<=	'0';
			CNU_BIS_en	<=	'0';
			CNU_Stat_Wen<=	'0';
			CNU_ACT_en	<=	'0';
		ELSIF clk_w = '1' AND clk_w'EVENT THEN
			CNU_MEM_en	<=	SIG_MEM_en;
			CNU_OFM_en	<=	SIG_OFM_en;
			CNU_BIS_en	<=	SIG_BIS_en;
			CNU_Stat_Wen<=	SIG_Stat_Wen;
			CNU_ACT_en	<=	SIG_ACT_en;
		END IF;
	END PROCESS;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
END Behavioral;

	