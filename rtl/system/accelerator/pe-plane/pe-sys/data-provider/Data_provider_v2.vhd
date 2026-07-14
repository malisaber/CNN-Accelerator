library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.my_pack_v2.ALL;

entity Data_provider_v2 is
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
end Data_provider_v2;

architecture Behavioral of Data_provider_v2 is
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		COMPONENTs
	--------------------------------------------------------------------------
	COMPONENT	Cont_add_unit_v3
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		--		high level controller
		start							:	IN	std_logic;
		done							:	OUT	std_logic;
		Bank_inc_Rs						:	IN	std_logic_vector(2 DOWNTO 0);
		CNT_PEs_PAUSE					:	IN	std_logic;
		--		Config bits
		Maxs							:	IN	MAX_vals;
		CNF_FSM_sel						:	IN	std_logic_vector(1	DOWNTO 0);
		--		Data flow control
		CMD_STA_ACK						:	IN	std_logic;
		pipo_ready						:	IN	std_logic;
		all_updated						:	IN	std_logic;
		clr_flag						:	OUT	std_logic;
		Bank_add						:	OUT	std_logic_vector(1 DOWNTO 0);
		--		inter Bank communication
		Inter_GBM_sig					:	OUT	inter_GBM_com);
	END COMPONENT;
	--------------------------------------------------------------------------
	COMPONENT	Memory_Bank_Group
	GENERIC(
		ifm_wfm							:	INTEGER	:=	0;
		row_pos							:	INTEGER	:=	0;
		col_pos							:	INTEGER	:=	0);
	PORT(
		clk								:	IN	std_logic;
		clk_w							:	IN	std_logic;
		rst								:	IN	std_logic;
		F_clr							:	IN	std_logic_vector(3 DOWNTO 0);
		F_set							:	IN	std_logic_vector(3 DOWNTO 0);
		F_val							:	OUT	std_logic_vector(3 DOWNTO 0);
		low_lvl_wen						:	IN	std_logic_vector(3 DOWNTO 0);
		low_lvl_sig						:	IN	MB_Low_level_mem;
		M_Radd							:	IN	std_logic_vector(P_IFM_Add_size-1 DOWNTO 0);
		M_Dout_0						:	OUT	std_logic_vector(P_word_size-1 DOWNTO 0);
		M_Dout_1						:	OUT	std_logic_vector(P_word_size-1 DOWNTO 0);
		M_Dout_2						:	OUT	std_logic_vector(P_word_size-1 DOWNTO 0);
		M_Dout_3						:	OUT	std_logic_vector(P_word_size-1 DOWNTO 0));
	END COMPONENT;
	--------------------------------------------------------------------------
	COMPONENT	BM_selector_v2
	PORT(
		Sel_banks						:	IN	std_logic_vector(1				DOWNTO 0);
		Bank_0_data						:	IN	std_logic_vector(P_word_size-1	DOWNTO 0);
		Bank_1_data						:	IN	std_logic_vector(P_word_size-1	DOWNTO 0);
		Bank_2_data						:	IN	std_logic_vector(P_word_size-1	DOWNTO 0);
		Bank_3_data						:	IN	std_logic_vector(P_word_size-1	DOWNTO 0);
		clear_Bank						:	IN	std_logic;
		clear_Bank_Enc					:	OUT	std_logic_vector(3				DOWNTO 0);
		Bank_stat						:	IN	std_logic_vector(3				DOWNTO 0);
		All_Updated						:	OUT	std_logic;
		BM_Dout							:	OUT	PE_IFM_data);
	END COMPONENT;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		TYPEs
	--------------------------------------------------------------------------
	
	TYPE	cons_1X4	IS ARRAY (1 TO 4) OF std_logic_vector(1 DOWNTO 0);
	CONSTANT GBM_const					:	cons_1X4 := ("00","01","10","11");
	
	
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		SIGNALs
	--------------------------------------------------------------------------
	SIGNAL	DP_internal					:	inter_GBM_com_4X4;
	SIGNAL	DP_Sel_banks				:	std_logic_4X4V2;
	SIGNAL	DP_BF_Clr					:	std_logic_4X4;
	SIGNAL	DP_BF_Clr_Enc				:	std_logic_4X4V4;
	SIGNAL	DP_BF_Val					:	std_logic_4X4V4;
	SIGNAL	DP_All_Updated				:	std_logic_4X4;
	SIGNAL	DP_Bank_0_Data				:	std_logic_4X4VPDS;
	SIGNAL	DP_Bank_1_Data				:	std_logic_4X4VPDS;
	SIGNAL	DP_Bank_2_Data				:	std_logic_4X4VPDS;
	SIGNAL	DP_Bank_3_Data				:	std_logic_4X4VPDS;
	SIGNAL	DP_MB_IFM_data				:	PE_IFM_data_4X4;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
begin
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		Instances
	--------------------------------------------------------------------------
	DataProvider_ROW_GWN				:	FOR	r	IN	1	TO	4	GENERATE
		DataProvider_COL_GWN			:	FOR	c	IN	1	TO	4	GENERATE
			------------------------------------------------------------------
			Cont_add_gen_rc				:	Cont_add_unit_v3
			PORT	MAP(
				clk						=>	clk,
				rst						=>	rst,
				--		high level controller
				start					=>	start			(r,c),
				done					=>	done			(r,c),
				Bank_inc_Rs				=>	init_inc_Rows	(r,c),
				CNT_PEs_PAUSE			=>	CNT_PEs_PAUSE	(r,c),
				--		Config bits
				Maxs					=>	Maxs			(r,c),
				CNF_FSM_sel				=>	CNF_FSM_sel		(r,c),
				--		Data flow control
				CMD_STA_ACK				=>	CMD_STA_ACK		(r,c),
				pipo_ready				=>	PEs_pipo_ready	(r,c),
				all_updated				=>	DP_All_Updated	(r,c),
				clr_flag				=>	DP_BF_Clr		(r,c),
				Bank_add				=>	DP_Sel_banks	(r,c),
				--		inter Bank communication
				Inter_GBM_sig			=>	DP_internal		(r,c));	
			------------------------------------------------------------------
			BM_rc						:	Memory_Bank_Group
			GENERIC	MAP(
				ifm_wfm					=>	0,
				row_pos					=>	r,
				col_pos					=>	c)
			PORT	MAP(
				clk						=>	clk,
				clk_w					=>	clk_w,
				rst						=>	rst,
				F_clr					=>	DP_BF_Clr_Enc	(r,c),
				F_set					=>	Bank_set_flag	(r,c),
				F_val					=>	DP_BF_Val		(r,c),
				low_lvl_wen				=>	MB_low_lvl_wen	(r,c),
				low_lvl_sig				=>	MB_low_lvl_sig	(r,c),
				M_Radd					=>	DP_internal		(r,c).IFM_add,
				M_Dout_0				=>	DP_Bank_0_Data	(r,c),
				M_Dout_1				=>	DP_Bank_1_Data	(r,c),
				M_Dout_2				=>	DP_Bank_2_Data	(r,c),
				M_Dout_3				=>	DP_Bank_3_Data	(r,c));
			------------------------------------------------------------------
			BM_selector_rc				:	BM_selector_v2
			PORT	MAP(
				Sel_banks				=>	DP_Sel_banks	(r,c),
				Bank_0_data				=>	DP_Bank_0_Data	(r,c),
				Bank_1_data				=>	DP_Bank_1_Data	(r,c),
				Bank_2_data				=>	DP_Bank_2_Data	(r,c),
				Bank_3_data				=>	DP_Bank_3_Data	(r,c),
				clear_Bank				=>	DP_BF_Clr		(r,c),
				clear_Bank_Enc			=>	DP_BF_Clr_Enc	(r,c),
				Bank_stat				=>	DP_BF_Val		(r,c),
				All_Updated				=>	DP_All_Updated	(r,c),
				BM_Dout					=>	DP_MB_IFM_data	(r,c));
			------------------------------------------------------------------
			PEs_DCA		(r,c).cont		<=	DP_internal		(r,c).PEs_cont_add;
			PEs_DCA		(r,c).data		<=	DP_MB_IFM_data	(r,c);
			Bank_status	(r,c)			<=	DP_BF_Val		(r,c);
			------------------------------------------------------------------
		END GENERATE;
	END GENERATE;
	
	
	
	
	
	
			
			
			
			
				
				
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
	
	
	
	
end Behavioral;


