library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity MUL_v4 is
	GENERIC(
		size			:	INTEGER	:=	16);
	PORT(
		inA				:	IN	std_logic_vector(size-1 DOWNTO 0);
		inB				:	IN	std_logic_vector(size-1 DOWNTO 0);
		mode			:	IN	std_logic_vector(2 DOWNTO 0);	--	A sign, B sign, op-mode
		res				:	OUT	std_logic_vector(2*size-1 DOWNTO 0));
end MUL_v4;

architecture Behavioral of MUL_v4 is
	
	COMPONENT	Absolute
	GENERIC(
		size			:	INTEGER	:=	16);
	PORT(
		inp				:	IN	std_logic_vector(size-1 DOWNTO 0);
		en_H			:	IN	std_logic;
		en_L			:	IN	std_logic;
		sign_H			:	IN	std_logic;
		sign_L			:	IN	std_logic;
		mode			:	IN	std_logic;								--	'0'	: <size>/2-bit,	'1' : <size>-bit
		res				:	OUT	std_logic_vector(size-1 DOWNTO 0));
	END COMPONENT;
	
	
	COMPONENT	COMB_MUL
	GENERIC(
		size			:	INTEGER	:= 4);
	PORT(
		IN_A			:	IN	std_logic_vector(size-1 DOWNTO 0);
		IN_B			:	IN	std_logic_vector(size-1 DOWNTO 0);
		mode			:	IN	std_logic;								--	'0'	: <size>/2-bit,	'1' : <size>-bit
		RES				:	OUT	std_logic_vector(2*size-1 DOWNTO 0));
	END COMPONENT;
	
	
	SIGNAL	abs_A		:	std_logic_vector(size-1 DOWNTO 0);
	SIGNAL	abs_B		:	std_logic_vector(size-1 DOWNTO 0);
	SIGNAL	mul_out		:	std_logic_vector(2*size-1 DOWNTO 0);
	SIGNAL	sign_A_H	:	std_logic;
	SIGNAL	sign_A_L	:	std_logic;
	SIGNAL	sign_B_H	:	std_logic;
	SIGNAL	sign_B_L	:	std_logic;
	SIGNAL	sign_R_H	:	std_logic;
	SIGNAL	sign_R_L	:	std_logic;
	SIGNAL	enable_R	:	std_logic;
	
begin
	
	res	<=	std_logic_vector(UNSIGNED(inA) * UNSIGNED(inB));
	
	--sign_A_H			<=	inA(size-1);
	--sign_A_L			<=	inA(size/2-1);
	--sign_B_H			<=	inB(size-1);
	--sign_B_L			<=	inB(size/2-1);
	--sign_R_H			<=	(mode(2) AND sign_A_H) XOR (mode(1) AND sign_B_H);
	--sign_R_L			<=	(mode(2) AND sign_A_L) XOR (mode(1) AND sign_B_L);
	--enable_R			<=	mode(2) OR mode(1);
	--
	--abs_cal_a			:	Absolute
	--GENERIC	MAP(
	--	size			=>	size)
	--PORT	MAP(
	--	inp				=>	inA,
	--	en_H			=>	mode(2),
	--	en_L			=>	mode(2),
	--	sign_H			=>	sign_A_H,
	--	sign_L			=>	sign_A_L,
	--	mode			=>	mode(0),
	--	res				=>	abs_A);
	--
	--
	--abs_cal_B			:	Absolute
	--GENERIC	MAP(
	--	size			=>	size)
	--PORT	MAP(
	--	inp				=>	inB,
	--	en_H			=>	mode(1),
	--	en_L			=>	mode(1),
	--	sign_H			=>	sign_B_H,
	--	sign_L			=>	sign_B_L,
	--	mode			=>	mode(0),
	--	res				=>	abs_B);
	--
	--
	--MUL					:	COMB_MUL
	--GENERIC	MAP(
	--	size			=>	size)
	--PORT	MAP(
	--	IN_A			=>	abs_A,
	--	IN_B			=>	abs_B,
	--	mode			=>	mode(0),
	--	RES				=>	mul_out);
	--
	--
	--abs_cal_res			:	Absolute
	--GENERIC	MAP(
	--	size			=>	2*size)
	--PORT	MAP(
	--	inp				=>	mul_out,
	--	en_H			=>	enable_R,
	--	en_L			=>	enable_R,
	--	sign_H			=>	sign_R_H,
	--	sign_L			=>	sign_R_L,
	--	mode			=>	mode(0),
	--	res				=>	res);
	
end Behavioral;

