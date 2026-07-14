library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.my_pack_v2.ALL;

entity Data_provider is
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
		Add_select						:	IN	std_logic_4X4V2;
		CNF_FSM_sel						:	IN	std_logic_4X4V2;
		
		--		Update Agent
		Bank_status						:	OUT	std_logic_4X4V4;
		Bank_set_flag					:	IN	std_logic_4X4V4;
		CMD_STA_ACK						:	IN	std_logic_4X4;
		
		--		to PEs
		PEs_pipo_ready					:	IN	std_logic_4X4;
		PEs_DCA							:	OUT	PEs_DCA_4X4);
end Data_provider;

architecture Behavioral of Data_provider is
	
	
	COMPONENT	Cont_add_unit
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
		Bank_inc_in						:	IN	std_logic;
		GBank_inc_in					:	IN	std_logic;
		all_updated						:	IN	std_logic;
		clr_flag						:	OUT	std_logic;
		Bank_inc_out					:	OUT	std_logic;
		GBank_inc_out					:	OUT	std_logic;
		Bank_add_R1						:	OUT	std_logic_vector(3 DOWNTO 0);
		Bank_add_R2						:	OUT	std_logic_vector(3 DOWNTO 0);
		Bank_add_R3						:	OUT	std_logic_vector(3 DOWNTO 0);
		--		inter Bank communication
		Inter_GBM_sig					:	OUT	inter_GBM_com);
	END COMPONENT;
	
	
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
	
	
	COMPONENT	address_selector
	PORT(
		sel								:	IN	std_logic_vector(1 DOWNTO 0);
		add_in_0						:	IN	inter_GBM_com;
		add_in_1						:	IN	inter_GBM_com;
		add_in_2						:	IN	inter_GBM_com;
		add_out							:	OUT	inter_GBM_com);
	END COMPONENT;
	
	
	COMPONENT	BM_selector
	PORT(
		Row1_sel						:	IN	std_logic_vector(3 DOWNTO 0);
		Row2_sel						:	IN	std_logic_vector(3 DOWNTO 0);
		Row3_sel						:	IN	std_logic_vector(3 DOWNTO 0);
		All_Bank_data					:	IN	All_bank_data_type;
		All_Bank_stat					:	IN	All_bank_1b_type;
		BM_Dout							:	OUT	PE_IFM_data;
		BM_redy							:	OUT	std_logic);
	END COMPONENT;
	
	
	COMPONENT	GBM_selector
	PORT(
		SRC_Sel_1						:	IN	std_logic_vector(1 DOWNTO 0);
		SRC_Sel_2						:	IN	std_logic_vector(1 DOWNTO 0);
		SRC_Sel_3						:	IN	std_logic_vector(1 DOWNTO 0);
		SRC_Sel_4						:	IN	std_logic_vector(1 DOWNTO 0);
		GBM_G1							:	IN	PE_IFM_data;
		GBM_G2							:	IN	PE_IFM_data;
		GBM_G3							:	IN	PE_IFM_data;
		GBM_G4							:	IN	PE_IFM_data;
		PE_1_Din						:	OUT	PE_IFM_data;
		PE_2_Din						:	OUT	PE_IFM_data;
		PE_3_Din						:	OUT	PE_IFM_data;
		PE_4_Din						:	OUT	PE_IFM_data);
	END COMPONENT;
	
	
	TYPE	cons_1X4	IS ARRAY (1 TO 4) OF std_logic_vector(1 DOWNTO 0);
	CONSTANT GBM_const					:	cons_1X4 := ("00","01","10","11");
	
	
	SIGNAL	DP_sig_out					:	inter_GBM_com_5X5;
	SIGNAL	DP_sig_in					:	inter_GBM_com_5X5;
	
	SIGNAL	G_bank_data					:	G_bank_data_type;
	SIGNAL	G_bank_st_t					:	std_logic_4X4V4;
	SIGNAL	G_bank_stat					:	G_bank_1b_type;
	SIGNAL	G_bank_clr					:	G_bank_1b_type;
	
	SIGNAL	Bank_rdy					:	std_logic_5X5;
	SIGNAL	Bank_rdy_c					:	std_logic_5X5;
	
	SIGNAL	Bank_inc					:	std_logic_5X5_0;
	SIGNAL	Bank_inc_t					:	std_logic_5X5_0;
	SIGNAL	Bank_inc_c					:	std_logic_5X5_0;
	
	SIGNAL	Bank_clr					:	std_logic_5X5_0;
	SIGNAL	Bank_clr_t					:	std_logic_5X5_0;
	SIGNAL	Bank_clr_c					:	std_logic_4X4V4;
	
	SIGNAL	Sel_banks					:	std_logic_4X4X3V4;
	
	
	SIGNAL	MB_IFM_data					:	PE_IFM_data_4X4;
	
	SIGNAL	Add_sel						:	std_logic_5X5V2;
	
	
	
begin
	
	init_vals							:	FOR i IN 1 TO 5 GENERATE
		Add_sel(5,i)					<=	"00";
		Add_sel(i,5)					<=	"00";
		Bank_rdy(5,i)					<=	'0';
		Bank_rdy(i,5)					<=	'0';
		Bank_rdy_c(5,i)					<=	'0';
		Bank_rdy_c(i,5)					<=	'0';
		Bank_inc(0,i-1)					<=	'0';
		Bank_inc(i-1,0)					<=	'0';
		Bank_inc_t(0,i-1)				<=	'0';
		Bank_inc_t(i-1,0)				<=	'0';
		Bank_inc_c(0,i-1)				<=	'0';
		Bank_inc_c(i-1,0)				<=	'0';
		Bank_clr(0,i-1)					<=	'0';
		Bank_clr(i-1,0)					<=	'0';
		Bank_clr_t(0,i-1)				<=	'0';
		Bank_clr_t(i-1,0)				<=	'0';
		DP_sig_in(0,i-1)				<=	inter_GBM_com_0;
		DP_sig_in(i-1,0)				<=	inter_GBM_com_0;
	END GENERATE;
	
	
	Bank_status							<=	G_bank_st_t;
	
	
	ROW_gen								:	FOR r IN 1 TO 4 GENERATE
		COL_gen							:	FOR c IN 1 TO 4 GENERATE
			
			Add_sel(r,c)				<=	Add_select(r,c);
			
			Cont_add_gen_rc				:	Cont_add_unit
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
				Bank_inc_in				=>	Bank_inc_c		(r,c),
				GBank_inc_in			=>	'0',
				all_updated				=>	Bank_rdy_c		(r,c),
				clr_flag				=>	Bank_clr		(r,c),
				Bank_inc_out			=>	Bank_inc		(r,c),
				GBank_inc_out			=>	open,
				Bank_add_R1				=>	Sel_banks		(r,c,1),
				Bank_add_R2				=>	Sel_banks		(r,c,2),
				Bank_add_R3				=>	Sel_banks		(r,c,3),
				--		inter Bank communication
				Inter_GBM_sig			=>	DP_sig_out		(r,c));
				
				
			
			add_selector_rc				:	address_selector
			PORT	MAP(
				sel						=>	Add_sel			(r,c),
				add_in_0				=>	DP_sig_out		(r,c),
				add_in_1				=>	DP_sig_in		(r-1,c),
				add_in_2				=>	DP_sig_in		(r,c-1),
				add_out					=>	DP_sig_in		(r,c));
			
			
			
			BM_rc						:	Memory_Bank_Group
			GENERIC	MAP(
				ifm_wfm					=>	0,
				row_pos					=>	r,
				col_pos					=>	c)
			PORT	MAP(
				clk						=>	clk,
				clk_w					=>	clk_w,
				rst						=>	rst,
				F_clr					=>	Bank_clr_c		(r,c),
				F_set					=>	Bank_set_flag	(r,c),
				F_val					=>	G_bank_st_t		(r,c),
				low_lvl_wen				=>	MB_low_lvl_wen	(r,c),
				low_lvl_sig				=>	MB_low_lvl_sig	(r,c),
				M_Radd					=>	DP_sig_in		(r,c).IFM_add,
				M_Dout_0				=>	G_bank_data		(c)(4*r-4),
				M_Dout_1				=>	G_bank_data		(c)(4*r-3),
				M_Dout_2				=>	G_bank_data		(c)(4*r-2),
				M_Dout_3				=>	G_bank_data		(c)(4*r-1));
			G_bank_stat(c)(4*r+0-4)		<=	G_bank_st_t		(r,c)(0);
			G_bank_stat(c)(4*r+1-4)		<=	G_bank_st_t		(r,c)(1);
			G_bank_stat(c)(4*r+2-4)		<=	G_bank_st_t		(r,c)(2);
			G_bank_stat(c)(4*r+3-4)		<=	G_bank_st_t		(r,c)(3);
			
			
			
			BM_selector_rc				:	BM_selector
			PORT	MAP(
				Row1_sel				=>	Sel_banks		(r,c,1),
				Row2_sel				=>	Sel_banks		(r,c,2),
				Row3_sel				=>	Sel_banks		(r,c,3),
				All_Bank_data			=>	G_bank_data		(c),
				All_Bank_stat			=>	G_bank_stat		(c),
				BM_Dout					=>	MB_IFM_data		(r,c),
				BM_redy					=>	Bank_rdy		(r,c));
			
			
			PEs_DCA(r,c).cont			<=	DP_sig_in(r,c).PEs_cont_add;
			
			
			PROCESS (	DP_sig_in(r,c).GBank_add,	Add_sel(r+1,c),	Bank_rdy_c(r+1,c),
						Bank_rdy(r,c), 				Bank_rdy(r,c+1))
			BEGIN	
				IF DP_sig_in(r,c).GBank_add = GBM_const(c) THEN
					IF Add_sel(r+1,c) = "01" THEN
						Bank_rdy_c(r,c)	<=	Bank_rdy_c(r+1,c) AND Bank_rdy(r,c);
					ELSE
						Bank_rdy_c(r,c)	<=	Bank_rdy(r,c);
					END IF;
				ELSE
					Bank_rdy_c(r,c)		<=	Bank_rdy(r,c+1);
				END IF;
			END PROCESS;
			
			
			
			PROCESS (Add_sel(r,c), Bank_inc(r,c), Bank_inc_t(r-1,c), Bank_inc_t(r,c-1))
			BEGIN
				CASE Add_sel(r,c) IS 
					WHEN	"00"		=>	Bank_inc_t(r,c)	<=	Bank_inc(r,c);
					WHEN	"01"		=>	Bank_inc_t(r,c)	<=	Bank_inc_t(r-1,c);
					WHEN	"10"		=>	Bank_inc_t(r,c)	<=	Bank_inc_t(r,c-1);
					WHEN	OTHERS		=>	Bank_inc_t(r,c)	<=	Bank_inc(r,c);
				END CASE; 
			END PROCESS;
			
			PROCESS (DP_sig_in(r,c).GBank_add,	Bank_inc_t(r,c))
			BEGIN
				IF DP_sig_in(r,c).GBank_add = GBM_const(c) THEN
					Bank_inc_c(r,c)		<=	Bank_inc_t(r,c);
				ELSE
					Bank_inc_c(r,c)		<=	'0';
				END IF;
			END PROCESS;
			
			
			
			
			PROCESS (Add_sel(r,c), Bank_clr(r,c), Bank_clr_t(r-1,c), Bank_clr_t(r,c-1))
			BEGIN
				CASE Add_sel(r,c) IS 
					WHEN	"00"		=>	Bank_clr_t(r,c)	<=	Bank_clr(r,c);
					WHEN	"01"		=>	Bank_clr_t(r,c)	<=	Bank_clr_t(r-1,c);
					WHEN	"10"		=>	Bank_clr_t(r,c)	<=	Bank_clr_t(r,c-1);
					WHEN	OTHERS		=>	Bank_clr_t(r,c)	<=	Bank_clr(r,c);
				END CASE;
			END PROCESS;
			
			PROCESS (DP_sig_in(r,c).GBank_add, Add_sel(r,c+1), Bank_clr_t(r,c), Sel_banks)
			BEGIN
				IF (DP_sig_in(r,c).GBank_add = GBM_const(c)) AND (NOT(Add_sel(r,c+1) = "01")) THEN
					Bank_clr_c(r,c)		<=	"0000";
					CASE	Sel_banks		(r,c,1)(1 DOWNTO 0)	IS
						WHEN	"00"	=>	Bank_clr_c(r,c)(0)		<=	Bank_clr_t(r,c);
						WHEN	"01"	=>	Bank_clr_c(r,c)(1)		<=	Bank_clr_t(r,c);
						WHEN	"10"	=>	Bank_clr_c(r,c)(2)		<=	Bank_clr_t(r,c);
						WHEN	"11"	=>	Bank_clr_c(r,c)(3)		<=	Bank_clr_t(r,c);
						WHEN	OTHERS	=>	NULL;
					END CASE;
				ELSE
					Bank_clr_c(r,c)		<=	"0000";
				END IF;
			END PROCESS;
			
		END GENERATE;
		
		
		
		GBM_selector_r					:	GBM_selector
		PORT	MAP(	
			SRC_Sel_1					=>	DP_sig_in			(r,1).GBank_add,
			SRC_Sel_2					=>	DP_sig_in			(r,2).GBank_add,
			SRC_Sel_3					=>	DP_sig_in			(r,3).GBank_add,
			SRC_Sel_4					=>	DP_sig_in			(r,4).GBank_add,
			GBM_G1						=>	MB_IFM_data			(r,1),
			GBM_G2						=>	MB_IFM_data			(r,2),
			GBM_G3						=>	MB_IFM_data			(r,3),
			GBM_G4						=>	MB_IFM_data			(r,4),
			PE_1_Din					=>	PEs_DCA				(r,1).data,
			PE_2_Din					=>	PEs_DCA				(r,2).data,
			PE_3_Din					=>	PEs_DCA				(r,3).data,
			PE_4_Din					=>	PEs_DCA				(r,4).data);
		
		
	END GENERATE;
	
	
	
	
end Behavioral;

