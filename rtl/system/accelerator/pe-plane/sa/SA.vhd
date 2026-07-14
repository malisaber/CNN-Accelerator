library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.math_real.ALL;
USE work.my_pack_v2.ALL;

entity SA is
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
		--	LMN
		--LMN_ready		:	IN	std_logic;
		LMN_wait		:	IN	std_logic;
		LMN_push		:	OUT	std_logic;
		LMN_ack			:	IN	std_logic;
		LMN_read		:	OUT	std_logic;
		LMN_write		:	OUT	std_logic;
		LMN_add			:	OUT	std_logic_vector(P_USA_Add_size-1		DOWNTO 0);
		LMN_cnt			:	OUT	std_logic_vector(P_USA_Cnt_size-1		DOWNTO 0);
		LMN_data_in		:	IN	std_logic_vector(P_word_size-1			DOWNTO 0);
		LMN_data_rdy	:	IN	std_logic;
		LMN_data_out	:	OUT	std_logic_vector(P_word_size-1			DOWNTO 0);
		LMN_data_wen	:	OUT	std_logic;
		--	Config
		CNF_MAX_Kern	:	IN	std_logic_vector(P_kernel_size-1		DOWNTO 0);
		CNF_MAX_Colm	:	IN	std_logic_vector(P_column_size-1		DOWNTO 0);
		CNF_MAX_mode	:	IN	std_logic;
		--	TOP Level
		TOP_Bias_val	:	IN	std_logic_vector(P_word_size-1			DOWNTO 0);
		TOP_Bias_Add	:	IN	std_logic_vector(P_kernel_size-1		DOWNTO 0);
		TOP_Addresses	:	IN	std_logic_vector(P_USA_Add_size-1		DOWNTO 0);
		TOP_Target_add	:	IN	std_logic_vector(0						DOWNTO 0);
		TOP_Base_Wen	:	IN	std_logic;
		TOP_Count_Wen	:	IN	std_logic;
		TOP_IntVal_Wen	:	IN	std_logic; 
		TOP_Bias_Wen	:	IN	std_logic;
		--	Output Buffer
		------	Data, Address
		OBM_DATA		:	IN	std_logic_vector(P_word_size-1			DOWNTO 0);
		OBM_ADD			:	OUT	std_logic_vector(P_OFM_Add_size-1		DOWNTO 0));
end SA;

architecture Behavioral of SA is
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	COMPONENT	SA_DP
	PORT(
		clk_w			:	IN	std_logic;
		rst_w			:	IN	std_logic;
		--	Config
		CNF_MAX_Kern	:	IN	std_logic_vector(P_kernel_size-1		DOWNTO 0);
		CNF_MAX_Colm	:	IN	std_logic_vector(P_column_size-1		DOWNTO 0);
		CNF_MAX_mode	:	IN	std_logic;
		--	TOP Level
		TOP_Bias_val	:	IN	std_logic_vector(P_word_size-1			DOWNTO 0);
		TOP_Bias_Add	:	IN	std_logic_vector(P_kernel_size-1		DOWNTO 0);
		TOP_Addresses	:	IN	std_logic_vector(P_USA_Add_size-1		DOWNTO 0);
		TOP_Target_add	:	IN	std_logic_vector(0						DOWNTO 0);
		TOP_Base_Wen	:	IN	std_logic;
		TOP_Count_Wen	:	IN	std_logic;
		TOP_IntVal_Wen	:	IN	std_logic;
		TOP_Bias_Wen	:	IN	std_logic;
		--	TO LMN
		LMN_add			:	OUT	std_logic_vector(P_USA_Add_size-1		DOWNTO 0);
		LMN_cnt			:	OUT	std_logic_vector(P_USA_Cnt_size-1		DOWNTO 0);
		LMN_data_in		:	IN	std_logic_vector(P_word_size-1			DOWNTO 0);
		LMN_data_rdy	:	IN	std_logic;
		LMN_data_out	:	OUT	std_logic_vector(P_word_size-1			DOWNTO 0);
		--	Output Buffer
		------	Data, Address
		OBM_DATA		:	IN	std_logic_vector(P_word_size-1			DOWNTO 0);
		OBM_ADD			:	OUT	std_logic_vector(P_OFM_Add_size-1		DOWNTO 0);
		--	Controller 
		------	input
		CNU_init		:	IN	std_logic;
		CNU_Kern_inc	:	IN	std_logic;
		CNU_Colm_inc	:	IN	std_logic;
		CNU_MEM_en		:	IN	std_logic;
		CNU_OFM_en		:	IN	std_logic;
		CNU_BIS_en		:	IN	std_logic;
		CNU_Stat_Wen	:	IN	std_logic;
		CNU_ACT_en		:	IN	std_logic;
		CNU_LSbar		:	IN	std_logic;
		CNU_Load_UA_en	:	IN	std_logic;
		CNU_Stor_UA_en	:	IN	std_logic;
		------	Output
		CNU_Kern_eq		:	OUT	std_logic;
		CNU_Colm_eq		:	OUT	std_logic);
	END COMPONENT;
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	COMPONENT	SA_CU
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
	ENd COMPONENT;
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	SIGNAL	CNU_init		:	std_logic;
	SIGNAL	CNU_Kern_inc	:	std_logic;
	SIGNAL	CNU_Colm_inc	:	std_logic;
	SIGNAL	CNU_MEM_en		:	std_logic;
	SIGNAL	CNU_OFM_en		:	std_logic;
	SIGNAL	CNU_BIS_en		:	std_logic;
	SIGNAL	CNU_Stat_Wen	:	std_logic;
	SIGNAL	CNU_ACT_en		:	std_logic;
	SIGNAL	CNU_LSbar		:	std_logic;
	SIGNAL	CNU_Load_UA_en	:	std_logic;
	SIGNAL	CNU_Stor_UA_en	:	std_logic;
	SIGNAL	CNU_Kern_eq		:	std_logic;
	SIGNAL	CNU_Colm_eq		:	std_logic;
	------------------------------------------------------------------------
	------------------------------------------------------------------------
begin
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	DP					:	SA_DP
	PORT	MAP(
		clk_w			=>	clk_w,
		rst_w			=>	rst_w,
		CNF_MAX_Kern	=>	CNF_MAX_Kern,
		CNF_MAX_Colm	=>	CNF_MAX_Colm,
		CNF_MAX_mode	=>	CNF_MAX_mode,
		TOP_Bias_val	=>	TOP_Bias_val,
		TOP_Bias_Add	=>	TOP_Bias_Add,
		TOP_Addresses	=>	TOP_Addresses,
		TOP_Target_add	=>	TOP_Target_add,
		TOP_Base_Wen	=>	TOP_Base_Wen,
		TOP_Count_Wen	=>	TOP_Count_Wen,
		TOP_IntVal_Wen	=>	TOP_IntVal_Wen,
		TOP_Bias_Wen	=>	TOP_Bias_Wen,
		LMN_add			=>	LMN_add,
		LMN_cnt			=>	LMN_cnt,
		LMN_data_in		=>	LMN_data_in,
		LMN_data_rdy	=>	LMN_data_rdy,
		LMN_data_out	=>	LMN_data_out,
		OBM_DATA		=>	OBM_DATA,
		OBM_ADD			=>	OBM_ADD,
		CNU_init		=>	CNU_init,
		CNU_Kern_inc	=>	CNU_Kern_inc,
		CNU_Colm_inc	=>	CNU_Colm_inc,
		CNU_MEM_en		=>	CNU_MEM_en,
		CNU_OFM_en		=>	CNU_OFM_en,
		CNU_BIS_en		=>	CNU_BIS_en,
		CNU_Stat_Wen	=>	CNU_Stat_Wen,
		CNU_ACT_en		=>	CNU_ACT_en,
		CNU_LSbar		=>	CNU_LSbar,
		CNU_Load_UA_en	=>	CNU_Load_UA_en,
		CNU_Stor_UA_en	=>	CNU_Stor_UA_en,
		CNU_Kern_eq		=>	CNU_Kern_eq,
		CNU_Colm_eq		=>	CNU_Colm_eq);
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	CU					:	SA_CU
	PORT	MAP(
		clk_w			=>	clk_w,
		rst_w			=>	rst_w,
		CMD_start		=>	CMD_start,
		CMD_ACK			=>	CMD_ACK,
		CMD_load		=>	CMD_load,
		CMD_MEM_en		=>	CMD_MEM_en,
		CMD_OBM_en		=>	CMD_OBM_en,
		CMD_BIS_en		=>	CMD_BIS_en,
		CMD_save		=>	CMD_save,
		CMD_active		=>	CMD_active,
		CMD_store		=>	CMD_store,
		CMD_load_UA		=>	CMD_load_UA,
		CMD_stor_UA		=>	CMD_stor_UA,
		CMD_done		=>	CMD_done,
		CNT_STA_PAUSE	=>	CNT_STA_PAUSE,
		--LMN_ready		=>	LMN_ready,
		LMN_wait		=>	LMN_wait,
		LMN_push		=>	LMN_push,
		LMN_ack			=>	LMN_ack,
		LMN_read		=>	LMN_read,
		LMN_write		=>	LMN_write,
		LMN_data_rdy	=>	LMN_data_rdy,
		LMN_data_wen	=>	LMN_data_wen,
		CNU_init		=>	CNU_init,
		CNU_Kern_inc	=>	CNU_Kern_inc,
		CNU_Colm_inc	=>	CNU_Colm_inc,
		CNU_MEM_en		=>	CNU_MEM_en,
		CNU_OFM_en		=>	CNU_OFM_en,
		CNU_BIS_en		=>	CNU_BIS_en,
		CNU_Stat_Wen	=>	CNU_Stat_Wen,
		CNU_ACT_en		=>	CNU_ACT_en,
		CNU_LSbar		=>	CNU_LSbar,
		CNU_Load_UA_en	=>	CNU_Load_UA_en,
		CNU_Stor_UA_en	=>	CNU_Stor_UA_en,
		CNU_Kern_eq		=>	CNU_Kern_eq,
		CNU_Colm_eq		=>	CNU_Colm_eq);
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	------------------------------------------------------------------------
end Behavioral;

