library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.my_pack_v2.ALL;

entity SA_Add_gen is
	PORT(
		clk				:	IN	std_logic;
		rst				:	IN	std_logic;
		
		ini				:	IN	std_logic;
		
		Kern_Max		:	IN	std_logic_vector(3 DOWNTO 0);
		Kern_inc		:	IN	std_logic;
		Kern_val		:	OUT	std_logic_vector(3 DOWNTO 0);
		Kern_eq			:	OUT	std_logic;
		
		Colm_Max		:	IN	std_logic_vector(3 DOWNTO 0);
		Colm_inc		:	IN	std_logic;
		Colm_val		:	OUT	std_logic_vector(3 DOWNTO 0);
		Colm_eq			:	OUT	std_logic); 
end SA_Add_gen;

architecture Behavioral of SA_Add_gen is
	
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
	
	Kern_incr			:	incr
	GENERIC	MAP(
		size			=>	4)
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
		size			=>	4)
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		ini				=>	ini,
		inc				=>	Colm_inc,
		max				=>	Colm_Max,
		val				=>	Colm_val,
		eq				=>	Colm_eq);
	
		
end Behavioral;


