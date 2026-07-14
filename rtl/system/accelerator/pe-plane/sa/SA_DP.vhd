library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.math_real.ALL;
USE work.my_pack_v2.ALL;

entity SA_DP is
	PORT(
		clk_w							:	IN	std_logic;
		rst_w							:	IN	std_logic;
		
		
		--	Config
		CNF_MAX_Kern					:	IN	std_logic_vector(P_kernel_size-1		DOWNTO 0);
		CNF_MAX_Colm					:	IN	std_logic_vector(P_column_size-1		DOWNTO 0);
		CNF_MAX_mode					:	IN	std_logic;
		
		
		--	TOP Level	(scheduler)
		TOP_Bias_val					:	IN	std_logic_vector(P_word_size-1			DOWNTO 0);
		TOP_Bias_Add					:	IN	std_logic_vector(P_kernel_size-1		DOWNTO 0);
		TOP_Addresses					:	IN	std_logic_vector(P_USA_Add_size-1		DOWNTO 0);
		TOP_Target_add					:	IN	std_logic_vector(0						DOWNTO 0);
		TOP_Base_Wen					:	IN	std_logic;
		TOP_Count_Wen					:	IN	std_logic;
		TOP_IntVal_Wen					:	IN	std_logic;
		TOP_Bias_Wen					:	IN	std_logic;
		
		
		--	TO LMN
		LMN_add							:	OUT	std_logic_vector(P_USA_Add_size-1		DOWNTO 0);
		LMN_cnt							:	OUT	std_logic_vector(P_USA_Cnt_size-1		DOWNTO 0);
		LMN_data_in						:	IN	std_logic_vector(P_word_size-1			DOWNTO 0);
		LMN_data_rdy					:	IN	std_logic;
		LMN_data_out					:	OUT	std_logic_vector(P_word_size-1			DOWNTO 0);
		
		
		--	Output Buffer
		------	Data, Address
		OBM_DATA						:	IN	std_logic_vector(P_word_size-1			DOWNTO 0);
		OBM_ADD							:	OUT	std_logic_vector(P_OFM_Add_size-1		DOWNTO 0);
		
		
		
		
		--	Controller 
		------	input
		CNU_init						:	IN	std_logic;
		CNU_Kern_inc					:	IN	std_logic;
		CNU_Colm_inc					:	IN	std_logic;
		CNU_MEM_en						:	IN	std_logic;
		CNU_OFM_en						:	IN	std_logic;
		CNU_BIS_en						:	IN	std_logic;
		CNU_Stat_Wen					:	IN	std_logic;
		CNU_ACT_en						:	IN	std_logic;
		CNU_LSbar						:	IN	std_logic;
		CNU_Load_UA_en					:	IN	std_logic;
		CNU_Stor_UA_en					:	IN	std_logic;
		
		------	Output
		CNU_Kern_eq						:	OUT	std_logic;
		CNU_Colm_eq						:	OUT	std_logic);
end SA_DP;

architecture Behavioral of SA_DP is
	------------------------------------------------------------------------
	--	Components 
	------------------------------------------------------------------------
	COMPONENT	LMN_memory_2_P 
	GENERIC(
		depth							:	INTEGER	:=	1024;
		size							:	INTEGER	:=	P_word_size);
	PORT(
		clk								:	IN	std_logic;
		MEM_1_Add						:	IN	std_logic_vector(integer(ceil(log2(real(depth))))-1 DOWNTO 0);
		MEM_1_wen						:	IN	std_logic;
		MEM_1_Dout						:	OUT	std_logic_vector(size-1				DOWNTO 0);
		MEM_1_Din						:	IN	std_logic_vector(size-1				DOWNTO 0);
		MEM_2_Add						:	IN	std_logic_vector(integer(ceil(log2(real(depth))))-1 DOWNTO 0);
		MEM_2_wen						:	IN	std_logic;
		MEM_2_Dout						:	OUT	std_logic_vector(size-1				DOWNTO 0);
		MEM_2_Din						:	IN	std_logic_vector(size-1				DOWNTO 0));
	END COMPONENT;
	------------------------------------------------------------------------
	COMPONENT	MOP_ACC
	GENERIC(
		word_size						:	INTEGER	:=	16);
	PORT(
		OP_1							:	IN	std_logic_vector(word_size-1		DOWNTO 0);
		OP_2							:	IN	std_logic_vector(word_size-1		DOWNTO 0);
		OP_3							:	IN	std_logic_vector(word_size-1		DOWNTO 0);
		mode							:	IN	std_logic;
		OP_out							:	OUT	std_logic_vector(word_size-1		DOWNTO 0));
	END	COMPONENT;
	------------------------------------------------------------------------
	COMPONENT	Activation
	PORT(
		enable							:	IN	std_logic;
		mode							:	IN	std_logic;
		Din								:	IN	std_logic_vector(P_word_size-1		DOWNTO 0);
		Dout							:	OUT	std_logic_vector(P_word_size-1		DOWNTO 0));
	END COMPONENT;
	------------------------------------------------------------------------
	COMPONENT	SA_Add_gen
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		ini								:	IN	std_logic;
		Kern_Max						:	IN	std_logic_vector(3					DOWNTO 0);
		Kern_inc						:	IN	std_logic;
		Kern_val						:	OUT	std_logic_vector(3					DOWNTO 0);
		Kern_eq							:	OUT	std_logic;
		Colm_Max						:	IN	std_logic_vector(3					DOWNTO 0);
		Colm_inc						:	IN	std_logic;
		Colm_val						:	OUT	std_logic_vector(3					DOWNTO 0);
		Colm_eq							:	OUT	std_logic);
	END COMPONENT;
	------------------------------------------------------------------------
	--	Constants
	------------------------------------------------------------------------
	CONSTANT	All_0					:	std_logic_vector(P_word_size-1			DOWNTO 0) := (OTHERS => '0');
	------------------------------------------------------------------------
	--	Signals
	------------------------------------------------------------------------
	SIGNAL	Kern_val					:	std_logic_vector(P_kernel_size-1		DOWNTO 0);
	SIGNAL	Colm_val					:	std_logic_vector(P_column_size-1		DOWNTO 0);
	SIGNAL	Srce_add					:	std_logic_vector(P_USA_Add_size-1		DOWNTO 0);
	SIGNAL	Srce_cnt					:	std_logic_vector(P_USA_Cnt_size-1		DOWNTO 0);
	SIGNAL	Srce_Ivl					:	std_logic_vector(P_USA_Add_size-1		DOWNTO 0);
	SIGNAL	dest_add					:	std_logic_vector(P_USA_Add_size-1		DOWNTO 0);
	SIGNAL	dest_cnt					:	std_logic_vector(P_USA_Cnt_size-1		DOWNTO 0);
	SIGNAL	dest_Ivl					:	std_logic_vector(P_USA_Add_size-1		DOWNTO 0);
	------------------------------------------------------------------------
	SIGNAL	Stat_ADD					:	std_logic_vector(7						DOWNTO 0);
	SIGNAL	Stat_ADD_R					:	std_logic_vector(7						DOWNTO 0);
	SIGNAL	Stat_ADD_R2					:	std_logic_vector(7						DOWNTO 0);
	------------------------------------------------------------------------
	SIGNAL	OP_MEM						:	std_logic_vector(P_word_size-1			DOWNTO 0);
	SIGNAL	OP_OFM						:	std_logic_vector(P_word_size-1			DOWNTO 0);
	SIGNAL	OP_BIS						:	std_logic_vector(P_word_size-1			DOWNTO 0);
	------------------------------------------------------------------------
	SIGNAL	ACC_OP1						:	std_logic_vector(P_word_size-1			DOWNTO 0);
	SIGNAL	ACC_OP2						:	std_logic_vector(P_word_size-1			DOWNTO 0);
	SIGNAL	ACC_OP3						:	std_logic_vector(P_word_size-1			DOWNTO 0);
	SIGNAL	ACC_OUT						:	std_logic_vector(P_word_size-1			DOWNTO 0);
	SIGNAL	ACC_OUT_R					:	std_logic_vector(P_word_size-1			DOWNTO 0);
	------------------------------------------------------------------------
	SIGNAL	ACT_out						:	std_logic_vector(P_word_size-1			DOWNTO 0);
	------------------------------------------------------------------------
	SIGNAL	Load_BAS					:	std_logic_vector(P_USA_Add_size-1		DOWNTO 0);
	SIGNAL	Load_CNT					:	std_logic_vector(P_USA_Cnt_size-1		DOWNTO 0);
	SIGNAL	Load_IVL					:	std_logic_vector(P_USA_Add_size-1		DOWNTO 0);
	SIGNAL	Stor_BAS					:	std_logic_vector(P_USA_Add_size-1		DOWNTO 0);
	SIGNAL	Stor_CNT					:	std_logic_vector(P_USA_Cnt_size-1		DOWNTO 0);
	SIGNAL	Stor_IVL					:	std_logic_vector(P_USA_Add_size-1		DOWNTO 0);
	------------------------------------------------------------------------
begin
	------------------------------------------------------------------------
	State_Memory						:	LMN_memory_2_P 
	GENERIC	MAP(
		depth							=>	256,
		size							=>	P_word_size)
	PORT	MAP(
		clk								=>	clk_w,
		MEM_1_Add						=>	Stat_ADD,
		MEM_1_wen						=>	LMN_data_rdy,
		MEM_1_Dout						=>	OP_MEM,
		MEM_1_Din						=>	LMN_data_in,
		MEM_2_Add						=>	Stat_ADD_R2,
		MEM_2_wen						=>	CNU_Stat_Wen,
		MEM_2_Dout						=>	OPEN,
		MEM_2_Din						=>	ACC_OUT_R);
	------------------------------------------------------------------------
	Bias_Memory							:	LMN_memory_2_P 
	GENERIC	MAP(
		depth							=>	2**P_kernel_size,
		size							=>	P_word_size)
	PORT	MAP(
		clk								=>	clk_w,
		MEM_1_Add						=>	TOP_Bias_Add,
		MEM_1_wen						=>	TOP_Bias_Wen,
		MEM_1_Dout						=>	OPEN,
		MEM_1_Din						=>	TOP_Bias_val,
		MEM_2_Add						=>	Kern_val,
		MEM_2_wen						=>	'0',
		MEM_2_Dout						=>	OP_BIS,
		MEM_2_Din						=>	All_0);
	------------------------------------------------------------------------
	add_gen								:	SA_Add_gen
	PORT	MAP(
		clk								=>	clk_w,
		rst								=>	rst_w,
		ini								=>	CNU_init,
		Kern_Max						=>	CNF_MAX_Kern,
		Kern_inc						=>	CNU_Kern_inc,
		Kern_val						=>	Kern_val,
		Kern_eq							=>	CNU_Kern_eq,
		Colm_Max						=>	CNF_MAX_Colm,
		Colm_inc						=>	CNU_Colm_inc,
		Colm_val						=>	Colm_val,
		Colm_eq							=>	CNU_Colm_eq);
		Stat_ADD						<=	Kern_val & Colm_val;
	------------------------------------------------------------------------
	PROCESS(clk_w, rst_w)
	BEGIN
		IF rst_w = '1' THEN
			Stat_ADD_R					<=	(OTHERS => '0');
			Stat_ADD_R2					<=	(OTHERS => '0');
		ELSIF clk_w = '1' AND clk_w'EVENT THEN
			Stat_ADD_R					<=	Stat_ADD;
			Stat_ADD_R2					<=	Stat_ADD_R;
		END IF;
	END PROCESS;
	------------------------------------------------------------------------
	OP_OFM								<=	OBM_DATA;
	ACC_OP1								<=	OP_MEM	WHEN CNU_MEM_en	= '1' ElSE (OTHERS => '0');
	ACC_OP2								<=	OP_OFM	WHEN CNU_OFM_en	= '1' ElSE (OTHERS => '0');
	ACC_OP3								<=	OP_BIS	WHEN CNU_BIS_en	= '1' ElSE (OTHERS => '0');
	ACC									:	MOP_ACC
	GENERIC	MAP(
		word_size						=>	P_word_size)
	PORT	MAP(
		OP_1							=>	ACC_OP1,
		OP_2							=>	ACC_OP2,
		OP_3							=>	ACC_OP3,
		mode							=>	CNF_MAX_mode,
		OP_out							=>	ACC_OUT);
	PROCESS (clk_w, rst_w)
	BEGIN
		IF rst_w = '1' THEN
			ACC_OUT_R					<=	(OTHERS => '0');
		ELSIF clk_w = '1' AND clk_w'EVENT THEN
			ACC_OUT_R					<=	ACC_OUT;
		END IF;
	END PROCESS;
	------------------------------------------------------------------------
	OBM_ADD								<=	Kern_val & Colm_val;
	------------------------------------------------------------------------
	ReLu								:	Activation
	PORT	MAP(
		enable							=>	CNU_ACT_en,
		mode							=>	CNF_MAX_mode,
		Din								=>	ACC_OUT_R,
		Dout							=>	ACT_out);
	LMN_data_out						<=	ACT_out;
	------------------------------------------------------------------------
	PROCESS(clk_w)
	BEGIN
		IF clk_w = '1' AND clk_w'EVENT THEN
			IF TOP_Target_add = "0" THEN
				IF TOP_Base_Wen			= '1'	THEN	Load_BAS	<=	TOP_Addresses;												END IF;
				IF TOP_Count_Wen		= '1'	THEN	Load_CNT	<=	TOP_Addresses(P_USA_Cnt_size-1 DOWNTO 0);					END IF;
				IF TOP_IntVal_Wen		= '1'	THEN	Load_IVL	<=	TOP_Addresses;												END IF;
			ELSE	
				IF TOP_Base_Wen			= '1'	THEN	Stor_BAS	<=	TOP_Addresses;												END IF;
				IF TOP_Count_Wen		= '1'	THEN	Stor_CNT	<=	TOP_Addresses(P_USA_Cnt_size-1 DOWNTO 0);					END IF;
				IF TOP_IntVal_Wen		= '1'	THEN	Stor_IVL	<=	TOP_Addresses;												END IF;
			END IF;	
			IF	CNU_Load_UA_en			= '1' 	THEN	Load_BAS	<= std_logic_vector(unsigned(Load_BAS) + unsigned(Load_IVL));	END IF;
			IF	CNU_Stor_UA_en			= '1' 	THEN	Stor_BAS	<= std_logic_vector(unsigned(Stor_BAS) + unsigned(Stor_IVL));	END IF;
		END IF;
	END PROCESS;
	------------------------------------------------------------------------
	LMN_add								<=	Load_BAS	WHEN	CNU_LSbar	=	'1'	ELSE	Stor_BAS;
	LMN_cnt								<=	Load_CNT	WHEN	CNU_LSbar	=	'1'	ELSE	Stor_CNT;
	------------------------------------------------------------------------
end Behavioral;
