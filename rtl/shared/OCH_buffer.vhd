library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.math_real.ALL;
USE std.textio.all;
USE ieee.std_logic_textio.ALL;

entity OCH_buffer is
	GENERIC(
		row_pos			:	INTEGER	:=	0;
		col_pos			:	INTEGER	:=	0;
		ping_pong		:	INTEGER	:=	0;
		word_size		:	INTEGER	:=	8;
		depth			:	INTEGER	:=	16);
	PORT(
		clk				:	IN	std_logic;
		wen				:	IN	std_logic;
		read_add_1		:	IN	std_logic_vector(integer(ceil(log2(real(depth))))-1 DOWNTO 0);
		read_add_2		:	IN	std_logic_vector(integer(ceil(log2(real(depth))))-1 DOWNTO 0);
		write_add		:	IN	std_logic_vector(integer(ceil(log2(real(depth))))-1 DOWNTO 0);
		data_in			:	IN	std_logic_vector(word_size-1 DOWNTO 0);
		data_out_1		:	OUT	std_logic_vector(word_size-1 DOWNTO 0);
		data_out_2		:	OUT	std_logic_vector(word_size-1 DOWNTO 0));
end OCH_buffer;

architecture Behavioral of OCH_buffer is
	--------------------------------------------------------------------------------------
	COMPONENT	sram_256X16_freepdk45_2rw
	PORT(
		-- Port 0: RW
		clk0				:	IN	std_logic;		
		csb0				:	IN	std_logic;		
		web0				:	IN	std_logic;		
		addr0				:	IN	std_logic_vector(7	DOWNTO 0);
		din0				:	IN	std_logic_vector(15	DOWNTO 0);
		dout0				:	OUT	std_logic_vector(15	DOWNTO 0);
		-- Port 1: RW	
		clk1				:	IN	std_logic;		
		csb1				:	IN	std_logic;		
		web1				:	IN	std_logic;		
		addr1				:	IN	std_logic_vector(7	DOWNTO 0);
		din1				:	IN	std_logic_vector(15	DOWNTO 0);
		dout1				:	OUT	std_logic_vector(15	DOWNTO 0));
	END COMPONENT;
	--------------------------------------------------------------------------------------
	SIGNAL	wen_n			:	std_logic;
	--------------------------------------------------------------------------------------
begin
	wen_n				<=	NOT	wen;
	SRAM_Gen			:	IF ((depth = 256) AND (word_size = 16)) GENERATE
		SRAM_BANK		:	sram_256X16_freepdk45_2rw
		PORT	MAP(
			-- Port 0: W
			clk0		=>	clk,
			csb0		=>	'0',
			web0		=>	wen_n,
			addr0		=>	write_add,
			din0		=>	data_in,
			dout0		=>	data_out_1,
			-- Port 1: R	
			clk1		=>	clk,
			csb1		=>	'0',
			web1		=>	'1',
			addr1		=>	read_add_2,
			din1		=>	"0000000000000000",
			dout1		=>	data_out_2);
	END GENERATE;
	
	FlipFlop_Gen		:	IF	NOT((depth = 256) AND (word_size = 16)) GENERATE
		ASSERT	true	REPORT	"ERROR, Invalid Generic Parameter"	SEVERITY	FAILURE;
	END GENERATE;
end Behavioral;


