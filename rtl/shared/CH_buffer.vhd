library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.math_real.ALL;
USE work.my_pack_v2.ALL;
USE std.textio.all;
USE ieee.std_logic_textio.ALL;

entity CH_buffer is
	GENERIC(
		ifm_wfm			:	INTEGER	:=	0;
		row_pos			:	INTEGER	:=	1;
		col_pos			:	INTEGER	:=	1;
		wid_pos			:	INTEGER	:=	1;
		word_size		:	INTEGER	:=	8;
		depth			:	INTEGER	:=	16);
	PORT(
		clk				:	IN	std_logic;
		clk_w			:	IN	std_logic;
		rst				:	IN	std_logic;
		wen				:	IN	std_logic;
		read_add		:	IN	std_logic_vector(integer(ceil(log2(real(depth))))-1 DOWNTO 0);
		write_add		:	IN	std_logic_vector(integer(ceil(log2(real(depth))))-1 DOWNTO 0);
		data_in			:	IN	std_logic_vector(word_size-1 DOWNTO 0);
		data_out		:	OUT	std_logic_vector(word_size-1 DOWNTO 0));
end CH_buffer;

architecture Behavioral of CH_buffer is
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	TYPE	mem	IS ARRAY(0 TO depth-1) OF std_logic_vector(word_size-1 DOWNTO 0);
	--------------------------------------------------------------------------------------
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
	--------------------------------------------------------------------------------------
	SIGNAL	SP			:	mem;	--:=	init(FM_File_names(ifm_wfm,row_pos,col_pos,wid_pos));
	SIGNAL	wen_n		:	std_logic;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
begin
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	
	wen_n				<=	NOT	wen;
	SRAM_Gen			:	IF ((depth = 256) AND (word_size = 16)) GENERATE
		SRAM_BANK		:	sram_256X16_freepdk45_2rw
		PORT	MAP(
			-- Port 0: W
			clk0		=>	clk_w,
			csb0		=>	'0',
			web0		=>	wen_n,
			addr0		=>	write_add,
			din0		=>	data_in,
			dout0		=>	OPEN,
			-- Port 1: R	
			clk1		=>	clk,
			csb1		=>	'0',
			web1		=>	'1',
			addr1		=>	read_add,
			din1		=>	"0000000000000000",
			dout1		=>	data_out);
	END GENERATE;
	
	FlipFlop_Gen		:	IF	NOT((depth = 256) AND (word_size = 16)) GENERATE
		ASSERT	true	REPORT	"ERROR, Invalid Generic Parameter"	SEVERITY	FAILURE;
	END GENERATE;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
end Behavioral;


