library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.my_pack_v2.ALL;

entity address_gen is
	PORT(
		clk				:	IN	std_logic;
		rst				:	IN	std_logic;
		
		ini				:	IN	std_logic;
		
		Zpad_Max		:	IN	std_logic_vector(P_Pad_size-1 DOWNTO 0);
		Zpad_inc		:	IN	std_logic;
		Zpad_val		:	OUT	std_logic_vector(P_Pad_size-1 DOWNTO 0);
		Zpad_eq			:	OUT	std_logic;
		
		Kern_Max		:	IN	std_logic_vector(P_kernel_size-1 DOWNTO 0);
		Kern_inc		:	IN	std_logic;
		Kern_val		:	OUT	std_logic_vector(P_kernel_size-1 DOWNTO 0);
		Kern_eq			:	OUT	std_logic;
		
		Colm_Max		:	IN	std_logic_vector(P_column_size-1 DOWNTO 0);
		Colm_inc		:	IN	std_logic;
		Colm_val		:	OUT	std_logic_vector(P_column_size-1 DOWNTO 0);
		Colm_eq			:	OUT	std_logic;
		
		Chan_Max		:	IN	std_logic_vector(P_channel_size-1 DOWNTO 0);
		Chan_inc		:	IN	std_logic;
		Chan_val		:	OUT	std_logic_vector(P_channel_size-1 DOWNTO 0);
		Chan_eq			:	OUT	std_logic;
		
		Rows_Max		:	IN	std_logic_vector(P_Row_size-1 DOWNTO 0);
		Rows_inc		:	IN	std_logic;
		Rows_val		:	OUT	std_logic_vector(P_Row_size-1 DOWNTO 0);
		Rows_eq			:	OUT	std_logic;
		
		Cntr_Max		:	IN	std_logic_vector(P_in_cntr_size-1 DOWNTO 0);
		Cntr_inc		:	IN	std_logic;
		Cntr_eq			:	OUT	std_logic;
		
		Bank_min		:	IN	std_logic_vector(3 DOWNTO 0);
		Bank_max		:	IN	std_logic_vector(3 DOWNTO 0);
		Bank_inc_all	:	IN	std_logic;
		Bank_inc_R1		:	IN	std_logic;
		Bank_inc_R2		:	IN	std_logic;
		Bank_inc_R3		:	IN	std_logic;
		Bank_add_R1		:	OUT	std_logic_vector(3 DOWNTO 0);
		Bank_add_R2		:	OUT	std_logic_vector(3 DOWNTO 0);
		Bank_add_R3		:	OUT	std_logic_vector(3 DOWNTO 0);
		
		GBMs_Min		:	IN	std_logic_vector(1 DOWNTO 0);
		GBMs_Max		:	IN	std_logic_vector(1 DOWNTO 0);
		GBMs_inc		:	IN	std_logic;
		GBMs_val		:	OUT	std_logic_vector(1 DOWNTO 0);
		GBMs_eq			:	OUT	std_logic);
end address_gen;

architecture Behavioral of address_gen is
	
	COMPONENT	incr
	GENERIC(
		size		:	INTEGER	:=	4);
	PORT(
		clk			:	IN	std_logic;
		rst			:	IN	std_logic;
		ini			:	IN	std_logic;
		inc			:	IN	std_logic;
		max			:	IN	std_logic_vector(size-1 DOWNTO 0);
		val			:	OUT	std_logic_vector(size-1 DOWNTO 0);
		eq			:	OUT	std_logic);
	END COMPONENT;
	
	COMPONENT	BM_sel_gen
	PORT(
		clk				:	IN	std_logic;
		rst				:	IN	std_logic;
		clr				:	IN	std_logic;
		inc				:	IN	std_logic;
		min				:	IN	std_logic_vector(3 DOWNTO 0);
		max				:	IN	std_logic_vector(3 DOWNTO 0);
		val				:	OUT	std_logic_vector(3 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT	GBM_sel_gen
	PORT(
		clk				:	IN	std_logic;
		rst				:	IN	std_logic;
		clr				:	IN	std_logic;
		inc				:	IN	std_logic;
		min				:	IN	std_logic_vector(1 DOWNTO 0);
		max				:	IN	std_logic_vector(1 DOWNTO 0);
		val				:	OUT	std_logic_vector(1 DOWNTO 0);
		eq				:	OUT	std_logic);
	END COMPONENT;
	
	SIGNAL	R1_inc		:	std_logic;
	SIGNAL	R2_inc		:	std_logic;
	SIGNAL	R3_inc		:	std_logic;
	
	SIGNAL	Cntr_val	:	std_logic_vector(P_in_cntr_size-1 DOWNTO 0);
	
begin
	
	
	R1_inc				<=	ini OR Bank_inc_all OR Bank_inc_R1;
	R2_inc				<=	ini OR Bank_inc_all OR Bank_inc_R2;
	R3_inc				<=	ini OR Bank_inc_all OR Bank_inc_R3;
	
	
	Zpad_incr			:	incr
	GENERIC	MAP(
		size			=>	P_Pad_size)
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		ini				=>	ini,
		inc				=>	Zpad_inc,
		max				=>	Zpad_Max,
		val				=>	Zpad_val,
		eq				=>	Zpad_eq);
	
	
	Kern_incr			:	incr
	GENERIC	MAP(
		size			=>	P_kernel_size)
	PORT	MAP(	
		clk				=>	clk,
		rst				=>	rst,
		ini				=>	ini,
		inc				=>	Kern_inc,
		max				=>	Kern_Max,
		val				=>	Kern_val,
		eq				=>	Kern_eq);
	
	
	Colm_incr			:	incr
	GENERIC	MAP(
		size			=>	P_column_size)
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		ini				=>	ini,
		inc				=>	Colm_inc,
		max				=>	Colm_Max,
		val				=>	Colm_val,
		eq				=>	Colm_eq);
	
	
	Chan_incr			:	incr
	GENERIC	MAP(
		size			=>	P_channel_size)
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		ini				=>	ini,
		inc				=>	Chan_inc,
		max				=>	Chan_Max,
		val				=>	Chan_val,
		eq				=>	Chan_eq);
	
	
	Rows_incr			:	incr
	GENERIC	MAP(
		size			=>	P_row_size)
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		ini				=>	ini,
		inc				=>	Rows_inc,
		max				=>	Rows_Max,
		val				=>	Rows_val,
		eq				=>	Rows_eq);
	
	
	in_cntr				:	incr
	GENERIC	MAP(
		size			=>	P_in_cntr_size)
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		ini				=>	ini,
		inc				=>	Cntr_inc,
		max				=>	Cntr_Max,
		val				=>	Cntr_val,
		eq				=>	Cntr_eq);
	
	
	R1_selector			:	BM_sel_gen
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		clr				=>	ini,
		inc				=>	R1_inc,
		min				=>	Bank_min,
		max				=>	Bank_max,
		val				=>	Bank_add_R1);
	
	
	R2_selector			:	BM_sel_gen
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		clr				=>	ini,
		inc				=>	R2_inc,
		min				=>	Bank_min,
		max				=>	Bank_max,
		val				=>	Bank_add_R2);
	
	
	R3_selector			:	BM_sel_gen
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		clr				=>	ini,
		inc				=>	R3_inc,
		min				=>	Bank_min,
		max				=>	Bank_max,
		val				=>	Bank_add_R3);
	
	
	
	GMSG				:	GBM_sel_gen
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		clr				=>	ini,
		inc				=>	GBMs_inc,
		min				=>	GBMs_Min,
		max				=>	GBMs_Max,
		val				=>	GBMs_val,
		eq				=>	GBMs_eq);
	
end Behavioral;

