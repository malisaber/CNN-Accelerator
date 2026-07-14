library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.math_real.ALL;


entity FIFO_RAM is
	GENERIC(
		size			:	INTEGER	:=	8;
		depth			:	INTEGER	:=	8;
		reged_output	:	INTEGER	:=	1);
	PORT(
		clk				:	IN	std_logic;
		rst				:	IN	std_logic;
		wen				:	IN	std_logic;
		ren				:	IN	std_logic;
		din				:	IN	std_logic_vector(size -1 DOWNTO 0);
		wadd			:	IN	std_logic_vector(integer(ceil(log2(real(depth))))-1 DOWNTO 0);
		Radd			:	IN	std_logic_vector(integer(ceil(log2(real(depth))))-1 DOWNTO 0);
		dout			:	OUT	std_logic_vector(size -1 DOWNTO 0));
end FIFO_RAM;

architecture Behavioral of FIFO_RAM is
	TYPE	memory	IS ARRAY (depth-1 DOWNTO 0) OF std_logic_vector(size -1 DOWNTO 0);
	
	SIGNAL	mem			:	memory;
	
begin
	 
	PROCESS(clk)
	BEGIN
		IF clk = '1' AND clk'EVENT THEN
			IF wen = '1' THEN
				mem(to_integer(unsigned(wadd)))	<=	din;
			END IF;
		END	IF;
	END PROCESS;
	
	
	GEN_STATE1	:	IF reged_output = 1 GENERATE
		PROCESS (clk, rst)
			VARIABLE add	:	integer;
		BEGIN
			IF RST = '1' THEN
				dout	<=	(OTHERS => '0');
			ELSIF clk = '1' AND clk'EVENT THEN
				add	:=	to_integer(unsigned(Radd));
				IF ren = '1' THEN
					IF add >= depth THEN
						dout	<=	(OTHERS => '0');
					ELSE
						dout<=	mem(add);
					END IF;
				END IF;
			END IF;
		END PROCESS;
	END GENERATE;
	
	GEN_STATE2	:	IF reged_output = 0 GENERATE
		PROCESS (Radd, mem)
			VARIABLE add	:	integer;
		BEGIN
			add	:=	to_integer(unsigned(Radd));
			IF add >= depth THEN
				dout	<=	(OTHERS => '0');
			ELSE
				dout<=	mem(add);
			END IF;
		END PROCESS;
	END GENERATE;
	
end Behavioral;

