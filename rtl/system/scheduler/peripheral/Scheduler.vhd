library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.math_real.ALL;
USE work.my_pack_v2.ALL;
USE work.MEM_MAPS.ALL;
	
entity Scheduler is
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
		CMD_DMA_start					:	OUT	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);			
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
end Scheduler;

architecture Behavioral of Scheduler IS
	--------------------------------------------------------------------------
	--		CONSTANTs
	--------------------------------------------------------------------------
	CONSTANT	BASE_ADDRESS_MEMx		:	INTEGER	:=		SING_MEMx_BASE_ADDRESS;
	CONSTANT	BASE_ADDRESS_DMAx		:	INTEGER	:=		SING_DMAx_BASE_ADDRESS;
	CONSTANT	BASE_ADDRESS_MPDR		:	INTEGER	:=		SING_MPDR_BASE_ADDRESS;
	CONSTANT	BASE_ADDRESS_TIMR		:	INTEGER	:=		SING_TIMR_BASE_ADDRESS;
	CONSTANT	BASE_ADDRESS_DMEV		:	INTEGER	:=		SING_DMEV_BASE_ADDRESS;
	CONSTANT	BASE_ADDRESS_MPEV		:	INTEGER	:=		SING_MPEV_BASE_ADDRESS;
	CONSTANT	BASE_ADDRESS_COST		:	INTEGER	:=		SING_COST_BASE_ADDRESS;
	CONSTANT	BASE_ADDRESS_TRxU		:	INTEGER	:=		SING_TRxU_BASE_ADDRESS;
	CONSTANT	BASE_ADDRESS_INTH		:	INTEGER	:=		SING_INTH_BASE_ADDRESS;
	CONSTANT	BASE_ADDRESS_PLNR		:	INTEGER	:=		SING_PLNR_BASE_ADDRESS;
	CONSTANT	OFFSET_PLANE			:	INTEGER	:=		PLAN_PLAN_OFFSET_ADDRESS;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		COMPONENTs
	--------------------------------------------------------------------------
	COMPONENT	Scheduler_Main_Memory
	GENERIC(
		MAIN_BASE_ADDRESS				:	INTEGER	:=	to_integer(SIGNED(X_check(X"FFFF0000")));
		DNoC_BASE_ADDRESS				:	INTEGER	:=	to_integer(SIGNED(X_check(X"FFFF0000")));
		LINE_COUNT						:	INTEGER	:=	2048);
	PORT(
		--	MAIN PORT
		MAIN_PORT_clk					:	IN	std_logic;
		MAIN_PORT_Dot_Rdy				:	OUT	std_logic;
		MAIN_PORT_SEL_This				:	OUT	std_logic;
		MAIN_PORT_Address				:	IN	std_logic_vector(31	DOWNTO	0);
		MAIN_PORT_Data_in				:	IN	std_logic_vector(31	DOWNTO	0);
		MAIN_PORT_WEN					:	IN	std_logic;
		MAIN_PORT_OEN					:	IN	std_logic;
		MAIN_PORT_Data_out				:	OUT	std_logic_vector(31	DOWNTO	0);
		--	DRAM NoC PORT
		DNoC_PORT_clk					:	IN	std_logic;
		DNoC_PORT_Dot_Rdy				:	OUT	std_logic;
		DNoC_PORT_SEL_This				:	OUT	std_logic;
		DNoC_PORT_Address				:	IN	std_logic_vector(31	DOWNTO	0);
		DNoC_PORT_Data_in				:	IN	std_logic_vector(31	DOWNTO	0);
		DNoC_PORT_WEN					:	IN	std_logic;
		DNoC_PORT_OEN					:	IN	std_logic;
		DNoC_PORT_Data_out				:	OUT	std_logic_vector(31	DOWNTO	0));
	END	COMPONENT;
	--------------------------------------------------------------------------
	COMPONENT	Scheduler_Main_Memory_64x
	GENERIC(
		MAIN_BASE_ADDRESS				:	INTEGER	:=	to_integer(SIGNED(X_check(X"FFFF0000")));
		DNoC_BASE_ADDRESS				:	INTEGER	:=	to_integer(SIGNED(X_check(X"FFFF0000")));
		LINE_COUNT						:	INTEGER	:=	4096);
	PORT(
		--	MAIN PORT
		MAIN_PORT_clk					:	IN	std_logic;
		MAIN_PORT_Dot_Rdy				:	OUT	std_logic;
		MAIN_PORT_SEL_This				:	OUT	std_logic;
		MAIN_PORT_Address				:	IN	std_logic_vector(31	DOWNTO	0);
		MAIN_PORT_Data_in				:	IN	std_logic_vector(31	DOWNTO	0);
		MAIN_PORT_WEN					:	IN	std_logic;
		MAIN_PORT_OEN					:	IN	std_logic;
		MAIN_PORT_Data_out				:	OUT	std_logic_vector(31	DOWNTO	0);
		--	DNoC PORT
		DNoC_PORT_clk					:	IN	std_logic;
		DNoC_PORT_Dot_Rdy				:	OUT	std_logic;
		DNoC_PORT_SEL_This				:	OUT	std_logic;
		DNoC_PORT_Address				:	IN	std_logic_vector(31	DOWNTO	0);
		DNoC_PORT_Data_in				:	IN	std_logic_vector(31	DOWNTO	0);
		DNoC_PORT_WEN					:	IN	std_logic;
		DNoC_PORT_OEN					:	IN	std_logic;
		DNoC_PORT_Data_out				:	OUT	std_logic_vector(31	DOWNTO	0);
		--	uProcessor PORT
		uPROC_PORT_clk					:	IN	std_logic;
		uPROC_PORT_rst					:	IN	std_logic;
		uPROC_PORT_rd_i					:	IN	std_logic;
		uPROC_PORT_flush_i				:	IN	std_logic;
		uPROC_PORT_invalidate_i			:	IN	std_logic;
		uPROC_PORT_valid_o				:	OUT	std_logic;
		uPROC_PORT_error_o				:	OUT	std_logic;
		uPROC_PORT_accept_o				:	OUT	std_logic;
		uPROC_PORT_Address				:	IN	std_logic_vector(31	DOWNTO	0);
		uPROC_PORT_Data_out				:	OUT	std_logic_vector(63	DOWNTO	0));
	END	COMPONENT;
	--------------------------------------------------------------------------
	COMPONENT	DMA_Control_Box_V2
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
		--	DMA
		CMD_DMA_start					:	OUT	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);		
		CMD_DMA_R_Add					:	OUT	Unc_2D_P_Addr_array	(3	DOWNTO	0,	3	DOWNTO 0);	--(regs)
		CMD_DMA_R_Cnt					:	OUT	Unc_2D_P_Cont_array	(3	DOWNTO	0,	3	DOWNTO 0);	--(regs)
		CMD_DMA_W_Add					:	OUT	Unc_2D_P_Addr_array	(3	DOWNTO	0,	3	DOWNTO 0);	--(regs)
		CMD_DMA_W_Cnt					:	OUT	Unc_2D_P_Cont_array	(3	DOWNTO	0,	3	DOWNTO 0));	--(regs)
	END	COMPONENT;
	--------------------------------------------------------------------------
	COMPONENT	MPDR_Control_Box
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
		
		--	MPDR
		CMD_MPDR_start					:	OUT	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	--(flag)
		CMD_MPDR_load					:	OUT	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	--(flag)
		CMD_MPDR_Addresses				:	OUT	std_logic_vector	(P_USA_Add_size-1	DOWNTO 0);
		CMD_MPDR_Target					:	OUT std_logic_vector	(2					DOWNTO 0);
		CMD_MPDR_Base_Wen				:	OUT	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	--(flag)
		CMD_MPDR_Cont_Wen				:	OUT	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	--(flag)
		CMD_MPDR_IVal_Wen				:	OUT	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);	--(flag)
		CMD_MPDR_MAX_Col				:	OUT	std_logic_vector	(P_column_size-1	DOWNTO 0);
		CMD_MPDR_MAX_Chn				:	OUT	std_logic_vector	(P_channel_size-1	DOWNTO 0));
	END	COMPONENT;
	--------------------------------------------------------------------------
	COMPONENT	Timer_Box
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
		--	INTERRUPT	HANDLER
		------	INTERRUPT REQUEST
		INT_TIMER						:	OUT	std_logic_vector(7	DOWNTO	0);
		------	INTERRUPT ANSWERED
		ANS_TIMER						:	IN	std_logic_vector(7	DOWNTO	0));
	END	COMPONENT;
	--------------------------------------------------------------------------
	COMPONENT	Singular_Event_Box
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
		CMD_EVNT_Ready					:	IN	Unc_2D_array	(3	DOWNTO	0,	3	DOWNTO 0);	
		--	INTERRUPT	HANDLER
		------	INTERRUPT REQUEST
		INT_EVNT_Done					:	OUT	Unc_1D_array	(15	DOWNTO 	0);
		------	INTERRUPT ANSWERED 
		ANS_EVNT_Done					:	IN	Unc_1D_array	(15	DOWNTO 	0));
	END	COMPONENT;
	--------------------------------------------------------------------------
	COMPONENT	Control_Status_Box
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
		--	ACCELERATOR
		ACCELERATOR_P0_rstb				:	OUT	std_logic;
		ACCELERATOR_P1_rstb				:	OUT	std_logic;
		ACCELERATOR_P2_rstb				:	OUT	std_logic;
		ACCELERATOR_P3_rstb				:	OUT	std_logic;
		ACCELERATOR_CONNECT				:	OUT	std_logic);
	END	COMPONENT;
	--------------------------------------------------------------------------
	COMPONENT	TRx_Box
	GENERIC(
		BASE_ADDRESS					:	INTEGER	:=	to_integer(SIGNED(X_check(X"FFFF0000"))));
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		--	MAIN PORT
		MAIN_PORT_Dot_Rdy				:	OUT	std_logic;
		MAIN_PORT_SEL_This				:	OUT	std_logic;
		MAIN_PORT_Address				:	IN	std_logic_vector	(31	DOWNTO	0);
		MAIN_PORT_Data_in				:	IN	std_logic_vector	(31	DOWNTO	0);
		MAIN_PORT_WEN					:	IN	std_logic;
		MAIN_PORT_OEN					:	IN	std_logic;
		MAIN_PORT_Data_out				:	OUT	std_logic_vector	(31	DOWNTO	0);
		--	Tx line
		Rx_Rx							:	IN	std_logic;
		Tx_Tx							:	OUT	std_logic;
		--	INTERRUPT	HANDLER
		------	INTERRUPT REQUEST
		INT_Tx_Buff_Empty				:	OUT	std_logic;
		INT_Tx_Sent						:	OUT	std_logic;
		INT_Rx_Buff_Full				:	OUT	std_logic;
		INT_Rx_Received					:	OUT	std_logic;
		------	INTERRUPT ANSWERED
		ANS_Tx_Buff_Empty				:	IN	std_logic;
		ANS_Tx_Sent						:	IN	std_logic;
		ANS_Rx_Buff_Full				:	IN	std_logic;
		ANS_Rx_Received					:	IN	std_logic);
	END	COMPONENT;
	--------------------------------------------------------------------------
	COMPONENT	Interrupt_handler
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
		--	Accelerator 
		------	Requests
		INT_REQ_SYS_PC					:	IN	std_logic;
		INT_REQ_TBE						:	IN	std_logic;
		INT_REQ_RBF						:	IN	std_logic;
		INT_REQ_TXD						:	IN	std_logic;
		INT_REQ_RXD						:	IN	std_logic;
		INT_REQ_SYS_TIMER				:	IN	std_logic_vector(7	DOWNTO	0);
		INT_REQ_MPDR_Ready				:	IN	Unc_1D_array	(15	DOWNTO	0);
		INT_REQ_DMA_Ready				:	IN	Unc_1D_array	(15	DOWNTO	0);
		INT_REQ_PSU_Done				:	IN	Plane_std_logic_4X4;
		------	Acknowledge
		INT_ACK_SYS_PC					:	OUT	std_logic;
		INT_ACK_TBE						:	OUT	std_logic;
		INT_ACK_RBF						:	OUT	std_logic;
		INT_ACK_TXD						:	OUT	std_logic;
		INT_ACK_RXD						:	OUT	std_logic;
		INT_ACK_SYS_TIMER				:	OUT	std_logic_vector(7	DOWNTO	0);
		INT_ACK_MPDR_Ready				:	OUT	Unc_1D_array	(15	DOWNTO	0);
		INT_ACK_DMA_Ready				:	OUT	Unc_1D_array	(15	DOWNTO	0);
		INT_ACK_PSU_Done				:	OUT	Plane_std_logic_4X4;
		--	Interrupt Port
        INT_REQ							:	OUT	std_logic;
        INT_ACK							:	IN	std_logic);
	END	COMPONENT;
	--------------------------------------------------------------------------
	COMPONENT	Planar_CSR_Box
	GENERIC(
		BASE_ADDRESS_PLAN				:	INTEGER	:=	to_integer(SIGNED(X_check(X"FFFF0000"))));
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		--	Configs
		CNF_ALL_Configurations			:	OUT	all_configs_type;
		--	Initiation
		------	STA	 &	UPA
		INI_Bias_val					:	OUT	std_logic_vector(P_word_size-1			DOWNTO 0);	--	Store Agent Only
		INI_Bias_Add					:	OUT	std_logic_vector(P_kernel_size-1		DOWNTO 0);	--	Store Agent Only
		INI_Bias_Wen					:	OUT	std_logic;											--	Store Agent Only
		INI_Addresses					:	OUT	std_logic_vector(P_Phy_Add_size-1		DOWNTO 0);	--	shared
		INI_Target_add					:	OUT	std_logic_vector(3						DOWNTO 0);	--	shared
		INI_Base_Wen					:	OUT	std_logic;											--	shared
		INI_Count_Wen					:	OUT	std_logic;											--	shared
		INI_IntVal_Wen					:	OUT	std_logic;											--	shared
		INI_SA_UAbar					:	OUT	std_logic;											--	SA ~UA Selector
		INI_SLU_unit_add				:	OUT	std_logic_vector(3 						DOWNTO 0);	--	PE address r,c
		--	High Level  
		------	PEs
		CMD_PEs_start					:	OUT	std_logic_4X4;			--(flip)	simple start
		CMD_PEs_init_inc_Rows			:	OUT	std_logic_4X4V3;		--(flag)	inc row select
		CMD_PEs_done					:	IN	std_logic_4X4;
		------	STA		
		CMD_STA_ACK						:	OUT	std_logic_4X4;			--(flip)	scheduler tells STA that the DMA transfers data and ready to accept another chunk
		CMD_STA_load					:	OUT	std_logic_4X4;			--(flip)	load a row data from memory
		CMD_STA_MEM_en					:	OUT	std_logic_4X4;			--(flip)	accumulate with internal memory content
		CMD_STA_OBM_en					:	OUT	std_logic_4X4;			--(flip)	accumulate with OBM content
		CMD_STA_BIS_en					:	OUT	std_logic_4X4;			--(flip)	accumulate with BIAS
		CMD_STA_save					:	OUT	std_logic_4X4;			--(flip)	save the result in the internal memory
		CMD_STA_active					:	OUT	std_logic_4X4;			--(flip)	pass through activation function module
		CMD_STA_store					:	OUT	std_logic_4X4;			--(flip)	store the row in memory
		CMD_STA_load_UA					:	OUT	std_logic_4X4;			--(flip)	update BASE ADDRESS of load  pointer 
		CMD_STA_stor_UA					:	OUT	std_logic_4X4;			--(flip)	update BASE ADDRESS of store pointer 
		CMD_STA_done					:	IN	std_logic_4X4;
		------	UPA		
		CMD_UPA_Up_IFM					:	OUT	std_logic_4X4;			--(flip)	update input feature map buffers
		CMD_UPA_Up_WFM					:	OUT	std_logic_4X4;			--(flip)	update weigh buffers
		CMD_UPA_status					:	IN	std_logic_4X4V2;		--			status of UPA
		CMD_UPA_done					:	IN	std_logic_4X4;
		--	CONTROL
		------	PAUSE
		CNT_PEs_PAUSE					:	OUT	std_logic_4X4;			--(flip)
		CNT_STA_PAUSE					:	OUT	std_logic_4X4;			--(flip)
		CNT_UPA_PAUSE					:	OUT	std_logic_4X4;			--(flip)
		--	Scheduler
		------	Interrupt REQUEST
		INT_PSU_Done					:	OUT	std_logic_4X4;
		------	INTERRUPT ANSWERED
		ANS_PSU_Done					:	IN	std_logic_4X4;
		------	MAIN PORT
		MAIN_PORT_Dot_Rdy				:	OUT	std_logic;
		MAIN_PORT_SEL_This				:	OUT	std_logic;
		MAIN_PORT_Address				:	IN	std_logic_vector(31	DOWNTO	0);
		MAIN_PORT_Data_in				:	IN	std_logic_vector(31	DOWNTO	0);
		MAIN_PORT_WEN					:	IN	std_logic;
		MAIN_PORT_OEN					:	IN	std_logic;
		MAIN_PORT_Data_out				:	OUT	std_logic_vector(31	DOWNTO	0));
	END	COMPONENT;
	--------------------------------------------------------------------------
	COMPONENT	AFTAB_Wrapper
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		--	Interrupt Port
        INT_REQ							:	IN	std_logic;
        INT_ACK							:	OUT	std_logic;
		--	Memory Interface
		MAIN_PORT_MEM_Rdy				:	IN	std_logic;
		MAIN_PORT_Address				:	OUT	std_logic_vector(31	DOWNTO	0);
		MAIN_PORT_Data_in				:	IN	std_logic_vector(31	DOWNTO	0);
		MAIN_PORT_DIN_Rdy				:	IN	std_logic;
		MAIN_PORT_WEN					:	OUT	std_logic;
		MAIN_PORT_OEN					:	OUT	std_logic;
		MAIN_PORT_Data_out				:	OUT	std_logic_vector(31	DOWNTO	0));
	END	COMPONENT;
	--------------------------------------------------------------------------
	COMPONENT	BIRISC_Wrapper
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		--	Interrupt Port
        INT_REQ							:	IN	std_logic;
        INT_ACK							:	OUT	std_logic;
		--	Memory Interface
		MAIN_PORT_MEM_Rdy				:	IN	std_logic;
		MAIN_PORT_DIN_Rdy				:	IN	std_logic;
		MAIN_PORT_Address				:	OUT	std_logic_vector(31	DOWNTO	0);
		MAIN_PORT_Data_in				:	IN	std_logic_vector(31	DOWNTO	0);
		MAIN_PORT_WEN					:	OUT	std_logic;
		MAIN_PORT_OEN					:	OUT	std_logic;
		MAIN_PORT_Data_out				:	OUT	std_logic_vector(31	DOWNTO	0);
		--	uProcessor PORT
		uPROC_PORT_rd					:	OUT	std_logic;
		uPROC_PORT_flush				:	OUT	std_logic;
		uPROC_PORT_invalidate			:	OUT	std_logic;
		uPROC_PORT_valid				:	IN	std_logic;
		uPROC_PORT_error				:	IN	std_logic;
		uPROC_PORT_accept				:	IN	std_logic;
		uPROC_PORT_Address				:	OUT	std_logic_vector(31	DOWNTO	0);
		uPROC_PORT_Data_out				:	IN	std_logic_vector(63	DOWNTO	0));
	END COMPONENT;
	--------------------------------------------------------------------------
	COMPONENT	Main_Port_Tracker
	PORT(
		clk								:	IN	std_logic;
		MAIN_PORT_Address				:	IN	std_logic_vector(31	DOWNTO	0);
		MAIN_PORT_Data_in				:	IN	std_logic_vector(31	DOWNTO	0);
		MAIN_PORT_WEN					:	IN	std_logic;
		MAIN_PORT_OEN					:	IN	std_logic;
		MAIN_PORT_Data_out				:	IN	std_logic_vector(31	DOWNTO	0));
	END	COMPONENT;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		SINGALs
	--------------------------------------------------------------------------
	SIGNAL	INT_EXT_RST					:	std_logic	:=	'0';	--	Exetrnal Reset
	--------------------------------------------------------------------------
	SIGNAL	MAIN_PORT_Address			:	std_logic_vector(31	DOWNTO	0);
	SIGNAL	MAIN_PORT_Data_in			:	std_logic_vector(31	DOWNTO	0);
	SIGNAL	MAIN_PORT_WEN				:	std_logic;
	SIGNAL	MAIN_PORT_OEN				:	std_logic;
	SIGNAL	MAIN_PORT_Data_out			:	std_logic_vector(31	DOWNTO	0);
	SIGNAL	MAIN_PORT_DIN_Rdy			:	std_logic;
	--------------------------------------------------------------------------
	SIGNAL	INT_REQ_PSU_Done			:	Plane_std_logic_4X4;
	SIGNAL	INT_REQ_DMA_Ready			:	Unc_1D_array	(15	DOWNTO	0);
	SIGNAL	INT_REQ_MPDR_Ready			:	Unc_1D_array	(15	DOWNTO	0);
	SIGNAL	INT_REQ_TIMER				:	std_logic_vector(7	DOWNTO	0);
	SIGNAL	INT_REQ_RXD					:	std_logic;
	SIGNAL	INT_REQ_TXD					:	std_logic;
	SIGNAL	INT_REQ_TBE					:	std_logic;
	SIGNAL	INT_REQ_RBF					:	std_logic;
	--------------------------------------------------------------------------
	SIGNAL	INT_ACK_PSU_Done			:	Plane_std_logic_4X4;
	SIGNAL	INT_ACK_DMA_Ready			:	Unc_1D_array	(15	DOWNTO	0);
	SIGNAL	INT_ACK_MPDR_Ready			:	Unc_1D_array	(15	DOWNTO	0);
	SIGNAL	INT_ACK_TIMER				:	std_logic_vector(7	DOWNTO	0);
	SIGNAL	INT_ACK_RXD					:	std_logic;
	SIGNAL	INT_ACK_TXD					:	std_logic;
	SIGNAL	INT_ACK_TBE					:	std_logic;
	SIGNAL	INT_ACK_RBF					:	std_logic;
	--------------------------------------------------------------------------
	SIGNAL	INT_En						:	std_logic;
	SIGNAL	INT_ADD						:	std_logic_vector(31	DOWNTO	0);
	SIGNAL	INT_REQ						:	std_logic;
	SIGNAL	INT_ACK						:	std_logic;
	--------------------------------------------------------------------------
	SIGNAL	MAIN_PORT_Dot_Redy_ECB		:	std_logic;	--	Data Out Ready for	DMA_Event_Counter_Box_unit
	SIGNAL	MAIN_PORT_SEL_This_ECB		:	std_logic;  --	Main Port selects	DMA_Event_Counter_Box_unit
	SIGNAL	MAIN_PORT_Dot_Redy_PCB		:	std_logic;	--	Data Out Ready for	MPDR_Event_Counter_Box_unit
	SIGNAL	MAIN_PORT_SEL_This_PCB		:	std_logic;  --	Main Port selects	MPDR_Event_Counter_Box_unit
	SIGNAL	MAIN_PORT_Dot_Redy_DCB		:	std_logic;  --	Data Out Ready for	DMA_Control_Box
	SIGNAL	MAIN_PORT_SEL_This_DCB		:	std_logic;  --	Main Port selects	DMA_Control_Box
	SIGNAL	MAIN_PORT_Dot_Redy_MCB		:	std_logic;  --	Data Out Ready for	MPDR_Control_Box
	SIGNAL	MAIN_PORT_SEL_This_MCB		:	std_logic;  --	Main Port selects	MPDR_Control_Box
	SIGNAL	MAIN_PORT_Dot_Redy_TCB		:	std_logic;  --	Data Out Ready for	Timer_Box
	SIGNAL	MAIN_PORT_SEL_This_TCB		:	std_logic;  --	Main Port selects	Timer_Box
	SIGNAL	MAIN_PORT_Dot_Redy_MEM		:	std_logic;  --	Data Out Ready for	Scheduler's Memory
	SIGNAL	MAIN_PORT_SEL_This_MEM		:	std_logic;  --	Main Port selects	Scheduler's Memory
	SIGNAL	MAIN_PORT_Dot_Redy_CSB		:	std_logic;  --	Data Out Ready for	Control_Status_Box
	SIGNAL	MAIN_PORT_SEL_This_CSB		:	std_logic;  --	Main Port selects	Control_Status_Box
	SIGNAL	MAIN_PORT_Dot_Redy_TRx		:	std_logic;  --	Data Out Ready for	TRx_Box
	SIGNAL	MAIN_PORT_SEL_This_TRx		:	std_logic;  --	Main Port selects	TRx_Box
	SIGNAL	MAIN_PORT_Dot_Redy_IRH		:	std_logic;  --	Data Out Ready for	Interrupt_handler
	SIGNAL	MAIN_PORT_SEL_This_IRH		:	std_logic;  --	Main Port selects	Interrupt_handler
	SIGNAL	MAIN_PORT_Dot_Redy_PLN		:	std_logic;  --	Data Out Ready for	Planar_CSR_Box
	SIGNAL	MAIN_PORT_SEL_This_PLN		:	std_logic;  --	Main Port selects	Planar_CSR_Box
	SIGNAL	MAIN_PORT_Dot_Redy_PLNp		:	std_logic_vector(P_Number_of_Planes-1	DOWNTO 0);
	SIGNAL	MAIN_PORT_SEL_This_PLNp		:	std_logic_vector(P_Number_of_Planes-1	DOWNTO 0);
	--SIGNAL	MAIN_PORT_ADD_b0			:	std_logic;
	--SIGNAL	MAIN_PORT_ADD_b1			:	std_logic;
	--------------------------------------------------------------------------
	SIGNAL	ERROR						:	std_logic;
	SIGNAL	ERROR_cmb					:	std_logic;
	SIGNAL	ERROR_flg					:	std_logic;
	SIGNAL	RISCV_rst					:	std_logic;
	--------------------------------------------------------------------------
	SIGNAL	uPROC_PORT_rd				:	std_logic;
	SIGNAL	uPROC_PORT_flush			:	std_logic;
	SIGNAL	uPROC_PORT_invalidate		:	std_logic;
	SIGNAL	uPROC_PORT_valid			:	std_logic;
	SIGNAL	uPROC_PORT_error			:	std_logic;
	SIGNAL	uPROC_PORT_accept			:	std_logic;
	SIGNAL	uPROC_PORT_Address			:	std_logic_vector(31	DOWNTO	0);
	SIGNAL	uPROC_PORT_Data_out			:	std_logic_vector(63	DOWNTO	0);
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
begin
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	Scheduler_Main_Memory_GEN			:	IF	P_uProcessor_in_use = P_USE_AFTAB	GENERATE
		Scheduler_Main_Memory_Unit		:	Scheduler_Main_Memory
		GENERIC	MAP(
			MAIN_BASE_ADDRESS			=>	BASE_ADDRESS_MEMx,
			DNoC_BASE_ADDRESS			=>	DNoC_BASE_ADDRESS,
			LINE_COUNT					=>	P_Main_MEMx_LINE_COUNT)
		PORT	MAP(
			--	MAIN PORT
			MAIN_PORT_clk				=>	clk,
			MAIN_PORT_Dot_Rdy			=>	MAIN_PORT_Dot_Redy_MEM,
			MAIN_PORT_SEL_This			=>	MAIN_PORT_SEL_This_MEM,
			MAIN_PORT_Address			=>	MAIN_PORT_Address,
			MAIN_PORT_Data_in			=>	MAIN_PORT_Data_in,
			MAIN_PORT_WEN				=>	MAIN_PORT_WEN,
			MAIN_PORT_OEN				=>	MAIN_PORT_OEN,
			MAIN_PORT_Data_out			=>	MAIN_PORT_Data_out,
			--	MAIN PORT
			DNoC_PORT_clk				=>	DNoC_PORT_clk,
			DNoC_PORT_Dot_Rdy			=>	DNoC_PORT_Dot_Rdy,
			DNoC_PORT_SEL_This			=>	DNoC_PORT_SEL_This,
			DNoC_PORT_Address			=>	DNoC_PORT_Address,
			DNoC_PORT_Data_in			=>	DNoC_PORT_Data_in,
			DNoC_PORT_WEN				=>	DNoC_PORT_WEN,
			DNoC_PORT_OEN				=>	DNoC_PORT_OEN,
			DNoC_PORT_Data_out			=>	DNoC_PORT_Data_out);
	END GENERATE;
	--------------------------------------------------------------------------
	Scheduler_Main_Memory_x64_GEN		:	IF	P_uProcessor_in_use = P_USE_BIRISC	GENERATE
		Scheduler_Main_Memory_Unit		:	Scheduler_Main_Memory_64x
		GENERIC	MAP(
			MAIN_BASE_ADDRESS			=>	BASE_ADDRESS_MEMx,
			DNoC_BASE_ADDRESS			=>	DNoC_BASE_ADDRESS,
			LINE_COUNT					=>	P_Main_MEMx_LINE_COUNT)
		PORT	MAP(
			--	MAIN PORT
			MAIN_PORT_clk				=>	clk,
			MAIN_PORT_Dot_Rdy			=>	MAIN_PORT_Dot_Redy_MEM,
			MAIN_PORT_SEL_This			=>	MAIN_PORT_SEL_This_MEM,
			MAIN_PORT_Address			=>	MAIN_PORT_Address,
			MAIN_PORT_Data_in			=>	MAIN_PORT_Data_in,
			MAIN_PORT_WEN				=>	MAIN_PORT_WEN,
			MAIN_PORT_OEN				=>	MAIN_PORT_OEN,
			MAIN_PORT_Data_out			=>	MAIN_PORT_Data_out,
			--	MAIN PORT
			DNoC_PORT_clk				=>	DNoC_PORT_clk,
			DNoC_PORT_Dot_Rdy			=>	DNoC_PORT_Dot_Rdy,
			DNoC_PORT_SEL_This			=>	DNoC_PORT_SEL_This,
			DNoC_PORT_Address			=>	DNoC_PORT_Address,
			DNoC_PORT_Data_in			=>	DNoC_PORT_Data_in,
			DNoC_PORT_WEN				=>	DNoC_PORT_WEN,
			DNoC_PORT_OEN				=>	DNoC_PORT_OEN,
			DNoC_PORT_Data_out			=>	DNoC_PORT_Data_out,
			--	uProcessor PORT
			uPROC_PORT_clk				=>	clk,
			uPROC_PORT_rst				=>	RISCV_rst,
			uPROC_PORT_rd_i				=>	uPROC_PORT_rd,
			uPROC_PORT_flush_i			=>	uPROC_PORT_flush,
			uPROC_PORT_invalidate_i		=>	uPROC_PORT_invalidate,
			uPROC_PORT_valid_o			=>	uPROC_PORT_valid,
			uPROC_PORT_error_o			=>	uPROC_PORT_error,
			uPROC_PORT_accept_o			=>	uPROC_PORT_accept,
			uPROC_PORT_Address			=>	uPROC_PORT_Address,
			uPROC_PORT_Data_out			=>	uPROC_PORT_Data_out);
	END GENERATE;
	--------------------------------------------------------------------------
	DMA_Control_Box_unit				:	DMA_Control_Box_V2
	GENERIC	MAP(
		BASE_ADDRESS					=>	BASE_ADDRESS_DMAx)
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		--	MAIN PORT
		MAIN_PORT_Dot_Rdy				=>	MAIN_PORT_Dot_Redy_DCB,
		MAIN_PORT_SEL_This				=>	MAIN_PORT_SEL_This_DCB,
		MAIN_PORT_Address				=>	MAIN_PORT_Address,
		MAIN_PORT_Data_in				=>	MAIN_PORT_Data_in,
		MAIN_PORT_WEN					=>	MAIN_PORT_WEN,
		MAIN_PORT_OEN					=>	MAIN_PORT_OEN,
		MAIN_PORT_Data_out				=>	MAIN_PORT_Data_out,
		--	DMA
		CMD_DMA_start					=>	CMD_DMA_start,
		CMD_DMA_R_Add					=>	CMD_DMA_R_Add,
		CMD_DMA_R_Cnt					=>	CMD_DMA_R_Cnt,
		CMD_DMA_W_Add					=>	CMD_DMA_W_Add,
		CMD_DMA_W_Cnt					=>	CMD_DMA_W_Cnt);
	--------------------------------------------------------------------------
	MPDR_Control_Box_unit				:	MPDR_Control_Box
	GENERIC	MAP(
		BASE_ADDRESS					=>	BASE_ADDRESS_MPDR)
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		--	MAIN PORT
		MAIN_PORT_Dot_Rdy				=>	MAIN_PORT_Dot_Redy_MCB,
		MAIN_PORT_SEL_This				=>	MAIN_PORT_SEL_This_MCB,
		MAIN_PORT_Address				=>	MAIN_PORT_Address,
		MAIN_PORT_Data_in				=>	MAIN_PORT_Data_in,
		MAIN_PORT_WEN					=>	MAIN_PORT_WEN,
		MAIN_PORT_OEN					=>	MAIN_PORT_OEN,
		MAIN_PORT_Data_out				=>	MAIN_PORT_Data_out,
		--	MPDR
		CMD_MPDR_start					=>	CMD_MPDR_start,
		CMD_MPDR_load					=>	CMD_MPDR_load,
		CMD_MPDR_Addresses				=>	CMD_MPDR_Addresses,
		CMD_MPDR_Target					=>	CMD_MPDR_Target,
		CMD_MPDR_Base_Wen				=>	CMD_MPDR_Base_Wen,
		CMD_MPDR_Cont_Wen				=>	CMD_MPDR_Cont_Wen,
		CMD_MPDR_IVal_Wen				=>	CMD_MPDR_IVal_Wen,
		CMD_MPDR_MAX_Col				=>	CMD_MPDR_MAX_Col,
		CMD_MPDR_MAX_Chn				=>	CMD_MPDR_MAX_Chn);
	--------------------------------------------------------------------------
	Timer_Box_unit						:	Timer_Box
	GENERIC	MAP(
		BASE_ADDRESS					=>	BASE_ADDRESS_TIMR)
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		--	MAIN PORT
		MAIN_PORT_Dot_Rdy				=>	MAIN_PORT_Dot_Redy_TCB,
		MAIN_PORT_SEL_This				=>	MAIN_PORT_SEL_This_TCB,
		MAIN_PORT_Address				=>	MAIN_PORT_Address,
		MAIN_PORT_Data_in				=>	MAIN_PORT_Data_in,
		MAIN_PORT_WEN					=>	MAIN_PORT_WEN,
		MAIN_PORT_OEN					=>	MAIN_PORT_OEN,
		MAIN_PORT_Data_out				=>	MAIN_PORT_Data_out,
		--	INTERRUPT	HANDLER
		------	INTERRUPT REQUEST
		INT_TIMER						=>	INT_REQ_TIMER,
		------	INTERRUPT ANSWERED
		ANS_TIMER						=>	INT_ACK_TIMER);
	--------------------------------------------------------------------------
	DMA_Event_Counter_Box_unit			:	Singular_Event_Box
	GENERIC	MAP(
		BASE_ADDRESS					=>	BASE_ADDRESS_DMEV)
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		--	MAIN PORT
		MAIN_PORT_Dot_Rdy				=>	MAIN_PORT_Dot_Redy_ECB,
		MAIN_PORT_SEL_This				=>	MAIN_PORT_SEL_This_ECB,
		MAIN_PORT_Address				=>	MAIN_PORT_Address,
		MAIN_PORT_Data_in				=>	MAIN_PORT_Data_in,
		MAIN_PORT_WEN					=>	MAIN_PORT_WEN,
		MAIN_PORT_OEN					=>	MAIN_PORT_OEN,
		MAIN_PORT_Data_out				=>	MAIN_PORT_Data_out,
		--	EVENTS
		CMD_EVNT_Ready					=>	CMD_DMA_Ready,
		--	INTERRUPT	HANDLER
		------	INTERRUPT REQUEST
		INT_EVNT_Done					=>	INT_REQ_DMA_Ready,
		------	INTERRUPT ANSWERED 
		ANS_EVNT_Done					=>	INT_ACK_DMA_Ready);
	--------------------------------------------------------------------------
	MPDR_Event_Counter_Box_unit			:	Singular_Event_Box
	GENERIC	MAP(
		BASE_ADDRESS					=>	BASE_ADDRESS_MPEV)
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		--	MAIN PORT
		MAIN_PORT_Dot_Rdy				=>	MAIN_PORT_Dot_Redy_PCB,
		MAIN_PORT_SEL_This				=>	MAIN_PORT_SEL_This_PCB,
		MAIN_PORT_Address				=>	MAIN_PORT_Address,
		MAIN_PORT_Data_in				=>	MAIN_PORT_Data_in,
		MAIN_PORT_WEN					=>	MAIN_PORT_WEN,
		MAIN_PORT_OEN					=>	MAIN_PORT_OEN,
		MAIN_PORT_Data_out				=>	MAIN_PORT_Data_out,
		--	EVENTS
		CMD_EVNT_Ready					=>	CMD_MPDR_Done,
		--	INTERRUPT	HANDLER
		------	INTERRUPT REQUEST
		INT_EVNT_Done					=>	INT_REQ_MPDR_Ready,
		------	INTERRUPT ANSWERED 
		ANS_EVNT_Done					=>	INT_ACK_MPDR_Ready);
	--------------------------------------------------------------------------
	Control_Status_Box_unit				:	Control_Status_Box
	GENERIC	MAP(
		BASE_ADDRESS					=>	BASE_ADDRESS_COST)
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		--	MAIN PORT
		MAIN_PORT_Dot_Rdy				=>	MAIN_PORT_Dot_Redy_CSB,
		MAIN_PORT_SEL_This				=>	MAIN_PORT_SEL_This_CSB,
		MAIN_PORT_Address				=>	MAIN_PORT_Address,
		MAIN_PORT_Data_in				=>	MAIN_PORT_Data_in,
		MAIN_PORT_WEN					=>	MAIN_PORT_WEN,
		MAIN_PORT_OEN					=>	MAIN_PORT_OEN,
		MAIN_PORT_Data_out				=>	MAIN_PORT_Data_out,
		--	ACCELERATOR
		ACCELERATOR_P0_rstb				=>	ACCELERATOR_P0_NORMAL,
		ACCELERATOR_P1_rstb				=>	ACCELERATOR_P1_NORMAL,
		ACCELERATOR_P2_rstb				=>	ACCELERATOR_P2_NORMAL,
		ACCELERATOR_P3_rstb				=>	ACCELERATOR_P3_NORMAL,
		ACCELERATOR_CONNECT				=>	ACCELERATOR_CONNECT);
	--------------------------------------------------------------------------
	TRx_Box_unit						:	TRx_Box
	GENERIC	MAP(
		BASE_ADDRESS					=>	BASE_ADDRESS_TRxU)
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		--	MAIN PORT
		MAIN_PORT_Dot_Rdy				=>	MAIN_PORT_Dot_Redy_TRx,
		MAIN_PORT_SEL_This				=>	MAIN_PORT_SEL_This_TRx,
		MAIN_PORT_Address				=>	MAIN_PORT_Address,
		MAIN_PORT_Data_in				=>	MAIN_PORT_Data_in,
		MAIN_PORT_WEN					=>	MAIN_PORT_WEN,
		MAIN_PORT_OEN					=>	MAIN_PORT_OEN,
		MAIN_PORT_Data_out				=>	MAIN_PORT_Data_out,
		--	Tx line
		Rx_Rx							=>	Rx_Rx,
		Tx_Tx							=>	Tx_Tx,
		--	INTERRUPT	HANDLER
		------	INTERRUPT REQUEST
		INT_Tx_Buff_Empty				=>	INT_REQ_TBE,
		INT_Tx_Sent						=>	INT_REQ_TXD,
		INT_Rx_Buff_Full				=>	INT_REQ_RBF,
		INT_Rx_Received					=>	INT_REQ_RXD,
		------	INTERRUPT ANSWERED
		ANS_Tx_Buff_Empty				=>	INT_ACK_TBE,
		ANS_Tx_Sent						=>	INT_ACK_TXD,
		ANS_Rx_Buff_Full				=>	INT_ACK_RBF,
		ANS_Rx_Received					=>	INT_ACK_RXD);
	--------------------------------------------------------------------------
	Interrupt_handler_Unit				:	Interrupt_handler
	GENERIC	MAP(
		BASE_ADDRESS					=>	BASE_ADDRESS_INTH)
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		--	MAIN PORT
		MAIN_PORT_Dot_Rdy				=>	MAIN_PORT_Dot_Redy_IRH,
		MAIN_PORT_SEL_This				=>	MAIN_PORT_SEL_This_IRH,
		MAIN_PORT_Address				=>	MAIN_PORT_Address,
		MAIN_PORT_Data_in				=>	MAIN_PORT_Data_in,
		MAIN_PORT_WEN					=>	MAIN_PORT_WEN,
		MAIN_PORT_OEN					=>	MAIN_PORT_OEN,
		MAIN_PORT_Data_out				=>	MAIN_PORT_Data_out,
		--	Accelerator 
		------	Requests
		INT_REQ_SYS_PC					=>	INT_REQ_SYS_PC,
		INT_REQ_TBE						=>	INT_REQ_TBE,
		INT_REQ_RBF						=>	INT_REQ_RBF,
		INT_REQ_TXD						=>	INT_REQ_TXD,
		INT_REQ_RXD						=>	INT_REQ_RXD,
		INT_REQ_SYS_TIMER				=>	INT_REQ_TIMER,
		INT_REQ_MPDR_Ready				=>	INT_REQ_MPDR_Ready,
		INT_REQ_DMA_Ready				=>	INT_REQ_DMA_Ready,
		INT_REQ_PSU_Done				=>	INT_REQ_PSU_Done,
		------	Acknowledge
		INT_ACK_SYS_PC					=>	INT_ACK_SYS_PC,
		INT_ACK_TBE						=>	INT_ACK_TBE,
		INT_ACK_RBF						=>	INT_ACK_RBF,
		INT_ACK_TXD						=>	INT_ACK_TXD,
		INT_ACK_RXD						=>	INT_ACK_RXD,
		INT_ACK_SYS_TIMER				=>	INT_ACK_TIMER,
		INT_ACK_MPDR_Ready				=>	INT_ACK_MPDR_Ready,
		INT_ACK_DMA_Ready				=>	INT_ACK_DMA_Ready,
		INT_ACK_PSU_Done				=>	INT_ACK_PSU_Done,
		--	Interrupt Port
        INT_REQ							=>	INT_REQ,
        INT_ACK							=>	INT_ACK);
	--------------------------------------------------------------------------
	PLANAR_CSR_GEN						:	FOR	p	IN	P_Number_of_Planes-1	DOWNTO	0	GENERATE
		Plane_p							:	Planar_CSR_Box
		GENERIC	MAP(
			BASE_ADDRESS_PLAN			=>	SING_PLNR_BASE_ADDRESS + (p  *OFFSET_PLANE))
		PORT	MAP(
			clk							=>	clk,
			rst							=>	rst,
			--	Configs
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
			--	Scheduler
			------	Interrupt REQUEST
			INT_PSU_Done				=>	INT_REQ_PSU_Done				(p),
			------	INTERRUPT ANSWERED
			ANS_PSU_Done				=>	INT_ACK_PSU_Done				(p),
			------	MAIN PORT
			MAIN_PORT_Dot_Rdy			=>	MAIN_PORT_Dot_Redy_PLNp			(p),
			MAIN_PORT_SEL_This			=>	MAIN_PORT_SEL_This_PLNp			(p),
			MAIN_PORT_Address			=>	MAIN_PORT_Address,
			MAIN_PORT_Data_in			=>	MAIN_PORT_Data_in,
			MAIN_PORT_WEN				=>	MAIN_PORT_WEN,
			MAIN_PORT_OEN				=>	MAIN_PORT_OEN,
			MAIN_PORT_Data_out			=>	MAIN_PORT_Data_out);
	END GENERATE;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	RISC_CORE_AFTAB_GEN					:	IF	P_uProcessor_in_use = P_USE_AFTAB	GENERATE
		RISCV_CORE						:	AFTAB_Wrapper
		PORT	MAP(                    
			clk							=>	clk,
			rst							=>	RISCV_rst,
			--	Interrupt Port          
			INT_REQ						=>	INT_REQ,
			INT_ACK						=>	INT_ACK,
			--	Memory Interface        
			MAIN_PORT_MEM_Rdy			=>	'1',	--	memories of the systm are always ready
			MAIN_PORT_Address			=>	MAIN_PORT_Address,
			MAIN_PORT_Data_in			=>	MAIN_PORT_Data_out,
			MAIN_PORT_DIN_Rdy			=>	MAIN_PORT_DIN_Rdy,
			MAIN_PORT_WEN				=>	MAIN_PORT_WEN,
			MAIN_PORT_OEN				=>	MAIN_PORT_OEN,
			MAIN_PORT_Data_out			=>	MAIN_PORT_Data_in);
	END GENERATE;
	--------------------------------------------------------------------------
	RISC_CORE_BIRISC_GEN				:	IF	P_uProcessor_in_use = P_USE_BIRISC	GENERATE
		RISCV_CORE						:	BIRISC_Wrapper
		PORT	MAP(
			clk							=>	clk,
			rst							=>	RISCV_rst,
			--	Interrupt Port
			INT_REQ						=>	INT_REQ,
			INT_ACK						=>	INT_ACK,
			--	Memory Interface
			MAIN_PORT_MEM_Rdy			=>	'1',	--	memories of the systm are always ready
			MAIN_PORT_Address			=>	MAIN_PORT_Address,
			MAIN_PORT_Data_in			=>	MAIN_PORT_Data_out,
			MAIN_PORT_DIN_Rdy			=>	MAIN_PORT_DIN_Rdy,
			MAIN_PORT_WEN				=>	MAIN_PORT_WEN,
			MAIN_PORT_OEN				=>	MAIN_PORT_OEN,
			MAIN_PORT_Data_out			=>	MAIN_PORT_Data_in,
			--	uProcessor PORT
			uPROC_PORT_rd				=>	uPROC_PORT_rd,
			uPROC_PORT_flush			=>	uPROC_PORT_flush,
			uPROC_PORT_invalidate		=>	uPROC_PORT_invalidate,
			uPROC_PORT_valid			=>	uPROC_PORT_valid,
			uPROC_PORT_error			=>	uPROC_PORT_error,
			uPROC_PORT_accept			=>	uPROC_PORT_accept,
			uPROC_PORT_Address			=>	uPROC_PORT_Address,
			uPROC_PORT_Data_out			=>	uPROC_PORT_Data_out);
	END GENERATE;
	--------------------------------------------------------------------------
	MP_Tracker							:	Main_Port_Tracker
	PORT	MAP(
		clk								=>	clk,
		MAIN_PORT_Address				=>	MAIN_PORT_Address,
		MAIN_PORT_Data_in				=>	MAIN_PORT_Data_in,
		MAIN_PORT_WEN					=>	MAIN_PORT_WEN,
		MAIN_PORT_OEN					=>	MAIN_PORT_OEN,
		MAIN_PORT_Data_out				=>	MAIN_PORT_Data_out);
	--------------------------------------------------------------------------
	PROCESS(MAIN_PORT_Dot_Redy_PLNp,	MAIN_PORT_SEL_This_PLNp)
		VARIABLE	tmp					:	std_logic;
	BEGIN
		tmp								:=	'0';
		FOR	p	IN	P_Number_of_Planes-1	DOWNTO	0	LOOP
			tmp							:=	tmp OR	MAIN_PORT_Dot_Redy_PLNp(p);
		END LOOP;
		MAIN_PORT_Dot_Redy_PLN			<=	tmp;
		tmp								:=	'0';
		FOR	p	IN	P_Number_of_Planes-1	DOWNTO	0	LOOP
			tmp							:=	tmp OR	MAIN_PORT_SEL_This_PLNp(p);
		END LOOP;
		MAIN_PORT_SEL_This_PLN			<=	tmp;
	END	PROCESS;
	
	--------------------------------------------------------------------------
	MAIN_PORT_DIN_Rdy					<=			MAIN_PORT_Dot_Redy_ECB	OR
													MAIN_PORT_Dot_Redy_DCB	OR
													MAIN_PORT_Dot_Redy_TCB	OR
													MAIN_PORT_Dot_Redy_MEM	OR
													MAIN_PORT_Dot_Redy_CSB	OR
													MAIN_PORT_Dot_Redy_TRx	OR
													MAIN_PORT_Dot_Redy_IRH	OR
													MAIN_PORT_Dot_Redy_PLN;
	--------------------------------------------------------------------------
	ERROR_cmb							<=		 ((	MAIN_PORT_WEN			OR
													MAIN_PORT_OEN)			AND
											NOT	(	MAIN_PORT_SEL_This_ECB	OR
													MAIN_PORT_SEL_This_DCB	OR
													MAIN_PORT_SEL_This_TCB	OR
													MAIN_PORT_SEL_This_MEM	OR
													MAIN_PORT_SEL_This_CSB	OR
													MAIN_PORT_SEL_This_TRx	OR
													MAIN_PORT_SEL_This_IRH	OR
													MAIN_PORT_SEL_This_PLN	OR
													MAIN_PORT_Address(0)	OR
													MAIN_PORT_Address(1)));
	--------------------------------------------------------------------------
	--MAIN_PORT_ADD_b0					<=			MAIN_PORT_Address(0);
	--MAIN_PORT_ADD_b1					<=			MAIN_PORT_Address(1);
	--------------------------------------------------------------------------
	RISCV_rst							<=	rst	OR	ERROR	OR	NOT	RUN_SYS_ALLOW;
	--------------------------------------------------------------------------
	PROCESS(clk)
	BEGIN
		IF clk = '1' AND clk'EVENT THEN
			ERROR						<=			ERROR_cmb;
		END IF;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS(rst, ERROR)
	BEGIN
		IF rst = '1' THEN
			ERROR_flg					<=	'0';
		ELSIF ERROR = '1'	THEN
			ERROR_flg					<=	'1';
		END IF;
	END PROCESS;
	--------------------------------------------------------------------------
end Behavioral;

