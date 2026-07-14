library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.my_pack_v2.ALL;
    
entity P_sys is
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
		PEs_OFM_add						:	IN	PEs_OFM_add_4X4;
		PEs_OFM_data					:	OUT	PEs_OFM_data_4X4;
		done							:	OUT	std_logic_4X4;
		PEs_SA_start					:	OUT	std_logic_4X4;
		--	CONTROL
		------	PAUSE
		CNT_PEs_PAUSE					:	IN	std_logic_4X4);
end P_sys;   

architecture Behavioral of P_sys is
	
	COMPONENT	Data_provider_v2 is
	PORT(
		clk								:	IN	std_logic;
		clk_w							:	IN	std_logic;
		rst								:	IN	std_logic;
		--		hgher level cont
		start							:	IN	std_logic_4X4;
		done							:	OUT	std_logic_4X4;
		init_inc_Rows					:	IN	std_logic_4X4V3;
		CNT_PEs_PAUSE					:	IN	std_logic_4X4;
		--		low level
		MB_low_lvl_wen					:	IN	std_logic_4X4V4;
		MB_low_lvl_sig					:	IN	MB_Low_level_mem_4X4;
		--		Config bits
		Maxs							:	IN	all_Max_vals;
		--Add_select						:	IN	std_logic_4X4V2;
		CNF_FSM_sel						:	IN	std_logic_4X4V2;
		--		Update Agent
		Bank_status						:	OUT	std_logic_4X4V4;
		Bank_set_flag					:	IN	std_logic_4X4V4;
		CMD_STA_ACK						:	IN	std_logic_4X4;
		--		to PEs
		PEs_pipo_ready					:	IN	std_logic_4X4;
		PEs_DCA							:	OUT	PEs_DCA_4X4);
	END COMPONENT;
	
	COMPONENT	PEs_v2 is
	PORT(
		clk								:	IN	std_logic;
		clk_w							:	IN	std_logic;
		rst								:	IN	std_logic;
		PEs_CFB							:	IN	PEs_config_bit_4X4;
		--PEs_SRCs						:	IN	std_logic_4X4;
		PEs_pipo_ready					:	OUT	std_logic_4X4;
		PEs_DCA							:	IN	PEs_DCA_4X4;
		WB_low_lvl_wen					:	IN	std_logic_4X4of3X3;
		WB_low_lvl_sig					:	IN	WB_Low_level_mem_4X4;
		PEs_OFM_add						:	IN	PEs_OFM_add_4X4;
		PEs_OFM_data					:	OUT	PEs_OFM_data_4X4;
		PEs_SA_start					:	OUT	std_logic_4X4;
		PEs_SA_ACK						:	IN	std_logic_4X4);
	END COMPONENT;
	
	SIGNAL	PEs_pipo_ready				:	std_logic_4X4;
	SIGNAL	PEs_DCA						:	PEs_DCA_4X4;
	
	SIGNAL	Maxs						:	all_Max_vals; 
	SIGNAL	CNF_FSM_sel					:	std_logic_4X4V2;
	SIGNAL	PEs_CFB						:	PEs_config_bit_4X4;
	
	
begin
	
	Maxs								<=	all_configs.Maxs;
	PEs_CFB								<=	all_configs.PEs_CFB;
	CNF_FSM_sel							<=	all_configs.FSM_sel;
	
	
	Banks								:	Data_provider_v2
	PORT	MAP(
		clk								=>	clk,
		clk_w							=>	clk_w,
		rst								=>	rst,
		--		hgher level cont
		start							=>	start,
		done							=>	done,
		init_inc_Rows					=>	init_inc_Rows,
		CNT_PEs_PAUSE					=>	CNT_PEs_PAUSE,
		--		low level
		MB_low_lvl_wen					=>	MB_low_lvl_wen,
		MB_low_lvl_sig					=>	MB_low_lvl_sig,
		--		Config bits
		Maxs							=>	Maxs,
		--Add_select						=>	Add_select,
		CNF_FSM_sel						=>	CNF_FSM_sel,
		--		Update Agent
		Bank_status						=>	Bank_status,
		Bank_set_flag					=>	Bank_set_flag,
		CMD_STA_ACK						=>	CMD_STA_ACK,
		--		to PEs
		PEs_pipo_ready					=>	PEs_pipo_ready,
		PEs_DCA							=>	PEs_DCA);
	
	
	Processing_Elements					:	PEs_v2
	PORT	MAP(
		clk								=>	clk,
		clk_w							=>	clk_w,
		rst								=>	rst,
		PEs_CFB							=>	PEs_CFB,
		--PEs_SRCs						=>	PEs_SRCs,
		PEs_pipo_ready					=>	PEs_pipo_ready,
		PEs_DCA							=>	PEs_DCA,
		WB_low_lvl_wen					=>	WB_low_lvl_wen,
		WB_low_lvl_sig					=>	WB_low_lvl_sig,
		PEs_OFM_add						=>	PEs_OFM_add,
		PEs_OFM_data					=>	PEs_OFM_data,
		PEs_SA_start					=>	PEs_SA_start,
		PEs_SA_ACK						=>	CMD_STA_ACK);
	
	
end Behavioral;

