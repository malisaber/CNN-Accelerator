library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.my_pack_v2.ALL;
USE IEEE.math_real.ALL;

entity Memory_Bank is
	GENERIC(
		ifm_wfm			:	INTEGER	:=	0;
		row_pos			:	INTEGER	:=	1;
		col_pos			:	INTEGER	:=	1;
		wid_pos			:	INTEGER	:=	1);
	PORT(
		clk				:	IN	std_logic;
		clk_w			:	IN	std_logic;
		rst				:	IN	std_logic;
		
		F_clr			:	IN	std_logic;
		F_set			:	IN	std_logic; 
		F_val			:	OUT	std_logic;
		
		M_wen			:	IN	std_logic;
		M_Radd			:	IN	std_logic_vector(P_IFM_Add_size-1 DOWNTO 0);
		M_Wadd			:	IN	std_logic_vector(P_IFM_Add_size-1 DOWNTO 0);
		M_Din			:	IN	std_logic_vector(P_word_size-1 DOWNTO 0);
		M_Dout			:	OUT	std_logic_vector(P_word_size-1 DOWNTO 0));
end Memory_Bank;

architecture Behavioral of Memory_Bank is
	
	COMPONENT	CH_buffer
	GENERIC(
		ifm_wfm			:	INTEGER	:=	0;
		row_pos			:	INTEGER	:=	0;
		col_pos			:	INTEGER	:=	0;
		wid_pos			:	INTEGER	:=	0;
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
	END COMPONENT;
	
	SIGNAL	flag		:	std_logic;
	
begin
	
	Bank				:	CH_buffer
	GENERIC	MAP(
		ifm_wfm			=>	ifm_wfm,
		row_pos			=>	row_pos,
		col_pos			=>	col_pos,
		wid_pos			=>	wid_pos,
		word_size		=>	P_word_size,
		depth			=>	2**P_IFM_Add_size)
	PORT	MAP(
		clk				=>	clk,
		clk_w			=>	clk_w,
		rst				=>	rst,
		wen				=>	M_wen,
		read_add		=>	M_Radd,
		write_add		=>	M_Wadd,
		data_in			=>	M_Din,
		data_out		=>	M_Dout);
	
	
	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			flag		<=	'0';
		ELSIF clk = '1' AND clk'EVENT THEN
			IF F_clr = '1' THEN
				flag	<=	'0';
			ELSIF F_set = '1' THEN
				flag	<=	'1';
			END IF;
		END IF;
	END PROCESS;
	
			
	
	
	F_val				<=	flag;
					
end Behavioral;

