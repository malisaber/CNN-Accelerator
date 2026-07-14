library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.math_real.ALL;
USE work.my_pack_v2.ALL;


entity PE_Plane is
	PORT(
		clk								:	IN	std_logic;
		clk_w							:	IN	std_logic;
		rst								:	IN	std_logic;
		rst_w							:	IN	std_logic;
		--	Config Holder
		CNF_ALL_Configurations			:	IN	all_configs_type;
		
		--	Initiation
		------	STA	 &	UPA
		INI_Bias_val					:	IN	std_logic_vector(P_word_size-1			DOWNTO 0);	--	Store Agent Only
		INI_Bias_Add					:	IN	std_logic_vector(P_kernel_size-1		DOWNTO 0);	--	Store Agent Only
		INI_Bias_Wen					:	IN	std_logic;											--	Store Agent Only
		INI_Addresses					:	IN	std_logic_vector(P_Phy_Add_size-1		DOWNTO 0);	--	shared
		INI_Target_add					:	IN	std_logic_vector(3						DOWNTO 0);	--	shared
		INI_Base_Wen					:	IN	std_logic;											--	shared
		INI_Count_Wen					:	IN	std_logic;											--	shared
		INI_IntVal_Wen					:	IN	std_logic;											--	shared
		INI_SA_UAbar					:	IN	std_logic;											--	SA ~UA Selector
		INI_SLU_unit_add				:	IN	std_logic_vector(3 						DOWNTO 0);	--	PE address r,c
		
		--	High Level  
		------	PEs
		CMD_PEs_start					:	IN	std_logic_4X4;		--(flip)	simple start
		CMD_PEs_init_inc_Rows			:	IN	std_logic_4X4V3;	--(flag)	inc row select
		CMD_PEs_done					:	OUT	std_logic_4X4;
		------	STA		
		CMD_STA_ACK						:	IN	std_logic_4X4;		--(flip)	scheduler tells STA that the DMA transfers data and ready to accept another chunk
		CMD_STA_load					:	IN	std_logic_4X4;		--(flip)	load a row data from memory
		CMD_STA_MEM_en					:	IN	std_logic_4X4;		--(flip)	accumulate with internal memory content
		CMD_STA_OBM_en					:	IN	std_logic_4X4;		--(flip)	accumulate with OBM content
		CMD_STA_BIS_en					:	IN	std_logic_4X4;		--(flip)	accumulate with BIAS
		CMD_STA_save					:	IN	std_logic_4X4;		--(flip)	save the result in the internal memory
		CMD_STA_active					:	IN	std_logic_4X4;		--(flip)	pass through activation function module
		CMD_STA_store					:	IN	std_logic_4X4;		--(flip)	store the row in memory
		CMD_STA_load_UA					:	IN	std_logic_4X4;		--(flip)	update BASE ADDRESS of load  pointer 
		CMD_STA_stor_UA					:	IN	std_logic_4X4;		--(flip)	update BASE ADDRESS of store pointer 
		CMD_STA_done					:	OUT	std_logic_4X4;
		------	UPA		
		CMD_UPA_Up_IFM					:	IN	std_logic_4X4;		--(flip)	update input feature map buffers
		CMD_UPA_Up_WFM					:	IN	std_logic_4X4;		--(flip)	update weigh buffers
		CMD_UPA_status					:	OUT	std_logic_4X4V2;	--			status of UPA
		CMD_UPA_done					:	OUT	std_logic_4X4;
		
		--	CONTROL
		------	PAUSE
		CNT_PEs_PAUSE					:	IN	std_logic_4X4;		--(flip)
		CNT_STA_PAUSE					:	IN	std_logic_4X4;		--(flip)
		CNT_UPA_PAUSE					:	IN	std_logic_4X4;		--(flip)
		
		
		--	Masters
		------	Update	Agent
		NAT_LMN_UPA_push				:	OUT	std_logic_4X4;
		NAT_LMN_UPA_ack					:	IN	std_logic_4X4;
		NAT_LMN_UPA_read				:	OUT	std_logic_4X4;
		NAT_LMN_UPA_write				:	OUT	std_logic_4X4;
		NAT_LMN_UPA_add					:	OUT	std_logic_4X4VPAS;
		NAT_LMN_UPA_cnt					:	OUT	std_logic_4X4VPCS;
		NAT_LMN_UPA_data_in				:	IN	std_logic_4X4VPDS;
		NAT_LMN_UPA_data_rdy			:	IN	std_logic_4X4;
		NAT_LMN_UPA_data_out			:	OUT	std_logic_4X4VPDS;
		NAT_LMN_UPA_data_wen			:	OUT	std_logic_4X4;
		------	Store	Agent
		NAT_LMN_STA_wait				:	IN	std_logic_4X4;
		NAT_LMN_STA_push				:	OUT	std_logic_4X4;
		NAT_LMN_STA_ack					:	IN	std_logic_4X4;
		NAT_LMN_STA_read				:	OUT	std_logic_4X4;
		NAT_LMN_STA_write				:	OUT	std_logic_4X4;
		NAT_LMN_STA_add					:	OUT	std_logic_4X4VPAS;
		NAT_LMN_STA_cnt					:	OUT	std_logic_4X4VPCS;
		NAT_LMN_STA_data_in				:	IN	std_logic_4X4VPDS;
		NAT_LMN_STA_data_rdy			:	IN	std_logic_4X4;
		NAT_LMN_STA_data_out			:	OUT	std_logic_4X4VPDS;
		NAT_LMN_STA_data_wen			:	OUT	std_logic_4X4);
end PE_Plane;

architecture Behavioral of PE_Plane is
	------------------------------------------------------------------------
	--	COMPONENTS
	------------------------------------------------------------------------
	COMPONENT	P_sys 
	PORT(
		clk								:	IN	std_logic;
		clk_w							:	IN	std_logic;
		rst								:	IN	std_logic;
		--		Config				
		all_configs						:	IN	all_configs_type;
		--		Low Level
		MB_low_lvl_wen					:	IN	std_logic_4X4V4;
		MB_low_lvl_sig					:	IN	MB_Low_level_mem_4X4;
		WB_low_lvl_wen					:	IN	std_logic_4X4of3X3;
		WB_low_lvl_sig					:	IN	WB_Low_level_mem_4X4;
		Bank_set_flag					:	IN	std_logic_4X4V4;
		Bank_status						:	OUT	std_logic_4X4V4;
		CMD_STA_ACK						:	IN	std_logic_4X4;
		--		High Level  
		start							:	IN	std_logic_4X4; 
		init_inc_Rows					:	IN	std_logic_4X4V3;
		done							:	OUT	std_logic_4X4;
		PEs_OFM_add						:	IN	PEs_OFM_add_4X4;
		PEs_OFM_data					:	OUT	PEs_OFM_data_4X4;
		PEs_SA_start					:	OUT	std_logic_4X4;
		--	CONTROL
		------	PAUSE
		CNT_PEs_PAUSE					:	IN	std_logic_4X4);
	END COMPONENT;
	------------------------------------------------------------------------
	COMPONENT	UA
	PORT(	
		clk_w							:	IN	std_logic;
		rst_w							:	IN	std_logic;
		--		Control				
		Addresses						:	IN	std_logic_vector(P_USA_Add_size-1		DOWNTO 0);
		Target_add						:	IN	std_logic_vector(3						DOWNTO 0);
		Base_Wen						:	IN	std_logic;
		Count_Wen						:	IN	std_logic;
		IntVal_Wen						:	IN	std_logic;
		--		Configs				
		MAX_Ker							:	IN	std_logic_vector(P_kernel_size-1		DOWNTO 0);
		MAX_Col							:	IN	std_logic_vector(P_column_size-1		DOWNTO 0);
		MAX_Chn							:	IN	std_logic_vector(P_channel_size-1		DOWNTO 0);
		--	TOP Level				
		Update_IFM						:	IN	std_logic;
		Update_WFM						:	IN	std_logic;
		status							:	OUT	std_logic_vector(1 DOWNTO 0);
		done							:	OUT	std_logic;
		--	CONTROL
		------	PAUSE
		CNT_UPA_PAUSE					:	IN	std_logic;
		--	TO LMN				
		LL_push							:	OUT	std_logic;
		LL_ack							:	IN	std_logic;
		LL_read							:	OUT	std_logic;
		LL_write						:	OUT	std_logic;
		LL_add							:	OUT	std_logic_vector(P_USA_Add_size-1		DOWNTO 0);
		LL_cnt							:	OUT	std_logic_vector(P_USA_Cnt_size-1		DOWNTO 0);
		LL_data_in						:	IN	std_logic_vector(P_word_size-1			DOWNTO 0);
		LL_data_rdy						:	IN	std_logic;
		LL_data_out						:	OUT	std_logic_vector(P_word_size-1			DOWNTO 0);
		LL_data_wen						:	OUT	std_logic;
		--		TO PEs
		MB_low_lvl_wen					:	OUT	std_logic_vector(3 DOWNTO 0);
		MB_low_lvl_sig					:	OUT	MB_Low_level_mem;
		WB_low_lvl_wen					:	OUT	std_logic_3X3;
		WB_low_lvl_sig					:	OUT	WB_Low_level_mem;
		MB_set_flag						:	OUT	std_logic_vector(3 DOWNTO 0);
		MB_status						:	IN	std_logic_vector(3 DOWNTO 0));
	END	COMPONENT;
	------------------------------------------------------------------------
	COMPONENT	SA
	PORT(	
		clk_w							:	IN	std_logic;
		rst_w							:	IN	std_logic;
		-- COMMANDS				
		CMD_start						:	IN	std_logic;
		CMD_ACK							:	IN	std_logic;
		CMD_load						:	IN	std_logic;
		CMD_MEM_en						:	IN	std_logic;
		CMD_OBM_en						:	IN	std_logic;
		CMD_BIS_en						:	IN	std_logic;
		CMD_save						:	IN	std_logic;
		CMD_active						:	IN	std_logic;
		CMD_store						:	IN	std_logic;
		CMD_load_UA						:	IN	std_logic;
		CMD_stor_UA						:	IN	std_logic;
		CMD_done						:	OUT	std_logic;
		--	LMN			
		--LMN_ready						:	IN	std_logic;
		LMN_wait						:	IN	std_logic;
		LMN_push						:	OUT	std_logic;
		LMN_ack							:	IN	std_logic;
		LMN_read						:	OUT	std_logic;
		LMN_write						:	OUT	std_logic;
		LMN_add							:	OUT	std_logic_vector(P_USA_Add_size-1		DOWNTO 0);
		LMN_cnt							:	OUT	std_logic_vector(P_USA_Cnt_size -1		DOWNTO 0);
		LMN_data_in						:	IN	std_logic_vector(P_word_size-1			DOWNTO 0);
		LMN_data_rdy					:	IN	std_logic;
		LMN_data_out					:	OUT	std_logic_vector(P_word_size-1			DOWNTO 0);
		LMN_data_wen					:	OUT	std_logic;
		--	Config				
		CNF_MAX_Kern					:	IN	std_logic_vector(P_kernel_size-1		DOWNTO 0);
		CNF_MAX_Colm					:	IN	std_logic_vector(P_column_size-1		DOWNTO 0);
		CNF_MAX_mode					:	IN	std_logic;
		--	CONTROL			
		------	PAUSE			
		CNT_STA_PAUSE					:	IN	std_logic;
		--	TOP Level				
		TOP_Bias_val					:	IN	std_logic_vector(P_word_size-1			DOWNTO 0);
		TOP_Bias_Add					:	IN	std_logic_vector(P_kernel_size-1		DOWNTO 0);
		TOP_Addresses					:	IN	std_logic_vector(P_USA_Add_size-1		DOWNTO 0);
		TOP_Target_add					:	IN	std_logic_vector(0						DOWNTO 0);
		TOP_Base_Wen					:	IN	std_logic;
		TOP_Count_Wen					:	IN	std_logic;
		TOP_IntVal_Wen					:	IN	std_logic; 
		TOP_Bias_Wen					:	IN	std_logic;
		--	Output Buffer		
		------	Data, Address		
		OBM_DATA						:	IN	std_logic_vector(P_word_size-1			DOWNTO 0);
		OBM_ADD							:	OUT	std_logic_vector(P_OFM_Add_size-1		DOWNTO 0));
	END	COMPONENT;
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	--	SIGNALS
	------------------------------------------------------------------------
	--	Update	Agent
	------	Data 
	SIGNAL	SIG_MB_wen					:	std_logic_4X4V4;
	SIGNAL	SIG_MB_sig					:	MB_Low_level_mem_4X4;
	SIGNAL	SIG_WB_wen					:	std_logic_4X4of3X3;
	SIGNAL	SIG_WB_sig					:	WB_Low_level_mem_4X4;
	SIGNAL	SIG_ST_flg					:	std_logic_4X4V4;
	SIGNAL	SIG_status					:	std_logic_4X4V4;
	------	Initial Data
	SIGNAL	SIG_UAI_Base_Wen			:	std_logic_4X4;	--
	SIGNAL	SIG_UAI_Count_Wen			:	std_logic_4X4;	--
	SIGNAL	SIG_UAI_IntVal_Wen			:	std_logic_4X4;	--
	--	Store	Agent
	------	Data
	SIGNAL	SIG_OB_add					:	PEs_OFM_add_4X4;
	SIGNAL	SIG_OB_dat					:	PEs_OFM_data_4X4;
	SIGNAL	SIG_SA_start				:	std_logic_4X4;
	------	Initial Data
	SIGNAL	SIG_SAI_Base_Wen			:	std_logic_4X4;	--
	SIGNAL	SIG_SAI_Count_Wen			:	std_logic_4X4;	--
	SIGNAL	SIG_SAI_IntVal_Wen			:	std_logic_4X4;	--
	SIGNAL	SIG_SAI_Bias_Wen			:	std_logic_4X4;	--
	------------------------------------------------------------------------
	------------------------------------------------------------------------
begin
	------------------------------------------------------------------------
	--	INSTANCES
	------------------------------------------------------------------------
	PECU_Array							:	P_sys 
	PORT	MAP(
		clk								=>	clk,
		clk_w							=>	clk_w,
		rst								=>	rst,
		--		Config				
		all_configs						=>	CNF_ALL_Configurations,
		--		Low Level
		MB_low_lvl_wen					=>	SIG_MB_wen,
		MB_low_lvl_sig					=>	SIG_MB_sig,
		WB_low_lvl_wen					=>	SIG_WB_wen,
		WB_low_lvl_sig					=>	SIG_WB_sig,
		Bank_set_flag					=>	SIG_ST_flg,
		Bank_status						=>	SIG_status,
		CMD_STA_ACK						=>	CMD_STA_ACK,
		--		High Level  
		start							=>	CMD_PEs_start,
		init_inc_Rows					=>	CMD_PEs_init_inc_Rows,
		done							=>	CMD_PEs_done,
		PEs_OFM_add						=>	SIG_OB_add,
		PEs_OFM_data					=>	SIG_OB_dat,
		PEs_SA_start					=>	SIG_SA_start,
		--	CONTROL
		------	PAUSE
		CNT_PEs_PAUSE					=>	CNT_PEs_PAUSE);
	------------------------------------------------------------------------
	ROW_GEN								:	FOR	r	IN	1	TO	4	GENERATE
		COL_GEN							:	FOR	c	IN	1	TO	4	GENERATE
			UA_unit						:	UA
			PORT	MAP(
				clk_w					=>	clk_w,
				rst_w					=>	rst_w,
				--		Control
				Addresses				=>	INI_Addresses,
				Target_add				=>	INI_Target_add,
				Base_Wen				=>	SIG_UAI_Base_Wen				(r,c),
				Count_Wen				=>	SIG_UAI_Count_Wen				(r,c),
				IntVal_Wen				=>	SIG_UAI_IntVal_Wen				(r,c),
				--		Configs
				MAX_Ker					=>	CNF_ALL_Configurations.Maxs		(r,c).Kern_Max,
				MAX_Col					=>	CNF_ALL_Configurations.Maxs		(r,c).Colm_Max,
				MAX_Chn					=>	CNF_ALL_Configurations.Maxs		(r,c).Chan_Max,
				--	TOP Level
				Update_IFM				=>	CMD_UPA_Up_IFM					(r,c),
				Update_WFM				=>	CMD_UPA_Up_WFM					(r,c),
				status					=>	CMD_UPA_status					(r,c),
				done					=>	CMD_UPA_done					(r,c),
				--	CONTROL
				------	PAUSE
				CNT_UPA_PAUSE			=>	CNT_UPA_PAUSE					(r,c),
				--	TO LMN                                      
				LL_push					=>	NAT_LMN_UPA_push				(r,c),
				LL_ack					=>	NAT_LMN_UPA_ack					(r,c),
				LL_read					=>	NAT_LMN_UPA_read				(r,c),
				LL_write				=>	NAT_LMN_UPA_write				(r,c),
				LL_add					=>	NAT_LMN_UPA_add					(r,c),
				LL_cnt					=>	NAT_LMN_UPA_cnt					(r,c),
				LL_data_in				=>	NAT_LMN_UPA_data_in				(r,c),
				LL_data_rdy				=>	NAT_LMN_UPA_data_rdy			(r,c),
				LL_data_out				=>	NAT_LMN_UPA_data_out			(r,c),
				LL_data_wen				=>	NAT_LMN_UPA_data_wen			(r,c),
				--		TO PEs
				MB_low_lvl_wen			=>	SIG_MB_wen						(r,c),
				MB_low_lvl_sig			=>	SIG_MB_sig						(r,c),
				WB_low_lvl_wen			=>	SIG_WB_wen						(r,c),
				WB_low_lvl_sig			=>	SIG_WB_sig						(r,c),
				MB_set_flag				=>	SIG_ST_flg						(r,c),
				MB_status				=>	SIG_status						(r,c));
			----------------------------------------------------------------
			SA_unit						:	SA
			PORT	MAP(
				clk_w					=>	clk_w,
				rst_w					=>	rst_w,
				-- COMMANDS
				CMD_start				=>	SIG_SA_start					(r,c),
				CMD_ACK					=>	CMD_STA_ACK						(r,c),
				CMD_load				=>	CMD_STA_load					(r,c),
				CMD_MEM_en				=>	CMD_STA_MEM_en					(r,c),
				CMD_OBM_en				=>	CMD_STA_OBM_en					(r,c),
				CMD_BIS_en				=>	CMD_STA_BIS_en					(r,c),
				CMD_save				=>	CMD_STA_save					(r,c),
				CMD_active				=>	CMD_STA_active					(r,c),
				CMD_store				=>	CMD_STA_store					(r,c),
				CMD_load_UA				=>	CMD_STA_load_UA					(r,c),
				CMD_stor_UA				=>	CMD_STA_stor_UA					(r,c),
				CMD_done				=>	CMD_STA_done					(r,c),
				--	LMN
				--LMN_ready
				LMN_wait				=>	NAT_LMN_STA_wait				(r,c),
				LMN_push				=>	NAT_LMN_STA_push				(r,c),
				LMN_ack					=>	NAT_LMN_STA_ack					(r,c),
				LMN_read				=>	NAT_LMN_STA_read				(r,c),
				LMN_write				=>	NAT_LMN_STA_write				(r,c),
				LMN_add					=>	NAT_LMN_STA_add					(r,c),
				LMN_cnt					=>	NAT_LMN_STA_cnt					(r,c),
				LMN_data_in				=>	NAT_LMN_STA_data_in				(r,c),
				LMN_data_rdy			=>	NAT_LMN_STA_data_rdy			(r,c),
				LMN_data_out			=>	NAT_LMN_STA_data_out			(r,c),
				LMN_data_wen			=>	NAT_LMN_STA_data_wen			(r,c),
				--	Config
				CNF_MAX_Kern			=>	CNF_ALL_Configurations.Maxs		(r,c).Kern_Max,
				CNF_MAX_Colm			=>	CNF_ALL_Configurations.Maxs		(r,c).Colm_Max,
				CNF_MAX_mode			=>	CNF_ALL_Configurations.PEs_CFB	(r,c).OP_mode,
				--	CONTROL
				------	PAUSE
				CNT_STA_PAUSE			=>	CNT_STA_PAUSE					(r,c),
				--	TOP Level
				TOP_Bias_val			=>	INI_Bias_val,
				TOP_Bias_Add			=>	INI_Bias_Add,
				TOP_Addresses			=>	INI_Addresses,
				TOP_Target_add			=>	INI_Target_add					(0	DOWNTO	0),
				TOP_Base_Wen			=>	SIG_SAI_Base_Wen				(r,c),
				TOP_Count_Wen			=>	SIG_SAI_Count_Wen				(r,c),
				TOP_IntVal_Wen			=>	SIG_SAI_IntVal_Wen				(r,c),
				TOP_Bias_Wen			=>	SIG_SAI_Bias_Wen				(r,c),
				--	Output Buffer
				------	Data, Address
				OBM_DATA				=>	SIG_OB_dat						(r,c),
				OBM_ADD					=>	SIG_OB_add						(r,c));
			
			END GENERATE;
		END GENERATE;
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	--	CONNECTIONS
	------------------------------------------------------------------------
	PROCESS(INI_SLU_unit_add, INI_Base_Wen, INI_Count_Wen, INI_IntVal_Wen, INI_Bias_Wen, INI_SA_UAbar)
		VARIABLE	row					:	INTEGER;
		VARIABLE	col					:	INTEGER;
	BEGIN
		SIG_UAI_Base_Wen				<=	(OTHERS => (OTHERS => '0'));
		SIG_UAI_Count_Wen				<=	(OTHERS => (OTHERS => '0'));
		SIG_UAI_IntVal_Wen				<=	(OTHERS => (OTHERS => '0'));
		SIG_SAI_Base_Wen				<=	(OTHERS => (OTHERS => '0'));
		SIG_SAI_Count_Wen				<=	(OTHERS => (OTHERS => '0'));
		SIG_SAI_IntVal_Wen				<=	(OTHERS => (OTHERS => '0'));
		SIG_SAI_Bias_Wen				<=	(OTHERS => (OTHERS => '0'));
		CASE(INI_SLU_unit_add)IS
			WHEN	X"0"				=>	row	:=	1;		col	:=	1;
			WHEN	X"1"				=>	row	:=	1;		col	:=	2;
			WHEN	X"2"				=>	row	:=	1;		col	:=	3;
			WHEN	X"3"				=>	row	:=	1;		col	:=	4;
			WHEN	X"4"				=>	row	:=	2;		col	:=	1;
			WHEN	X"5"				=>	row	:=	2;		col	:=	2;
			WHEN	X"6"				=>	row	:=	2;		col	:=	3;
			WHEN	X"7"				=>	row	:=	2;		col	:=	4;
			WHEN	X"8"				=>	row	:=	3;		col	:=	1;
			WHEN	X"9"				=>	row	:=	3;		col	:=	2;
			WHEN	X"A"				=>	row	:=	3;		col	:=	3;
			WHEN	X"B"				=>	row	:=	3;		col	:=	4;
			WHEN	X"C"				=>	row	:=	4;		col	:=	1;
			WHEN	X"D"				=>	row	:=	4;		col	:=	2;
			WHEN	X"E"				=>	row	:=	4;		col	:=	3;
			WHEN	X"F"				=>	row	:=	4;		col	:=	4;
			WHEN	OTHERS				=>	row	:=	1;		col	:=	1;
		END CASE;
		IF	INI_SA_UAbar	=	'0'	THEN
			SIG_UAI_Base_Wen	(row,col)	<=	INI_Base_Wen;
			SIG_UAI_Count_Wen	(row,col)	<=	INI_Count_Wen;
			SIG_UAI_IntVal_Wen	(row,col)	<=	INI_IntVal_Wen;
		ELSE
			SIG_SAI_Base_Wen	(row,col)	<=	INI_Base_Wen;
			SIG_SAI_Count_Wen	(row,col)	<=	INI_Count_Wen;
			SIG_SAI_IntVal_Wen	(row,col)	<=	INI_IntVal_Wen;
			SIG_SAI_Bias_Wen	(row,col)	<=	INI_Bias_Wen;
		END	IF;
	END PROCESS;
	------------------------------------------------------------------------
	------------------------------------------------------------------------
end Behavioral;
		