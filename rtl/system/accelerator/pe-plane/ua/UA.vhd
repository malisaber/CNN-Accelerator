library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.my_pack_v2.ALL;

entity UA is
	PORT(
		clk_w			:	IN	std_logic;
		rst_w			:	IN	std_logic;
		
		
		--		Control	(Scheduler)
		Addresses		:	IN	std_logic_vector(P_USA_Add_size-1		DOWNTO 0);
		Target_add		:	IN	std_logic_vector(3						DOWNTO 0);
		Base_Wen		:	IN	std_logic;
		Count_Wen		:	IN	std_logic;
		IntVal_Wen		:	IN	std_logic;
		
		
		--		Configs
		MAX_Ker			:	IN	std_logic_vector(P_kernel_size-1		DOWNTO 0);
		MAX_Col			:	IN	std_logic_vector(P_column_size-1		DOWNTO 0);
		MAX_Chn			:	IN	std_logic_vector(P_channel_size-1		DOWNTO 0);
		
		
		--	TOP Level
		Update_IFM		:	IN	std_logic;
		Update_WFM		:	IN	std_logic;
		status			:	OUT	std_logic_vector(1 DOWNTO 0);
		done			:	OUT	std_logic;
		
		
		--	CONTROL
		------	PAUSE
		CNT_UPA_PAUSE	:	IN	std_logic;
		
		
		--	TO LMN
		--LL_ready		:	IN	std_logic;
		--LL_wait			:	IN	std_logic;
		LL_push			:	OUT	std_logic;
		LL_ack			:	IN	std_logic;
		LL_read			:	OUT	std_logic;
		LL_write		:	OUT	std_logic;
		LL_add			:	OUT	std_logic_vector(P_USA_Add_size-1		DOWNTO 0);
		LL_cnt			:	OUT	std_logic_vector(P_USA_Cnt_size-1		DOWNTO 0);
		LL_data_in		:	IN	std_logic_vector(P_word_size-1			DOWNTO 0);
		LL_data_rdy		:	IN	std_logic;
		LL_data_out		:	OUT	std_logic_vector(P_word_size-1			DOWNTO 0);
		LL_data_wen		:	OUT	std_logic;
		
		
		--		TO PEs
		MB_low_lvl_wen	:	OUT	std_logic_vector(3 DOWNTO 0);
		MB_low_lvl_sig	:	OUT	MB_Low_level_mem;
		WB_low_lvl_wen	:	OUT	std_logic_3X3;
		WB_low_lvl_sig	:	OUT	WB_Low_level_mem;
		MB_set_flag		:	OUT	std_logic_vector(3 DOWNTO 0);
		MB_status		:	IN	std_logic_vector(3 DOWNTO 0));
end UA;

architecture Behavioral of UA is
	------------------------------------------------------------------------
	COMPONENT	UA_controller
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
	END COMPONENT;
	------------------------------------------------------------------------
	COMPONENT	UA_datapath
	PORT(
		clk_w			:	IN	std_logic;
		rst_w			:	IN	std_logic;
		--		Config
		Kern_max		:	IN	std_logic_vector(P_kernel_size-1		DOWNTO 0);
		Colm_max		:	IN	std_logic_vector(P_column_size-1		DOWNTO 0);
		Chan_max		:	IN	std_logic_vector(P_channel_size-1		DOWNTO 0);
		--		initiate
		Addresses		:	IN	std_logic_vector(P_USA_Add_size-1		DOWNTO 0);
		Target_add		:	IN	std_logic_vector(3						DOWNTO 0);
		Base_Wen		:	IN	std_logic;
		Count_Wen		:	IN	std_logic;
		IntVal_Wen		:	IN	std_logic;
		--		Low Level
		LL_data_in		:	IN	std_logic_vector(P_word_size-1			DOWNTO 0);
		LL_add			:	OUT	std_logic_vector(P_USA_Add_size-1		DOWNTO 0);
		LL_cnt			:	OUT	std_logic_vector(P_USA_Cnt_size-1		DOWNTO 0);
		--		TO PEs
		MB_low_lvl_sig	:	OUT	MB_Low_level_mem;
		WB_low_lvl_sig	:	OUT	WB_Low_level_mem;
		--		CONTROLLER's SIGNAL
		------	outputs
		Kern_eq			:	OUT	std_logic;
		Colm_eq			:	OUT	std_logic;
		Chan_eq			:	OUT	std_logic;
		Phys_eq			:	OUT	std_logic;
		Phys_val		:	OUT	std_logic_vector(3						DOWNTO 0);
		------	inputs
		init			:	IN	std_logic;
		Kern_inc		:	IN	std_logic;
		Colm_inc		:	IN	std_logic;
		Chan_inc		:	IN	std_logic;
		Phys_inc		:	IN	std_logic;
		Base_Step_en	:	IN	std_logic;
		BCI_add			:	IN	std_logic_vector(3						DOWNTO 0));
	END COMPONENT;
	------------------------------------------------------------------------
	SIGNAL	MB_wen		:	std_logic_vector(3							DOWNTO 0);
	SIGNAL	WB_wen		:	std_logic_vector(8							DOWNTO 0);
	SIGNAL	MB_set		:	std_logic_vector(3							DOWNTO 0);
	SIGNAL	Kern_eq		:	std_logic;
	SIGNAL	Colm_eq		:	std_logic;
	SIGNAL	Chan_eq		:	std_logic;
	SIGNAL	Phys_eq		:	std_logic;
	SIGNAL	Phys_val	:	std_logic_vector(3							DOWNTO 0);
	SIGNAL	init		:	std_logic;
	SIGNAL	Kern_inc	:	std_logic;
	SIGNAL	Colm_inc	:	std_logic;
	SIGNAL	Chan_inc	:	std_logic;
	SIGNAL	Phys_inc	:	std_logic;
	SIGNAL	Base_Step_en:	std_logic;
	SIGNAL	BCI_add		:	std_logic_vector(3							DOWNTO 0);
	------------------------------------------------------------------------
begin
	------------------------------------------------------------------------
	CU					:	UA_controller
	PORT	MAP(
		clk_w			=>	clk_w,
		rst_w			=>	rst_w,
		MB_low_lvl_wen	=>	MB_wen,
		WB_low_lvl_wen	=>	WB_wen,
		MB_set_flag		=>	MB_set,
		MB_status		=>	MB_status,
		Update_IFM		=>	Update_IFM,
		Update_WFM		=>	Update_WFM,
		status			=>	status,
		done			=>	done,
		CNT_UPA_PAUSE	=>	CNT_UPA_PAUSE,
		--LL_ready		=>	LL_ready,
		--LL_wait			=>	LL_wait,
		LL_push			=>	LL_push,
		LL_ack			=>	LL_ack,
		LL_read			=>	LL_read,
		LL_write		=>	LL_write,
		LL_data_rdy		=>	LL_data_rdy,
		LL_data_wen		=>	LL_data_wen,
		Kern_eq			=>	Kern_eq,
		Colm_eq			=>	Colm_eq,
		Chan_eq			=>	Chan_eq,
		Phys_eq			=>	Phys_eq,
		Phys_val		=>	Phys_val,
		init			=>	init,
		Kern_inc		=>	Kern_inc,
		Colm_inc		=>	Colm_inc,
		Chan_inc		=>	Chan_inc,
		Phys_inc		=>	Phys_inc,
		Base_Step_en	=>	Base_Step_en,
		BCI_add			=>	BCI_add);
	------------------------------------------------------------------------
	DP					:	UA_datapath
	PORT	MAP(
		clk_w			=>	clk_w,
		rst_w			=>	rst_w,
		Kern_max		=>	MAX_Ker,
		Colm_max		=>	MAX_Col,
		Chan_max		=>	MAX_Chn,
		Addresses		=>	Addresses,
		Target_add		=>	Target_add,
		Base_Wen		=>	Base_Wen,
		Count_Wen		=>	Count_Wen,
		IntVal_Wen		=>	IntVal_Wen,
		LL_data_in		=>	LL_data_in,
		LL_add			=>	LL_add,
		LL_cnt			=>	LL_cnt,
		MB_low_lvl_sig	=>	MB_low_lvl_sig,
		WB_low_lvl_sig	=>	WB_low_lvl_sig,
		Kern_eq			=>	Kern_eq,
		Colm_eq			=>	Colm_eq,
		Chan_eq			=>	Chan_eq,
		Phys_eq			=>	Phys_eq,
		Phys_val		=>	Phys_val,
		init			=>	init,
		Kern_inc		=>	Kern_inc,
		Colm_inc		=>	Colm_inc,
		Chan_inc		=>	Chan_inc,
		Phys_inc		=>	Phys_inc,
		Base_Step_en	=>	Base_Step_en,
		BCI_add			=>	BCI_add);
	------------------------------------------------------------------------
	MB_low_lvl_wen		<=	MB_wen;
	MB_set_flag			<=	MB_set;
	------------------------------------------------------------------------
	WB_low_lvl_wen(1,1)	<=	WB_wen(0);
	WB_low_lvl_wen(1,2)	<=	WB_wen(1);
	WB_low_lvl_wen(1,3)	<=	WB_wen(2);
	WB_low_lvl_wen(2,1)	<=	WB_wen(3);
	WB_low_lvl_wen(2,2)	<=	WB_wen(4);
	WB_low_lvl_wen(2,3)	<=	WB_wen(5);
	WB_low_lvl_wen(3,1)	<=	WB_wen(6);
	WB_low_lvl_wen(3,2)	<=	WB_wen(7);
	WB_low_lvl_wen(3,3)	<=	WB_wen(8);
	------------------------------------------------------------------------
	LL_data_out			<=	(OTHERS	=>	'0');
	------------------------------------------------------------------------
end Behavioral;

