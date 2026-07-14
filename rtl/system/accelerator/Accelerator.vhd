library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE IEEE.math_real.ALL;
USE work.my_pack_v2.ALL;

entity Accelerator is 
	PORT(
		clk								:	IN	std_logic;
		clk_w							:	IN	std_logic;
		rst_in							:	IN	std_logic;
		rst_w							:	IN	std_logic;
		ACCELERATOR_P0_NORMAL			:	IN	std_logic;
		ACCELERATOR_P1_NORMAL			:	IN	std_logic;
		ACCELERATOR_P2_NORMAL			:	IN	std_logic;
		ACCELERATOR_P3_NORMAL			:	IN	std_logic;
		
		
		--	Config Holder
		CNF_ALL_Configurations			:	IN	Plane_all_configs_type;
		
		
		--	Initiation
		------	STA	 &	UPA
		INI_Bias_val					:	IN	Unc_1D_P_Data_array	(P_Number_of_Planes-1	DOWNTO	0);	--	Store Agent Only
		INI_Bias_Add					:	IN	Unc_1D_P_Kern_array	(P_Number_of_Planes-1	DOWNTO	0);	--	Store Agent Only
		INI_Bias_Wen					:	IN	Unc_1D_array		(P_Number_of_Planes-1	DOWNTO	0);	--	Store Agent Only
		INI_Addresses					:	IN	Unc_1D_P_Addr_array	(P_Number_of_Planes-1	DOWNTO	0);	--	shared
		INI_Target_add					:	IN	Unc_1D_4bit_array	(P_Number_of_Planes-1	DOWNTO	0);	--	shared
		INI_Base_Wen					:	IN	Unc_1D_array		(P_Number_of_Planes-1	DOWNTO	0);	--	shared
		INI_Count_Wen					:	IN	Unc_1D_array		(P_Number_of_Planes-1	DOWNTO	0);	--	shared
		INI_IntVal_Wen					:	IN	Unc_1D_array		(P_Number_of_Planes-1	DOWNTO	0);	--	shared
		INI_SA_UAbar					:	IN	Unc_1D_array		(P_Number_of_Planes-1	DOWNTO	0);	--	SA ~UA Selector
		INI_SLU_unit_add				:	IN	Unc_1D_4bit_array	(P_Number_of_Planes-1	DOWNTO	0);	--	PE address r,c
		--	High Level  
		------	PEs
		CMD_PEs_start					:	IN	Plane_std_logic_4X4;		--(flip)	simple start
		CMD_PEs_init_inc_Rows			:	IN	Plane_std_logic_4X4V3;		--(flag)	inc row select
		CMD_PEs_done					:	OUT	Plane_std_logic_4X4;
		------	STA		
		CMD_STA_ACK						:	IN	Plane_std_logic_4X4;		--(flip)	scheduler tells STA that the DMA transfers data and ready to accept another chunk
		CMD_STA_load					:	IN	Plane_std_logic_4X4;		--(flip)	load a row data from memory
		CMD_STA_MEM_en					:	IN	Plane_std_logic_4X4;		--(flip)	accumulate with internal memory content
		CMD_STA_OBM_en					:	IN	Plane_std_logic_4X4;		--(flip)	accumulate with OBM content
		CMD_STA_BIS_en					:	IN	Plane_std_logic_4X4;		--(flip)	accumulate with BIAS
		CMD_STA_save					:	IN	Plane_std_logic_4X4;		--(flip)	save the result in the internal memory
		CMD_STA_active					:	IN	Plane_std_logic_4X4;		--(flip)	pass through activation function module
		CMD_STA_store					:	IN	Plane_std_logic_4X4;		--(flip)	store the row in memory
		CMD_STA_load_UA					:	IN	Plane_std_logic_4X4;		--(flip)	update BASE ADDRESS of load  pointer 
		CMD_STA_stor_UA					:	IN	Plane_std_logic_4X4;		--(flip)	update BASE ADDRESS of store pointer 
		CMD_STA_done					:	OUT	Plane_std_logic_4X4;
		------	UPA		
		CMD_UPA_Up_IFM					:	IN	Plane_std_logic_4X4;		--(flip)	update input feature map buffers
		CMD_UPA_Up_WFM					:	IN	Plane_std_logic_4X4;		--(flip)	update weigh buffers
		CMD_UPA_status					:	OUT	Plane_std_logic_4X4V2;		--			status of UPA
		CMD_UPA_done					:	OUT	Plane_std_logic_4X4;
		--	CONTROL
		------	PAUSE
		CNT_PEs_PAUSE					:	IN	Plane_std_logic_4X4;		--(flip)
		CNT_STA_PAUSE					:	IN	Plane_std_logic_4X4;		--(flip)
		CNT_UPA_PAUSE					:	IN	Plane_std_logic_4X4;		--(flip)
		
		--	DMA
		CMD_DMA_start					:	IN	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	--(flag)
		CMD_DMA_ready					:	OUT	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	
		CMD_DMA_R_Add					:	IN	Unc_2D_P_Addr_array	(3	DOWNTO	0,	3	DOWNTO 0);	--(regs)
		CMD_DMA_R_Cnt					:	IN	Unc_2D_P_Cont_array	(3	DOWNTO	0,	3	DOWNTO 0);	--(regs)
		CMD_DMA_W_Add					:	IN	Unc_2D_P_Addr_array	(3	DOWNTO	0,	3	DOWNTO 0);	--(regs)
		CMD_DMA_W_Cnt					:	IN	Unc_2D_P_Cont_array	(3	DOWNTO	0,	3	DOWNTO 0);	--(regs)
		
		--	MPDR 
		CMD_MPDR_start					:	IN	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	--(flag)
		CMD_MPDR_Done					:	OUT	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	
		CMD_MPDR_load					:	IN	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	--(flag)
		CMD_MPDR_Addresses				:	IN	std_logic_vector	(P_USA_Add_size-1	DOWNTO 0);
		CMD_MPDR_Target					:	IN	std_logic_vector	(2	DOWNTO 0);	
		CMD_MPDR_Base_Wen				:	IN	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	
		CMD_MPDR_Cont_Wen				:	IN	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	
		CMD_MPDR_IVal_Wen				:	IN	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	
		CMD_MPDR_MAX_Col				:	IN	std_logic_vector	(P_column_size-1	DOWNTO 0);
		CMD_MPDR_MAX_Chn				:	IN	std_logic_vector	(P_channel_size-1	DOWNTO 0);
		
		--	to	VC
		OGM_2VCU_req					:	OUT	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);
		OGM_2VCU_grant					:	IN	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);
		OGM_2VCU_done					:	IN	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);
		OGM_2VCU_wait					:	IN	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);
		OGM_2VCU_read					:	OUT	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);
		OGM_2VCU_write					:	OUT	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);
		OGM_2VCU_Add					:	OUT	Unc_2D_P_Addr_array	(3	DOWNTO	0,	3	DOWNTO 0);
		OGM_2VCU_Cnt					:	OUT	Unc_2D_P_Cont_array	(3	DOWNTO	0,	3	DOWNTO 0);
		OGM_2VCU_MD_in					:	IN	Unc_2D_P_Data_array	(3	DOWNTO	0,	3	DOWNTO 0);
		OGM_2VCU_MD_in_rdy				:	IN	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);
		OGM_2VCU_MD_out					:	OUT	Unc_2D_P_Data_array	(3	DOWNTO	0,	3	DOWNTO 0);
		OGM_2VCU_MD_out_rdy				:	OUT	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0));
end Accelerator;
 
architecture Behavioral of Accelerator is
	------------------------------------------------------------------------
	--	COMPONENTS
	------------------------------------------------------------------------
	COMPONENT	PE_Plane
	PORT(
		clk								:	std_logic;
		clk_w							:	std_logic;
		rst								:	std_logic;
		rst_w							:	std_logic;
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
	END COMPONENT;
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	COMPONENT	LMN
	GENERIC(
		LMN_ROW_POS						:	INTEGER		:=	0;
		LMN_COL_POS						:	INTEGER		:=	0);
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		--	PE's	Update	Agent	Native Side
		NAT_UPA_ready					:	OUT	Plane_std_logic;
		NAT_UPA_wait					:	OUT	Plane_std_logic;
		NAT_UPA_push					:	IN	Plane_std_logic;
		NAT_UPA_ack						:	OUT	Plane_std_logic;
		NAT_UPA_read					:	IN	Plane_std_logic;
		NAT_UPA_write					:	IN	Plane_std_logic;
		NAT_UPA_Add						:	IN	Plane_std_logic_vector_Addr;
		NAT_UPA_Cnt						:	IN	Plane_std_logic_vector_Cont;
		NAT_UPA_data_out				:	OUT	Plane_std_logic_vector_Data;
		NAT_UPA_data_rdy				:	OUT	Plane_std_logic;
		NAT_UPA_data_in					:	IN	Plane_std_logic_vector_Data;
		NAT_UPA_data_wen				:	IN	Plane_std_logic;
		--	PE's	Store	Agent	Native Side
		NAT_STA_ready					:	OUT	Plane_std_logic;
		NAT_STA_wait					:	OUT	Plane_std_logic;
		NAT_STA_push					:	IN	Plane_std_logic;
		NAT_STA_ack						:	OUT	Plane_std_logic;
		NAT_STA_read					:	IN	Plane_std_logic;
		NAT_STA_write					:	IN	Plane_std_logic;
		NAT_STA_Add						:	IN	Plane_std_logic_vector_Addr;
		NAT_STA_Cnt						:	IN	Plane_std_logic_vector_Cont;
		NAT_STA_data_out				:	OUT	Plane_std_logic_vector_Data;
		NAT_STA_data_rdy				:	OUT	Plane_std_logic;
		NAT_STA_data_in					:	IN	Plane_std_logic_vector_Data;
		NAT_STA_data_wen				:	IN	Plane_std_logic;
		--	MPE		Native Side		
		NAT_MPEU_ready					:	OUT	std_logic;
		NAT_MPEU_wait					:	OUT	std_logic;
		NAT_MPEU_push					:	IN	std_logic;
		NAT_MPEU_ack					:	OUT	std_logic;
		NAT_MPEU_read					:	IN	std_logic;
		NAT_MPEU_write					:	IN	std_logic;
		NAT_MPEU_Add					:	IN	std_logic_vector(P_Phy_Add_size-1 DOWNTO 0);
		NAT_MPEU_Cnt					:	IN	std_logic_vector(P_Phy_Cnt_size-1 DOWNTO 0);
		NAT_MPEU_data_out				:	OUT	std_logic_vector(P_word_size-1   DOWNTO 0);
		NAT_MPEU_data_rdy				:	OUT	std_logic;
		NAT_MPEU_data_in				:	IN	std_logic_vector(P_word_size-1   DOWNTO 0);
		NAT_MPEU_data_wen				:	IN	std_logic;
		--	OUT GATE	To	VC	(Master IN top Level)
		OGM_2VCU_req					:	OUT	std_logic;
		OGM_2VCU_grant					:	IN	std_logic;
		OGM_2VCU_done					:	IN	std_logic;
		OGM_2VCU_wait					:	IN	std_logic;
		OGM_2VCU_read					:	OUT	std_logic;
		OGM_2VCU_write					:	OUT	std_logic;
		OGM_2VCU_Add					:	OUT	std_logic_vector(P_Phy_Add_size-1	DOWNTO 0);
		OGM_2VCU_Cnt					:	OUT	std_logic_vector(P_Phy_Cnt_size-1	DOWNTO 0);
		OGM_2VCU_MD_in					:	IN	std_logic_vector(P_word_size-1		DOWNTO 0);
		OGM_2VCU_MD_in_rdy				:	IN	std_logic;
		OGM_2VCU_MD_out					:	OUT	std_logic_vector(P_word_size-1		DOWNTO 0);
		OGM_2VCU_MD_out_rdy				:	OUT	std_logic;
		--	OUT GATE	To	GMN	(Master IN top Level)
		OGM_2GMN_req					:	OUT	std_logic;
		OGM_2GMN_grant					:	IN	std_logic;
		OGM_2GMN_done					:	IN	std_logic;
		OGM_2GMN_wait					:	IN	std_logic;
		OGM_2GMN_read					:	OUT	std_logic;
		OGM_2GMN_write					:	OUT	std_logic;
		OGM_2GMN_Add					:	OUT	std_logic_vector(P_Phy_Add_size-1	DOWNTO 0);
		OGM_2GMN_Cnt					:	OUT	std_logic_vector(P_Phy_Cnt_size-1	DOWNTO 0);
		OGM_2GMN_MD_in					:	IN	std_logic_vector(P_word_size-1		DOWNTO 0);
		OGM_2GMN_MD_in_rdy				:	IN	std_logic;
		OGM_2GMN_MD_out					:	OUT	std_logic_vector(P_word_size-1		DOWNTO 0);
		OGM_2GMN_MD_out_rdy				:	OUT	std_logic;
		--	IN GATE		TO	GMN	(Slave IN top Level)
		IGM_2GMN_CS						:	IN	std_logic;
		IGM_2GMN_done					:	OUT	std_logic;
		IGM_2GMN_wait					:	OUT	std_logic;
		IGM_2GMN_read					:	IN	std_logic;
		IGM_2GMN_write					:	IN	std_logic;
		IGM_2GMN_Add					:	IN	std_logic_vector(P_Phy_Add_size-1	DOWNTO 0);
		IGM_2GMN_Cnt					:	IN	std_logic_vector(P_Phy_Cnt_size-1	DOWNTO 0);
		IGM_2GMN_SD_out					:	OUT	std_logic_vector(P_word_size-1		DOWNTO 0);
		IGM_2GMN_SD_out_rdy				:	OUT	std_logic;
		IGM_2GMN_SD_in					:	IN	std_logic_vector(P_word_size-1		DOWNTO 0);
		IGM_2GMN_SD_in_rdy				:	IN	std_logic;
		--	DMA	Transaction Port
		TR_start						:	IN	std_logic;
		TR_ready						:	OUT	std_logic;
		TR_R_Add						:	IN	std_logic_vector(P_Phy_Add_size-1 DOWNTO 0);
		TR_R_Cnt						:	IN	std_logic_vector(P_Phy_Cnt_size-1 DOWNTO 0);
		TR_W_Add						:	IN	std_logic_vector(P_Phy_Add_size-1 DOWNTO 0);
		TR_W_Cnt						:	IN	std_logic_vector(P_Phy_Cnt_size-1 DOWNTO 0));
	END	COMPONENT;
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	COMPONENT	GMN
	PORT(
		clk_w							:	std_logic;
		rst_w							:	std_logic;
		--	LMN IN Gates' Slave
		GMN_S_CS						:	OUT	Unc_1D_array			(15 DOWNTO 0);
		GMN_S_done						:	IN	Unc_1D_array			(15 DOWNTO 0);
		GMN_S_wait						:	IN	Unc_1D_array			(15 DOWNTO 0);
		GMN_S_read						:	OUT	Unc_1D_array			(15 DOWNTO 0);
		GMN_S_write						:	OUT	Unc_1D_array			(15 DOWNTO 0);
		GMN_S_Add						:	OUT	Unc_1D_P_Addr_array		(15 DOWNTO 0);
		GMN_S_Cnt						:	OUT	Unc_1D_P_Cont_array		(15 DOWNTO 0);
		GMN_S_Dout						:	IN	Unc_1D_P_Data_array		(15 DOWNTO 0);
		GMN_S_Dout_rdy					:	IN	Unc_1D_array			(15 DOWNTO 0);
		GMN_S_Din						:	OUT	Unc_1D_P_Data_array		(15 DOWNTO 0);
		GMN_S_Din_rdy					:	OUT	Unc_1D_array			(15 DOWNTO 0);
		--	LMN	Out Gates' Master
		GMN_M_req						:	IN	Unc_1D_array			(15 DOWNTO 0);
		GMN_M_grant						:	OUT	Unc_1D_array			(15 DOWNTO 0);
		GMN_M_done						:	OUT	Unc_1D_array			(15 DOWNTO 0);
		GMN_M_wait						:	OUT	Unc_1D_array			(15 DOWNTO 0);
		GMN_M_read						:	IN	Unc_1D_array			(15 DOWNTO 0);
		GMN_M_write						:	IN	Unc_1D_array			(15 DOWNTO 0);
		GMN_M_Add						:	IN	Unc_1D_P_Addr_array		(15 DOWNTO 0);
		GMN_M_Cnt						:	IN	Unc_1D_P_Cont_array		(15 DOWNTO 0);
		GMN_M_Din						:	OUT	Unc_1D_P_Data_array		(15 DOWNTO 0);
		GMN_M_Din_rdy					:	OUT	Unc_1D_array			(15 DOWNTO 0);
		GMN_M_Dout						:	IN	Unc_1D_P_Data_array		(15 DOWNTO 0);
		GMN_M_Dout_rdy					:	IN	Unc_1D_array			(15 DOWNTO 0));
	END	COMPONENT;
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	COMPONENT	MPDR 
	PORT(
		clk_w							:	IN	std_logic;
		rst_w							:	IN	std_logic;
		--		Control	(Scheduler)
		CNT_start						:	IN	std_logic;
		CNT_done						:	OUT	std_logic;
		CNT_load						:	IN	std_logic;
		CNT_Addresses					:	IN	std_logic_vector(P_USA_Add_size-1		DOWNTO 0);
		CNT_Target						:	IN	std_logic_vector(2						DOWNTO 0);
		CNT_Base_Wen					:	IN	std_logic;
		CNT_Cont_Wen					:	IN	std_logic;
		CNT_IVal_Wen					:	IN	std_logic;
		--		Config		
		CNT_MAX_Col						:	IN	std_logic_vector(P_column_size-1		DOWNTO 0);
		CNT_MAX_Chn						:	IN	std_logic_vector(P_channel_size-1		DOWNTO 0);
		--	TO LMN
		LL_ready						:	IN	std_logic;
		LL_wait							:	IN	std_logic;
		LL_push							:	OUT	std_logic;
		LL_ack							:	IN	std_logic;
		LL_read							:	OUT	std_logic;
		LL_write						:	OUT	std_logic;
		LL_add							:	OUT	std_logic_vector(P_USA_Add_size-1		DOWNTO 0);
		LL_cnt							:	OUT	std_logic_vector(P_USA_Cnt_size-1		DOWNTO 0);
		LL_data_in						:	IN	std_logic_vector(P_word_size-1			DOWNTO 0);
		LL_data_rdy						:	IN	std_logic;
		LL_data_out						:	OUT	std_logic_vector(P_word_size-1			DOWNTO 0);
		LL_data_wen						:	OUT	std_logic);
	END COMPONENT;
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	--	SIGNALs
	------------------------------------------------------------------------
	SIGNAL	rst							:	std_logic_vector(3	DOWNTO	0);
	------------------------------------------------------------------------
	SIGNAL	SIG_PEP_UPA_push			:	Plane_std_logic_4X4;
	SIGNAL	SIG_PEP_UPA_ack				:	Plane_std_logic_4X4;
	SIGNAL	SIG_PEP_UPA_read			:	Plane_std_logic_4X4;
	SIGNAL	SIG_PEP_UPA_write			:	Plane_std_logic_4X4;
	SIGNAL	SIG_PEP_UPA_add				:	Plane_std_logic_4X4VPAS;
	SIGNAL	SIG_PEP_UPA_cnt				:	Plane_std_logic_4X4VPCS;
	SIGNAL	SIG_PEP_UPA_data_in			:	Plane_std_logic_4X4VPDS;
	SIGNAL	SIG_PEP_UPA_data_rdy		:	Plane_std_logic_4X4;
	SIGNAL	SIG_PEP_UPA_data_out		:	Plane_std_logic_4X4VPDS;
	SIGNAL	SIG_PEP_UPA_data_wen		:	Plane_std_logic_4X4;
	SIGNAL	SIG_PEP_STA_wait			:	Plane_std_logic_4X4;
	SIGNAL	SIG_PEP_STA_push			:	Plane_std_logic_4X4;
	SIGNAL	SIG_PEP_STA_ack				:	Plane_std_logic_4X4;
	SIGNAL	SIG_PEP_STA_read			:	Plane_std_logic_4X4;
	SIGNAL	SIG_PEP_STA_write			:	Plane_std_logic_4X4;
	SIGNAL	SIG_PEP_STA_add				:	Plane_std_logic_4X4VPAS;
	SIGNAL	SIG_PEP_STA_cnt				:	Plane_std_logic_4X4VPCS;
	SIGNAL	SIG_PEP_STA_data_in			:	Plane_std_logic_4X4VPDS;
	SIGNAL	SIG_PEP_STA_data_rdy		:	Plane_std_logic_4X4;
	SIGNAL	SIG_PEP_STA_data_out		:	Plane_std_logic_4X4VPDS;
	SIGNAL	SIG_PEP_STA_data_wen		:	Plane_std_logic_4X4;
	------------------------------------------------------------------------
	SIGNAL	SIG_LMN_UPA_push			:	Arr_4X4_Plane_sl;
	SIGNAL	SIG_LMN_UPA_ack				:	Arr_4X4_Plane_sl;
	SIGNAL	SIG_LMN_UPA_read			:	Arr_4X4_Plane_sl;
	SIGNAL	SIG_LMN_UPA_write			:	Arr_4X4_Plane_sl;
	SIGNAL	SIG_LMN_UPA_add				:	Arr_4X4_Plane_slv_Addr;
	SIGNAL	SIG_LMN_UPA_cnt				:	Arr_4X4_Plane_slv_Cont;
	SIGNAL	SIG_LMN_UPA_data_in			:	Arr_4X4_Plane_slv_Data;
	SIGNAL	SIG_LMN_UPA_data_rdy		:	Arr_4X4_Plane_sl;
	SIGNAL	SIG_LMN_UPA_data_out		:	Arr_4X4_Plane_slv_Data;
	SIGNAL	SIG_LMN_UPA_data_wen		:	Arr_4X4_Plane_sl;
	SIGNAL	SIG_LMN_STA_wait			:	Arr_4X4_Plane_sl;
	SIGNAL	SIG_LMN_STA_push			:	Arr_4X4_Plane_sl;
	SIGNAL	SIG_LMN_STA_ack				:	Arr_4X4_Plane_sl;
	SIGNAL	SIG_LMN_STA_read			:	Arr_4X4_Plane_sl;
	SIGNAL	SIG_LMN_STA_write			:	Arr_4X4_Plane_sl;
	SIGNAL	SIG_LMN_STA_add				:	Arr_4X4_Plane_slv_Addr;
	SIGNAL	SIG_LMN_STA_cnt				:	Arr_4X4_Plane_slv_Cont;
	SIGNAL	SIG_LMN_STA_data_in			:	Arr_4X4_Plane_slv_Data;
	SIGNAL	SIG_LMN_STA_data_rdy		:	Arr_4X4_Plane_sl;
	SIGNAL	SIG_LMN_STA_data_out		:	Arr_4X4_Plane_slv_Data;
	SIGNAL	SIG_LMN_STA_data_wen		:	Arr_4X4_Plane_sl;
	------------------------------------------------------------------------
	SIGNAL	SIG_LMN_MPDR_ready			:	std_logic_4X4;
	SIGNAL	SIG_LMN_MPDR_wait			:	std_logic_4X4;
	SIGNAL	SIG_LMN_MPDR_push			:	std_logic_4X4;
	SIGNAL	SIG_LMN_MPDR_ack			:	std_logic_4X4;
	SIGNAL	SIG_LMN_MPDR_read			:	std_logic_4X4;
	SIGNAL	SIG_LMN_MPDR_write			:	std_logic_4X4;
	SIGNAL	SIG_LMN_MPDR_Add			:	std_logic_4X4VPAS;
	SIGNAL	SIG_LMN_MPDR_Cnt			:	std_logic_4X4VPCS;
	SIGNAL	SIG_LMN_MPDR_data_out		:	std_logic_4X4VPDS;
	SIGNAL	SIG_LMN_MPDR_data_rdy		:	std_logic_4X4;
	SIGNAL	SIG_LMN_MPDR_data_in		:	std_logic_4X4VPDS;
	SIGNAL	SIG_LMN_MPDR_data_wen		:	std_logic_4X4;
	------------------------------------------------------------------------
	SIGNAL	SIG_GMN_S_CS				:	Unc_1D_array				(15 DOWNTO 0);
	SIGNAL	SIG_GMN_S_done				:	Unc_1D_array				(15 DOWNTO 0);
	SIGNAL	SIG_GMN_S_wait				:	Unc_1D_array				(15 DOWNTO 0);
	SIGNAL	SIG_GMN_S_read				:	Unc_1D_array				(15 DOWNTO 0);
	SIGNAL	SIG_GMN_S_write				:	Unc_1D_array				(15 DOWNTO 0);
	SIGNAL	SIG_GMN_S_Add				:	Unc_1D_P_Addr_array			(15 DOWNTO 0);
	SIGNAL	SIG_GMN_S_Cnt				:	Unc_1D_P_Cont_array			(15 DOWNTO 0);
	SIGNAL	SIG_GMN_S_Dout				:	Unc_1D_P_Data_array			(15 DOWNTO 0);
	SIGNAL	SIG_GMN_S_Dout_rdy			:	Unc_1D_array				(15 DOWNTO 0);
	SIGNAL	SIG_GMN_S_Din				:	Unc_1D_P_Data_array			(15 DOWNTO 0);
	SIGNAL	SIG_GMN_S_Din_rdy			:	Unc_1D_array				(15 DOWNTO 0);
	SIGNAL	SIG_GMN_M_req				:	Unc_1D_array				(15 DOWNTO 0);
	SIGNAL	SIG_GMN_M_grant				:	Unc_1D_array				(15 DOWNTO 0);
	SIGNAL	SIG_GMN_M_done				:	Unc_1D_array				(15 DOWNTO 0);
	SIGNAL	SIG_GMN_M_wait				:	Unc_1D_array				(15 DOWNTO 0);
	SIGNAL	SIG_GMN_M_read				:	Unc_1D_array				(15 DOWNTO 0);
	SIGNAL	SIG_GMN_M_write				:	Unc_1D_array				(15 DOWNTO 0);
	SIGNAL	SIG_GMN_M_Add				:	Unc_1D_P_Addr_array			(15 DOWNTO 0);
	SIGNAL	SIG_GMN_M_Cnt				:	Unc_1D_P_Cont_array			(15 DOWNTO 0);
	SIGNAL	SIG_GMN_M_Din				:	Unc_1D_P_Data_array			(15 DOWNTO 0);
	SIGNAL	SIG_GMN_M_Din_rdy			:	Unc_1D_array				(15 DOWNTO 0);
	SIGNAL	SIG_GMN_M_Dout				:	Unc_1D_P_Data_array			(15 DOWNTO 0);
	SIGNAL	SIG_GMN_M_Dout_rdy			:	Unc_1D_array				(15 DOWNTO 0);
	------------------------------------------------------------------------
	------------------------------------------------------------------------
begin
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	--	INSTANCEs
	------------------------------------------------------------------------
	PLANE_GEN							:	FOR	p	IN	P_Number_of_Planes-1	DOWNTO	0	GENERATE
		Processing_Plane				:	PE_Plane
		PORT	MAP(
			clk							=>	clk,
			clk_w						=>	clk_w,
			rst							=>	rst								(p),
			rst_w						=>	rst_w,
			--	Config Holder
			CNF_ALL_Configurations		=>	CNF_ALL_Configurations			(p),
			--	Initiation
			------	STA	 &	UPA
			INI_Bias_val				=>	INI_Bias_val					(p),
			INI_Bias_Add				=>	INI_Bias_Add					(p),
			INI_Bias_Wen				=>	INI_Bias_Wen					(p),
			INI_Addresses				=>	INI_Addresses					(p),
			INI_Target_add				=>	INI_Target_add					(p),
			INI_Base_Wen				=>	INI_Base_Wen					(p),
			INI_Count_Wen				=>	INI_Count_Wen					(p),
			INI_IntVal_Wen				=>	INI_IntVal_Wen					(p),
			INI_SA_UAbar				=>	INI_SA_UAbar					(p),
			INI_SLU_unit_add			=>	INI_SLU_unit_add				(p),
			--	High Level
			------	PEs
			CMD_PEs_start				=>	CMD_PEs_start					(p),
			CMD_PEs_init_inc_Rows		=>	CMD_PEs_init_inc_Rows			(p),
			CMD_PEs_done				=>	CMD_PEs_done					(p),
			------	STA
			CMD_STA_ACK					=>	CMD_STA_ACK						(p),
			CMD_STA_load				=>	CMD_STA_load					(p),
			CMD_STA_MEM_en				=>	CMD_STA_MEM_en					(p),
			CMD_STA_OBM_en				=>	CMD_STA_OBM_en					(p),
			CMD_STA_BIS_en				=>	CMD_STA_BIS_en					(p),
			CMD_STA_save				=>	CMD_STA_save					(p),
			CMD_STA_active				=>	CMD_STA_active					(p),
			CMD_STA_store				=>	CMD_STA_store					(p),
			CMD_STA_load_UA				=>	CMD_STA_load_UA					(p),
			CMD_STA_stor_UA				=>	CMD_STA_stor_UA					(p),
			CMD_STA_done				=>	CMD_STA_done					(p),
			------	UPA
			CMD_UPA_Up_IFM				=>	CMD_UPA_Up_IFM					(p),
			CMD_UPA_Up_WFM				=>	CMD_UPA_Up_WFM					(p),
			CMD_UPA_status				=>	CMD_UPA_status					(p),
			CMD_UPA_done				=>	CMD_UPA_done					(p),
			--	CONTROL
			------	PAUSE
			CNT_PEs_PAUSE				=>	CNT_PEs_PAUSE					(p),
			CNT_STA_PAUSE				=>	CNT_STA_PAUSE					(p),
			CNT_UPA_PAUSE				=>	CNT_UPA_PAUSE					(p),
			--	Masters
			------	Update	Agent
			NAT_LMN_UPA_push			=>	SIG_PEP_UPA_push				(p),
			NAT_LMN_UPA_ack				=>	SIG_PEP_UPA_ack					(p),
			NAT_LMN_UPA_read			=>	SIG_PEP_UPA_read				(p),
			NAT_LMN_UPA_write			=>	SIG_PEP_UPA_write				(p),
			NAT_LMN_UPA_add				=>	SIG_PEP_UPA_add					(p),
			NAT_LMN_UPA_cnt				=>	SIG_PEP_UPA_cnt					(p),
			NAT_LMN_UPA_data_in			=>	SIG_PEP_UPA_data_in				(p),
			NAT_LMN_UPA_data_rdy		=>	SIG_PEP_UPA_data_rdy			(p),
			NAT_LMN_UPA_data_out		=>	SIG_PEP_UPA_data_out			(p),
			NAT_LMN_UPA_data_wen		=>	SIG_PEP_UPA_data_wen			(p),
			------	Store	Agent
			NAT_LMN_STA_wait			=>	SIG_PEP_STA_wait				(p),
			NAT_LMN_STA_push			=>	SIG_PEP_STA_push				(p),
			NAT_LMN_STA_ack				=>	SIG_PEP_STA_ack					(p),
			NAT_LMN_STA_read			=>	SIG_PEP_STA_read				(p),
			NAT_LMN_STA_write			=>	SIG_PEP_STA_write				(p),
			NAT_LMN_STA_add				=>	SIG_PEP_STA_add					(p),
			NAT_LMN_STA_cnt				=>	SIG_PEP_STA_cnt					(p),
			NAT_LMN_STA_data_in			=>	SIG_PEP_STA_data_in				(p),
			NAT_LMN_STA_data_rdy		=>	SIG_PEP_STA_data_rdy			(p),
			NAT_LMN_STA_data_out		=>	SIG_PEP_STA_data_out			(p),
			NAT_LMN_STA_data_wen		=>	SIG_PEP_STA_data_wen			(p));
	END GENERATE;
	------------------------------------------------------------------------
	LMN_ROW_GEN							:	FOR	r	IN	3	DOWNTO	0	GENERATE
		LMN_COL_GEN						:	FOR	c	IN	3	DOWNTO	0	GENERATE
			Local_Memory_Node			:	LMN
			GENERIC	MAP(
				LMN_ROW_POS				=>	r,
				LMN_COL_POS				=>	c)
			PORT	MAP(
				clk						=>	clk_w,
				rst						=>	rst_w,
				--	PE's	Update	Agent	Native Side
				NAT_UPA_ready			=>	OPEN,
				NAT_UPA_wait			=>	OPEN,
				NAT_UPA_push			=>	SIG_LMN_UPA_push				(r+1,c+1),
				NAT_UPA_ack				=>	SIG_LMN_UPA_ack					(r+1,c+1),
				NAT_UPA_read			=>	SIG_LMN_UPA_read				(r+1,c+1),
				NAT_UPA_write			=>	SIG_LMN_UPA_write				(r+1,c+1),
				NAT_UPA_Add				=>	SIG_LMN_UPA_add					(r+1,c+1),
				NAT_UPA_Cnt				=>	SIG_LMN_UPA_cnt					(r+1,c+1),
				NAT_UPA_data_out		=>	SIG_LMN_UPA_data_out			(r+1,c+1),
				NAT_UPA_data_rdy		=>	SIG_LMN_UPA_data_rdy			(r+1,c+1),
				NAT_UPA_data_in			=>	SIG_LMN_UPA_data_in				(r+1,c+1),
				NAT_UPA_data_wen		=>	SIG_LMN_UPA_data_wen			(r+1,c+1),
				--	PE's	Store	Agent	Native Side
				NAT_STA_ready			=>	OPEN,
				NAT_STA_wait			=>	SIG_LMN_STA_wait				(r+1,c+1),
				NAT_STA_push			=>	SIG_LMN_STA_push				(r+1,c+1),
				NAT_STA_ack				=>	SIG_LMN_STA_ack					(r+1,c+1),
				NAT_STA_read			=>	SIG_LMN_STA_read				(r+1,c+1),
				NAT_STA_write			=>	SIG_LMN_STA_write				(r+1,c+1),
				NAT_STA_Add				=>	SIG_LMN_STA_add					(r+1,c+1),
				NAT_STA_Cnt				=>	SIG_LMN_STA_cnt					(r+1,c+1),
				NAT_STA_data_out		=>	SIG_LMN_STA_data_out			(r+1,c+1),
				NAT_STA_data_rdy		=>	SIG_LMN_STA_data_rdy			(r+1,c+1),
				NAT_STA_data_in			=>	SIG_LMN_STA_data_in				(r+1,c+1),
				NAT_STA_data_wen		=>	SIG_LMN_STA_data_wen			(r+1,c+1),
				--	MPE		Native Side		
				NAT_MPEU_ready			=>	SIG_LMN_MPDR_ready				(r+1,c+1),
				NAT_MPEU_wait			=>	SIG_LMN_MPDR_wait				(r+1,c+1),
				NAT_MPEU_push			=>	SIG_LMN_MPDR_push				(r+1,c+1),
				NAT_MPEU_ack			=>	SIG_LMN_MPDR_ack				(r+1,c+1),
				NAT_MPEU_read			=>	SIG_LMN_MPDR_read				(r+1,c+1),
				NAT_MPEU_write			=>	SIG_LMN_MPDR_write				(r+1,c+1),
				NAT_MPEU_Add			=>	SIG_LMN_MPDR_Add				(r+1,c+1),
				NAT_MPEU_Cnt			=>	SIG_LMN_MPDR_Cnt				(r+1,c+1),
				NAT_MPEU_data_out		=>	SIG_LMN_MPDR_data_out			(r+1,c+1),
				NAT_MPEU_data_rdy		=>	SIG_LMN_MPDR_data_rdy			(r+1,c+1),
				NAT_MPEU_data_in		=>	SIG_LMN_MPDR_data_in			(r+1,c+1),
				NAT_MPEU_data_wen		=>	SIG_LMN_MPDR_data_wen			(r+1,c+1),
				--	OUT GATE	To	VC	(Master IN top Level)
				OGM_2VCU_req			=>	OGM_2VCU_req					(r,c),
				OGM_2VCU_grant			=>	OGM_2VCU_grant					(r,c),
				OGM_2VCU_done			=>	OGM_2VCU_done					(r,c),
				OGM_2VCU_wait			=>	OGM_2VCU_wait					(r,c),
				OGM_2VCU_read			=>	OGM_2VCU_read					(r,c),
				OGM_2VCU_write			=>	OGM_2VCU_write					(r,c),
				OGM_2VCU_Add			=>	OGM_2VCU_Add					(r,c),
				OGM_2VCU_Cnt			=>	OGM_2VCU_Cnt					(r,c),
				OGM_2VCU_MD_in			=>	OGM_2VCU_MD_in					(r,c),
				OGM_2VCU_MD_in_rdy		=>	OGM_2VCU_MD_in_rdy				(r,c),
				OGM_2VCU_MD_out			=>	OGM_2VCU_MD_out					(r,c),
				OGM_2VCU_MD_out_rdy		=>	OGM_2VCU_MD_out_rdy				(r,c),
				--	OUT GATE	To	GMN	(Master IN top Level)
				OGM_2GMN_req			=>	SIG_GMN_M_req					(4*r+c),
				OGM_2GMN_grant			=>	SIG_GMN_M_grant					(4*r+c),
				OGM_2GMN_done			=>	SIG_GMN_M_done					(4*r+c),
				OGM_2GMN_wait			=>	SIG_GMN_M_wait					(4*r+c),
				OGM_2GMN_read			=>	SIG_GMN_M_read					(4*r+c),
				OGM_2GMN_write			=>	SIG_GMN_M_write					(4*r+c),
				OGM_2GMN_Add			=>	SIG_GMN_M_Add					(4*r+c),
				OGM_2GMN_Cnt			=>	SIG_GMN_M_Cnt					(4*r+c),
				OGM_2GMN_MD_in			=>	SIG_GMN_M_Din					(4*r+c),
				OGM_2GMN_MD_in_rdy		=>	SIG_GMN_M_Din_rdy				(4*r+c),
				OGM_2GMN_MD_out			=>	SIG_GMN_M_Dout					(4*r+c),
				OGM_2GMN_MD_out_rdy		=>	SIG_GMN_M_Dout_rdy				(4*r+c),
				--	IN GATE		TO	GMN	(Slave IN top Level)
				IGM_2GMN_CS				=>	SIG_GMN_S_CS					(4*r+c),
				IGM_2GMN_done			=>	SIG_GMN_S_done					(4*r+c),
				IGM_2GMN_wait			=>	SIG_GMN_S_wait					(4*r+c),
				IGM_2GMN_read			=>	SIG_GMN_S_read					(4*r+c),
				IGM_2GMN_write			=>	SIG_GMN_S_write					(4*r+c),
				IGM_2GMN_Add			=>	SIG_GMN_S_Add					(4*r+c),
				IGM_2GMN_Cnt			=>	SIG_GMN_S_Cnt					(4*r+c),
				IGM_2GMN_SD_out			=>	SIG_GMN_S_Dout					(4*r+c),
				IGM_2GMN_SD_out_rdy		=>	SIG_GMN_S_Dout_rdy				(4*r+c),
				IGM_2GMN_SD_in			=>	SIG_GMN_S_Din					(4*r+c),
				IGM_2GMN_SD_in_rdy		=>	SIG_GMN_S_Din_rdy				(4*r+c),
				--	DMA	Transaction Port
				TR_start				=>	CMD_DMA_start					(r,c),
				TR_ready				=>	CMD_DMA_ready					(r,c),
				TR_R_Add				=>	CMD_DMA_R_Add					(r,c),
				TR_R_Cnt				=>	CMD_DMA_R_Cnt					(r,c),
				TR_W_Add				=>	CMD_DMA_W_Add					(r,c),
				TR_W_Cnt				=>	CMD_DMA_W_Cnt					(r,c));
		END GENERATE;
	END GENERATE;
	------------------------------------------------------------------------
	Global_Memory_Node					:	GMN
	PORT	MAP(
		clk_w							=>	clk_w,
		rst_w							=>	rst_w,
		--	LMN IN Gates' Slave
		GMN_S_CS						=>	SIG_GMN_S_CS,
		GMN_S_done						=>	SIG_GMN_S_done,
		GMN_S_wait						=>	SIG_GMN_S_wait,
		GMN_S_read						=>	SIG_GMN_S_read,
		GMN_S_write						=>	SIG_GMN_S_write,
		GMN_S_Add						=>	SIG_GMN_S_Add,
		GMN_S_Cnt						=>	SIG_GMN_S_Cnt,
		GMN_S_Dout						=>	SIG_GMN_S_Din,
		GMN_S_Dout_rdy					=>	SIG_GMN_S_Din_rdy,
		GMN_S_Din						=>	SIG_GMN_S_Dout,
		GMN_S_Din_rdy					=>	SIG_GMN_S_Dout_rdy,
		--	LMN	Out Gates' Master
		GMN_M_req						=>	SIG_GMN_M_req,
		GMN_M_grant						=>	SIG_GMN_M_grant,
		GMN_M_done						=>	SIG_GMN_M_done,
		GMN_M_wait						=>	SIG_GMN_M_wait,
		GMN_M_read						=>	SIG_GMN_M_read,
		GMN_M_write						=>	SIG_GMN_M_write,
		GMN_M_Add						=>	SIG_GMN_M_Add,
		GMN_M_Cnt						=>	SIG_GMN_M_Cnt,
		GMN_M_Din						=>	SIG_GMN_M_Dout,
		GMN_M_Din_rdy					=>	SIG_GMN_M_Dout_rdy,
		GMN_M_Dout						=>	SIG_GMN_M_Din,
		GMN_M_Dout_rdy					=>	SIG_GMN_M_Din_rdy);
	------------------------------------------------------------------------
	MPDR_ROW_GEN							:	FOR	r	IN	3	DOWNTO	0	GENERATE
		MPDR_COL_GEN						:	FOR	c	IN	3	DOWNTO	0	GENERATE
			MPDR_Unit					:	MPDR 
			PORT	MAP(
				clk_w					=>	clk_w,
				rst_w					=>	rst_w,
				--	Control
				CNT_start				=>	CMD_MPDR_start					(r,c),
				CNT_done				=>	CMD_MPDR_Done					(r,c),
				CNT_load				=>	CMD_MPDR_load					(r,c),
				CNT_Addresses			=>	CMD_MPDR_Addresses,
				CNT_Target				=>	CMD_MPDR_Target,
				CNT_Base_Wen			=>	CMD_MPDR_Base_Wen				(r,c),
				CNT_Cont_Wen			=>	CMD_MPDR_Cont_Wen				(r,c),
				CNT_IVal_Wen			=>	CMD_MPDR_IVal_Wen				(r,c),
				--	Config
				CNT_MAX_Col				=>	CMD_MPDR_MAX_Col,
				CNT_MAX_Chn				=>	CMD_MPDR_MAX_Chn,
				--	TO LMN
				LL_ready				=>	SIG_LMN_MPDR_ready				(r+1,c+1),
				LL_wait					=>	SIG_LMN_MPDR_wait				(r+1,c+1),
				LL_push					=>	SIG_LMN_MPDR_push				(r+1,c+1),
				LL_ack					=>	SIG_LMN_MPDR_ack				(r+1,c+1),
				LL_read					=>	SIG_LMN_MPDR_read				(r+1,c+1),
				LL_write				=>	SIG_LMN_MPDR_write				(r+1,c+1),
				LL_add					=>	SIG_LMN_MPDR_Add				(r+1,c+1),
				LL_cnt					=>	SIG_LMN_MPDR_Cnt				(r+1,c+1),
				LL_data_in				=>	SIG_LMN_MPDR_data_out			(r+1,c+1),
				LL_data_rdy				=>	SIG_LMN_MPDR_data_rdy			(r+1,c+1),
				LL_data_out				=>	SIG_LMN_MPDR_data_in			(r+1,c+1),
				LL_data_wen				=>	SIG_LMN_MPDR_data_wen			(r+1,c+1));
		END GENERATE;
	END GENERATE;
	------------------------------------------------------------------------
	rst(0)	<=	rst_in	OR	NOT ACCELERATOR_P0_NORMAL;
	rst(1)	<=	rst_in	OR	NOT ACCELERATOR_P1_NORMAL;
	rst(2)	<=	rst_in	OR	NOT ACCELERATOR_P2_NORMAL;
	rst(3)	<=	rst_in	OR	NOT ACCELERATOR_P3_NORMAL;
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	PLANE_CON_GEN									:	FOR	p	IN	P_Number_of_Planes-1	DOWNTO	0	GENERATE
		ROW_CON_GEN									:	FOR	r	IN	4						DOWNTO	1	GENERATE
			COL_CON_GEN								:	FOR	c	IN	4						DOWNTO	1	GENERATE
				SIG_LMN_UPA_push		(r,c)(p)	<=	SIG_PEP_UPA_push			(p)(r,c);
				SIG_PEP_UPA_ack			(p)(r,c)	<=	SIG_LMN_UPA_ack				(r,c)(p);
				SIG_LMN_UPA_read		(r,c)(p)	<=	SIG_PEP_UPA_read			(p)(r,c);
				SIG_LMN_UPA_write		(r,c)(p)	<=	SIG_PEP_UPA_write			(p)(r,c);
				SIG_LMN_UPA_add			(r,c)(p)	<=	SIG_PEP_UPA_add				(p)(r,c);
				SIG_LMN_UPA_cnt			(r,c)(p)	<=	SIG_PEP_UPA_cnt				(p)(r,c);
				SIG_PEP_UPA_data_in		(p)(r,c)	<=	SIG_LMN_UPA_data_out		(r,c)(p);
				SIG_PEP_UPA_data_rdy	(p)(r,c)	<=	SIG_LMN_UPA_data_rdy		(r,c)(p);
				SIG_LMN_UPA_data_in		(r,c)(p)	<=	SIG_PEP_UPA_data_out		(p)(r,c);
				SIG_LMN_UPA_data_wen	(r,c)(p)	<=	SIG_PEP_UPA_data_wen		(p)(r,c);
				SIG_PEP_STA_wait		(p)(r,c)	<=	SIG_LMN_STA_wait			(r,c)(p);
				SIG_LMN_STA_push		(r,c)(p)	<=	SIG_PEP_STA_push			(p)(r,c);
				SIG_PEP_STA_ack			(p)(r,c)	<=	SIG_LMN_STA_ack				(r,c)(p);
				SIG_LMN_STA_read		(r,c)(p)	<=	SIG_PEP_STA_read			(p)(r,c);
				SIG_LMN_STA_write		(r,c)(p)	<=	SIG_PEP_STA_write			(p)(r,c);
				SIG_LMN_STA_add			(r,c)(p)	<=	SIG_PEP_STA_add				(p)(r,c);
				SIG_LMN_STA_cnt			(r,c)(p)	<=	SIG_PEP_STA_cnt				(p)(r,c);
				SIG_PEP_STA_data_in		(p)(r,c)	<=	SIG_LMN_STA_data_out		(r,c)(p);
				SIG_PEP_STA_data_rdy	(p)(r,c)	<=	SIG_LMN_STA_data_rdy		(r,c)(p);
				SIG_LMN_STA_data_in		(r,c)(p)	<=	SIG_PEP_STA_data_out		(p)(r,c);
				SIG_LMN_STA_data_wen	(r,c)(p)	<=	SIG_PEP_STA_data_wen		(p)(r,c);
			END GENERATE;
		END GENERATE;
	END GENERATE;
	------------------------------------------------------------------------
	------------------------------------------------------------------------
end Behavioral;

