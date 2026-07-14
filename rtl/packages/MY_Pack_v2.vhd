library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;
USE std.textio.ALL;
--USE work.my_pack_v2.ALL;
 

package MY_Pack_v2	IS
	TYPE		P_uProcessor_type				IS	(P_USE_BIRISC, P_USE_AFTAB);
	
	CONSTANT	P_uProcessor_in_use				:	P_uProcessor_type	:=	P_USE_BIRISC;
	
	
	-- Main Memory Size, 
	CONSTANT	P_Main_MEMx_LINE_COUNT			:	INTEGER	:=	8; -- 10000
	
	
	--		First level constant
	CONSTANT	P_CU_add_size					:	INTEGER	:=	4;
				
	CONSTANT	P_PE_ROW_CNT					:	INTEGER	:=	4;
	CONSTANT	P_PE_COL_CNT					:	INTEGER	:=	4;
				
	CONSTANT	P_PE_ROW_size					:	INTEGER	:=	4;
	CONSTANT	P_PE_COL_size					:	INTEGER	:=	4;
				
	CONSTANT	P_IFM_Add_size					:	INTEGER	:=	8;
	CONSTANT	P_WFM_Add_size					:	INTEGER	:=	8;
	CONSTANT	P_OFM_Add_size					:	INTEGER	:=	8;
				
	CONSTANT	P_word_size						:	INTEGER	:=	16;
				
	CONSTANT	P_Pad_size						:	INTEGER	:=	2;
	CONSTANT	P_kernel_size					:	INTEGER	:=	4;
	CONSTANT	P_column_size					:	INTEGER	:=	4;
	CONSTANT	P_channel_size					:	INTEGER	:=	4;
	CONSTANT	P_row_size						:	INTEGER	:=	4;
	CONSTANT	P_in_cntr_size					:	INTEGER	:=	4;
				
				
				
	--		second level constant			
	CONSTANT	P_shift_cnt						:	INTEGER	:=	integer(ceil(log2(real(P_word_size+1))));
				
	
	--		Transiver FIFO Size
	CONSTANT	P_Transiver_Word_size			:	INTEGER	:=	64;
	
	
				
	--		CU bit position			
	CONSTANT	P_init_pos						:	INTEGER	:=	0;
	CONSTANT	P_Zpad_inc_pos					:	INTEGER	:=	1;
	CONSTANT	P_Kern_inc_pos					:	INTEGER	:=	2;
	CONSTANT	P_Colm_inc_pos					:	INTEGER	:=	3;
	CONSTANT	P_Chan_inc_pos					:	INTEGER	:=	4;
	CONSTANT	P_Rows_inc_pos					:	INTEGER	:=	5;
	CONSTANT	P_Cntr_inc_pos					:	INTEGER	:=	6;
	CONSTANT	P_Bank_inc_pos					:	INTEGER	:=	7;
	CONSTANT	P_GBMs_inc_pos					:	INTEGER	:=	8;
	CONSTANT	P_SHR_en_pos					:	INTEGER	:=	9;
	CONSTANT	P_SHR_clr_pos					:	INTEGER	:=	10;
	CONSTANT	P_PIPR_en_pos					:	INTEGER	:=	11;
	CONSTANT	P_inject_0_pos					:	INTEGER	:=	12;
	CONSTANT	P_swap_ifm_pos					:	INTEGER	:=	13;
	CONSTANT	P_clr_flag_pos					:	INTEGER	:=	14;
	CONSTANT	P_set_OBU_pos					:	INTEGER	:=	15;
	CONSTANT	P_clr_OBU_pos					:	INTEGER	:=	16;
	CONSTANT	P_PingPong_pos					:	INTEGER	:=	17;
	CONSTANT	P_SA_start_pos					:	INTEGER	:=	18;
	CONSTANT	P_done_pos						:	INTEGER	:=	19;
				
	CONSTANT	P_start_e_pos					:	INTEGER	:=	20;
	CONSTANT	P_start_j_pos					:	INTEGER	:=	21;
	CONSTANT	P_Zpad_eq_e_pos					:	INTEGER	:=	22;
	CONSTANT	P_Zpad_eq_j_pos					:	INTEGER	:=	23;
	CONSTANT	P_Kern_eq_e_pos					:	INTEGER	:=	24;
	CONSTANT	P_Kern_eq_j_pos					:	INTEGER	:=	25;
	CONSTANT	P_Colm_eq_e_pos					:	INTEGER	:=	26;
	CONSTANT	P_Colm_eq_j_pos					:	INTEGER	:=	27;
	CONSTANT	P_Chan_eq_e_pos					:	INTEGER	:=	28;
	CONSTANT	P_Chan_eq_j_pos					:	INTEGER	:=	29;
	CONSTANT	P_Rows_eq_e_pos					:	INTEGER	:=	30;
	CONSTANT	P_Rows_eq_j_pos					:	INTEGER	:=	31;
	CONSTANT	P_Cntr_eq_e_pos					:	INTEGER	:=	32;
	CONSTANT	P_Cntr_eq_j_pos					:	INTEGER	:=	33;
	CONSTANT	P_GBMs_eq_e_pos					:	INTEGER	:=	34;
	CONSTANT	P_GBMs_eq_j_pos					:	INTEGER	:=	35;
	CONSTANT	P_ABR_e_pos						:	INTEGER	:=	36;
	CONSTANT	P_ABR_j_pos						:	INTEGER	:=	37;
				
	CONSTANT	P_jmp_type_pos					:	INTEGER	:=	38;
	CONSTANT	P_add_pos						:	INTEGER	:=	39;
				
	CONSTANT	P_CU_width						:	INTEGER	:=	P_add_pos + P_CU_add_size;
	CONSTANT	P_CU_word_cnt					:	INTEGER	:=	(P_CU_width / P_word_size) +1;
	CONSTANT	P_CU_Max_word					:	INTEGER	:=	((P_CU_width / P_word_size) + 1) * P_word_size;
				
				
	--		Config Handler			
	CONSTANT	P_Maxs_size						:	INTEGER	:=	P_Pad_size + P_kernel_size + P_column_size + P_channel_size + P_Row_size + P_in_cntr_size + 12;
	CONSTANT	P_Asel_size						:	INTEGER	:=	2;
	CONSTANT	P_CFBs_size						:	INTEGER	:=	P_shift_cnt + 3;
	CONSTANT	P_SRCs_size						:	INTEGER	:=	1;
	CONSTANT	P_size							:	INTEGER	:=	P_Maxs_size + P_Asel_size + P_CFBs_size + P_SRCs_size;
	CONSTANT	P_size_byte						:	INTEGER	:=	((P_size / P_word_size)+1) * P_word_size;
	CONSTANT	P_word_cnt_m					:	INTEGER	:=	P_size / P_word_size;
	CONSTANT	P_word_cnt						:	INTEGER	:=	integer(ceil(log2(real(P_word_cnt_m+1))));
				
				
				
				
	--		Memory Hierarchy			
	CONSTANT	P_Phy_Add_size					:	INTEGER	:=	32;
	CONSTANT	P_Phy_Cnt_size					:	INTEGER	:=	12;
	CONSTANT	P_Phy_Data_size					:	INTEGER	:=	32;
				
	--		Update AND Store Agent			
	CONSTANT	P_USA_Add_size					:	INTEGER	:=	P_Phy_Add_size;
	CONSTANT	P_USA_Cnt_size					:	INTEGER	:=	P_Phy_Cnt_size;
				
				
				
	CONSTANT	P_CMD_ID_size					:	INTEGER	:=	7;
	CONSTANT	P_CMD_Reserve_size				:	INTEGER	:=	4;
	CONSTANT	P_CMD_PE_R_R_size				:	INTEGER	:=	2;
	CONSTANT	P_CMD_PE_R_C_size				:	INTEGER	:=	2;
	CONSTANT	P_CMD_PE_S_R_size				:	INTEGER	:=	2;
	CONSTANT	P_CMD_PE_S_C_size				:	INTEGER	:=	2;
	CONSTANT	P_CMD_ACT_size					:	INTEGER	:=	4;
				
	CONSTANT	P_CMD_ID_pos					:	INTEGER	:=	25;
	CONSTANT	P_CMD_Reserve_pos				:	INTEGER	:=	21;
	CONSTANT	P_CMD_PE_R_R_pos				:	INTEGER	:=	19;
	CONSTANT	P_CMD_PE_R_C_pos				:	INTEGER	:=	17;
	CONSTANT	P_CMD_PE_S_R_pos				:	INTEGER	:=	15;
	CONSTANT	P_CMD_PE_S_C_pos				:	INTEGER	:=	13;
	CONSTANT	P_CMD_ACT_pos					:	INTEGER	:=	9;
	CONSTANT	P_CMD_mode_pos					:	INTEGER	:=	8;
	CONSTANT	P_CMD_Pre_Load_pos				:	INTEGER	:=	7;
	CONSTANT	P_CMD_Post_Store_pos			:	INTEGER	:=	6;
	CONSTANT	P_CMD_PL_UA_pos					:	INTEGER	:=	5;
	CONSTANT	P_CMD_PS_UA_pos					:	INTEGER	:=	4;
	CONSTANT	P_CMD_OBM_en_pos				:	INTEGER	:=	3;
	CONSTANT	P_CMD_Bias_en_pos				:	INTEGER	:=	2;
	CONSTANT	P_CMD_Buff_en_pos				:	INTEGER	:=	1;
	CONSTANT	P_CMD_save_en_pos				:	INTEGER	:=	0;
	CONSTANT	P_CMD_word_size					:	INTEGER	:=	P_CMD_ID_pos+P_CMD_ID_size;
	
	
	
	
	
	
	----------------------------------------------
	----------------------------------------------
	----------------------------------------------
	CONSTANT	P_Number_of_Planes				:	INTEGER			:=	1;
	
	CONSTANT	P_LMN_Mem_Add_width				:	INTEGER			:=	12;	--	Maximum is 12
	CONSTANT	P_LMN_Number_of_ways			:	INTEGER			:=	4;
	
	
	CONSTANT	P_GMN_Number_of_ways			:	INTEGER			:=	8;
	
	
	
	--	Global Memory Node	GMN
	TYPE		GMN_properties					IS	RECORD
				Number_of_Memories				:	INTEGER;
				Number_of_Memory_Ports			:	INTEGER RANGE 1 TO 2;
				Memory_depth					:	INTEGER;
				Number_of_LMN					:	INTEGER;
				Number_of_DMA					:	INTEGER;
				--Number_of_TLB_entities		:	INTEGER;
				Number_of_Out_Gate				:	INTEGER;
				Number_of_In_Gate				:	INTEGER;
				Number_of_ways					:	INTEGER;
	END RECORD;
	
	
	
	--	the number of DMAs FOR each MMN modules should be between 1 to 4 
	CONSTANT	P_MMN_prob						:	GMN_properties	:=	(	Number_of_Memories			=>	1,
																			Number_of_Memory_Ports		=>	2,
																			Memory_depth				=>	2**10,
																			Number_of_LMN				=>	4,
																			Number_of_DMA				=>	1,
																			Number_of_Out_Gate			=>	1,
																			Number_of_In_Gate			=>	1,
																			Number_of_ways				=>	6);
	--	the number of DMAs FOR the  GMN modules should be between 1 to 16 
	CONSTANT	P_GMN_prob						:	GMN_properties	:=	(	Number_of_Memories			=>	1,
																			Number_of_Memory_Ports		=>	2,
																			Memory_depth				=>	2**10,
																			Number_of_LMN				=>	4,
																			Number_of_DMA				=>	4,
																			Number_of_Out_Gate			=>	16,
																			Number_of_In_Gate			=>	1,
																			Number_of_ways				=>	12);
	
	
	
	
	
	--		New Types
	------	Records
	TYPE		PE_IFM_data 					IS	RECORD
				Row1							:	std_logic_vector(P_word_size-1	DOWNTO	0);
				Row2							:	std_logic_vector(P_word_size-1	DOWNTO	0);
				Row3							:	std_logic_vector(P_word_size-1	DOWNTO	0);
	END RECORD;	
	CONSTANT	PE_IFM_data_0					:	PE_IFM_data	:=	(OTHERS => (OTHERS => '0'));
	
	
	TYPE		PE_WGT_data 					IS	ARRAY(1 TO 3, 1 TO 3) OF std_logic_vector(P_word_size-1	DOWNTO	0);
	
	
	TYPE		MAX_vals						IS	RECORD
				Zpad_Max						:	std_logic_vector(P_Pad_size-1		DOWNTO	0);
				Kern_Max						:	std_logic_vector(P_kernel_size-1	DOWNTO	0);
				Colm_Max						:	std_logic_vector(P_column_size-1	DOWNTO	0);
				Chan_Max						:	std_logic_vector(P_channel_size-1	DOWNTO	0);
				--Rows_Max						:	std_logic_vector(P_Row_size-1		DOWNTO	0);
				--Cntr_Max						:	std_logic_vector(P_in_cntr_size-1	DOWNTO	0);
				--Bank_min						:	std_logic_vector(3	DOWNTO	0);
				--Bank_max						:	std_logic_vector(3	DOWNTO	0);
				--GBMs_Min						:	std_logic_vector(1	DOWNTO	0);
				--GBMs_Max						:	std_logic_vector(1	DOWNTO	0);
	END RECORD;
	
	
	TYPE	PE_cont_add_type					IS	RECORD
				SHR_enable						:	std_logic;
				SHR_clear						:	std_logic;
				PIPR_enable						:	std_logic;
				OB_update						:	std_logic;
				inject_zero						:	std_logic;
				swap_ifm						:	std_logic;
				PingPong						:	std_logic;
				SA_start						:	std_logic;
				WFM_add							:	std_logic_vector(P_channel_size+P_kernel_size-1	DOWNTO	0);
				OFM_add							:	std_logic_vector(P_kernel_size +P_column_size-1	DOWNTO	0);
	END RECORD;				
	CONSTANT	PE_cont_add_0					:	PE_cont_add_type	:=	(
				SHR_enable						=>	'0',
				SHR_clear						=>	'0',
				PIPR_enable						=>	'0',
				OB_update						=>	'0',
				inject_zero						=>	'0',
				swap_ifm						=>	'0',
				PingPong						=>	'0',
				SA_start						=>	'0',
				WFM_add							=>	(OTHERS => '0'),
				OFM_add							=>	(OTHERS => '0'));
					
					
	TYPE		CU_Low_level_mem				IS	RECORD
				Wadd							:	std_logic_vector(P_CU_add_size+4-1	DOWNTO	0);
				Wdata							:	std_logic_vector(P_word_size-1		DOWNTO	0);
	END RECORD;				
					
					
	TYPE		MB_Low_level_mem				IS	RECORD
				Wadd							:	std_logic_vector(P_IFM_Add_size-1	DOWNTO	0);
				Wdata							:	std_logic_vector(P_word_size-1		DOWNTO	0);
	END RECORD;				
					
					
	TYPE		WB_Low_level_mem				IS	RECORD
				Wadd							:	std_logic_vector(P_WFM_Add_size-1	DOWNTO	0);
				Wdata							:	std_logic_vector(P_word_size-1		DOWNTO	0);
	END RECORD;	
		
		
		
		
		
	TYPE		inter_GBM_com					IS	RECORD
				IFM_add							:	std_logic_vector(P_IFM_Add_size-1	DOWNTO	0);
				PEs_cont_add					:	PE_cont_add_type;
	END RECORD;				
	CONSTANT	inter_GBM_com_0					:	inter_GBM_com		:=	(
				IFM_add							=>	(OTHERS => '0'),
				PEs_cont_add					=>	PE_cont_add_0);
					
					
	TYPE		PEs_data_cont_add				IS	RECORD
				data							:	PE_IFM_data;
				cont							:	PE_cont_add_type;
	END RECORD;				
					
					
	TYPE		PEs_config_bit					IS	RECORD
				IFM_NS							:	std_logic;
				WFM_NS							:	std_logic;
				OP_mode							:	std_logic;		--'0'	: <size>/2-bit,	'1' : <size>-bit
				Shift_cnt						:	std_logic_vector(P_shift_cnt-1	DOWNTO	0);
	END RECORD;	
	
	
	
	
	TYPE		P_Birisc_param_type				IS	RECORD
				SUPPORT_BRANCH_PREDICTION		:	INTEGER;
				SUPPORT_MULDIV					:	INTEGER;
				SUPPORT_SUPER					:	INTEGER;
				SUPPORT_MMU						:	INTEGER;
				SUPPORT_DUAL_ISSUE				:	INTEGER;
				SUPPORT_LOAD_BYPASS				:	INTEGER;
				SUPPORT_MUL_BYPASS				:	INTEGER;
				SUPPORT_REGFILE_XILINX			:	INTEGER;
				EXTRA_DECODE_STAGE				:	INTEGER;
				MEM_CACHE_ADDR_MIN				:	INTEGER;
				MEM_CACHE_ADDR_MAX				:	INTEGER;
				NUM_BTB_ENTRIES					:	INTEGER;
				NUM_BTB_ENTRIES_W				:	INTEGER;
				NUM_BHT_ENTRIES					:	INTEGER;
				NUM_BHT_ENTRIES_W				:	INTEGER;
				RAS_ENABLE						:	INTEGER;
				GSHARE_ENABLE					:	INTEGER;
				BHT_ENABLE						:	INTEGER;
				NUM_RAS_ENTRIES					:	INTEGER;
				NUM_RAS_ENTRIES_W				:	INTEGER;
	END RECORD;
	
	
	
	CONSTANT	P_Birisc_param					:	P_Birisc_param_type	:=	(
				SUPPORT_SUPER					=>	1,
				SUPPORT_MMU						=>	0,
				SUPPORT_MULDIV					=>	1,
				SUPPORT_DUAL_ISSUE				=>	1,
				SUPPORT_LOAD_BYPASS				=>	1,
				SUPPORT_MUL_BYPASS				=>	1,
				SUPPORT_REGFILE_XILINX			=>	0,
				SUPPORT_BRANCH_PREDICTION		=>	0,
				NUM_BTB_ENTRIES					=>	4,
				NUM_BTB_ENTRIES_W				=>	2,
				NUM_BHT_ENTRIES					=>	4,
				NUM_BHT_ENTRIES_W				=>	2,
				BHT_ENABLE						=>	0,
				GSHARE_ENABLE					=>	0,
				RAS_ENABLE						=>	0,
				NUM_RAS_ENTRIES					=>	4,
				NUM_RAS_ENTRIES_W				=>	2,
				EXTRA_DECODE_STAGE				=>	1,
				MEM_CACHE_ADDR_MIN				=>	0,
				MEM_CACHE_ADDR_MAX				=>	P_Main_MEMx_LINE_COUNT);
	
	
	
	
	
	
	TYPE		Unc_1D_array					IS	ARRAY (NATURAL RANGE <>)														OF	std_logic;
	TYPE		Unc_1D_P_Addr_array				IS	ARRAY (NATURAL RANGE <>)														OF	std_logic_vector(P_Phy_Add_size-1	DOWNTO	0);
	TYPE		Unc_1D_P_Cont_array				IS	ARRAY (NATURAL RANGE <>)														OF	std_logic_vector(P_Phy_Cnt_size-1	DOWNTO	0);
	TYPE		Unc_1D_P_Data_array				IS	ARRAY (NATURAL RANGE <>)														OF	std_logic_vector(P_word_size-1		DOWNTO	0);
	TYPE		Unc_1D_P_Kern_array				IS	ARRAY (NATURAL RANGE <>)														OF	std_logic_vector(P_kernel_size-1	DOWNTO	0);
	TYPE		Unc_1D_3bit_array				IS	ARRAY (NATURAL RANGE <>)														OF	std_logic_vector(2					DOWNTO	0);
	TYPE		Unc_1D_4bit_array				IS	ARRAY (NATURAL RANGE <>)														OF	std_logic_vector(3					DOWNTO	0);
	
	
	TYPE		Unc_2D_array					IS	ARRAY (NATURAL RANGE <>, NATURAL RANGE <>)										OF	std_logic;
	TYPE		Unc_2D_3bit_array				IS	ARRAY (NATURAL RANGE <>, NATURAL RANGE <>)										OF	std_logic_vector(2					DOWNTO	0);
	TYPE		Unc_2D_P_Addr_array				IS	ARRAY (NATURAL RANGE <>, NATURAL RANGE <>)										OF	std_logic_vector(P_Phy_Add_size-1	DOWNTO	0);
	TYPE		Unc_2D_P_Colm_array				IS	ARRAY (NATURAL RANGE <>, NATURAL RANGE <>)										OF	std_logic_vector(P_column_size	-1	DOWNTO	0);
	TYPE		Unc_2D_P_Chan_array				IS	ARRAY (NATURAL RANGE <>, NATURAL RANGE <>)										OF	std_logic_vector(P_channel_size	-1	DOWNTO	0);
	TYPE		Unc_2D_P_Cont_array				IS	ARRAY (NATURAL RANGE <>, NATURAL RANGE <>)										OF	std_logic_vector(P_Phy_Cnt_size-1	DOWNTO	0);
	TYPE		Unc_2D_P_Data_array				IS	ARRAY (NATURAL RANGE <>, NATURAL RANGE <>)										OF	std_logic_vector(P_word_size-1		DOWNTO	0);
	
	
	TYPE		Unc_3D_array					IS	ARRAY (NATURAL RANGE <>, NATURAL RANGE <>, NATURAL RANGE <>)					OF	std_logic;
	TYPE		Unc_3D_3bit_array				IS	ARRAY (NATURAL RANGE <>, NATURAL RANGE <>, NATURAL RANGE <>)					OF	std_logic_vector(2					DOWNTO	0);
	TYPE		Unc_3D_2bit_array				IS	ARRAY (NATURAL RANGE <>, NATURAL RANGE <>, NATURAL RANGE <>)					OF	std_logic_vector(1					DOWNTO	0);
	
	
	TYPE		Unc_4D_array					IS	ARRAY (NATURAL RANGE <>, NATURAL RANGE <>, NATURAL RANGE <>, NATURAL RANGE <>)	OF	std_logic;
	
	
				
	TYPE		PE_IFM_data_4X4					IS	ARRAY (1 TO 4, 1 TO 4) OF PE_IFM_data;
					
	TYPE		std_logic_2X2					IS	ARRAY (1 TO 2, 1 TO 2) OF std_logic;
	TYPE		std_logic_3X3					IS	ARRAY (1 TO 3, 1 TO 3) OF std_logic;
	TYPE		std_logic_4X4					IS	ARRAY (1 TO 4, 1 TO 4) OF std_logic;
	TYPE		std_logic_4X4V2					IS	ARRAY (1 TO 4, 1 TO 4) OF std_logic_vector(1				DOWNTO	0);
	TYPE		std_logic_4X4V3					IS	ARRAY (1 TO 4, 1 TO 4) OF std_logic_vector(2				DOWNTO	0);
	TYPE		std_logic_4X4V4					IS	ARRAY (1 TO 4, 1 TO 4) OF std_logic_vector(3				DOWNTO	0);
	TYPE		std_logic_4X4VPAS				IS	ARRAY (1 TO 4, 1 TO 4) OF std_logic_vector(P_Phy_Add_size-1	DOWNTO	0);
	TYPE		std_logic_4X4VPCS				IS	ARRAY (1 TO 4, 1 TO 4) OF std_logic_vector(P_Phy_Cnt_size-1	DOWNTO	0);
	TYPE		std_logic_4X4VPDS				IS	ARRAY (1 TO 4, 1 TO 4) OF std_logic_vector(P_word_size-1	DOWNTO	0);
	TYPE		std_logic_4X4X3V4				IS	ARRAY (1 TO 4, 1 TO 4, 1 TO 3) OF std_logic_vector(3		DOWNTO	0);
	TYPE		std_logic_5X5					IS	ARRAY (1 TO 5, 1 TO 5) OF std_logic;
	TYPE		std_logic_5X5_0					IS	ARRAY (0 TO 4, 0 TO 4) OF std_logic;
	TYPE		std_logic_5X5V2					IS	ARRAY (1 TO 5, 1 TO 5) OF std_logic_vector(1				DOWNTO	0);
	TYPE		all_Max_vals					IS	ARRAY (1 TO 4, 1 TO 4) OF MAX_vals;
	TYPE		inter_GBM_com_5X5				IS	ARRAY (0 TO 4, 0 TO 4) OF inter_GBM_com;
	TYPE		inter_GBM_com_4X4				IS	ARRAY (1 TO 4, 1 TO 4) OF inter_GBM_com;
				
	--TYPE		ALL_OBM_DATA					IS	ARRAY (1 TO 4, 1 TO 4) OF std_logic_vector(P_word_size-1	DOWNTO	0);
				
				
	TYPE		All_bank_data_type				IS	ARRAY (0 TO 15) OF std_logic_vector(P_word_size-1			DOWNTO	0);
	TYPE		All_bank_1b_type				IS	ARRAY (0 TO 15) OF std_logic;
					
	TYPE		G_bank_data_type				IS	ARRAY (1 TO 4) OF All_bank_data_type;
	TYPE		G_bank_1b_type					IS	ARRAY (1 TO 4) OF All_bank_1b_type;
					
	TYPE		PEs_DCA_4X4						IS	ARRAY (1 TO 4, 1 TO 4) OF PEs_data_cont_add;
					
	TYPE		PEs_Data_4X4					IS	ARRAY (1 TO 4, 1 TO 4) OF PE_IFM_data;
					
					
	TYPE		PEs_config_bit_4X4				IS	ARRAY (1 TO 4, 1 TO 4) OF PEs_config_bit;
					
	TYPE		std_logic_4X4of3X3				IS	ARRAY (1 TO 4, 1 TO 4) OF std_logic_3X3;
					
	TYPE		PEs_OFM_add_4X4					IS	ARRAY (1 TO 4, 1 TO 4) OF std_logic_vector(P_OFM_Add_size-1	DOWNTO	0);
	TYPE		PEs_OFM_data_4X4				IS	ARRAY (1 TO 4, 1 TO 4) OF std_logic_vector(P_word_size-1	DOWNTO	0);
	
	
	TYPE		Kern_MAX_4X4					IS	ARRAY (1 TO 4, 1 TO 4) OF std_logic_vector(P_kernel_size-1	DOWNTO	0);
	TYPE		Colm_MAX_4X4					IS	ARRAY (1 TO 4, 1 TO 4) OF std_logic_vector(P_column_size-1	DOWNTO	0);
	TYPE		OP_mode_4X4						IS	ARRAY (1 TO 4, 1 TO 4) OF std_logic;
	
	TYPE		all_configs_type				IS	RECORD
				Maxs							:	all_Max_vals; 
				PEs_CFB							:	PEs_config_bit_4X4;
				FSM_sel							:	std_logic_4X4V2;
	END RECORD;	
	
	
	TYPE		CU_Low_level_mem_4X4			IS	ARRAY	(1 TO 4, 1 TO 4)	OF	CU_Low_level_mem;
	TYPE		WB_Low_level_mem_4X4			IS	ARRAY	(1 TO 4, 1 TO 4)	OF	WB_Low_level_mem;
	TYPE		MB_Low_level_mem_4X4			IS	ARRAY	(1 TO 4, 1 TO 4)	OF	MB_Low_level_mem;
	
	
	
	TYPE		Plane_all_configs_type			IS	ARRAY	(P_Number_of_Planes-1	DOWNTO	0)	OF	all_configs_type;
	TYPE		Plane_std_logic_4X4				IS	ARRAY	(P_Number_of_Planes-1	DOWNTO	0)	OF	std_logic_4X4;
	TYPE		Plane_std_logic_4X4V2			IS	ARRAY	(P_Number_of_Planes-1	DOWNTO	0)	OF	std_logic_4X4V2;
	TYPE		Plane_std_logic_4X4V3			IS	ARRAY	(P_Number_of_Planes-1	DOWNTO	0)	OF	std_logic_4X4V3;
	TYPE		Plane_std_logic_4X4VPAS			IS	ARRAY	(P_Number_of_Planes-1	DOWNTO	0)	OF	std_logic_4X4VPAS;
	TYPE		Plane_std_logic_4X4VPCS			IS	ARRAY	(P_Number_of_Planes-1	DOWNTO	0)	OF	std_logic_4X4VPCS;
	TYPE		Plane_std_logic_4X4VPDS			IS	ARRAY	(P_Number_of_Planes-1	DOWNTO	0)	OF	std_logic_4X4VPDS;
	
	TYPE		PLN_INT							IS	ARRAY	(P_Number_of_Planes-1	DOWNTO	0)	OF	INTEGER;
	
	TYPE		Plane_std_logic					IS	ARRAY	(P_Number_of_Planes-1	DOWNTO	0)	OF	std_logic;
	TYPE		Plane_std_logic_vector_Addr		IS	ARRAY	(P_Number_of_Planes-1	DOWNTO	0)	OF	std_logic_vector(P_Phy_Add_size-1	DOWNTO	0);
	TYPE		Plane_std_logic_vector_Cont		IS	ARRAY	(P_Number_of_Planes-1	DOWNTO	0)	OF	std_logic_vector(P_Phy_Cnt_size-1	DOWNTO	0);
	TYPE		Plane_std_logic_vector_Data		IS	ARRAY	(P_Number_of_Planes-1	DOWNTO	0)	OF	std_logic_vector(P_word_size-1		DOWNTO	0);
	
	TYPE		Arr_4X4_Plane_sl				IS	ARRAY	(1 TO 4, 1 TO 4) 					OF	Plane_std_logic;
	TYPE		Arr_4X4_Plane_slv_Addr			IS	ARRAY	(1 TO 4, 1 TO 4) 					OF	Plane_std_logic_vector_Addr;
	TYPE		Arr_4X4_Plane_slv_Cont			IS	ARRAY	(1 TO 4, 1 TO 4) 					OF	Plane_std_logic_vector_Cont;
	TYPE		Arr_4X4_Plane_slv_Data			IS	ARRAY	(1 TO 4, 1 TO 4) 					OF	Plane_std_logic_vector_Data;
	

	
		
				
	CONSTANT	UA_start_add_fn					:	STRING	:=	"UA_start_add.BIN";
	CONSTANT	UA_count_size_fn				:	STRING	:=	"UA_count_of_read.BIN";
	CONSTANT	SA_start_add_fn					:	STRING	:=	"SA_start_add.BIN";
	CONSTANT	SA_count_size_fn				:	STRING	:=	"SA_count_of_read.BIN";
	
	
	
	
	
	
	TYPE		T_LMN_MMAP						IS	ARRAY (0 TO 3, 0 TO 3, 0 TO 1) OF Unc_1D_P_Addr_array (2	DOWNTO 0);
	--																	Row			Col			Min`/Max				MEM_Port_1				MEM_Port_2				Gate 2 VC
	CONSTANT	P_LMN_MMAP						:	T_LMN_MMAP	:=	(	0	=>	(	0	=>	(	0	=>		(	0	=>	X"FFFF0000",	1	=>	X"FFFF0000",	2	=>	X"00000000"),		--	min
																								1	=>		(	0	=>	X"FFFF0FFF",	1	=>	X"FFFF0FFF",	2	=>	X"0FFFFFFF")),		--	max
																					1	=>	(	0	=>		(	0	=>	X"FFFF1000",	1	=>	X"FFFF1000",	2	=>	X"10000000"),		--	min
																								1	=>		(	0	=>	X"FFFF1FFF",	1	=>	X"FFFF1FFF",	2	=>	X"1FFFFFFF")),		--	max
																					2	=>	(	0	=>		(	0	=>	X"FFFF2000",	1	=>	X"FFFF2000",	2	=>	X"20000000"),		--	min
																								1	=>		(	0	=>	X"FFFF2FFF",	1	=>	X"FFFF2FFF",	2	=>	X"2FFFFFFF")),		--	max
																					3	=>	(	0	=>		(	0	=>	X"FFFF3000",	1	=>	X"FFFF3000",	2	=>	X"30000000"),		--	min
																								1	=>		(	0	=>	X"FFFF3FFF",	1	=>	X"FFFF3FFF",	2	=>	X"3FFFFFFF"))),		--	max
																		1	=>	(	0	=>	(	0	=>		(	0	=>	X"FFFF4000",	1	=>	X"FFFF4000",	2	=>	X"40000000"),		--	min
																								1	=>		(	0	=>	X"FFFF4FFF",	1	=>	X"FFFF4FFF",	2	=>	X"4FFFFFFF")),		--	max
																					1	=>	(	0	=>		(	0	=>	X"FFFF5000",	1	=>	X"FFFF5000",	2	=>	X"50000000"),		--	min
																								1	=>		(	0	=>	X"FFFF5FFF",	1	=>	X"FFFF5FFF",	2	=>	X"5FFFFFFF")),		--	max
																					2	=>	(	0	=>		(	0	=>	X"FFFF6000",	1	=>	X"FFFF6000",	2	=>	X"60000000"),		--	min
																								1	=>		(	0	=>	X"FFFF6FFF",	1	=>	X"FFFF6FFF",	2	=>	X"6FFFFFFF")),		--	max
																					3	=>	(	0	=>		(	0	=>	X"FFFF7000",	1	=>	X"FFFF7000",	2	=>	X"70000000"),		--	min
																								1	=>		(	0	=>	X"FFFF7FFF",	1	=>	X"FFFF7FFF",	2	=>	X"7FFFFFFF"))),		--	max
																		2	=>	(	0	=>	(	0	=>		(	0	=>	X"FFFF8000",	1	=>	X"FFFF8000",	2	=>	X"80000000"),		--	min
																								1	=>		(	0	=>	X"FFFF8FFF",	1	=>	X"FFFF8FFF",	2	=>	X"8FFFFFFF")),		--	max
																					1	=>	(	0	=>		(	0	=>	X"FFFF9000",	1	=>	X"FFFF9000",	2	=>	X"90000000"),		--	min
																								1	=>		(	0	=>	X"FFFF9FFF",	1	=>	X"FFFF9FFF",	2	=>	X"9FFFFFFF")),		--	max
																					2	=>	(	0	=>		(	0	=>	X"FFFFA000",	1	=>	X"FFFFA000",	2	=>	X"A0000000"),		--	min
																								1	=>		(	0	=>	X"FFFFAFFF",	1	=>	X"FFFFAFFF",	2	=>	X"AFFFFFFF")),		--	max
																					3	=>	(	0	=>		(	0	=>	X"FFFFB000",	1	=>	X"FFFFB000",	2	=>	X"B0000000"),		--	min
																								1	=>		(	0	=>	X"FFFFBFFF",	1	=>	X"FFFFBFFF",	2	=>	X"BFFFFFFF"))),		--	max
																		3	=>	(	0	=>	(	0	=>		(	0	=>	X"FFFFC000",	1	=>	X"FFFFC000",	2	=>	X"C0000000"),		--	min
																								1	=>		(	0	=>	X"FFFFCFFF",	1	=>	X"FFFFCFFF",	2	=>	X"CFFFFFFF")),		--	max
																					1	=>	(	0	=>		(	0	=>	X"FFFFD000",	1	=>	X"FFFFD000",	2	=>	X"D0000000"),		--	min
																								1	=>		(	0	=>	X"FFFFDFFF",	1	=>	X"FFFFDFFF",	2	=>	X"DFFFFFFF")),		--	max
																					2	=>	(	0	=>		(	0	=>	X"FFFFE000",	1	=>	X"FFFFE000",	2	=>	X"E0000000"),		--	min
																								1	=>		(	0	=>	X"FFFFEFFF",	1	=>	X"FFFFEFFF",	2	=>	X"EFFFFFFF")),		--	max
																					3	=>	(	0	=>		(	0	=>	X"FFFFF000",	1	=>	X"FFFFF000",	2	=>	X"F0000000"),		--	min
																								1	=>		(	0	=>	X"FFFFFFFF",	1	=>	X"FFFFFFFF",	2	=>	X"FFFEFFFF"))));	--	max
																		
																		
	
	
	
	
	
	
	CONSTANT	P_GMN_MMAP_Min_1				:	Unc_1D_P_Addr_array (15	DOWNTO 0)	:=	(	X"00000000",	X"10000000",	X"20000000",	X"30000000",	
																								X"40000000",	X"50000000",	X"60000000",	X"70000000",
																								X"80000000",	X"90000000",	X"A0000000",	X"B0000000",	
																								X"C0000000",	X"D0000000",	X"E0000000",	X"F0000000");
	CONSTANT	P_GMN_MMAP_Max_1				:	Unc_1D_P_Addr_array (15	DOWNTO 0)	:=	(	X"0FFFFFFF",	X"1FFFFFFF",	X"2FFFFFFF",	X"3FFFFFFF",	
																								X"4FFFFFFF",	X"5FFFFFFF",	X"6FFFFFFF",	X"7FFFFFFF",
																								X"8FFFFFFF",	X"9FFFFFFF",	X"AFFFFFFF",	X"BFFFFFFF",	
																								X"CFFFFFFF",	X"DFFFFFFF",	X"EFFFFFFF",	X"FFFEFFFF");
	
																								
	
																								
	
	CONSTANT	P_GMN_MMAP_Min_2				:	Unc_1D_P_Addr_array (15	DOWNTO 0)	:=	(	X"FFFF0000",	X"FFFF1000",	X"FFFF2000",	X"FFFF3000",	
																								X"FFFF4000",	X"FFFF5000",	X"FFFF6000",	X"FFFF7000",
																								X"FFFF8000",	X"FFFF9000",	X"FFFFA000",	X"FFFFB000",	
																								X"FFFFC000",	X"FFFFD000",	X"FFFFE000",	X"FFFFF000");
	CONSTANT	P_GMN_MMAP_Max_2				:	Unc_1D_P_Addr_array (15	DOWNTO 0)	:=	(	X"FFFF0FFF",	X"FFFF1FFF",	X"FFFF2FFF",	X"FFFF3FFF",	
																								X"FFFF4FFF",	X"FFFF5FFF",	X"FFFF6FFF",	X"FFFF7FFF",
																								X"FFFF8FFF",	X"FFFF9FFF",	X"FFFFAFFF",	X"FFFFBFFF",	
																								X"FFFFCFFF",	X"FFFFDFFF",	X"FFFFEFFF",	X"FFFFFFFF");	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	--------------------------------------------------------------------------------------
	--	FUNCTIONs
	--------------------------------------------------------------------------------------
	FUNCTION	max				(	in1		:	INTEGER;
									in2		:	INTEGER)	RETURN INTEGER;
	--------------------------------------------------------------------------------------
	--FUNCTION	rep_msg			(	fn		:	IN	string;
	--								msg		:	IN	string) RETURN INTEGER;
	--------------------------------------------------------------------------------------
	--FUNCTION	close_f			(	fn		:	IN	string) RETURN INTEGER;
	--------------------------------------------------------------------------------------
	FUNCTION	my_to_uint		(	inp		:	std_logic_vector)	RETURN	INTEGER;
	--------------------------------------------------------------------------------------
	FUNCTION	X_check			(	inp		:	std_logic_vector)	RETURN	std_logic_vector;
	--------------------------------------------------------------------------------------
	
	
	
	
	
	
	
	
	
	
	----	Memory Controller
	--CONSTANT	T_interface_Hclk	:	TIME					:=	0.5 ns;										--	Clock cycle time
	--CONSTANT	T_RCD_time			:	TIME					:=	10	ns;										--	ROW cmd to COL cmd
	--CONSTANT	T_RP				:	TIME					:=	10	ns;										--	row precharge
	--
	--CONSTANT	C_RL				:	INTEGER	RANGE 4 TO 63	:=	8;											--	Read Latency
	--CONSTANT	C_WL				:	INTEGER	RANGE 4 TO 16	:=	8;											--	Write Latency
	--CONSTANT	C_WR				:	INTEGER	RANGE 4 TO 63	:=	8;											--	Write Recoveery
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
end MY_Pack_v2;

package body MY_Pack_v2	IS
	----------------------------------------------------------------------------------------
	----	FUNCTIONs
	----------------------------------------------------------------------------------------
	FUNCTION	max			(		in1		:	INTEGER;
									in2		:	INTEGER)	RETURN INTEGER	IS	
	BEGIN
		IF	in1 > in2	THEN
			RETURN in1;
		ELSE
			RETURN in2;
		END IF;
	END FUNCTION;
	----------------------------------------------------------------------------------------	
	--FUNCTION	rep_msg		(		fn		:	IN	string;
	--								msg		:	IN	string) RETURN INTEGER	IS
	--	file					VEC_FILE	:	text	OPEN	append_mode	IS	fn;
	--	VARIABLE				VEC_LINE	:	line;
	--BEGIN
	--	--REPORT	"Opening File " & fn & " in Read mode" SEVERITY NOTE; 
	--	write(VEC_LINE, msg);
	--	writeline(VEC_FILE, VEC_LINE);
	--	RETURN 0;
	--END FUNCTION;
	----------------------------------------------------------------------------------------	
	--FUNCTION	close_f			(	fn		:	IN	string) RETURN INTEGER IS
	--	file					VEC_FILE	:	text	OPEN	write_mode IS	fn;
	--BEGIN
	--	RETURN 0;
	--END FUNCTION;
	----------------------------------------------------------------------------------------	
	FUNCTION	my_to_uint		(	inp		:	std_logic_vector)	RETURN	INTEGER	IS
	BEGIN
		RETURN	to_integer(UNSIGNED(X_check(inp)));
	END;
	----------------------------------------------------------------------------------------	
	FUNCTION	X_check			(	inp		:	std_logic_vector)	RETURN	std_logic_vector	IS
		VARIABLE					tmp		:	std_logic_vector(inp'RANGE);
		VARIABLE					has		:	INTEGER	:=	0;
	BEGIN
		has			:=	0;
		FOR i IN inp'RANGE LOOP
			IF inp(i) = '1' THEN
				NULL;
			ELSIF inp(i) = '0' THEN
				NULL;
			ELSE
				has	:=	1;
				EXIT;
			END IF;
		END LOOP;
		IF has = 1 THEN
			tmp		:=	(OTHERS	=>	'0');
		ELSE
			tmp		:=	inp;
		END IF;
		RETURN	tmp;
	END;
	----------------------------------------------------------------------------------------	
end MY_Pack_v2;
