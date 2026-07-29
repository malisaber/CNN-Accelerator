LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.math_real.ALL;
 
 
ENTITY SIM_FIFO_V2 IS
	GENERIC(
		depth			:	INTEGER	:=	32; 
		word_size		:	INTEGER	:=	8);
END SIM_FIFO_V2;
 
ARCHITECTURE behavior OF SIM_FIFO_V2 IS 
	
	-- Component Declaration for the Unit Under Test (UUT)
	
	COMPONENT FIFO_v2
	GENERIC(
		depth			:	INTEGER	:=	32; 
		word_size		:	INTEGER	:=	4;
		reged_output	:	INTEGER	:=	0);
	PORT(
		clk				:	IN	std_logic;
		rst				:	IN	std_logic;
		-- input
		push			:	IN std_logic;
		data_in			:	IN	std_logic_vector(word_size -1 DOWNTO 0);
		full			:	OUT	std_logic;
		-- output
		pop				:	IN	std_logic;
		data_out		:	OUT	std_logic_vector(word_size -1 DOWNTO 0);
		empty			:	OUT	std_logic);
	END COMPONENT;
    
	
	--Inputs
	SIGNAL	clk			:	std_logic								:=	'0';
	SIGNAL	rst			:	std_logic								:=	'0';
	SIGNAL	push		:	std_logic								:=	'0';
	SIGNAL	data_in		:	std_logic_vector(word_size-1 downto 0)	:=	(others => '0');
	SIGNAL	pop			:	std_logic								:=	'0';
	
	--Outputs
	SIGNAL	full		:	std_logic;
	SIGNAL	full_R		:	std_logic;
	SIGNAL	data_out	:	std_logic_vector(word_size-1 downto 0);
	SIGNAL	data_out_R	:	std_logic_vector(word_size-1 downto 0);
	SIGNAL	data_out_R2	:	std_logic_vector(word_size-1 downto 0);
	SIGNAL	empty		:	std_logic;
	SIGNAL	empty_R		:	std_logic;
	
	--	Clock period definitions
	CONSTANT clk_period	:	time							:= 10 ns;
 
BEGIN
	
	-- Instantiate the Unit Under Test (UUT)
	uut					:		FIFO_v2
	GENERIC	MAP	(
		depth			=>	depth,
		word_size		=>	word_size,
		reged_output	=>	0)
	PORT	MAP	(
		clk				=>	clk,
		rst				=>	rst,
		push			=>	push,
		data_in			=>	data_in,
		full			=>	full,
		pop				=>	pop,
		data_out		=>	data_out,
		empty			=>	empty);
		
	-- Instantiate the Unit Under Test (UUT)
	uut_Reged			:		FIFO_v2
	GENERIC	MAP	(
		depth			=>	depth,
		word_size		=>	word_size,
		reged_output	=>	1)
	PORT	MAP	(
		clk				=>	clk,
		rst				=>	rst,
		push			=>	push,
		data_in			=>	data_in,
		full			=>	full_R,
		pop				=>	pop,
		data_out		=>	data_out_R,
		empty			=>	empty_R);
	
	
	
	-- Clock process definitions
	clk_process :process
	begin
		clk				<= '0';
		wait for clk_period/2;
		clk				<= '1';
		wait for clk_period/2;
	end process;
	
	
	process (clk)
	begin 
	if clk = '1' and clk'event then 
		data_out_R2	<=	data_out;
	end if;
	end process;
	
	
	-- Stimulus process
	stim_proc1: process
	begin
		rst				<=	'1';
		wait for clk_period*50;
		rst				<=	'0';
		wait for clk_period*10;
		FOR i IN 1 TO 100 LOOP 
			push		<=	'1';
			data_in		<=	std_logic_vector(unsigned(data_in) + 1);
			wait for clk_period;
			push		<=	'0';
			wait for clk_period * 9;
		END LOOP;
		wait;
	end process;
	
	
	
	
	
	-- Stimulus process
	stim_proc2: process
	begin		
		wait for clk_period*100;
		FOR i IN 1 TO 100 LOOP 
			pop			<=	'1';
			wait for clk_period;
			pop			<=	'0';
			wait for clk_period * 13;
		END LOOP;
		wait;
	end process;
	
	
END;
