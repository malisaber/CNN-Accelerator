library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Reg is
	GENERIC(
		size	:	integer	:=	4);
	PORt(
		clk		:	IN	std_logic;
		rst		:	IN	std_logic;
		load	:	IN	std_logic;
		clear	:	IN	std_logic;
		inp		:	IN	std_logic_vector(size-1 DOWNTO 0);
		val		:	OUT	std_logic_vector(size-1 DOWNTO 0));
end Reg;

architecture Behavioral of Reg is
begin
	
	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			val <= (OTHERS => '0');
		ELSIF clk = '1' AND clk'EVENT THEN
			IF load = '1' THEN
				val <= inp;
			ElSIF clear = '1' THEN
				val <= (OTHERS => '0');
			END IF; 
		END IF;
	END PROCESS;
	
end Behavioral;

