library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.my_pack_v2.ALL;

entity MPDR is
	PORT(
		clk_w					:	IN	std_logic;
		rst_w					:	IN	std_logic;
		
		
		
		--		Control	(Scheduler)
		CNT_start				:	IN	std_logic;
		CNT_done				:	OUT	std_logic;
		CNT_load				:	IN	std_logic;
		CNT_Addresses			:	IN	std_logic_vector(P_USA_Add_size-1		DOWNTO 0);
		CNT_Target				:	IN	std_logic_vector(2						DOWNTO 0);
		CNT_Base_Wen			:	IN	std_logic;
		CNT_Cont_Wen			:	IN	std_logic;
		CNT_IVal_Wen			:	IN	std_logic;
		--		Config
		CNT_MAX_Col				:	IN	std_logic_vector(P_column_size-1		DOWNTO 0);
		CNT_MAX_Chn				:	IN	std_logic_vector(P_channel_size-1		DOWNTO 0);
		
		
		
		--	TO LMN
		LL_ready				:	IN	std_logic;
		LL_wait					:	IN	std_logic;
		LL_push					:	OUT	std_logic;
		LL_ack					:	IN	std_logic;
		LL_read					:	OUT	std_logic;
		LL_write				:	OUT	std_logic;
		LL_add					:	OUT	std_logic_vector(P_USA_Add_size-1		DOWNTO 0);
		LL_cnt					:	OUT	std_logic_vector(P_USA_Cnt_size-1		DOWNTO 0);
		LL_data_in				:	IN	std_logic_vector(P_word_size-1			DOWNTO 0);
		LL_data_rdy				:	IN	std_logic;
		LL_data_out				:	OUT	std_logic_vector(P_word_size-1			DOWNTO 0);
		LL_data_wen				:	OUT	std_logic);
end MPDR;

architecture Behavioral of MPDR is
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	--	Components 
	------------------------------------------------------------------------
	COMPONENT	MPDR_Datapath
	PORT(
		clk_w					:	IN	std_logic;
		rst_w					:	IN	std_logic;
		--		Config		
		CNF_MAX_Col				:	IN	std_logic_vector(P_column_size-1	DOWNTO 0);
		CNF_MAX_Chn				:	IN	std_logic_vector(P_channel_size-1	DOWNTO 0);
		--		Control	(Scheduler)
		Addresses				:	IN	std_logic_vector(P_USA_Add_size-1	DOWNTO 0);
		Target					:	IN	std_logic_vector(2					DOWNTO 0);
		Base_Wen				:	IN	std_logic;
		Cont_Wen				:	IN	std_logic;
		IVal_Wen				:	IN	std_logic;
		--	TO LMN		
		LL_add					:	OUT	std_logic_vector(P_USA_Add_size-1	DOWNTO 0);
		LL_cnt					:	OUT	std_logic_vector(P_USA_Cnt_size-1	DOWNTO 0);
		LL_data_in				:	IN	std_logic_vector(P_word_size-1		DOWNTO 0);
		LL_data_out				:	OUT	std_logic_vector(P_word_size-1		DOWNTO 0);
		--	Controller
		init					:	IN	std_logic;
		BA_wen					:	IN	std_logic;
		Block_Address			:	IN	std_logic_vector(2					DOWNTO 0);
		second_DataBlock		:	IN	std_logic;
		main_wen				:	IN	std_logic;
		Hand_wen				:	IN	std_logic;
		Pass_Hand				:	IN	std_logic;
		load_mxes				:	IN	std_logic;
		LMNs_Colm_inc			:	IN	std_logic;
		LMNs_Chan_inc			:	IN	std_logic;
		MPUs_Colm_inc			:	IN	std_logic;
		MPUs_Chan_inc			:	IN	std_logic;
		LMNs_Colm_eq			:	OUT	std_logic;
		LMNs_Chan_eq			:	OUT	std_logic;
		MPUs_Colm_eq			:	OUT	std_logic;
		MPUs_Chan_eq			:	OUT	std_logic);
	END COMPONENT;
	------------------------------------------------------------------------
	COMPONENT	MPDR_Controller 
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
		Block_Address			:	OUT	std_logic_vector(2					DOWNTO 0);
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
	END COMPONENT;
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	--	SIGNALs 
	------------------------------------------------------------------------
	SIGNAL	init				:	std_logic;
	SIGNAL	BA_wen				:	std_logic;
	SIGNAL	Block_Address		:	std_logic_vector(2						DOWNTO 0);
	SIGNAL	second_DataBlock	:	std_logic;
	SIGNAL	main_wen			:	std_logic;
	SIGNAL	Hand_wen			:	std_logic;
	SIGNAL	Pass_Hand			:	std_logic;
	SIGNAL	load_mxes			:	std_logic;
	SIGNAL	LMNs_Colm_inc		:	std_logic;
	SIGNAL	LMNs_Chan_inc		:	std_logic;
	SIGNAL	MPUs_Colm_inc		:	std_logic;
	SIGNAL	MPUs_Chan_inc		:	std_logic;
	SIGNAL	LMNs_Colm_eq		:	std_logic;
	SIGNAL	LMNs_Chan_eq		:	std_logic;
	SIGNAL	MPUs_Colm_eq		:	std_logic;
	SIGNAL	MPUs_Chan_eq		:	std_logic;
	------------------------------------------------------------------------
	------------------------------------------------------------------------
begin
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	--	Instnces 
	------------------------------------------------------------------------
	MPDR_DP						:	MPDR_Datapath
	PORT	MAP(
		clk_w					=>	clk_w,
		rst_w					=>	rst_w,
		--		Config		
		CNF_MAX_Col				=>	CNT_MAX_Col,
		CNF_MAX_Chn				=>	CNT_MAX_Chn,
		--		Control	(Scheduler)
		Addresses				=>	CNT_Addresses,
		Target					=>	CNT_Target,
		Base_Wen				=>	CNT_Base_Wen,
		Cont_Wen				=>	CNT_Cont_Wen,
		IVal_Wen				=>	CNT_IVal_Wen,
		--	TO LMN		
		LL_add					=>	LL_add,
		LL_cnt					=>	LL_cnt,
		LL_data_in				=>	LL_data_in,
		LL_data_out				=>	LL_data_out,
		--	Controller
		init					=>	init,
		BA_wen					=>	BA_wen,
		Block_Address			=>	Block_Address,
		second_DataBlock		=>	second_DataBlock,
		main_wen				=>	main_wen,
		Hand_wen				=>	Hand_wen,
		Pass_Hand				=>	Pass_Hand,
		load_mxes				=>	load_mxes,
		LMNs_Colm_inc			=>	LMNs_Colm_inc,
		LMNs_Chan_inc			=>	LMNs_Chan_inc,
		MPUs_Colm_inc			=>	MPUs_Colm_inc,
		MPUs_Chan_inc			=>	MPUs_Chan_inc,
		LMNs_Colm_eq			=>	LMNs_Colm_eq,
		LMNs_Chan_eq			=>	LMNs_Chan_eq,
		MPUs_Colm_eq			=>	MPUs_Colm_eq,
		MPUs_Chan_eq			=>	MPUs_Chan_eq);
	------------------------------------------------------------------------
	MPDR_CU						:	MPDR_Controller 
	PORT	MAP(
		clk_w					=>	clk_w,
		rst_w					=>	rst_w,
		--		Control	(Scheduler)
		CNT_start				=>	CNT_start,
		CNT_done				=>	CNT_done,
		CNT_load				=>	CNT_load,
		--	TO LMN		
		LL_ready				=>	LL_ready,
		LL_wait					=>	LL_wait,
		LL_push					=>	LL_push,
		LL_ack					=>	LL_ack,
		LL_read					=>	LL_read,
		LL_write				=>	LL_write,
		LL_data_rdy				=>	LL_data_rdy,
		LL_data_wen				=>	LL_data_wen,
		--	Controller
		init					=>	init,
		BA_wen					=>	BA_wen,
		Block_Address			=>	Block_Address,
		second_DataBlock		=>	second_DataBlock,
		main_wen				=>	main_wen,
		Hand_wen				=>	Hand_wen,
		Pass_Hand				=>	Pass_Hand,
		load_mxes				=>	load_mxes,
		LMNs_Colm_inc			=>	LMNs_Colm_inc,
		LMNs_Chan_inc			=>	LMNs_Chan_inc,
		MPUs_Colm_inc			=>	MPUs_Colm_inc,
		MPUs_Chan_inc			=>	MPUs_Chan_inc,
		LMNs_Colm_eq			=>	LMNs_Colm_eq,
		LMNs_Chan_eq			=>	LMNs_Chan_eq,
		MPUs_Colm_eq			=>	MPUs_Colm_eq,
		MPUs_Chan_eq			=>	MPUs_Chan_eq);
	------------------------------------------------------------------------
	------------------------------------------------------------------------
end Behavioral;

