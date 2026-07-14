library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.math_real.ALL;


entity Incrementer is
	GENERIC(
		size	:	INTEGER	:=	4;
		MAX		:	INTEGER	:=	15);
	PORT(
		clk		:	IN	std_logic;
		rst		:	IN	std_logic;
		inc		:	IN	std_logic;
		load	:	IN	std_logic;
		par_in	:	IN	std_logic_vector(size -1 DOWNTO 0);
		par_out	:	OUT	std_logic_vector(size -1 DOWNTO 0);
		co		:	OUT	std_logic);
end Incrementer;

architecture Behavioral of Incrementer is
	SIGNAL	tmp	:	std_logic_vector(size -1 DOWNTO 0);
begin

	PROCESS (clk, rst)
		variable val	:	std_logic_vector(size -1 DOWNTO 0) := (OTHERS => '0');
	BEGIN
		IF rst = '1' THEN
			val	:= (OTHERS => '0');
		ELSIF clk = '1' AND clk'EVENT THEN
			IF load = '1' THEN 
				val := par_in;
			ELSIF inc = '1' THEN
				IF val = std_logic_vector(to_unsigned(MAX,tmp'LENGTH)) THEN
					val	:= (OTHERS => '0');
				ELSE
					val := std_logic_vector(unsigned(val) + 1);
				END IF ;
			END IF;
		END IF;
		tmp	<=	val;
	END PROCESS;
	
	PROCESS (tmp)
	BEGIN
		IF tmp = std_logic_vector(to_unsigned(MAX,tmp'LENGTH)) THEN
			co <= '1';
		ELSE
			co <= '0';
		END IF;
	END PROCESS;
	
	par_out	<=	tmp;
end Behavioral;

