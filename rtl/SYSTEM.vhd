library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.my_pack_v2.ALL;
USE IEEE.math_real.ALL;

entity SYSTEM is 
	GENERIC(
		DNoC_BASE_ADDRESS				:	INTEGER			:=	my_to_uint(X"00000000"));
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		
		--	CONFIG
		ACCELERATOR_CONNECT				:	OUT	std_logic;
		
		
		--	Tx line
		Rx_Rx							:	IN	std_logic;
		Tx_Tx							:	OUT	std_logic;
		
		
		--	NoC
		------	DRAM MEMORY NoC
		DNoC_PORT_clk					:	IN	std_logic;
		DNoC_PORT_Dot_Rdy				:	OUT	std_logic;
		DNoC_PORT_SEL_This				:	OUT	std_logic;
		DNoC_PORT_Address				:	IN	std_logic_vector(31	DOWNTO	0);
		DNoC_PORT_Data_in				:	IN	std_logic_vector(31	DOWNTO	0);
		DNoC_PORT_WEN					:	IN	std_logic;
		DNoC_PORT_OEN					:	IN	std_logic;
		DNoC_PORT_Data_out				:	OUT	std_logic_vector(31	DOWNTO	0);
		------	CONTROL
		RUN_SYS_ALLOW					:	IN	std_logic;
		INT_REQ_SYS_PC					:	IN	std_logic;
		INT_ACK_SYS_PC					:	OUT	std_logic;
		
		
		--	To Vault Controller 
		--	OCM	Memory	(to out of chip memory controller)
		------	Out Gate	to Memory Controller Unit
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
end SYSTEM;
 
architecture Behavioral of SYSTEM is
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--	COMPONENTS
	--------------------------------------------------------------------------
	COMPONENT	Scheduler
	GENERIC(
		DNoC_BASE_ADDRESS				:	INTEGER			:=	my_to_uint(X"00000000"));
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		--	Configs
		CNF_ALL_Configurations			:	OUT	Plane_all_configs_type;
		ACCELERATOR_P0_NORMAL			:	OUT	std_logic;
		ACCELERATOR_P1_NORMAL			:	OUT	std_logic;
		ACCELERATOR_P2_NORMAL			:	OUT	std_logic;
		ACCELERATOR_P3_NORMAL			:	OUT	std_logic;
		ACCELERATOR_CONNECT				:	OUT	std_logic;
		--	Initiation
		------	STA	 &	UPA
		INI_Bias_val					:	OUT	Unc_1D_P_Data_array	(P_Number_of_Planes-1	DOWNTO	0);	--	Store Agent Only
		INI_Bias_Add					:	OUT	Unc_1D_P_Kern_array	(P_Number_of_Planes-1	DOWNTO	0);	--	Store Agent Only
		INI_Bias_Wen					:	OUT	Unc_1D_array		(P_Number_of_Planes-1	DOWNTO	0);	--	Store Agent Only
		INI_Addresses					:	OUT	Unc_1D_P_Addr_array	(P_Number_of_Planes-1	DOWNTO	0);	--	shared
		INI_Target_add					:	OUT	Unc_1D_4bit_array	(P_Number_of_Planes-1	DOWNTO	0);	--	shared
		INI_Base_Wen					:	OUT	Unc_1D_array		(P_Number_of_Planes-1	DOWNTO	0);	--	shared
		INI_Count_Wen					:	OUT	Unc_1D_array		(P_Number_of_Planes-1	DOWNTO	0);	--	shared
		INI_IntVal_Wen					:	OUT	Unc_1D_array		(P_Number_of_Planes-1	DOWNTO	0);	--	shared
		INI_SA_UAbar					:	OUT	Unc_1D_array		(P_Number_of_Planes-1	DOWNTO	0);	--	SA ~UA Selector
		INI_SLU_unit_add				:	OUT	Unc_1D_4bit_array	(P_Number_of_Planes-1	DOWNTO	0);	--	PE address r,c
		--	High Level  
		------	PEs
		CMD_PEs_start					:	OUT	Plane_std_logic_4X4;				--(flip)	simple start
		CMD_PEs_init_inc_Rows			:	OUT	Plane_std_logic_4X4V3;				--(flag)	inc row select
		CMD_PEs_done					:	IN	Plane_std_logic_4X4;
		------	STA		
		CMD_STA_ACK						:	OUT	Plane_std_logic_4X4;				--(flip)	scheduler tells STA that the DMA transfers data and ready to accept another chunk
		CMD_STA_load					:	OUT	Plane_std_logic_4X4;				--(flip)	load a row data from memory
		CMD_STA_MEM_en					:	OUT	Plane_std_logic_4X4;				--(flip)	accumulate with internal memory content
		CMD_STA_OBM_en					:	OUT	Plane_std_logic_4X4;				--(flip)	accumulate with OBM content
		CMD_STA_BIS_en					:	OUT	Plane_std_logic_4X4;				--(flip)	accumulate with BIAS
		CMD_STA_save					:	OUT	Plane_std_logic_4X4;				--(flip)	save the result in the internal memory
		CMD_STA_active					:	OUT	Plane_std_logic_4X4;				--(flip)	pass through activation function module
		CMD_STA_store					:	OUT	Plane_std_logic_4X4;				--(flip)	store the row in memory
		CMD_STA_load_UA					:	OUT	Plane_std_logic_4X4;				--(flip)	update BASE ADDRESS of load  pointer 
		CMD_STA_stor_UA					:	OUT	Plane_std_logic_4X4;				--(flip)	update BASE ADDRESS of store pointer 
		CMD_STA_done					:	IN	Plane_std_logic_4X4;
		------	UPA		
		CMD_UPA_Up_IFM					:	OUT	Plane_std_logic_4X4;				--(flip)	update input feature map buffers
		CMD_UPA_Up_WFM					:	OUT	Plane_std_logic_4X4;				--(flip)	update weigh buffers
		CMD_UPA_status					:	IN	Plane_std_logic_4X4V2;				--			status of UPA
		CMD_UPA_done					:	IN	Plane_std_logic_4X4;
		--	CONTROL
		------	PAUSE
		CNT_PEs_PAUSE					:	OUT	Plane_std_logic_4X4;				--(flip)
		CNT_STA_PAUSE					:	OUT	Plane_std_logic_4X4;				--(flip)
		CNT_UPA_PAUSE					:	OUT	Plane_std_logic_4X4;				--(flip)
		--	DMA
		CMD_DMA_start					:	OUT	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	--(flag)
		CMD_DMA_ready					:	IN	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	
		CMD_DMA_R_Add					:	OUT	Unc_2D_P_Addr_array	(3	DOWNTO	0,	3	DOWNTO 0);	--(regs)
		CMD_DMA_R_Cnt					:	OUT	Unc_2D_P_Cont_array	(3	DOWNTO	0,	3	DOWNTO 0);	--(regs)
		CMD_DMA_W_Add					:	OUT	Unc_2D_P_Addr_array	(3	DOWNTO	0,	3	DOWNTO 0);	--(regs)
		CMD_DMA_W_Cnt					:	OUT	Unc_2D_P_Cont_array	(3	DOWNTO	0,	3	DOWNTO 0);	--(regs)
		--	MPDR 
		CMD_MPDR_start					:	OUT	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	--(flag)
		CMD_MPDR_Done					:	IN	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	
		CMD_MPDR_load					:	OUT	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	--(flag)
		CMD_MPDR_Addresses				:	OUT	std_logic_vector	(P_USA_Add_size-1	DOWNTO 0);
		CMD_MPDR_Target					:	OUT	std_logic_vector	(2	DOWNTO 0);	
		CMD_MPDR_Base_Wen				:	OUT	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	
		CMD_MPDR_Cont_Wen				:	OUT	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	
		CMD_MPDR_IVal_Wen				:	OUT	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	
		CMD_MPDR_MAX_Col				:	OUT	std_logic_vector	(P_column_size-1	DOWNTO 0);
		CMD_MPDR_MAX_Chn				:	OUT	std_logic_vector	(P_channel_size-1	DOWNTO 0);
		--	Tx line
		Rx_Rx							:	IN	std_logic;
		Tx_Tx							:	OUT	std_logic;
		--	DRAM NoC PORT
		DNoC_PORT_clk					:	IN	std_logic;
		DNoC_PORT_Dot_Rdy				:	OUT	std_logic;
		DNoC_PORT_SEL_This				:	OUT	std_logic;
		DNoC_PORT_Address				:	IN	std_logic_vector(31	DOWNTO	0);
		DNoC_PORT_Data_in				:	IN	std_logic_vector(31	DOWNTO	0);
		DNoC_PORT_WEN					:	IN	std_logic;
		DNoC_PORT_OEN					:	IN	std_logic;
		DNoC_PORT_Data_out				:	OUT	std_logic_vector(31	DOWNTO	0);
		--	CONTROL
		RUN_SYS_ALLOW					:	IN	std_logic;
		INT_REQ_SYS_PC					:	IN	std_logic;
		INT_ACK_SYS_PC					:	OUT	std_logic);
	END COMPONENT;
	--------------------------------------------------------------------------
	COMPONENT	Accelerator 
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
	END	COMPONENT;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--	SIGNALs
	--------------------------------------------------------------------------
	--	Configuration
	SIGNAL	CNF_ALL_Configurations		:	Plane_all_configs_type;
	SIGNAL	ACCELERATOR_P0_NORMAL		:	std_logic;
	SIGNAL	ACCELERATOR_P1_NORMAL		:	std_logic;
	SIGNAL	ACCELERATOR_P2_NORMAL		:	std_logic;
	SIGNAL	ACCELERATOR_P3_NORMAL		:	std_logic;
	--	Initiation
	------	STA	 &	UPA
	SIGNAL	INI_Bias_val				:	Unc_1D_P_Data_array	(P_Number_of_Planes-1	DOWNTO	0);	--	Store Agent Only
	SIGNAL	INI_Bias_Add				:	Unc_1D_P_Kern_array	(P_Number_of_Planes-1	DOWNTO	0);	--	Store Agent Only
	SIGNAL	INI_Bias_Wen				:	Unc_1D_array		(P_Number_of_Planes-1	DOWNTO	0);	--	Store Agent Only
	SIGNAL	INI_Addresses				:	Unc_1D_P_Addr_array	(P_Number_of_Planes-1	DOWNTO	0);	--	shared
	SIGNAL	INI_Target_add				:	Unc_1D_4bit_array	(P_Number_of_Planes-1	DOWNTO	0);	--	shared
	SIGNAL	INI_Base_Wen				:	Unc_1D_array		(P_Number_of_Planes-1	DOWNTO	0);	--	shared
	SIGNAL	INI_Count_Wen				:	Unc_1D_array		(P_Number_of_Planes-1	DOWNTO	0);	--	shared
	SIGNAL	INI_IntVal_Wen				:	Unc_1D_array		(P_Number_of_Planes-1	DOWNTO	0);	--	shared
	SIGNAL	INI_SA_UAbar				:	Unc_1D_array		(P_Number_of_Planes-1	DOWNTO	0);	--	SA ~UA Selector
	SIGNAL	INI_SLU_unit_add			:	Unc_1D_4bit_array	(P_Number_of_Planes-1	DOWNTO	0);	--	PE address r,c
	--	High Level  
	------	PEs
	SIGNAL	CMD_PEs_start				:	Plane_std_logic_4X4;		--(flip)	simple start
	SIGNAL	CMD_PEs_init_inc_Rows		:	Plane_std_logic_4X4V3;		--(flag)	inc row select
	SIGNAL	CMD_PEs_done				:	Plane_std_logic_4X4;
	------	STA		
	SIGNAL	CMD_STA_ACK					:	Plane_std_logic_4X4;		--(flip)	scheduler tells STA that the DMA transfers data and ready to accept another chunk
	SIGNAL	CMD_STA_load				:	Plane_std_logic_4X4;		--(flip)	load a row data from memory
	SIGNAL	CMD_STA_MEM_en				:	Plane_std_logic_4X4;		--(flip)	accumulate with internal memory content
	SIGNAL	CMD_STA_OBM_en				:	Plane_std_logic_4X4;		--(flip)	accumulate with OBM content
	SIGNAL	CMD_STA_BIS_en				:	Plane_std_logic_4X4;		--(flip)	accumulate with BIAS
	SIGNAL	CMD_STA_save				:	Plane_std_logic_4X4;		--(flip)	save the result in the internal memory
	SIGNAL	CMD_STA_active				:	Plane_std_logic_4X4;		--(flip)	pass through activation function module
	SIGNAL	CMD_STA_store				:	Plane_std_logic_4X4;		--(flip)	store the row in memory
	SIGNAL	CMD_STA_load_UA				:	Plane_std_logic_4X4;		--(flip)	update BASE ADDRESS of load  pointer 
	SIGNAL	CMD_STA_stor_UA				:	Plane_std_logic_4X4;		--(flip)	update BASE ADDRESS of store pointer 
	SIGNAL	CMD_STA_done				:	Plane_std_logic_4X4;
	------	UPA		
	SIGNAL	CMD_UPA_Up_IFM				:	Plane_std_logic_4X4;		--(flip)	update input feature map buffers
	SIGNAL	CMD_UPA_Up_WFM				:	Plane_std_logic_4X4;		--(flip)	update weigh buffers
	SIGNAL	CMD_UPA_status				:	Plane_std_logic_4X4V2;		--			status of UPA
	SIGNAL	CMD_UPA_done				:	Plane_std_logic_4X4;
	--	CONTROL
	------	PAUSE
	SIGNAL	CNT_PEs_PAUSE				:	Plane_std_logic_4X4;		--(flip)
	SIGNAL	CNT_STA_PAUSE				:	Plane_std_logic_4X4;		--(flip)
	SIGNAL	CNT_UPA_PAUSE				:	Plane_std_logic_4X4;		--(flip)
	------	DMA
	SIGNAL	CMD_DMA_start				:	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);				
	SIGNAL	CMD_DMA_ready				:	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	
	SIGNAL	CMD_DMA_R_Add				:	Unc_2D_P_Addr_array	(3	DOWNTO	0,	3	DOWNTO 0);	--(regs)
	SIGNAL	CMD_DMA_R_Cnt				:	Unc_2D_P_Cont_array	(3	DOWNTO	0,	3	DOWNTO 0);	--(regs)
	SIGNAL	CMD_DMA_W_Add				:	Unc_2D_P_Addr_array	(3	DOWNTO	0,	3	DOWNTO 0);	--(regs)
	SIGNAL	CMD_DMA_W_Cnt				:	Unc_2D_P_Cont_array	(3	DOWNTO	0,	3	DOWNTO 0);	--(regs)
	------	MPDR 
	SIGNAL	CMD_MPDR_start				:	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	--(flag)
	SIGNAL	CMD_MPDR_Done				:	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	
	SIGNAL	CMD_MPDR_load				:	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	--(flag)
	SIGNAL	CMD_MPDR_Addresses			:	std_logic_vector	(P_USA_Add_size-1	DOWNTO 0);
	SIGNAL	CMD_MPDR_Target				:	std_logic_vector	(2	DOWNTO 0);	
	SIGNAL	CMD_MPDR_Base_Wen			:	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	
	SIGNAL	CMD_MPDR_Cont_Wen			:	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	
	SIGNAL	CMD_MPDR_IVal_Wen			:	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	
	SIGNAL	CMD_MPDR_MAX_Col			:	std_logic_vector	(P_column_size-1	DOWNTO 0);
	SIGNAL	CMD_MPDR_MAX_Chn			:	std_logic_vector	(P_channel_size-1	DOWNTO 0);
	--------------------------------------------------------------------------
	SIGNAL	SCHEDULER_clk				:	std_logic;
	SIGNAL	SCHEDULER_rst				:	std_logic;
	SIGNAL	ACCELERATOR_clk				:	std_logic;
	SIGNAL	ACCELERATOR_rst				:	std_logic;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
begin
	--------------------------------------------------------------------------
	--	INSTANCEs
	--------------------------------------------------------------------------
	Scheduler_Unit						:	Scheduler
	GENERIC	MAP(
		DNoC_BASE_ADDRESS				=>	my_to_uint(X"00000000"))
	PORT	MAP(
		clk								=>	SCHEDULER_clk,
		rst								=>	SCHEDULER_rst,
		--	Configs
		CNF_ALL_Configurations			=>	CNF_ALL_Configurations,
		ACCELERATOR_P0_NORMAL			=>	ACCELERATOR_P0_NORMAL,
		ACCELERATOR_P1_NORMAL			=>	ACCELERATOR_P1_NORMAL,
		ACCELERATOR_P2_NORMAL			=>	ACCELERATOR_P2_NORMAL,
		ACCELERATOR_P3_NORMAL			=>	ACCELERATOR_P3_NORMAL,
		ACCELERATOR_CONNECT				=>	ACCELERATOR_CONNECT,
		--	Initiation
		------	STA	 &	UPA
		INI_Bias_val					=>	INI_Bias_val,
		INI_Bias_Add					=>	INI_Bias_Add,
		INI_Bias_Wen					=>	INI_Bias_Wen,
		INI_Addresses					=>	INI_Addresses,
		INI_Target_add					=>	INI_Target_add,
		INI_Base_Wen					=>	INI_Base_Wen,
		INI_Count_Wen					=>	INI_Count_Wen,
		INI_IntVal_Wen					=>	INI_IntVal_Wen,
		INI_SA_UAbar					=>	INI_SA_UAbar,
		INI_SLU_unit_add				=>	INI_SLU_unit_add,
		--	High Level  
		------	PEs
		CMD_PEs_start					=>	CMD_PEs_start,
		CMD_PEs_init_inc_Rows			=>	CMD_PEs_init_inc_Rows,
		CMD_PEs_done					=>	CMD_PEs_done,
		------	STA		
		CMD_STA_ACK						=>	CMD_STA_ACK,
		CMD_STA_load					=>	CMD_STA_load,
		CMD_STA_MEM_en					=>	CMD_STA_MEM_en,
		CMD_STA_OBM_en					=>	CMD_STA_OBM_en,
		CMD_STA_BIS_en					=>	CMD_STA_BIS_en,
		CMD_STA_save					=>	CMD_STA_save,
		CMD_STA_active					=>	CMD_STA_active,
		CMD_STA_store					=>	CMD_STA_store,
		CMD_STA_load_UA					=>	CMD_STA_load_UA,
		CMD_STA_stor_UA					=>	CMD_STA_stor_UA,
		CMD_STA_done					=>	CMD_STA_done,
		------	UPA		
		CMD_UPA_Up_IFM					=>	CMD_UPA_Up_IFM,
		CMD_UPA_Up_WFM					=>	CMD_UPA_Up_WFM,
		CMD_UPA_status					=>	CMD_UPA_status,
		CMD_UPA_done					=>	CMD_UPA_done,
		--	CONTROL
		------	PAUSE
		CNT_PEs_PAUSE					=>	CNT_PEs_PAUSE,
		CNT_STA_PAUSE					=>	CNT_STA_PAUSE,
		CNT_UPA_PAUSE					=>	CNT_UPA_PAUSE,
		--	DMA
		CMD_DMA_start					=>	CMD_DMA_start,
		CMD_DMA_ready					=>	CMD_DMA_ready,
		CMD_DMA_R_Add					=>	CMD_DMA_R_Add,
		CMD_DMA_R_Cnt					=>	CMD_DMA_R_Cnt,
		CMD_DMA_W_Add					=>	CMD_DMA_W_Add,
		CMD_DMA_W_Cnt					=>	CMD_DMA_W_Cnt,
		--	MPDR 
		CMD_MPDR_start					=>	CMD_MPDR_start,
		CMD_MPDR_Done					=>	CMD_MPDR_Done,
		CMD_MPDR_load					=>	CMD_MPDR_load,
		CMD_MPDR_Addresses				=>	CMD_MPDR_Addresses,
		CMD_MPDR_Target					=>	CMD_MPDR_Target,
		CMD_MPDR_Base_Wen				=>	CMD_MPDR_Base_Wen,
		CMD_MPDR_Cont_Wen				=>	CMD_MPDR_Cont_Wen,
		CMD_MPDR_IVal_Wen				=>	CMD_MPDR_IVal_Wen,
		CMD_MPDR_MAX_Col				=>	CMD_MPDR_MAX_Col,
		CMD_MPDR_MAX_Chn				=>	CMD_MPDR_MAX_Chn,
		--	Tx line
		Rx_Rx							=>	Rx_Rx,
		Tx_Tx							=>	Tx_Tx,
		--	DRAM NoC PORT
		DNoC_PORT_clk					=>	DNoC_PORT_clk,
		DNoC_PORT_Dot_Rdy				=>	DNoC_PORT_Dot_Rdy,
		DNoC_PORT_SEL_This				=>	DNoC_PORT_SEL_This,
		DNoC_PORT_Address				=>	DNoC_PORT_Address,
		DNoC_PORT_Data_in				=>	DNoC_PORT_Data_in,
		DNoC_PORT_WEN					=>	DNoC_PORT_WEN,
		DNoC_PORT_OEN					=>	DNoC_PORT_OEN,
		DNoC_PORT_Data_out				=>	DNoC_PORT_Data_out,
		--	CONTROL
		RUN_SYS_ALLOW					=>	RUN_SYS_ALLOW,
		INT_REQ_SYS_PC					=>	INT_REQ_SYS_PC,
		INT_ACK_SYS_PC					=>	INT_ACK_SYS_PC);
	--------------------------------------------------------------------------
	Accelerator_Unit					:	Accelerator
	PORT	MAP(
		clk								=>	ACCELERATOR_clk,
		clk_w							=>	ACCELERATOR_clk,
		rst_in							=>	ACCELERATOR_rst,
		rst_w							=>	ACCELERATOR_rst,
		ACCELERATOR_P0_NORMAL			=>	ACCELERATOR_P0_NORMAL,
		ACCELERATOR_P1_NORMAL			=>	ACCELERATOR_P1_NORMAL,
		ACCELERATOR_P2_NORMAL			=>	ACCELERATOR_P2_NORMAL,
		ACCELERATOR_P3_NORMAL			=>	ACCELERATOR_P3_NORMAL,
		--	Config Holder
		CNF_ALL_Configurations			=>	CNF_ALL_Configurations,
		--	Initiation
		------	STA	 &	UPA
		INI_Bias_val					=>	INI_Bias_val,
		INI_Bias_Add					=>	INI_Bias_Add,
		INI_Bias_Wen					=>	INI_Bias_Wen,
		INI_Addresses					=>	INI_Addresses,
		INI_Target_add					=>	INI_Target_add,
		INI_Base_Wen					=>	INI_Base_Wen,
		INI_Count_Wen					=>	INI_Count_Wen,
		INI_IntVal_Wen					=>	INI_IntVal_Wen,
		INI_SA_UAbar					=>	INI_SA_UAbar,
		INI_SLU_unit_add				=>	INI_SLU_unit_add,
		--	High Level  
		------	PEs
		CMD_PEs_start					=>	CMD_PEs_start,
		CMD_PEs_init_inc_Rows			=>	CMD_PEs_init_inc_Rows,
		CMD_PEs_done					=>	CMD_PEs_done,
		------	STA		
		CMD_STA_ACK						=>	CMD_STA_ACK,
		CMD_STA_load					=>	CMD_STA_load,
		CMD_STA_MEM_en					=>	CMD_STA_MEM_en,
		CMD_STA_OBM_en					=>	CMD_STA_OBM_en,
		CMD_STA_BIS_en					=>	CMD_STA_BIS_en,
		CMD_STA_save					=>	CMD_STA_save,
		CMD_STA_active					=>	CMD_STA_active,
		CMD_STA_store					=>	CMD_STA_store,
		CMD_STA_load_UA					=>	CMD_STA_load_UA,
		CMD_STA_stor_UA					=>	CMD_STA_stor_UA,
		CMD_STA_done					=>	CMD_STA_done,
		------	UPA		
		CMD_UPA_Up_IFM					=>	CMD_UPA_Up_IFM,
		CMD_UPA_Up_WFM					=>	CMD_UPA_Up_WFM,
		CMD_UPA_status					=>	CMD_UPA_status,
		CMD_UPA_done					=>	CMD_UPA_done,
		--	CONTROL
		------	PAUSE
		CNT_PEs_PAUSE					=>	CNT_PEs_PAUSE,
		CNT_STA_PAUSE					=>	CNT_STA_PAUSE,
		CNT_UPA_PAUSE					=>	CNT_UPA_PAUSE,
		--	DMA
		CMD_DMA_start					=>	CMD_DMA_start,
		CMD_DMA_ready					=>	CMD_DMA_ready,
		CMD_DMA_R_Add					=>	CMD_DMA_R_Add,
		CMD_DMA_R_Cnt					=>	CMD_DMA_R_Cnt,
		CMD_DMA_W_Add					=>	CMD_DMA_W_Add,
		CMD_DMA_W_Cnt					=>	CMD_DMA_W_Cnt,
		
		--	MPDR 
		CMD_MPDR_start					=>	CMD_MPDR_start,
		CMD_MPDR_Done					=>	CMD_MPDR_Done,
		CMD_MPDR_load					=>	CMD_MPDR_load,
		CMD_MPDR_Addresses				=>	CMD_MPDR_Addresses,
		CMD_MPDR_Target					=>	CMD_MPDR_Target,
		CMD_MPDR_Base_Wen				=>	CMD_MPDR_Base_Wen,
		CMD_MPDR_Cont_Wen				=>	CMD_MPDR_Cont_Wen,
		CMD_MPDR_IVal_Wen				=>	CMD_MPDR_IVal_Wen,
		CMD_MPDR_MAX_Col				=>	CMD_MPDR_MAX_Col,
		CMD_MPDR_MAX_Chn				=>	CMD_MPDR_MAX_Chn,
		
		--	to	VC
		OGM_2VCU_req					=>	OGM_2VCU_req,
		OGM_2VCU_grant					=>	OGM_2VCU_grant,
		OGM_2VCU_done					=>	OGM_2VCU_done,
		OGM_2VCU_wait					=>	OGM_2VCU_wait,
		OGM_2VCU_read					=>	OGM_2VCU_read,
		OGM_2VCU_write					=>	OGM_2VCU_write,
		OGM_2VCU_Add					=>	OGM_2VCU_Add,
		OGM_2VCU_Cnt					=>	OGM_2VCU_Cnt,
		OGM_2VCU_MD_in					=>	OGM_2VCU_MD_in,
		OGM_2VCU_MD_in_rdy				=>	OGM_2VCU_MD_in_rdy,
		OGM_2VCU_MD_out					=>	OGM_2VCU_MD_out,
		OGM_2VCU_MD_out_rdy				=>	OGM_2VCU_MD_out_rdy);
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	SCHEDULER_clk						<=	clk;
	SCHEDULER_rst						<=	rst;
	ACCELERATOR_clk						<=	clk;
	ACCELERATOR_rst						<=	rst;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
end Behavioral;

