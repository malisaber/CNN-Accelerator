library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MultiOpAdder is
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
end MultiOpAdder;

architecture Behavioral of MultiOpAdder is
	
	COMPONENT	MOA_slice
	PORT(
		operand_in		:	IN	std_logic_vector(8 DOWNTO 0);
		carry_in		:	IN	std_logic_vector(6 DOWNTO 0);
		carry_out		:	OUT	std_logic_vector(6 DOWNTO 0);
		operand_out		:	OUT	std_logic_vector(1 DOWNTO 0));
	END COMPONENT;
	
	TYPE	carries	IS ARRAY (0 TO size-1) OF std_logic_vector(6 DOWNTO 0);
	TYPE	outputs	IS ARRAY (0 TO size-1) OF std_logic_vector(1 DOWNTO 0);
	TYPE	inputs	IS ARRAY (0 TO size-1) OF std_logic_vector(8 DOWNTO 0);
	SIGNAL	carry_in	:	carries;
	SIGNAL	carry_out	:	carries;
	SIGNAL	OP_T		:	outputs;
	SIGNAL	IOP			:	inputs;
	
begin
	
	slice_gen			:	FOR i IN 0 TO size-1 GENERATE
		bit_slice_i		:	MOA_slice
	PORT	MAP(
		operand_in		=>	IOP(i),
		carry_in		=>	carry_in(i),
		carry_out		=>	carry_out(i),
		operand_out		=>	OP_T(i));
	END GENERATE;
	
	carry_in(0)			<=	(OTHERS => '0');
	low_carry			:	FOR i IN 1 TO size/2-1 GENERATE
		carry_in(i)		<=	carry_out(i-1);
	END GENERATE;
	carry_in(size/2)	<=	carry_out(size/2-1) WHEN mode = '1' ELSE (OTHERS => '0');
	high_carry			:	FOR i IN size/2+1 TO size-1 GENERATE
		carry_in(i)		<=	carry_out(i-1);
	END GENERATE;
	
	output_gen			:	FOR i IN 0 TO size-1 GENERATE
		OP_O1(i)		<=	OP_T(i)(0);
		OP_O2(i)		<=	OP_T(i)(1);
	END GENERATE;
	
	input_gen			:	FOR i IN 0 TO size-1 GENERATE
		IOP(i)			<=	OP_3_3(i) & OP_3_2(i) & OP_3_1(i) & OP_2_3(i) & OP_2_2(i) & OP_2_1(i) & OP_1_3(i) & OP_1_2(i) & OP_1_1(i);
	END GENERATE;
	
end Behavioral;

