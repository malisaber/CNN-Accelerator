library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;

entity	Scheduler_mem_core is
	GENERIC(
		line_count						:	INTEGER	:=	100);
    PORT(
		clk1							:	IN	std_logic;
		addr1							:	IN	std_logic_vector(31 DOWNTO 0);
		data_in1						:	IN	std_logic_vector(31	DOWNTO 0);
		write_enable1					:	IN	std_logic;
		data_out1						:	OUT	std_logic_vector(31	DOWNTO 0);
		clk2							:	IN	std_logic;
		addr2							:	IN	std_logic_vector(31	DOWNTO 0);
		data_in2						:	IN	std_logic_vector(31	DOWNTO 0);
		write_enable2					:	IN	std_logic;
		data_out2						:	OUT	std_logic_vector(31	DOWNTO 0));
END	Scheduler_mem_core;

ARCHITECTURE Behavioral OF Scheduler_mem_core IS
    TYPE	RAM_TYPE 					IS ARRAY (0	TO	line_count - 1)	OF	std_logic_vector(31	DOWNTO 0);
    SIGNAL	memory						:	RAM_TYPE;
BEGIN
    PROCESS(clk1)
    begin
        IF rising_edge(clk1) THEN
            IF write_enable1 = '1' THEN
                memory(conv_integer(addr1)/4) <= data_in1;
            END IF;
            data_out1	<= memory(conv_integer(addr1)/4);
        END IF;
    END PROCESS;

    PROCESS(clk2)
    begin
        IF rising_edge(clk2) THEN
            IF write_enable2 = '1' THEN
                memory(conv_integer(addr2)/4) <= data_in2;
            END IF;
            data_out2	<= memory(conv_integer(addr2)/4);
        END IF;
    END PROCESS;
END Behavioral;

