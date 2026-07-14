library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.math_real.ALL;
USE work.my_pack_v2.ALL;

entity MPDR_Datapath is
	PORT(
		clk_w					:	IN	std_logic;
		rst_w					:	IN	std_logic;
				
				
		--		Config		
		CNF_MAX_Col				:	IN	std_logic_vector(P_column_size-1		DOWNTO 0);
		CNF_MAX_Chn				:	IN	std_logic_vector(P_channel_size-1		DOWNTO 0);
		
		
		--		Control	(Scheduler)
		Addresses				:	IN	std_logic_vector(P_USA_Add_size-1		DOWNTO 0);
		Target					:	IN	std_logic_vector(2						DOWNTO 0);
		Base_Wen				:	IN	std_logic;
		Cont_Wen				:	IN	std_logic;
		IVal_Wen				:	IN	std_logic;
				
				
		--	TO LMN		
		LL_add					:	OUT	std_logic_vector(P_USA_Add_size-1		DOWNTO 0);
		LL_cnt					:	OUT	std_logic_vector(P_USA_Cnt_size-1		DOWNTO 0);
		LL_data_in				:	IN	std_logic_vector(P_word_size-1			DOWNTO 0);
		LL_data_out				:	OUT	std_logic_vector(P_word_size-1			DOWNTO 0);
		
		
		
		--	Controller
		init					:	IN	std_logic;
		BA_wen					:	IN	std_logic;
		Block_Address			:	IN	std_logic_vector(2						DOWNTO 0);
		second_DataBlock		:	IN	std_logic;
		main_wen				:	IN	std_logic;
		Hand_wen				:	IN	std_logic;
		Pass_Hand				:	IN	std_logic;
		load_mxes				:	IN	std_logic;
		
		
		LMNs_Colm_inc			:	IN	std_logic;
		LMNs_Chan_inc			:	IN	std_logic;
		MPUs_Colm_inc			:	IN	std_logic;
		MPUs_Chan_inc			:	IN	std_logic;
		
		LMNs_Colm_eq			:	OUT	std_logic;
		LMNs_Chan_eq			:	OUT	std_logic;
		MPUs_Colm_eq			:	OUT	std_logic;
		MPUs_Chan_eq			:	OUT	std_logic);
end MPDR_Datapath;

architecture Behavioral of MPDR_Datapath is
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	--	Components 
	------------------------------------------------------------------------
	COMPONENT	LMN_memory_2_P 
	GENERIC(
		depth					:	INTEGER	:=	1024;
		size					:	INTEGER	:=	P_word_size);
	PORT(		
		clk						:	IN	std_logic;
		MEM_1_Add				:	IN	std_logic_vector(integer(ceil(log2(real(depth))))-1 DOWNTO 0);
		MEM_1_wen				:	IN	std_logic;
		MEM_1_Dout				:	OUT	std_logic_vector(size-1 DOWNTO 0);
		MEM_1_Din				:	IN	std_logic_vector(size-1 DOWNTO 0);
		MEM_2_Add				:	IN	std_logic_vector(integer(ceil(log2(real(depth))))-1 DOWNTO 0);
		MEM_2_wen				:	IN	std_logic;
		MEM_2_Dout				:	OUT	std_logic_vector(size-1 DOWNTO 0);
		MEM_2_Din				:	IN	std_logic_vector(size-1 DOWNTO 0));
	END COMPONENT;
	------------------------------------------------------------------------
	COMPONENT	Simple_2P_RegFile 
	GENERIC(
		Asize					:	INTEGER	:=	3;
		Dsize					:	INTEGER	:=	8);
	PORT(		
		clk						:	IN	std_logic;
		MEM_1_Add				:	IN	std_logic_vector(Asize-1 DOWNTO 0);
		MEM_1_wen				:	IN	std_logic;
		MEM_1_Dout				:	OUT	std_logic_vector(Dsize-1 DOWNTO 0);
		MEM_1_Din				:	IN	std_logic_vector(Dsize-1 DOWNTO 0);
		MEM_2_Add				:	IN	std_logic_vector(Asize-1 DOWNTO 0);
		MEM_2_wen				:	IN	std_logic;
		MEM_2_Dout				:	OUT	std_logic_vector(Dsize-1 DOWNTO 0);
		MEM_2_Din				:	IN	std_logic_vector(Dsize-1 DOWNTO 0));
	END COMPONENT;
	------------------------------------------------------------------------
	COMPONENT	address_gen_reduced
	PORT(
		clk						:	IN	std_logic;
		rst						:	IN	std_logic;
		ini						:	IN	std_logic;
		Cntr1_Max				:	IN	std_logic_vector(3 DOWNTO 0);
		Cntr1_inc				:	IN	std_logic;
		Cntr1_val				:	OUT	std_logic_vector(3 DOWNTO 0);
		Cntr1_eq				:	OUT	std_logic;
		Cntr2_Max				:	IN	std_logic_vector(3 DOWNTO 0);
		Cntr2_inc				:	IN	std_logic;
		Cntr2_val				:	OUT	std_logic_vector(3 DOWNTO 0);
		Cntr2_eq				:	OUT	std_logic;
		Cntr3_Max				:	IN	std_logic_vector(3 DOWNTO 0);
		Cntr3_inc				:	IN	std_logic;
		Cntr3_val				:	OUT	std_logic_vector(3 DOWNTO 0);
		Cntr3_eq				:	OUT	std_logic;
		Cntr4_Max				:	IN	std_logic_vector(3 DOWNTO 0);
		Cntr4_inc				:	IN	std_logic;
		Cntr4_val				:	OUT	std_logic_vector(3 DOWNTO 0);
		Cntr4_eq				:	OUT	std_logic;
		Cntr5_Max				:	IN	std_logic_vector(3 DOWNTO 0);
		Cntr5_inc				:	IN	std_logic;
		Cntr5_val				:	OUT	std_logic_vector(3 DOWNTO 0);
		Cntr5_eq				:	OUT	std_logic); 
	END COMPONENT;
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	--	SIGNALS 
	------------------------------------------------------------------------
	SIGNAL	Add_Zero			:	std_logic_vector(P_USA_Add_size-1	DOWNTO	0)	:=	(OTHERS	=>	'0');
	SIGNAL	Cnt_Zero			:	std_logic_vector(P_USA_Cnt_size-1	DOWNTO	0)	:=	(OTHERS	=>	'0');
	SIGNAL	Data_Zero			:	std_logic_vector(P_word_size-1		DOWNTO	0)	:=	(OTHERS	=>	'0');
	------------------------------------------------------------------------
	SIGNAL	BA_Di				:	std_logic_vector(P_USA_Add_size-1	DOWNTO	0);
	SIGNAL	BA_Do				:	std_logic_vector(P_USA_Add_size-1	DOWNTO	0);
	SIGNAL	CA_Do				:	std_logic_vector(P_USA_Cnt_size-1	DOWNTO	0);
	SIGNAL	IA_Do				:	std_logic_vector(P_USA_Add_size-1	DOWNTO	0);
	------------------------------------------------------------------------
	SIGNAL	LMNs_Colm_Max		:	std_logic_vector(P_column_size-1	DOWNTO 0);
	SIGNAL	LMNs_Colm_val		:	std_logic_vector(P_column_size-1	DOWNTO 0);
	SIGNAL	LMNs_Chan_Max		:	std_logic_vector(P_channel_size-1	DOWNTO 0);
	SIGNAL	LMNs_Chan_val		:	std_logic_vector(P_channel_size-1	DOWNTO 0);
	SIGNAL	MPUs_Colm_Max		:	std_logic_vector(P_column_size-1	DOWNTO 0);
	SIGNAL	MPUs_Colm_val		:	std_logic_vector(P_column_size-1	DOWNTO 0);
	SIGNAL	MPUs_Chan_Max		:	std_logic_vector(P_channel_size-1	DOWNTO 0);
	SIGNAL	MPUs_Chan_val		:	std_logic_vector(P_channel_size-1	DOWNTO 0);
	------------------------------------------------------------------------
	SIGNAL	LMN_Side_Addr		:	std_logic_vector(P_column_size + P_channel_size-1	DOWNTO 0);
	SIGNAL	MPU_Side_Main_Addr	:	std_logic_vector(P_column_size + P_channel_size-1	DOWNTO 0);
	SIGNAL	MPU_Side_Hand_Addr	:	std_logic_vector(P_column_size + P_channel_size-1	DOWNTO 0);
	------------------------------------------------------------------------
	SIGNAL	MPU_Main_Do			:	std_logic_vector(P_word_size-1		DOWNTO	0);
	SIGNAL	MPU_Main_Di			:	std_logic_vector(P_word_size-1		DOWNTO	0);
	SIGNAL	MPU_Hand_Do			:	std_logic_vector(P_word_size-1		DOWNTO	0);
	------------------------------------------------------------------------
	------------------------------------------------------------------------
begin
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	--	Instnciation 
	------------------------------------------------------------------------
	DataBlock_Base_Add			:	Simple_2P_RegFile 
	GENERIC	MAP(
		Asize					=>	3,
		Dsize					=>	P_USA_Add_size)
	PORT	MAP(
		clk						=>	clk_w,
		--	Scheduler Side
		MEM_1_Add				=>	Target,
		MEM_1_wen				=>	Base_Wen,
		MEM_1_Dout				=>	OPEN,
		MEM_1_Din				=>	Addresses,
		--	Memory hierarchy side
		MEM_2_Add				=>	Block_Address,
		MEM_2_wen				=>	BA_wen,
		MEM_2_Dout				=>	BA_Do,
		MEM_2_Din				=>	BA_Di);
	------------------------------------------------------------------------
	DataBlock_Base_Cnt			:	Simple_2P_RegFile 
	GENERIC	MAP(
		Asize					=>	3,
		Dsize					=>	P_USA_Cnt_size)
	PORT	MAP(
		clk						=>	clk_w,
		--	Scheduler Side
		MEM_1_Add				=>	Target,
		MEM_1_wen				=>	Cont_Wen,
		MEM_1_Dout				=>	OPEN,
		MEM_1_Din				=>	Addresses(P_USA_Cnt_size-1 DOWNTO 0),
		--	Memory hierarchy side
		MEM_2_Add				=>	Block_Address,
		MEM_2_wen				=>	'0',
		MEM_2_Dout				=>	CA_Do,
		MEM_2_Din				=>	Cnt_Zero);
	------------------------------------------------------------------------
	DataBlock_Base_Ival			:	Simple_2P_RegFile 
	GENERIC	MAP(
		Asize					=>	3,
		Dsize					=>	P_USA_Add_size)
	PORT	MAP(		
		clk						=>	clk_w,
		--	Scheduler Side
		MEM_1_Add				=>	Target,
		MEM_1_wen				=>	IVal_Wen,
		MEM_1_Dout				=>	OPEN,
		MEM_1_Din				=>	Addresses,
		--	Memory hierarchy side
		MEM_2_Add				=>	Block_Address,
		MEM_2_wen				=>	'0',
		MEM_2_Dout				=>	IA_Do,
		MEM_2_Din				=>	Add_Zero);
	------------------------------------------------------------------------
	Main_Content				:	LMN_memory_2_P 
	GENERIC	MAP(
		depth					=>	2 ** (P_channel_size + P_column_size),
		size					=>	P_word_size)
	PORT	MAP(		
		clk						=>	clk_w,
		--	LMN Side
		MEM_1_Add				=>	LMN_Side_Addr,
		MEM_1_wen				=>	'0',
		MEM_1_Dout				=>	LL_data_out,
		MEM_1_Din				=>	Data_Zero,
		--	MPU Side
		MEM_2_Add				=>	MPU_Side_Main_Addr,
		MEM_2_wen				=>	main_wen,
		MEM_2_Dout				=>	MPU_Main_Do,
		MEM_2_Din				=>	MPU_Main_Di);
	------------------------------------------------------------------------
	Helper_Content				:	LMN_memory_2_P 
	GENERIC	MAP(
		depth					=>	2 ** (P_channel_size + P_column_size),
		size					=>	P_word_size)
	PORT	MAP(		
		clk						=>	clk_w,
		--	LMN Side
		MEM_1_Add				=>	LMN_Side_Addr,
		MEM_1_wen				=>	Hand_wen,
		MEM_1_Dout				=>	OPEN,
		MEM_1_Din				=>	LL_data_in,
		--	MPU Side
		MEM_2_Add				=>	MPU_Side_Hand_Addr,
		MEM_2_wen				=>	'0',
		MEM_2_Dout				=>	MPU_Hand_Do,
		MEM_2_Din				=>	Data_Zero);
	------------------------------------------------------------------------
	Add_gen						:	address_gen_reduced
	PORT	MAP(
		clk						=>	clk_w,
		rst						=>	rst_w,
		ini						=>	init,
		--	LMN Side
		Cntr1_Max				=>	LMNs_Colm_Max,
		Cntr1_inc				=>	LMNs_Colm_inc,
		Cntr1_val				=>	LMNs_Colm_val,
		Cntr1_eq				=>	LMNs_Colm_eq,
		Cntr2_Max				=>	LMNs_Chan_Max,
		Cntr2_inc				=>	LMNs_Chan_inc,
		Cntr2_val				=>	LMNs_Chan_val,
		Cntr2_eq				=>	LMNs_Chan_eq,
		--	MPU Side
		Cntr3_Max				=>	MPUs_Colm_Max,
		Cntr3_inc				=>	MPUs_Colm_inc,
		Cntr3_val				=>	MPUs_Colm_val,
		Cntr3_eq				=>	MPUs_Colm_eq,
		Cntr4_Max				=>	MPUs_Chan_Max,
		Cntr4_inc				=>	MPUs_Chan_inc,
		Cntr4_val				=>	MPUs_Chan_val,
		Cntr4_eq				=>	MPUs_Chan_eq,
		Cntr5_Max				=>	"0000",
		Cntr5_inc				=>	'0',
		Cntr5_val				=>	OPEN,
		Cntr5_eq				=>	OPEN);
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	--	Connections
	------------------------------------------------------------------------
	LL_add						<=	BA_Do;
	LL_cnt						<=	CA_Do;
	BA_Di						<=	std_logic_vector(unsigned(BA_Do) + unsigned(IA_Do));
	------------------------------------------------------------------------
	LMN_Side_Addr				<=	LMNs_Chan_val	&	LMNs_Colm_val;
	MPU_Side_Main_Addr			<=	MPUs_Chan_val	&	second_DataBlock	&	LMNs_Colm_val(P_column_size-1	DOWNTO 1);
	MPU_Side_Hand_Addr			<=	MPUs_Chan_val	&	MPUs_Colm_val;
	------------------------------------------------------------------------
	PROCESS	(clk_w, rst_w)
	BEGIN
		IF rst_w = '1' THEN
			LMNs_Colm_Max		<=	(OTHERS	=> '0');		
			LMNs_Chan_Max		<=	(OTHERS	=> '0');		
			MPUs_Colm_Max		<=	(OTHERS	=> '0');		
			MPUs_Chan_Max		<=	(OTHERS	=> '0');		
		ELSIF clk_w = '1' AND clk_w'EVENT THEN
			IF load_mxes = '1'	THEN
				LMNs_Colm_Max	<=	CNF_MAX_Col;
				LMNs_Chan_Max	<=	CNF_MAX_Chn;
				MPUs_Colm_Max	<=	CNF_MAX_Col;
				MPUs_Chan_Max	<=	CNF_MAX_Chn;
			END IF;
		END IF;
	END PROCESS;
	------------------------------------------------------------------------
	PROCESS	(Pass_Hand,		MPU_Hand_Do,	MPU_Main_Do)
	BEGIN
		IF	Pass_Hand = '1' THEN
			MPU_Main_Di			<=	MPU_Hand_Do;
		ElSE
			IF unsigned(MPU_Hand_Do) > unsigned(MPU_Main_Do) THEN
				MPU_Main_Di		<=	MPU_Hand_Do;
			ELSE
				MPU_Main_Di		<=	MPU_Main_Do;
			END IF;
		END IF;
	END PROCESS;
	------------------------------------------------------------------------
	------------------------------------------------------------------------
end Behavioral;

