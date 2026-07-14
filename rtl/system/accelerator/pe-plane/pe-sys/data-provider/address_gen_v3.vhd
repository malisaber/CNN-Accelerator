library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.my_pack_v2.ALL;

entity address_gen_v3 is
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
		
		Bank_Max		:	IN	std_logic_vector(1 DOWNTO 0);
		Bank_inc		:	IN	std_logic;
		Bank_val		:	OUT	std_logic_vector(1 DOWNTO 0);
		Bank_eq			:	OUT	std_logic);
end address_gen_v3;

architecture Behavioral of address_gen_v3 is
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		COMPONENTs
	--------------------------------------------------------------------------
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
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
begin
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		Instances
	--------------------------------------------------------------------------
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
	--------------------------------------------------------------------------
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
	--------------------------------------------------------------------------
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
	--------------------------------------------------------------------------
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
	--------------------------------------------------------------------------
	Bank_incr			:	incr
	GENERIC	MAP(
		size			=>	2)
	PORT	MAP(
		clk				=>	clk,
		rst				=>	rst,
		ini				=>	ini,
		inc				=>	Bank_inc,
		max				=>	Bank_Max,
		val				=>	Bank_val,
		eq				=>	Bank_eq);
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
end Behavioral;


