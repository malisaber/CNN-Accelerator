library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_arith.ALL;

entity inc_dec_v2 is
	GENERIC(
		size	:	integer	:=	5);
	PORT(
		clk		:	IN	std_logic;
		rst		:	IN	std_logic;
		clr		:	IN	std_logic;
		inc		:	IN	std_logic;
		dec		:	IN	std_logic;
		val		:	OUT	std_logic_vector(size-1 DOWNTO 0));
end inc_dec_v2;

architecture Behavioral of inc_dec_v2 is
	SIGNAL	par			:	std_logic_vector(size-1 DOWNTO 0);
	SIGNAL	par_clked	:	std_logic_vector(size-1 DOWNTO 0);
begin
	
	PROCESS (clr, inc, dec, par_clked)
		VARIABLE temp	:	std_logic_vector(size-1 DOWNTO 0);
	BEGIN
		temp   := par_clked;
		IF   clr  = '1' THEN 
			temp := (OTHERS => '0');
		ELSIF inc = '1' AND dec = '1' THEN 
			temp := temp;
		ELSIF inc = '1' AND dec = '0' THEN 
			temp := unsigned(temp) + 1;
		ELSIF inc = '0' AND dec = '1' THEN 
			temp := unsigned(temp) - 1;
		ELSIF inc = '0' AND dec = '0' THEN 
			temp := temp;
		END IF;
		par <= temp;
	END PROCESS;
	
	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			par_clked <= (OTHERS => '0');
		ELSIF clk = '1' AND clk'EVENT THEN
			par_clked <= par;
		END IF;
	END PROCESS;
	
	val <= par_clked;
	
end Behavioral;

