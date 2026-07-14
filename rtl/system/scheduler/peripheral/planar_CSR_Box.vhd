library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.math_real.ALL;
USE work.my_pack_v2.ALL;
USE work.MEM_MAPS.ALL;
	
entity Planar_CSR_Box is
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
end Planar_CSR_Box;

architecture Behavioral of Planar_CSR_Box IS
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		CONSTANTs
	--------------------------------------------------------------------------
	CONSTANT	BASE_ADDRESS_CONF		:	INTEGER	:=	BASE_ADDRESS_PLAN	+	PLAN_CONF_OFFSET_ADDRESS;
	CONSTANT	BASE_ADDRESS_INIT		:	INTEGER	:=	BASE_ADDRESS_PLAN	+	PLAN_INIT_OFFSET_ADDRESS;
	CONSTANT	BASE_ADDRESS_PECO		:	INTEGER	:=	BASE_ADDRESS_PLAN	+	PLAN_PECO_OFFSET_ADDRESS;
	CONSTANT	BASE_ADDRESS_EVNT		:	INTEGER	:=	BASE_ADDRESS_PLAN	+	PLAN_EVNT_OFFSET_ADDRESS;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		COMPONENTs
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	COMPONENT	config_holder_v2
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
		--	Configuration
		all_configs						:	OUT	all_configs_type);
	END	COMPONENT;
	--------------------------------------------------------------------------
	COMPONENT	Initiator_Box
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
		--	Initiation
		------	STA	 &	UPA
		INI_Bias_val					:	OUT	std_logic_vector(P_word_size-1						DOWNTO 0);	--			Store Agent Only
		INI_Bias_Add					:	OUT	std_logic_vector(P_kernel_size-1					DOWNTO 0);	--			Store Agent Only
		INI_Bias_Wen					:	OUT	std_logic;														--	flag	Store Agent Only
		INI_Addresses					:	OUT	std_logic_vector(P_Phy_Add_size-1					DOWNTO 0);	--			shared
		INI_Target_add					:	OUT	std_logic_vector(3									DOWNTO 0);	--			shared
		INI_Base_Wen					:	OUT	std_logic;														--	flag	shared
		INI_Count_Wen					:	OUT	std_logic;														--	flag	shared
		INI_IntVal_Wen					:	OUT	std_logic;														--	flag	shared
		INI_SA_UAbar					:	OUT	std_logic;														--			SA ~UA Selector
		INI_SLU_unit_add				:	OUT	std_logic_vector(3 									DOWNTO 0));	--			PE address r,c
	END	COMPONENT;
	--------------------------------------------------------------------------
	COMPONENT	PEs_Control_Box
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
		--	Control Signals
		------	PEs
		CMD_PEs_start					:	OUT	std_logic_4X4;		--(flip)	simple start
		CMD_PEs_init_inc_Rows			:	OUT	std_logic_4X4V3;	--(flag)	inc row select
		------	STA		
		CMD_STA_ACK						:	OUT	std_logic_4X4;		--(flip)	scheduler tells STA that the DMA transfers data and ready to accept another chunk
		CMD_STA_load					:	OUT	std_logic_4X4;		--(flip)	load a row data from memory
		CMD_STA_MEM_en					:	OUT	std_logic_4X4;		--(flip)	accumulate with internal memory content
		CMD_STA_OBM_en					:	OUT	std_logic_4X4;		--(flip)	accumulate with OBM content
		CMD_STA_BIS_en					:	OUT	std_logic_4X4;		--(flip)	accumulate with BIAS
		CMD_STA_save					:	OUT	std_logic_4X4;		--(flip)	save the result in the internal memory
		CMD_STA_active					:	OUT	std_logic_4X4;		--(flip)	pass through activation function module
		CMD_STA_store					:	OUT	std_logic_4X4;		--(flip)	store the row in memory
		CMD_STA_load_UA					:	OUT	std_logic_4X4;		--(flip)	update BASE ADDRESS of load  pointer 
		CMD_STA_stor_UA					:	OUT	std_logic_4X4;		--(flip)	update BASE ADDRESS of store pointer 
		CMD_STA_done					:	IN	std_logic_4X4;
		------	UPA		
		CMD_UPA_Up_IFM					:	OUT	std_logic_4X4;		--(flip)	update input feature map buffers
		CMD_UPA_Up_WFM					:	OUT	std_logic_4X4;		--(flip)	update weigh buffers
		CMD_UPA_status					:	IN	std_logic_4X4V2;	--			status of UPA--	CONTROL
		------	PAUSE
		CNT_PEs_PAUSE					:	OUT	std_logic_4X4;		--(flip)
		CNT_STA_PAUSE					:	OUT	std_logic_4X4;		--(flip)
		CNT_UPA_PAUSE					:	OUT	std_logic_4X4);		--(flip)
	END	COMPONENT;
	--------------------------------------------------------------------------
	COMPONENT	Plane_Event_Box
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
	END	COMPONENT;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		SIGNALs
	--------------------------------------------------------------------------
	SIGNAL	MAIN_PORT_Dot_Redy_CHB		:	std_logic;
	SIGNAL	MAIN_PORT_SEL_This_CHB		:	std_logic;
	SIGNAL	MAIN_PORT_Dot_Redy_AIB		:	std_logic;
	SIGNAL	MAIN_PORT_SEL_This_AIB		:	std_logic;
	SIGNAL	MAIN_PORT_Dot_Redy_PCB		:	std_logic;
	SIGNAL	MAIN_PORT_SEL_This_PCB		:	std_logic;
	SIGNAL	MAIN_PORT_Dot_Redy_ECB		:	std_logic;
	SIGNAL	MAIN_PORT_SEL_This_ECB		:	std_logic;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
begin
	--------------------------------------------------------------------------
	config_holder_v2_unit				:	config_holder_v2
	GENERIC	MAP(
		BASE_ADDRESS					=>	BASE_ADDRESS_CONF)
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		MAIN_PORT_Dot_Rdy				=>	MAIN_PORT_Dot_Redy_CHB,
		MAIN_PORT_SEL_This				=>	MAIN_PORT_SEL_This_CHB,
		MAIN_PORT_Address				=>	MAIN_PORT_Address,
		MAIN_PORT_Data_in				=>	MAIN_PORT_Data_in,
		MAIN_PORT_WEN					=>	MAIN_PORT_WEN,
		MAIN_PORT_OEN					=>	MAIN_PORT_OEN,
		MAIN_PORT_Data_out				=>	MAIN_PORT_Data_out,
		all_configs						=>	CNF_ALL_Configurations);
	--------------------------------------------------------------------------
	Accelerator_Initiator_Box_unit		:	Initiator_Box
	GENERIC	MAP(
		BASE_ADDRESS					=>	BASE_ADDRESS_INIT)
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		MAIN_PORT_Dot_Rdy				=>	MAIN_PORT_Dot_Redy_AIB,
		MAIN_PORT_SEL_This				=>	MAIN_PORT_SEL_This_AIB,
		MAIN_PORT_Address				=>	MAIN_PORT_Address,
		MAIN_PORT_Data_in				=>	MAIN_PORT_Data_in,
		MAIN_PORT_WEN					=>	MAIN_PORT_WEN,
		MAIN_PORT_OEN					=>	MAIN_PORT_OEN,
		MAIN_PORT_Data_out				=>	MAIN_PORT_Data_out,
		INI_Bias_val					=>	INI_Bias_val,
		INI_Bias_Add					=>	INI_Bias_Add,
		INI_Bias_Wen					=>	INI_Bias_Wen,
		INI_Addresses					=>	INI_Addresses,
		INI_Target_add					=>	INI_Target_add,
		INI_Base_Wen					=>	INI_Base_Wen,
		INI_Count_Wen					=>	INI_Count_Wen,
		INI_IntVal_Wen					=>	INI_IntVal_Wen,
		INI_SA_UAbar					=>	INI_SA_UAbar,
		INI_SLU_unit_add				=>	INI_SLU_unit_add);
	--------------------------------------------------------------------------
	PEs_Control_Box_unit				:	PEs_Control_Box
	GENERIC	MAP(
		BASE_ADDRESS					=>	BASE_ADDRESS_PECO)
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		MAIN_PORT_Dot_Rdy				=>	MAIN_PORT_Dot_Redy_PCB,
		MAIN_PORT_SEL_This				=>	MAIN_PORT_SEL_This_PCB,
		MAIN_PORT_Address				=>	MAIN_PORT_Address,
		MAIN_PORT_Data_in				=>	MAIN_PORT_Data_in,
		MAIN_PORT_WEN					=>	MAIN_PORT_WEN,
		MAIN_PORT_OEN					=>	MAIN_PORT_OEN,
		MAIN_PORT_Data_out				=>	MAIN_PORT_Data_out,
		CMD_PEs_start					=>	CMD_PEs_start,
		CMD_PEs_init_inc_Rows			=>	CMD_PEs_init_inc_Rows,
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
		CMD_UPA_Up_IFM					=>	CMD_UPA_Up_IFM,
		CMD_UPA_Up_WFM					=>	CMD_UPA_Up_WFM,
		CMD_UPA_status					=>	CMD_UPA_status,
		CNT_PEs_PAUSE					=>	CNT_PEs_PAUSE,
		CNT_STA_PAUSE					=>	CNT_STA_PAUSE,
		CNT_UPA_PAUSE					=>	CNT_UPA_PAUSE);
	--------------------------------------------------------------------------
	Event_Counter_Box_unit				:	Plane_Event_Box
	GENERIC	MAP(
		BASE_ADDRESS					=>	BASE_ADDRESS_EVNT)
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
		CMD_PEs_done					=>	CMD_PEs_done,
		CMD_STA_done					=>	CMD_STA_done,
		CMD_UPA_done					=>	CMD_UPA_done,
		--	INTERRUPT	HANDLER
		------	INTERRUPT REQUEST
		INT_EVNT_Done					=>	INT_PSU_Done,
		------	INTERRUPT ANSWERED
		ANS_EVNT_Done					=>	ANS_PSU_Done);
	--------------------------------------------------------------------------
	MAIN_PORT_Dot_Rdy					<=	MAIN_PORT_Dot_Redy_CHB	OR
											MAIN_PORT_Dot_Redy_AIB	OR
											MAIN_PORT_Dot_Redy_PCB	OR
											MAIN_PORT_Dot_Redy_ECB;
	--------------------------------------------------------------------------
	MAIN_PORT_SEL_This					<=	MAIN_PORT_SEL_This_CHB	OR
											MAIN_PORT_SEL_This_AIB	OR
											MAIN_PORT_SEL_This_PCB	OR
											MAIN_PORT_SEL_This_ECB;
	--------------------------------------------------------------------------
end Behavioral;


