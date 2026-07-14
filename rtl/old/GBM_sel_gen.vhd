library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity GBM_sel_gen is
	PORT(
		clk				:	IN	std_logic;
		rst				:	IN	std_logic;
		clr				:	IN	std_logic;
		inc				:	IN	std_logic;
		min				:	IN	std_logic_vector(1 DOWNTO 0);
		max				:	IN	std_logic_vector(1 DOWNTO 0);
		val				:	OUT	std_logic_vector(1 DOWNTO 0);
		eq				:	OUT	std_logic);
end GBM_sel_gen;

architecture Behavioral of GBM_sel_gen is
	
	SIGNAL	tmp			:	std_logic_vector(1 DOWNTO 0);
	
begin
	
	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			tmp			<=	(OTHERS => '0');
		ELSIF clk = '1' AND clk'EVENT THEN
			IF clr = '1' THEN
				tmp		<=	min;	
			ELSIF inc = '1' THEN
				IF tmp = max THEN
					tmp	<= min;
				ELSE
					tmp	<=	std_logic_vector(unsigned(tmp) + 1);
				END IF;
			END IF;
		END IF;
	END PROCESS;
	
	val					<=	tmp;
	eq					<=	'1' WHEN tmp = max ELSE '0';
	
end Behavioral;
