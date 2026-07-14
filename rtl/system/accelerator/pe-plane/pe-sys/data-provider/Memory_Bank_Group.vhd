library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.my_pack_v2.ALL;

entity Memory_Bank_Group is
	GENERIC(
		ifm_wfm			:	INTEGER	:=	0;
		row_pos			:	INTEGER	:=	1;
		col_pos			:	INTEGER	:=	1);
	PORT(
		clk				:	IN	std_logic;
		clk_w			:	IN	std_logic;
		rst				:	IN	std_logic;
		
		F_clr			:	IN	std_logic_vector(3 DOWNTO 0);
		F_set			:	IN	std_logic_vector(3 DOWNTO 0);
		F_val			:	OUT	std_logic_vector(3 DOWNTO 0);
		low_lvl_wen		:	IN	std_logic_vector(3 DOWNTO 0);
		low_lvl_sig		:	IN	MB_Low_level_mem;
		M_Radd			:	IN	std_logic_vector(P_IFM_Add_size-1 DOWNTO 0);
		M_Dout_0		:	OUT	std_logic_vector(P_word_size-1 DOWNTO 0);
		M_Dout_1		:	OUT	std_logic_vector(P_word_size-1 DOWNTO 0);
		M_Dout_2		:	OUT	std_logic_vector(P_word_size-1 DOWNTO 0);
		M_Dout_3		:	OUT	std_logic_vector(P_word_size-1 DOWNTO 0));
end Memory_Bank_Group;

architecture Behavioral of Memory_Bank_Group is
	
	COMPONENT	Memory_Bank
	GENERIC(
		ifm_wfm			:	INTEGER	:=	0;
		row_pos			:	INTEGER	:=	0;
		col_pos			:	INTEGER	:=	0;
		wid_pos			:	INTEGER	:=	0);
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
	END COMPONENT;
	
begin
	
	MB_0				:	Memory_Bank
	GENERIC	MAP(
		ifm_wfm			=>	ifm_wfm,
		row_pos			=>	row_pos,
		col_pos			=>	col_pos,
		wid_pos			=>	1)
	PORT	MAP(
		clk				=>	clk,
		clk_w			=>	clk_w,
		rst				=>	rst,
		F_clr			=>	F_clr(0),
		F_set			=>	F_set(0),
		F_val			=>	F_val(0),
		M_wen			=>	low_lvl_wen(0),
		M_Radd			=>	M_Radd,
		M_Wadd			=>	low_lvl_sig.Wadd,
		M_Din			=>	low_lvl_sig.Wdata,
		M_Dout			=>	M_Dout_0);
	
	MB_1				:	Memory_Bank
	GENERIC	MAP(
		ifm_wfm			=>	ifm_wfm,
		row_pos			=>	row_pos,
		col_pos			=>	col_pos,
		wid_pos			=>	2)
	PORT	MAP(
		clk				=>	clk,
		clk_w			=>	clk_w,
		rst				=>	rst,
		F_clr			=>	F_clr(1),
		F_set			=>	F_set(1),
		F_val			=>	F_val(1),
		M_wen			=>	low_lvl_wen(1),
		M_Radd			=>	M_Radd,
		M_Wadd			=>	low_lvl_sig.Wadd,
		M_Din			=>	low_lvl_sig.Wdata,
		M_Dout			=>	M_Dout_1);
	
	MB_2				:	Memory_Bank
	GENERIC	MAP(
		ifm_wfm			=>	ifm_wfm,
		row_pos			=>	row_pos,
		col_pos			=>	col_pos,
		wid_pos			=>	3)
	PORT	MAP(
		clk				=>	clk,
		clk_w			=>	clk_w,
		rst				=>	rst,
		F_clr			=>	F_clr(2),
		F_set			=>	F_set(2),
		F_val			=>	F_val(2),
		M_wen			=>	low_lvl_wen(2),
		M_Radd			=>	M_Radd,
		M_Wadd			=>	low_lvl_sig.Wadd,
		M_Din			=>	low_lvl_sig.Wdata,
		M_Dout			=>	M_Dout_2);
	
	MB_3				:	Memory_Bank
	GENERIC	MAP(
		ifm_wfm			=>	ifm_wfm,
		row_pos			=>	row_pos,
		col_pos			=>	col_pos,
		wid_pos			=>	4)
	PORT	MAP(
		clk				=>	clk,
		clk_w			=>	clk_w,
		rst				=>	rst,
		F_clr			=>	F_clr(3),
		F_set			=>	F_set(3),
		F_val			=>	F_val(3),
		M_wen			=>	low_lvl_wen(3),
		M_Radd			=>	M_Radd,
		M_Wadd			=>	low_lvl_sig.Wadd,
		M_Din			=>	low_lvl_sig.Wdata,
		M_Dout			=>	M_Dout_3);
	
end Behavioral;

