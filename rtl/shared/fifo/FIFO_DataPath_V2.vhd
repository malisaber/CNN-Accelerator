library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.math_real.ALL;

entity FIFO_DataPath_V2 is
	GENERIC(
		size			:	INTEGER	:=	8;
		depth			:	INTEGER	:=	8;
		reged_output	:	INTEGER	:=	0);
	PORT(
		clk				:	IN	std_logic;
		rst				:	IN	std_logic;
		wen				:	IN	std_logic;
		W_inc_en		:	IN	std_logic;
		R_inc_en		:	IN	std_logic;
		din				:	IN	std_logic_vector(size-1 DOWNTO 0);
		dout			:	OUT	std_logic_vector(size-1 DOWNTO 0);
		DC_clr			:	IN	std_logic;
		DC_inc			:	IN	std_logic;
		DC_dec			:	IN	std_logic;
		DC_val			:	OUT	std_logic_vector(integer(ceil(log2(real(depth+1))))-1 DOWNTO 0));
end FIFO_DataPath_V2;

architecture Behavioral of FIFO_DataPath_V2 is

	COMPONENT	Incrementer
	GENERIC(
		size			:	INTEGER	:=	4;
		MAX				:	INTEGER	:=	15);
	PORT(
		clk				:	IN	std_logic;
		rst				:	IN	std_logic;
		inc				:	IN	std_logic;
		load			:	IN	std_logic;
		par_in			:	IN	std_logic_vector(size -1 DOWNTO 0);
		par_out			:	OUT	std_logic_vector(size -1 DOWNTO 0);
		co				:	OUT	std_logic);
	END COMPONENT;
	
	COMPONENT	FIFO_RAM
	GENERIC(
		size			:	INTEGER	:=	8;
		depth			:	INTEGER	:=	8;
		reged_output	:	INTEGER	:=	0);
	PORT(
		clk				:	IN	std_logic;
		rst				:	IN	std_logic;
		wen				:	IN	std_logic;
		ren				:	IN	std_logic;
		din				:	IN	std_logic_vector(size -1 DOWNTO 0);
		wadd			:	IN	std_logic_vector(integer(ceil(log2(real(depth))))-1 DOWNTO 0);
		Radd			:	IN	std_logic_vector(integer(ceil(log2(real(depth))))-1 DOWNTO 0);
		dout			:	OUT	std_logic_vector(size -1 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT	inc_dec_v2
	GENERIC(
		size			:	integer	:=	5);
	PORT(
		clk				:	IN	std_logic;
		rst				:	IN	std_logic;
		clr				:	IN	std_logic;
		inc				:	IN	std_logic;
		dec				:	IN	std_logic;
		val				:	OUT	std_logic_vector(size-1 DOWNTO 0));
	END COMPONENT;
	
	SIGNAL	Radd		:	std_logic_vector(integer(ceil(log2(real(depth))))-1 DOWNTO 0);
	SIGNAL	Wadd		:	std_logic_vector(integer(ceil(log2(real(depth))))-1 DOWNTO 0);
	SIGNAL	wco, rco	:	std_logic := 'Z';
begin
	--Read_cntr	<=	Radd;
	--Write_cntr<=	Wadd;
	
	
	buff				:	FIFO_RAM
		GENERIC	MAP(
			size		=>	size,
			depth		=>	depth,
			reged_output=>	reged_output)
		PORT	MAP(
			clk			=>	clk,
			rst			=>	rst,
			wen			=>	wen,
			ren			=>	R_inc_en,
			din			=>	din,
			wadd		=>	Wadd,
			Radd		=>	Radd,
			dout		=>	dout);
	
	write_pointer		:	Incrementer
		GENERIC	MAP(
			size		=>	integer(ceil(log2(real(depth)))),
			MAX			=>	depth-1)
		PORT	MAP(
			clk			=>	clk,
			rst			=>	rst,
			inc			=>	W_inc_en,
			load		=>	'0',
			par_in		=>	(OTHERS => '0'),
			par_out		=>	Wadd,
			co			=>	wco);
	
	
	read_pointer		:	Incrementer
		GENERIC	MAP(
			size		=>	integer(ceil(log2(real(depth)))),
			MAX			=>	depth-1)
		PORT	MAP(
			clk			=>	clk,
			rst			=>	rst,
			inc			=>	R_inc_en,
			load		=>	'0',
			par_in		=>	(OTHERS => '0'),
			par_out		=>	Radd,
			co			=>	rco);
	
	
	data_cntr			:	inc_dec_v2
	GENERIC	MAP(
		size			=>	integer(ceil(log2(real(depth+1)))))
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		clr				=>	DC_clr,
		inc				=>	DC_inc,
		dec				=>	DC_dec,
		val				=>	DC_val);
	
	
	
end Behavioral;

