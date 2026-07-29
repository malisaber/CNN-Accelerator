library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.math_real.ALL;
USE work.my_pack_v2.ALL;

entity UA_datapath is
	PORT(
		clk_w			:	IN	std_logic;
		rst_w			:	IN	std_logic;
		
		
		--		Config
		Kern_max		:	IN	std_logic_vector(P_kernel_size-1		DOWNTO 0);
		Colm_max		:	IN	std_logic_vector(P_column_size-1		DOWNTO 0);
		Chan_max		:	IN	std_logic_vector(P_channel_size-1		DOWNTO 0);
		
		--		initiate	(scheduler)
		Addresses		:	IN	std_logic_vector(P_USA_Add_size-1		DOWNTO 0);
		Target_add		:	IN	std_logic_vector(3						DOWNTO 0);
		Base_Wen		:	IN	std_logic;
		Count_Wen		:	IN	std_logic;
		IntVal_Wen		:	IN	std_logic;
		
		
		--		Low Level (to LMN)
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
end UA_datapath;

architecture Behavioral of UA_datapath is
	------------------------------------------------------------------------
	--	Components 
	------------------------------------------------------------------------
	COMPONENT	LMN_memory_2_P 
	GENERIC(
		depth			:	INTEGER	:=	1024;
		size			:	INTEGER	:=	P_word_size);
	PORT(
		clk				:	IN	std_logic;
		MEM_1_Add		:	IN	std_logic_vector(integer(ceil(log2(real(depth))))-1 DOWNTO 0);
		MEM_1_wen		:	IN	std_logic;
		MEM_1_Dout		:	OUT	std_logic_vector(size-1 DOWNTO 0);
		MEM_1_Din		:	IN	std_logic_vector(size-1 DOWNTO 0);
		MEM_2_Add		:	IN	std_logic_vector(integer(ceil(log2(real(depth))))-1 DOWNTO 0);
		MEM_2_wen		:	IN	std_logic;
		MEM_2_Dout		:	OUT	std_logic_vector(size-1 DOWNTO 0);
		MEM_2_Din		:	IN	std_logic_vector(size-1 DOWNTO 0));
	END COMPONENT;
	------------------------------------------------------------------------
	COMPONENT	address_gen_reduced
	PORT(
		clk				:	IN	std_logic;
		rst				:	IN	std_logic;
		ini				:	IN	std_logic;
		Cntr1_Max		:	IN	std_logic_vector(3 DOWNTO 0);
		Cntr1_inc		:	IN	std_logic;
		Cntr1_val		:	OUT	std_logic_vector(3 DOWNTO 0);
		Cntr1_eq		:	OUT	std_logic;
		Cntr2_Max		:	IN	std_logic_vector(3 DOWNTO 0);
		Cntr2_inc		:	IN	std_logic;
		Cntr2_val		:	OUT	std_logic_vector(3 DOWNTO 0);
		Cntr2_eq		:	OUT	std_logic;
		Cntr3_Max		:	IN	std_logic_vector(3 DOWNTO 0);
		Cntr3_inc		:	IN	std_logic;
		Cntr3_val		:	OUT	std_logic_vector(3 DOWNTO 0);
		Cntr3_eq		:	OUT	std_logic;
		Cntr4_Max		:	IN	std_logic_vector(3 DOWNTO 0);
		Cntr4_inc		:	IN	std_logic;
		Cntr4_val		:	OUT	std_logic_vector(3 DOWNTO 0);
		Cntr4_eq		:	OUT	std_logic;
		Cntr5_Max		:	IN	std_logic_vector(3 DOWNTO 0);
		Cntr5_inc		:	IN	std_logic;
		Cntr5_val		:	OUT	std_logic_vector(3 DOWNTO 0);
		Cntr5_eq		:	OUT	std_logic); 
	END COMPONENT;
	------------------------------------------------------------------------
	--	Constants 
	------------------------------------------------------------------------
	CONSTANT	zeros	:	std_logic_vector(P_USA_Add_size-1		DOWNTO 0)	:=	(OTHERS	=>	'0');
	------------------------------------------------------------------------
	--	Signals
	------------------------------------------------------------------------
	SIGNAL	Phys_max	:	std_logic_vector(3					DOWNTO	0)		:=	"1000";
	------------------------------------------------------------------------
	SIGNAL	Phys_vls	:	std_logic_vector(3					DOWNTO	0);
	SIGNAL	Kern_val	:	std_logic_vector(P_kernel_size-1	DOWNTO	0);
	SIGNAL	Colm_val	:	std_logic_vector(P_column_size-1	DOWNTO	0);
	SIGNAL	Chan_val	:	std_logic_vector(P_channel_size-1	DOWNTO	0);
	SIGNAL	BAdd_vli	:	std_logic_vector(P_USA_Add_size-1	DOWNTO	0);
	SIGNAL	BAdd_val	:	std_logic_vector(P_USA_Add_size-1	DOWNTO	0);
	SIGNAL	CAdd_val	:	std_logic_vector(P_USA_Cnt_size-1	DOWNTO	0);
	SIGNAL	IAdd_val	:	std_logic_vector(P_USA_Add_size-1	DOWNTO	0);
	------------------------------------------------------------------------
	SIGNAL	tmp			:	std_logic_vector(P_USA_Cnt_size-1	DOWNTO	0);
	------------------------------------------------------------------------
begin
	------------------------------------------------------------------------
	Base_Add_Mem		:	LMN_memory_2_P
	GENERIC	MAP(
		depth			=>	16,
		size			=>	P_USA_Add_size)
	PORT	MAP(
		clk				=>	clk_w,
		--					initiate and Config Port
		MEM_1_Add		=>	Target_add,
		MEM_1_wen		=>	Base_Wen,
		MEM_1_Dout		=>	OPEN,
		MEM_1_Din		=>	Addresses,
		--					NOrmal Mode Use
		MEM_2_Add		=>	BCI_add,
		MEM_2_wen		=>	Base_Step_en,
		MEM_2_Dout		=>	BAdd_val,
		MEM_2_Din		=>	BAdd_vli);
		BAdd_vli		<=	std_logic_vector(unsigned(BAdd_val) + unsigned(IAdd_val));
		LL_add			<=	BAdd_val;
		LL_cnt			<=	CAdd_val;
	------------------------------------------------------------------------
	count_Add_Mem		:	LMN_memory_2_P
	GENERIC	MAP(
		depth			=>	16,
		size			=>	P_USA_Cnt_size)
	PORT	MAP(
		clk				=>	clk_w,
		--					initiate and Config Port
		MEM_1_Add		=>	Target_add,
		MEM_1_wen		=>	Count_Wen,
		MEM_1_Dout		=>	OPEN,
		MEM_1_Din		=>	tmp,
		--					NOrmal Mode Use
		MEM_2_Add		=>	BCI_add,
		MEM_2_wen		=>	'0',
		MEM_2_Dout		=>	CAdd_val,
		MEM_2_Din		=>	zeros(P_USA_Cnt_size-1 DOWNTO 0));
		tmp				<=	Addresses(P_USA_Cnt_size-1 DOWNTO 0);
	------------------------------------------------------------------------
	interVal_Add_Mem	:	LMN_memory_2_P
	GENERIC	MAP(
		depth			=>	16,
		size			=>	P_USA_Add_size)
	PORT	MAP(
		clk				=>	clk_w,
		--					initiate and Config Port
		MEM_1_Add		=>	Target_add,
		MEM_1_wen		=>	IntVal_Wen,
		MEM_1_Dout		=>	OPEN,
		MEM_1_Din		=>	Addresses,
		--					NOrmal Mode Use
		MEM_2_Add		=>	BCI_add,
		MEM_2_wen		=>	'0',
		MEM_2_Dout		=>	iAdd_val,
		MEM_2_Din		=>	zeros);
	------------------------------------------------------------------------
	Address_gen			:	address_gen_reduced
	PORT	MAP(
		clk				=>	clk_w,
		rst				=>	rst_w,
		ini				=>	init,
		Cntr1_Max		=>	Kern_max,
		Cntr1_inc		=>	Kern_inc,
		Cntr1_val		=>	Kern_val,
		Cntr1_eq		=>	Kern_eq	,
		Cntr2_Max		=>	Colm_max,
		Cntr2_inc		=>	Colm_inc,
		Cntr2_val		=>	Colm_val,
		Cntr2_eq		=>	Colm_eq	,
		Cntr3_Max		=>	Chan_max,
		Cntr3_inc		=>	Chan_inc,
		Cntr3_val		=>	Chan_val,
		Cntr3_eq		=>	Chan_eq,
		Cntr4_Max		=>	Phys_max,
		Cntr4_inc		=>	Phys_inc,
		Cntr4_val		=>	Phys_vls,
		Cntr4_eq		=>	Phys_eq,
		Cntr5_Max		=>	"0000",
		Cntr5_inc		=>	'0',
		Cntr5_val		=>	OPEN,
		Cntr5_eq		=>	OPEN);
		Phys_val		<=	Phys_vls;
	------------------------------------------------------------------------
	PROCESS	(clk_w, rst_w)
	BEGIN
		IF rst_w = '1' THEN 
		
		ELSIF clk_w = '1' AND clk_w'EVENT THEN
				MB_low_lvl_sig.Wadd		<=	Chan_val & Colm_val;
				MB_low_lvl_sig.Wdata	<=	LL_data_in;
				WB_low_lvl_sig.Wadd		<=	Chan_val & Kern_val;
				WB_low_lvl_sig.Wdata	<=	LL_data_in;
		END IF;
	END PROCESS;
	------------------------------------------------------------------------
end Behavioral;



