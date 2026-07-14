library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Full_Adder is
	PORT(
		in_1			:	IN	std_logic;
		in_2			:	IN	std_logic;
		in_3			:	IN	std_logic;
		SUM				:	OUT	std_logic;
		CRY				:	OUT	std_logic);
end Full_Adder;

architecture Behavioral of Full_Adder is
begin
	
	SUM					<=	in_1 XOR in_2 XOR in_3;
	CRY					<=	(in_1 AND in_2) OR (in_2 AND in_3) OR (in_3 AND in_1);
	
end Behavioral;

