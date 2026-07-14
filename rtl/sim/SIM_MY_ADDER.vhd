library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE work.my_pack_v2.ALL;

entity SIM_MY_Adder is
	GENERIC(
		word_size		:	INTEGER	:=	8);
end SIM_MY_Adder;

architecture Behavioral of SIM_MY_Adder is
	
	COMPONENT	MY_Adder 
	GENERIC(
		word_size		:	INTEGER	:=	8);
	PORT(
		OP_1			:	IN	std_logic_vector(word_size-1 DOWNTO 0);
		OP_2			:	IN	std_logic_vector(word_size-1 DOWNTO 0);
		mode			:	IN	std_logic;
		OP_out			:	OUT	std_logic_vector(word_size-1 DOWNTO 0));
	END	COMPONENT;
	
	
	SIGNAL	OP_1		:	std_logic_vector(word_size-1 DOWNTO 0)	:=	(OTHERS	=>	'0');
	SIGNAL	OP_2		:	std_logic_vector(word_size-1 DOWNTO 0)	:=	(OTHERS	=>	'0');
	SIGNAL	OP_out		:	std_logic_vector(word_size-1 DOWNTO 0);
	SIGNAL	mode		:	std_logic;
	
	
begin
	
	UUT					:	MY_Adder
	GENERIC	MAP(
		word_size		=>	word_size)
	PORT	MAP(
		OP_1			=>	OP_1,
		OP_2			=>	OP_2,
		mode			=>	mode,
		OP_out			=>	OP_out);
	
	
	
	PROCESS
	BEGIN
		OP_1			<=	unsigned(OP_1) + 1;
		WAIT FOR 10 NS;
	END PROCESS;
	
	
	PROCESS
	BEGIN
		OP_2			<=	unsigned(OP_2) + 1;
		WAIT FOR 2560 NS;
	END PROCESS;
	
	
	PROCESS
	BEGIN
		mode			<=	'0';
		WAIT FOR 256*2560 NS;
		mode			<=	'1';
		WAIT FOR 256*2560 NS;
	END PROCESS;
	
	
end Behavioral;

