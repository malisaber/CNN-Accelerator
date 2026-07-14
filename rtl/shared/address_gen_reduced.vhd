library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.my_pack_v2.ALL;

entity address_gen_reduced is
	PORT(
		clk				:	IN	std_logic;
		rst				:	IN	std_logic;
		
		ini				:	IN	std_logic;
		
		Cntr1_Max		:	IN	std_logic_vector(3 DOWNTO 0);
		Cntr1_inc		:	IN	std_logic;
		Cntr1_val		:	OUT	std_logic_vector(3 DOWNTO 0);
		Cntr1_eq		:	OUT	std_logic;
		
		Cntr2_Max		:	IN	std_logic_vector(3 DOWNTO 0);
		Cntr2_inc		:	IN	std_logic;
		Cntr2_val		:	OUT	std_logic_vector(3 DOWNTO 0);
		Cntr2_eq		:	OUT	std_logic;
		
		Cntr3_Max		:	IN	std_logic_vector(3 DOWNTO 0);
		Cntr3_inc		:	IN	std_logic;
		Cntr3_val		:	OUT	std_logic_vector(3 DOWNTO 0);
		Cntr3_eq		:	OUT	std_logic;
		
		Cntr4_Max		:	IN	std_logic_vector(3 DOWNTO 0);
		Cntr4_inc		:	IN	std_logic;
		Cntr4_val		:	OUT	std_logic_vector(3 DOWNTO 0);
		Cntr4_eq		:	OUT	std_logic;
		
		Cntr5_Max		:	IN	std_logic_vector(3 DOWNTO 0);
		Cntr5_inc		:	IN	std_logic;
		Cntr5_val		:	OUT	std_logic_vector(3 DOWNTO 0);
		Cntr5_eq		:	OUT	std_logic); 
end address_gen_reduced;

architecture Behavioral of address_gen_reduced is
	
	COMPONENT	incr
	GENERIC(
		size			:	INTEGER	:=	4);
	PORT(
		clk				:	IN	std_logic;
		rst				:	IN	std_logic;
		ini				:	IN	std_logic;
		inc				:	IN	std_logic;
		max				:	IN	std_logic_vector(size-1 DOWNTO 0);
		val				:	OUT	std_logic_vector(size-1 DOWNTO 0);
		eq				:	OUT	std_logic);
	END COMPONENT;
	
begin
	
	Cntr1_incr			:	incr
	GENERIC	MAP(
		size			=>	4)
	PORT	MAP(	
		clk				=>	clk,
		rst				=>	rst,
		ini				=>	ini,
		inc				=>	Cntr1_inc,
		max				=>	Cntr1_Max,
		val				=>	Cntr1_val,
		eq				=>	Cntr1_eq);
	
	
	Cntr2_incr			:	incr
	GENERIC	MAP(
		size			=>	4)
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		ini				=>	ini,
		inc				=>	Cntr2_inc,
		max				=>	Cntr2_Max,
		val				=>	Cntr2_val,
		eq				=>	Cntr2_eq);
	
	
	Cntr3_incr			:	incr
	GENERIC	MAP(
		size			=>	4)
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		ini				=>	ini,
		inc				=>	Cntr3_inc,
		max				=>	Cntr3_Max,
		val				=>	Cntr3_val,
		eq				=>	Cntr3_eq);
	
	
	Cntr4_incr			:	incr
	GENERIC	MAP(
		size			=>	4)
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		ini				=>	ini,
		inc				=>	Cntr4_inc,
		max				=>	Cntr4_Max,
		val				=>	Cntr4_val,
		eq				=>	Cntr4_eq);
		
		
	Cntr5_incr			:	incr
	GENERIC	MAP(
		size			=>	4)
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		ini				=>	ini,
		inc				=>	Cntr5_inc,
		max				=>	Cntr5_Max,
		val				=>	Cntr5_val,
		eq				=>	Cntr5_eq);
		
end Behavioral;


