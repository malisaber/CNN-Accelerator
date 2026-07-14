library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity incr is
	GENERIC(
		size		:	INTEGER	:=	4);
	PORT(
		clk			:	IN	std_logic;
		rst			:	IN	std_logic;
		ini			:	IN	std_logic;
		inc			:	IN	std_logic;
		max			:	IN	std_logic_vector(size-1 DOWNTO 0);
		val			:	OUT	std_logic_vector(size-1 DOWNTO 0);
		eq			:	OUT	std_logic);
end incr;

architecture Behavioral of incr IS
	
	SIGNAL	tmp		:	std_logic_vector(size-1 DOWNTO 0);
	
begin
	
	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			tmp			<=	(OTHERS => '0');
		ELSIF clk = '1' AND clk'EVENT THEN
			IF ini = '1' THEN
				tmp		<=	(OTHERS => '0');
			ELSIF inc = '1' THEN
				IF tmp = max THEN
					tmp	<= (OTHERS => '0');
				ELSE
					tmp	<=	std_logic_vector(unsigned(tmp) + 1);
				END IF;
			END IF;
		END IF;
	END PROCESS;
	
	val					<=	tmp;
	eq					<=	'1'	WHEN tmp = max ELSE '0';
	
end Behavioral;

