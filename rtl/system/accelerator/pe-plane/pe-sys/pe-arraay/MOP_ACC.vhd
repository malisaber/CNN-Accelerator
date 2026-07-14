library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MOP_ACC is
	GENERIC(
		word_size		:	INTEGER	:=	16);
	PORT(
		OP_1			:	IN	std_logic_vector(word_size-1 DOWNTO 0);
		OP_2			:	IN	std_logic_vector(word_size-1 DOWNTO 0);
		OP_3			:	IN	std_logic_vector(word_size-1 DOWNTO 0);
		mode			:	IN	std_logic;
		OP_out			:	OUT	std_logic_vector(word_size-1 DOWNTO 0));
end MOP_ACC;

architecture Behavioral of MOP_ACC is
	
	COMPONENT	Full_Adder
	PORT(
		in_1			:	IN	std_logic;
		in_2			:	IN	std_logic;
		in_3			:	IN	std_logic;
		SUM				:	OUT	std_logic;
		CRY				:	OUT	std_logic);
	END	COMPONENT;
	
	COMPONENT	MY_Adder
	GENERIC(
		word_size		:	INTEGER	:=	8);
	PORT(
		OP_1			:	IN	std_logic_vector(word_size-1 DOWNTO 0);
		OP_2			:	IN	std_logic_vector(word_size-1 DOWNTO 0);
		mode			:	IN	std_logic;
		OP_out			:	OUT	std_logic_vector(word_size-1 DOWNTO 0));
	END	COMPONENT;
	
	SIGNAL	SUM			:	std_logic_vector(word_size-1 DOWNTO 0);
	SIGNAL	CRY			:	std_logic_vector(word_size-1 DOWNTO 0);
	
	SIGNAL	Adder_op1	:	std_logic_vector(word_size-1 DOWNTO 0);
	SIGNAL	Adder_op2	:	std_logic_vector(word_size-1 DOWNTO 0);
	
begin
	
	three_2_two			:	FOR i IN 0 TO word_size-1 GENERATE
		FA_i			:	Full_Adder
		PORT	MAP(
			in_1		=>	OP_1(i),
			in_2		=>	OP_2(i),
			in_3		=>	OP_3(i),
			SUM			=>	SUM(i),
			CRY			=>	CRY(i));
	END GENERATE;
	
	Adder_op1			<=	SUM;
	Adder_op2			<=	(CRY(word_size-2 DOWNTO 0) & '0') AND ((word_size-1 DOWNTO word_size/2+1 => '1') & mode & (word_size/2-1 DOWNTO 0 => '1'));
	
	adder				:	MY_Adder
	GENERIC	MAP( 
		word_size		=>	word_size)
	PORT	MAP(
		OP_1			=>	Adder_op1,
		OP_2			=>	Adder_op2,
		mode			=>	mode,
		OP_out			=>	OP_out);
	
end Behavioral;

