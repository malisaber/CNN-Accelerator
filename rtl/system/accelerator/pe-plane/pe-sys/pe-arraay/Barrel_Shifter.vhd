library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.my_pack_v2.ALL;
USE IEEE.math_real.ALL;

entity Barrel_Shifter is
	GENERIC(
		size			:	INTEGER	:=	8);
	PORT(
		Data_in			:	IN	std_logic_vector(2*size-1 DOWNTO 0);
		Data_out		:	OUT	std_logic_vector(size-1 DOWNTO 0);
		mode			:	IN	std_logic;
		shift_cnt		:	IN	std_logic_vector(integer(ceil(log2(real(size+1))))-1 DOWNTO 0));
end Barrel_Shifter;

architecture Behavioral of Barrel_Shifter is
	
	COMPONENT	BS_layer
	GENERIC(
		size				:	INTEGER	:=	16);
	PORT(
		Data_in				:	IN	std_logic_vector(size-1 DOWNTO 0);
		Data_out			:	OUT	std_logic_vector(size-1 DOWNTO 0);
		Par_out				:	OUT	std_logic;
		control				:	IN	std_logic_vector(size-1 DOWNTO 0));
	END COMPONENT;
	
	TYPE	IO_layer	IS ARRAY (0 TO size) OF std_logic_vector(0 TO 2*size-1);
	SIGNAL	lay_inp			:	IO_layer;
	SIGNAL	lay_out			:	IO_layer;
	SIGNAL	Shifts			:	IO_layer;
	SIGNAL	lower_dec		:	std_logic_vector(0 TO size-1);
	SIGNAL	upper_dec		:	std_logic_vector(0 TO size-1);
	
begin
	
	
	
	CONNECT_GEN				:	FOR i IN 0 TO size-1 GENERATE
		PROCESS (Data_in, shift_cnt)
			VARIABLE	add	:	INTEGER;
		BEGIN
			add				:=	my_to_uint(shift_cnt);
			Data_out(i)		<=	Data_in(add + i);
		END PROCESS;
	END GENERATE;
	
	
	
	--Data_out	<=	Data_in(31 DOWNTO 16);
	
--	PROCESS
--		VARIABLE	add		:	INTEGER;
--	BEGIN
--		add						:=	to_integer(unsigned(shift_cnt));
--		lower_dec				<=	(OTHERS => '0');
--		upper_dec				<=	(OTHERS => '0');
		
--		IF mode = '1' THEN
--			lower_dec(add)		<=	'1'; 
--			upper_dec(add)		<=	'1';
--		ElSE
--			add					:=	add mod (size/2);
--			lower_dec(add)		<=	'1';
--			upper_dec(size/2+add)	<=	'1';
--		END IF;
--		WAIT ON shift_cnt, mode;
--	END PROCESS;
	
--	inp_gen					:	FOR i IN 0 TO 2*size-1 GENERATE
--		lay_inp(0)(i)		<=	Data_in(i);
--	END GENERATE;
	
--	layer_gen				:	FOR i IN 0 TO size-1 GENERATE
--		layers				:	BS_layer
--		GENERIC	MAP(
--			size			=>	2*size)
--		PORT	MAP(
--			Data_in			=>	lay_inp(i),
--			Data_out		=>	lay_out(i),
--			Par_out			=>	Data_out(size-1-i),
--			control			=>	Shifts(i));
--		lay_inp(i+1)		<=	lay_out(i);
--	END GENERATE;
	
--	Shifts(size-1)			<=	lower_dec & (0 TO size-1 => '0');
--	lower_control_gen		:	FOR i IN size-2 DOWNTO size/2 GENERATE
--		Shifts(i)			<=	'0' & Shifts(i+1)(0 TO 2*size-2);
--	END GENERATE;
	
--	Shifts(size/2-1)		<=	(0 TO size/2-1 => '0') & upper_dec & (0 TO size/2-1 => '0');
--	upper_control_gen		:	FOR i IN size/2-2 DOWNTO 0 GENERATE
--		Shifts(i)			<=	'0' & Shifts(i+1)(0 TO 2*size-2);
--	END GENERATE;
	
	
end Behavioral;

