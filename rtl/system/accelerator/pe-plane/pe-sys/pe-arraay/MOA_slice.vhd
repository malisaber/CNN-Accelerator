library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MOA_slice is
	PORT(
		operand_in		:	IN	std_logic_vector(8 DOWNTO 0);
		carry_in		:	IN	std_logic_vector(6 DOWNTO 0);
		carry_out		:	OUT	std_logic_vector(6 DOWNTO 0);
		operand_out		:	OUT	std_logic_vector(1 DOWNTO 0));
end MOA_slice;

architecture Behavioral of MOA_slice is
	
	COMPONENT	Full_Adder
	PORT(
		in_1			:	IN	std_logic;
		in_2			:	IN	std_logic;
		in_3			:	IN	std_logic;
		SUM				:	OUT	std_logic;
		CRY				:	OUT	std_logic);
	END	COMPONENT;
	
	SIGNAL	sum_1		:	std_logic_vector(2 DOWNTO 0);
	SIGNAL	sum_2		:	std_logic_vector(1 DOWNTO 0);
	SIGNAL	sum_3		:	std_logic;
	
begin
	
	FA_inp_0			:	Full_Adder
	PORT	MAP(
		in_1			=>	operand_in(0),
		in_2			=>	operand_in(1),
		in_3			=>	operand_in(2),
		SUM				=>	sum_1(0),
		CRY				=>	carry_out(0));
	
	
	FA_inp_1			:	Full_Adder
	PORT	MAP(
		in_1			=>	operand_in(3),
		in_2			=>	operand_in(4),
		in_3			=>	operand_in(5),
		SUM				=>	sum_1(1),
		CRY				=>	carry_out(1));
	
	
	FA_inp_2			:	Full_Adder
	PORT	MAP(
		in_1			=>	operand_in(6),
		in_2			=>	operand_in(7),
		in_3			=>	operand_in(8),
		SUM				=>	sum_1(2),
		CRY				=>	carry_out(2));
	
	
	FA_1_0				:	Full_Adder
	PORT	MAP(
		in_1			=>	sum_1(0),
		in_2			=>	sum_1(1),
		in_3			=>	sum_1(2),
		SUM				=>	sum_2(0),
		CRY				=>	carry_out(3));
	
	
	FA_l_0				:	Full_Adder
	PORT	MAP(
		in_1			=>	carry_in(0),
		in_2			=>	carry_in(1),
		in_3			=>	carry_in(2),
		SUM				=>	sum_2(1),
		CRY				=>	carry_out(4));
	
	
	FA_2_0				:	Full_Adder
	PORT	MAP(
		in_1			=>	carry_in(3),
		in_2			=>	carry_in(4),
		in_3			=>	sum_2(0),
		SUM				=>	sum_3,
		CRY				=>	carry_out(5));
	
	
	FA_3_0				:	Full_Adder
	PORT	MAP(
		in_1			=>	carry_in(5),
		in_2			=>	sum_2(1),
		in_3			=>	sum_3,
		SUM				=>	operand_out(0),
		CRY				=>	carry_out(6));
	
	
	operand_out(1)		<=	carry_in(6);
	
end Behavioral;

