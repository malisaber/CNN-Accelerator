library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.math_real.ALL;
USE work.my_pack_v2.ALL;

entity dataPath_v3 is
	PORT(
		clk				:	IN	std_logic;
		rst				:	IN	std_logic;
		
		--		config bits
		mul_in1_NS		:	IN	std_logic;
		mul_in2_NS		:	IN	std_logic;
		op_half_size	:	IN	std_logic;
		Shift_cnt		:	IN	std_logic_vector(P_shift_cnt-1 DOWNTO 0);
		 
		--		control bits
		SHR_enable		:	IN	std_logic;
		SHR_clear		:	IN	std_logic;
		PIPR_enable		:	IN	std_logic;
		OB_update		:	IN	std_logic;
		OB_wen			:	OUT	std_logic;
		
		--		Data In
		ROW_Din			:	IN	PE_IFM_data;
		WGT_Din			:	IN	PE_WGT_data;
		OB_Din			:	IN	std_logic_vector(P_word_size-1 DOWNTO 0);
		
		--		Data Out
		ROW_Dout		:	OUT	PE_IFM_data;
		OB_Dout			:	OUT	std_logic_vector(P_word_size-1 DOWNTO 0));
end dataPath_v3;

architecture Behavioral of dataPath_v3 is
	
	COMPONENT	MUL_v4
	GENERIC(
		size			:	INTEGER	:=	16);
	PORT(
		inA				:	IN	std_logic_vector(size-1 DOWNTO 0);
		inB				:	IN	std_logic_vector(size-1 DOWNTO 0);
		mode			:	IN	std_logic_vector(2 DOWNTO 0);	--	A sign, B sign, op-mode
		res				:	OUT	std_logic_vector(2*size-1 DOWNTO 0));
	END COMPONENT;
	
	
	COMPONENT	Barrel_Shifter
	GENERIC(
		size			:	INTEGER	:=	8);
	PORT(
		Data_in			:	IN	std_logic_vector(2*size-1 DOWNTO 0);
		Data_out		:	OUT	std_logic_vector(size-1 DOWNTO 0);
		mode			:	IN	std_logic;
		shift_cnt		:	IN	std_logic_vector(integer(ceil(log2(real(size+1))))-1 DOWNTO 0));
	END COMPONENT;
	 
	
	COMPONENT	MultiOpAdder
	GENERIC(
		size			:	INTEGER	:=	16);
	PORT(
		OP_1_1			:	IN	std_logic_vector(size-1 DOWNTO 0);
		OP_1_2			:	IN	std_logic_vector(size-1 DOWNTO 0);
		OP_1_3			:	IN	std_logic_vector(size-1 DOWNTO 0);
		OP_2_1			:	IN	std_logic_vector(size-1 DOWNTO 0);
		OP_2_2			:	IN	std_logic_vector(size-1 DOWNTO 0);
		OP_2_3			:	IN	std_logic_vector(size-1 DOWNTO 0);
		OP_3_1			:	IN	std_logic_vector(size-1 DOWNTO 0);
		OP_3_2			:	IN	std_logic_vector(size-1 DOWNTO 0);
		OP_3_3			:	IN	std_logic_vector(size-1 DOWNTO 0);
		mode			:	IN	std_logic;
		OP_O1			:	OUT	std_logic_vector(size-1 DOWNTO 0);
		OP_O2			:	OUT	std_logic_vector(size-1 DOWNTO 0));
	END COMPONENT;
	
	
	COMPONENT	Reg
	GENERIC(
		size			:	integer	:=	4);
	PORT(	
		clk				:	IN	std_logic;
		rst				:	IN	std_logic;
		load			:	IN	std_logic;
		clear			:	IN	std_logic;
		inp				:	IN	std_logic_vector(size-1 DOWNTO 0);
		val				:	OUT	std_logic_vector(size-1 DOWNTO 0));
	END COMPONENT;
	
	
	COMPONENT	MOP_ACC
	GENERIC(
		word_size		:	INTEGER	:=	16);
	PORT(
		OP_1			:	IN	std_logic_vector(word_size-1 DOWNTO 0);
		OP_2			:	IN	std_logic_vector(word_size-1 DOWNTO 0);
		OP_3			:	IN	std_logic_vector(word_size-1 DOWNTO 0);
		mode			:	IN	std_logic;
		OP_out			:	OUT	std_logic_vector(word_size-1 DOWNTO 0));
	END	COMPONENT;
	
	SIGNAL	mode		:	std_logic_vector(2 DOWNTO 0);
	SIGNAL	en			:	std_logic;
	SIGNAL	en_R		:	std_logic;
	SIGNAL	en_RR		:	std_logic;
	SIGNAL	mode_0_R	:	std_logic;
	SIGNAL	mode_0_RR	:	std_logic;
	SIGNAL	OBU_R		:	std_logic;
	SIGNAL	OBU_RR		:	std_logic;
	
	SIGNAL	R1_P3_DO	:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	R1_P2_DO	:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	R1_P1_DO	:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	R2_P3_DO	:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	R2_P2_DO	:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	R2_P1_DO	:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	R3_P3_DO	:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	R3_P2_DO	:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	R3_P1_DO	:	std_logic_vector(P_word_size-1 DOWNTO 0);
	
	SIGNAL	MO_1_1		:	std_logic_vector(2*P_word_size-1 DOWNTO 0);
	SIGNAL	MO_1_2		:	std_logic_vector(2*P_word_size-1 DOWNTO 0);
	SIGNAL	MO_1_3		:	std_logic_vector(2*P_word_size-1 DOWNTO 0);
	SIGNAL	MO_2_1		:	std_logic_vector(2*P_word_size-1 DOWNTO 0);
	SIGNAL	MO_2_2		:	std_logic_vector(2*P_word_size-1 DOWNTO 0);
	SIGNAL	MO_2_3		:	std_logic_vector(2*P_word_size-1 DOWNTO 0);
	SIGNAL	MO_3_1		:	std_logic_vector(2*P_word_size-1 DOWNTO 0);
	SIGNAL	MO_3_2		:	std_logic_vector(2*P_word_size-1 DOWNTO 0);
	SIGNAL	MO_3_3		:	std_logic_vector(2*P_word_size-1 DOWNTO 0);
	
	SIGNAL	TO_1_1		:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	TO_1_2		:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	TO_1_3		:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	TO_2_1		:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	TO_2_2		:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	TO_2_3		:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	TO_3_1		:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	TO_3_2		:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	TO_3_3		:	std_logic_vector(P_word_size-1 DOWNTO 0);
	
	SIGNAL	RO_1_1		:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	RO_1_2		:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	RO_1_3		:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	RO_2_1		:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	RO_2_2		:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	RO_2_3		:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	RO_3_1		:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	RO_3_2		:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	RO_3_3		:	std_logic_vector(P_word_size-1 DOWNTO 0);
	
	SIGNAL	MOP_OP_1	:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	MOP_OP_2	:	std_logic_vector(P_word_size-1 DOWNTO 0);
	
	SIGNAL	RMOP_OP_1	:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	RMOP_OP_2	:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	RMOP_OP_3	:	std_logic_vector(P_word_size-1 DOWNTO 0);
	
begin
	mode				<=	mul_in1_NS	&	mul_in2_NS	&	op_half_size;
	en					<=	PIPR_enable;
	OB_wen				<=	en_RR;
	
	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			en_R		<=	'0';
			en_RR		<=	'0';
			mode_0_R	<=	'0';
			mode_0_RR	<=	'0';
		ELSIF clk = '1' AND clk'EVENT THEN
			en_R		<=	en;
			en_RR		<=	en_R;
			mode_0_R	<=	mode(0);
			mode_0_RR	<=	mode_0_R;
			OBU_R		<=	OB_update;
			OBU_RR		<=	OBU_R;
		END IF;
	END PROCESS;
	
	
	R1_P3				:	Reg
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		load			=>	SHR_enable,
		clear			=>	SHR_clear,
		inp				=>	ROW_Din.Row1,
		val				=>	R1_P3_DO);
	
	R1_P2				:	Reg
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		load			=>	SHR_enable,
		clear			=>	SHR_clear,
		inp				=>	R1_P3_DO,
		val				=>	R1_P2_DO);
	
	R1_P1				:	Reg
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		load			=>	SHR_enable,
		clear			=>	SHR_clear,
		inp				=>	R1_P2_DO,
		val				=>	R1_P1_DO);
	ROW_Dout.Row1		<=	R1_P1_DO;
	
	
	
	R2_P3				:	Reg
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		load			=>	SHR_enable,
		clear			=>	SHR_clear,
		inp				=>	ROW_Din.Row2,
		val				=>	R2_P3_DO);
	
	R2_P2				:	Reg
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		load			=>	SHR_enable,
		clear			=>	SHR_clear,
		inp				=>	R2_P3_DO,
		val				=>	R2_P2_DO);
	
	R2_P1				:	Reg
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		load			=>	SHR_enable,
		clear			=>	SHR_clear,
		inp				=>	R2_P2_DO,
		val				=>	R2_P1_DO);
	ROW_Dout.Row2		<=	R2_P1_DO;
	
	
	R3_P3				:	Reg
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		load			=>	SHR_enable,
		clear			=>	SHR_clear,
		inp				=>	ROW_Din.Row3,
		val				=>	R3_P3_DO);
		
	R3_P2				:	Reg
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		load			=>	SHR_enable,
		clear			=>	SHR_clear,
		inp				=>	R3_P3_DO,
		val				=>	R3_P2_DO);
		
	R3_P1				:	Reg
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		load			=>	SHR_enable,
		clear			=>	SHR_clear,
		inp				=>	R3_P2_DO,
		val				=>	R3_P1_DO);
	ROW_Dout.Row3		<=	R3_P1_DO;
	
	
	
	
	MUL_1_1				:	MUL_v4
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		inA				=>	R1_P1_DO,
		inB				=>	WGT_Din(1,1),
		mode			=>	mode,
		res				=>	MO_1_1);
	BS_1_1				:	Barrel_Shifter
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		Data_in			=>	MO_1_1,
		Data_out		=>	TO_1_1,
		mode			=>	mode(0),
		shift_cnt		=>	Shift_cnt);
	RP_1_1				:	Reg
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		load			=>	en,
		clear			=>	'0',
		inp				=>	TO_1_1,
		val				=>	RO_1_1);
	
	
	MUL_1_2				:	MUL_v4
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		inA				=>	R1_P2_DO,
		inB				=>	WGT_Din(1,2),
		mode			=>	mode,
		res				=>	MO_1_2);
	BS_1_2				:	Barrel_Shifter
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		Data_in			=>	MO_1_2,
		Data_out		=>	TO_1_2,
		mode			=>	mode(0),
		shift_cnt		=>	Shift_cnt);
	RP_1_2				:	Reg
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		load			=>	en,
		clear			=>	'0',
		inp				=>	TO_1_2,
		val				=>	RO_1_2);
	
	
	MUL_1_3				:	MUL_v4
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		inA				=>	R1_P3_DO,
		inB				=>	WGT_Din(1,3),
		mode			=>	mode,
		res				=>	MO_1_3);
	BS_1_3				:	Barrel_Shifter
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		Data_in			=>	MO_1_3,
		Data_out		=>	TO_1_3,
		mode			=>	mode(0),
		shift_cnt		=>	Shift_cnt);
	RP_1_3				:	Reg
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		load			=>	en,
		clear			=>	'0',
		inp				=>	TO_1_3,
		val				=>	RO_1_3);
	
	
	MUL_2_1				:	MUL_v4
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		inA				=>	R2_P1_DO,
		inB				=>	WGT_Din(2,1),
		mode			=>	mode,
		res				=>	MO_2_1);
	BS_2_1				:	Barrel_Shifter
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		Data_in			=>	MO_2_1,
		Data_out		=>	TO_2_1,
		mode			=>	mode(0),
		shift_cnt		=>	Shift_cnt);
	RP_2_1				:	Reg
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		load			=>	en,
		clear			=>	'0',
		inp				=>	TO_2_1,
		val				=>	RO_2_1);
	
	
	MUL_2_2				:	MUL_v4
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		inA				=>	R2_P2_DO,
		inB				=>	WGT_Din(2,2),
		mode			=>	mode,
		res				=>	MO_2_2);
	BS_2_2				:	Barrel_Shifter
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		Data_in			=>	MO_2_2,
		Data_out		=>	TO_2_2,
		mode			=>	mode(0),
		shift_cnt		=>	Shift_cnt);
	RP_2_2				:	Reg
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		load			=>	en,
		clear			=>	'0',
		inp				=>	TO_2_2,
		val				=>	RO_2_2);
	
	
	MUL_2_3				:	MUL_v4
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		inA				=>	R2_P3_DO,
		inB				=>	WGT_Din(2,3),
		mode			=>	mode,
		res				=>	MO_2_3);
	BS_2_3				:	Barrel_Shifter
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		Data_in			=>	MO_2_3,
		Data_out		=>	TO_2_3,
		mode			=>	mode(0),
		shift_cnt		=>	Shift_cnt);
	RP_2_3				:	Reg
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		load			=>	en,
		clear			=>	'0',
		inp				=>	TO_2_3,
		val				=>	RO_2_3);
	
	
	
	MUL_3_1				:	MUL_v4
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		inA				=>	R3_P1_DO,
		inB				=>	WGT_Din(3,1),
		mode			=>	mode,
		res				=>	MO_3_1);
	BS_3_1				:	Barrel_Shifter
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		Data_in			=>	MO_3_1,
		Data_out		=>	TO_3_1,
		mode			=>	mode(0),
		shift_cnt		=>	Shift_cnt);
	RP_3_1				:	Reg
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		load			=>	en,
		clear			=>	'0',
		inp				=>	TO_3_1,
		val				=>	RO_3_1);
	
	
	MUL_3_2				:	MUL_v4
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		inA				=>	R3_P2_DO,
		inB				=>	WGT_Din(3,2),
		mode			=>	mode,
		res				=>	MO_3_2);
	BS_3_2				:	Barrel_Shifter
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		Data_in			=>	MO_3_2,
		Data_out		=>	TO_3_2,
		mode			=>	mode(0),
		shift_cnt		=>	Shift_cnt);
	RP_3_2				:	Reg
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		load			=>	en,
		clear			=>	'0',
		inp				=>	TO_3_2,
		val				=>	RO_3_2);
	
	
	MUL_3_3				:	MUL_v4
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		inA				=>	R3_P3_DO,
		inB				=>	WGT_Din(3,3),
		mode			=>	mode,
		res				=>	MO_3_3);
	BS_3_3				:	Barrel_Shifter
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		Data_in			=>	MO_3_3,
		Data_out		=>	TO_3_3,
		mode			=>	mode(0),
		shift_cnt		=>	Shift_cnt);
	RP_3_3				:	Reg
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		load			=>	en,
		clear			=>	'0',
		inp				=>	TO_3_3,
		val				=>	RO_3_3);
	
	
	
	nine_2_two_MOPA		:	MultiOpAdder
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		OP_1_1			=>	RO_1_1,
		OP_1_2			=>	RO_1_2,
		OP_1_3			=>	RO_1_3,
		OP_2_1			=>	RO_2_1,
		OP_2_2			=>	RO_2_2,
		OP_2_3			=>	RO_2_3,
		OP_3_1			=>	RO_3_1,
		OP_3_2			=>	RO_3_2,
		OP_3_3			=>	RO_3_3,
		mode			=>	mode_0_R,
		OP_O1			=>	MOP_OP_1,
		OP_O2			=>	MOP_OP_2);
	MOP_PREG_1			:	Reg
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		load			=>	en_R,
		clear			=>	'0',
		inp				=>	MOP_OP_1,
		val				=>	RMOP_OP_1);
	MOP_PREG_2			:	Reg
	GENERIC	MAP(
		size			=>	P_word_size)
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		load			=>	en_R,
		clear			=>	'0',
		inp				=>	MOP_OP_2,
		val				=>	RMOP_OP_2);
	
	
	RMOP_OP_3			<=	OB_Din WHEN	OBU_RR = '1' ELSE (OTHERS => '0');
	
	three2one			:	MOP_ACC
	GENERIC	MAP(
		word_size		=>	P_word_size)
	PORT	MAP(
		OP_1			=>	RMOP_OP_1,
		OP_2			=>	RMOP_OP_2,
		OP_3			=>	RMOP_OP_3,
		mode			=>	mode_0_RR,
		OP_out			=>	OB_Dout);
	
end Behavioral;

