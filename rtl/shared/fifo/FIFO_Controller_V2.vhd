library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.math_real.ALL;


entity FIFO_Controller_V2 is
	GENERIC(
		depth		:	INTEGER	:=	127);
	PORT(
		clk			:	IN	std_logic;
		rst			:	IN	std_logic;
		Push		:	IN	std_logic;
		Pop			:	IN	std_logic;
		Full		:	OUT	std_logic;
		Empty		:	OUT	std_logic;
		write_en	:	OUT	std_logic;
		W_inc_en	:	OUT	std_logic;
		R_inc_en	:	OUT	std_logic;
		DC_clr		:	OUT	std_logic;
		DC_inc		:	OUT	std_logic;
		DC_dec		:	OUT	std_logic;
		DC_val		:	IN	std_logic_vector(integer(ceil(log2(real(depth+1))))-1 DOWNTO 0));
end FIFO_Controller_V2;

architecture Behavioral of FIFO_Controller_V2 is
	TYPE	FSM	IS (rstting, S_empty, normal, S_full);
	SIGNAL	PState		:	FSM;
	SIGNAL	NState		:	FSM;
	
	SIGNAL	lastPush	:	std_logic;
	SIGNAL	lastPop		:	std_logic;
begin

	next_state:PROCESS (PState, Push, Pop, lastPush, lastPop)
	BEGIN
		CASE PState	IS
			WHEN	rstting	=>						 NState	<= S_empty;
			WHEN	S_empty	=>	IF Push = '1'	THEN Nstate <= normal; 
												ELSE NState <= S_empty ;	END IF;
			WHEN	normal	=>	
				NState	<=	normal;
				IF		(Push = '1' AND Pop = '1')						THEN	NState	<=	normal;
				ELSIF	(Push = '1' AND Pop = '0' AND lastPush = '1') 	THEN	NState	<=	S_full;
				ELSIF	(Push = '0' AND Pop = '1' AND lastPop = '1') 	THEN	NState	<=	S_empty;
				END IF;
			WHEN	S_full	=>	IF Pop = '1'	THEN Nstate <= normal; 
												ELSE NState <= S_full;	END IF;
			WHEN	OTHERS	=>	NState	<=	rstting;
			END CASE;
	END PROCESS;
	
	Present_state:PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN 
			PState	<=	rstting;
		ELSIF clk = '1' AND clk'EVENT THEN
			PState	<=	NState;
		END IF;
	END PROCESS;
	
	
	last:PROCESS (DC_val)
		variable cntr	:	INTEGER;
	BEGIN
		cntr := to_integer(unsigned(DC_val));
		
		IF cntr = 1 THEN
			lastPop		<= '1';
		ELSE
			lastPop		<= '0';
		END IF;
		
		IF cntr = depth - 1 THEN
			lastPush	<= '1';
		ELSE
			lastPush	<= '0';
		END IF;
		
	END PROCESS;
	
	
	outputs:PROCESS (PState, Push, Pop)
	BEGIN
		Full				<= '0';
		Empty				<= '0';
		write_en			<= '0';
		W_inc_en			<= '0';
		R_inc_en			<= '0';
		DC_clr				<= '0';
		DC_inc				<= '0';
		DC_dec				<= '0';
		CASE PState	IS 
			WHEN	S_empty	=>
				Empty		<= '1';
				write_en	<= Push;
				W_inc_en	<= Push;
				DC_inc		<= Push;
			WHEN	normal	=>
				write_en	<= Push;
				W_inc_en	<= Push;
				R_inc_en	<= Pop;
				DC_inc		<= Push;
				DC_dec		<= Pop;
			WHEN	S_full	=>
				Full		<= '1';
				R_inc_en	<= Pop;
				DC_dec		<= Pop;
			WHEN	OTHERS	=>
				DC_clr		<= '1';
				Full		<= '0';
				Empty		<= '0';
				write_en	<= '0';
				W_inc_en	<= '0';
				R_inc_en	<= '0';
			END CASE;
	END PROCESS;
	
end Behavioral;
