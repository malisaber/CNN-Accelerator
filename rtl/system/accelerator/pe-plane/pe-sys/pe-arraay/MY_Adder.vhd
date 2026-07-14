library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE work.my_pack_v2.ALL;

entity MY_Adder is
	GENERIC(
		word_size		:	INTEGER	:=	8);
	PORT(
		OP_1			:	IN	std_logic_vector(word_size-1 DOWNTO 0);
		OP_2			:	IN	std_logic_vector(word_size-1 DOWNTO 0);
		mode			:	IN	std_logic;
		OP_out			:	OUT	std_logic_vector(word_size-1 DOWNTO 0));
end MY_Adder;

architecture Behavioral of MY_Adder is
	
	SIGNAL	SUM_low		:	std_logic_vector(word_size/2 DOWNTO 0);
	SIGNAL	SUM_high	:	std_logic_vector(word_size/2-1 DOWNTO 0);
	
	SIGNAL	OP_1_low	:	std_logic_vector(word_size/2 DOWNTO 0);
	SIGNAL	OP_1_high	:	std_logic_vector(word_size/2-1 DOWNTO 0);
	SIGNAL	OP_2_low	:	std_logic_vector(word_size/2 DOWNTO 0);
	SIGNAL	OP_2_high	:	std_logic_vector(word_size/2-1 DOWNTO 0);
	
	SIGNAL	UOP_1_low	:	UNSIGNED(word_size/2 DOWNTO 0);
	SIGNAL	UOP_1_high	:	UNSIGNED(word_size/2-1 DOWNTO 0);
	SIGNAL	UOP_2_low	:	UNSIGNED(word_size/2 DOWNTO 0);
	SIGNAL	UOP_2_high	:	UNSIGNED(word_size/2-1 DOWNTO 0);
	
	SIGNAL	high_cry	:	std_logic;
begin
	
	OP_1_low			<=	OP_1(word_size/2-1) & OP_1(word_size/2-1 DOWNTO 0);
	OP_2_low			<=	OP_2(word_size/2-1) & OP_2(word_size/2-1 DOWNTO 0);
	OP_1_high			<=	OP_1(word_size-1 DOWNTO word_size/2);
	OP_2_high			<=	OP_2(word_size-1 DOWNTO word_size/2);
	
	
	UOP_1_low			<=	unsigned(X_check(OP_1_low));
	UOP_1_high			<=	unsigned(X_check(OP_1_high));
	UOP_2_low			<=	unsigned(X_check(OP_2_low));
	UOP_2_high			<=	unsigned(X_check(OP_2_high));
	
	
	PROCESS (UOP_1_low, UOP_2_low)
	BEGIN
		SUM_low			<=	UOP_1_low + UOP_2_low;
	END PROCESS;
	
	high_cry		<=	SUM_low(word_size/2) WHEN mode = '1' ELSE '0';
	
	OP_out(word_size/2-1 DOWNTO 0)	<=	SUM_low(word_size/2-1 DOWNTO 0);
	
	PROCESS (UOP_1_high, UOP_2_high, high_cry)
	BEGIN
		SUM_high	<=	UOP_1_high + UOP_2_high + high_cry;
	END PROCESS;
	
	OP_out(word_size-1 DOWNTO word_size/2)	<=	SUM_high;
	
end Behavioral;

