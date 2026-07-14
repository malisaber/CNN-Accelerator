library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.my_pack_v2.ALL;
	
entity MiniBatch_Interrupt_handler		is			--	16	Interrupt Source
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		
		
		--	Interrupt Handler
		INT_IHA_Enable					:	IN	std_logic_vector(15	DOWNTO	0);
		
		--	Accelerator
		------	Requests
		INT_ACC_REQ						:	IN	std_logic_vector(15	DOWNTO	0);
		------	Acknowledge
		INT_ACC_ACK						:	OUT	std_logic_vector(15	DOWNTO	0);
		
		
		--	Interrupt Port
		INT_IHA_Load					:	OUT	std_logic;
        INT_IHA_REQ						:	OUT	std_logic;
		INT_IHA_REQ_ADD					:	OUT	std_logic_vector(3	DOWNTO	0);
        INT_IHA_ACK						:	IN	std_logic;
		INT_IHA_ACK_ADD					:	IN	std_logic_vector(3	DOWNTO	0));
end MiniBatch_Interrupt_handler;

ARCHITECTURE Behavioral of MiniBatch_Interrupt_handler IS
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		TYPEs
	--------------------------------------------------------------------------
	TYPE	states						IS	(reset, get_req, put_req, put_ack);
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		SINGALs
	--------------------------------------------------------------------------
	SIGNAL	P_State						:	states;
	SIGNAL	N_State						:	states;
	--------------------------------------------------------------------------
	SIGNAL	INT_REQ_ALL					:	std_logic_vector(15	DOWNTO	0);
	SIGNAL	INT_ACK_ALL					:	std_logic_vector(15	DOWNTO	0);
	SIGNAL	INT_REQ_LOC					:	std_logic_vector(4	DOWNTO	0);
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
begin
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--			Connections													--
	--------------------------------------------------------------------------
	INT_REQ_ALL(0)						<=	INT_IHA_Enable(0)		AND		INT_ACC_REQ(0);
	INT_REQ_ALL(1)						<=	INT_IHA_Enable(1)		AND		INT_ACC_REQ(1);
	INT_REQ_ALL(2)						<=	INT_IHA_Enable(2)		AND		INT_ACC_REQ(2);
	INT_REQ_ALL(3)						<=	INT_IHA_Enable(3)		AND		INT_ACC_REQ(3);
	INT_REQ_ALL(4)						<=	INT_IHA_Enable(4)		AND		INT_ACC_REQ(4);
	INT_REQ_ALL(5)						<=	INT_IHA_Enable(5)		AND		INT_ACC_REQ(5);
	INT_REQ_ALL(6)						<=	INT_IHA_Enable(6)		AND		INT_ACC_REQ(6);
	INT_REQ_ALL(7)						<=	INT_IHA_Enable(7)		AND		INT_ACC_REQ(7);
	INT_REQ_ALL(8)						<=	INT_IHA_Enable(8)		AND		INT_ACC_REQ(8);
	INT_REQ_ALL(9)						<=	INT_IHA_Enable(9)		AND		INT_ACC_REQ(9);
	INT_REQ_ALL(10)						<=	INT_IHA_Enable(10)		AND		INT_ACC_REQ(10);
	INT_REQ_ALL(11)						<=	INT_IHA_Enable(11)		AND		INT_ACC_REQ(11);
	INT_REQ_ALL(12)						<=	INT_IHA_Enable(12)		AND		INT_ACC_REQ(12);
	INT_REQ_ALL(13)						<=	INT_IHA_Enable(13)		AND		INT_ACC_REQ(13);
	INT_REQ_ALL(14)						<=	INT_IHA_Enable(14)		AND		INT_ACC_REQ(14);
	INT_REQ_ALL(15)						<=	INT_IHA_Enable(15)		AND		INT_ACC_REQ(15);
	--------------------------------------------------------------------------
	INT_ACC_ACK(0)						<=	INT_ACK_ALL(0);
	INT_ACC_ACK(1)						<=	INT_ACK_ALL(1);
	INT_ACC_ACK(2)						<=	INT_ACK_ALL(2);
	INT_ACC_ACK(3)						<=	INT_ACK_ALL(3);
	INT_ACC_ACK(4)						<=	INT_ACK_ALL(4);
	INT_ACC_ACK(5)						<=	INT_ACK_ALL(5);
	INT_ACC_ACK(6)						<=	INT_ACK_ALL(6);
	INT_ACC_ACK(7)						<=	INT_ACK_ALL(7);
	INT_ACC_ACK(8)						<=	INT_ACK_ALL(8);
	INT_ACC_ACK(9)						<=	INT_ACK_ALL(9);
	INT_ACC_ACK(10)						<=	INT_ACK_ALL(10);
	INT_ACC_ACK(11)						<=	INT_ACK_ALL(11);
	INT_ACC_ACK(12)						<=	INT_ACK_ALL(12);
	INT_ACC_ACK(13)						<=	INT_ACK_ALL(13);
	INT_ACC_ACK(14)						<=	INT_ACK_ALL(14);
	INT_ACC_ACK(15)						<=	INT_ACK_ALL(15);
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	PROCESS(INT_REQ_ALL)
	BEGIN
		IF		INT_REQ_ALL(0)	= '1'	THEN	INT_REQ_LOC	<=	"00000";
		ELSIF	INT_REQ_ALL(1)	= '1'	THEN	INT_REQ_LOC	<=	"00001";
		ELSIF	INT_REQ_ALL(2)	= '1'	THEN	INT_REQ_LOC	<=	"00010";
		ELSIF	INT_REQ_ALL(3)	= '1'	THEN	INT_REQ_LOC	<=	"00011";
		ELSIF	INT_REQ_ALL(4)	= '1'	THEN	INT_REQ_LOC	<=	"00100";
		ELSIF	INT_REQ_ALL(5)	= '1'	THEN	INT_REQ_LOC	<=	"00101";
		ELSIF	INT_REQ_ALL(6)	= '1'	THEN	INT_REQ_LOC	<=	"00110";
		ELSIF	INT_REQ_ALL(7)	= '1'	THEN	INT_REQ_LOC	<=	"00111";
		ELSIF	INT_REQ_ALL(8)	= '1'	THEN	INT_REQ_LOC	<=	"01000";
		ELSIF	INT_REQ_ALL(9)	= '1'	THEN	INT_REQ_LOC	<=	"01001";
		ELSIF	INT_REQ_ALL(10)	= '1'	THEN	INT_REQ_LOC	<=	"01010";
		ELSIF	INT_REQ_ALL(11)	= '1'	THEN	INT_REQ_LOC	<=	"01011";
		ELSIF	INT_REQ_ALL(12)	= '1'	THEN	INT_REQ_LOC	<=	"01100";
		ELSIF	INT_REQ_ALL(13)	= '1'	THEN	INT_REQ_LOC	<=	"01101";
		ELSIF	INT_REQ_ALL(14)	= '1'	THEN	INT_REQ_LOC	<=	"01110";
		ELSIF	INT_REQ_ALL(15)	= '1'	THEN	INT_REQ_LOC	<=	"01111";
		ELSE									INT_REQ_LOC	<=	"10000";
		END IF;
		--WAIT ON INT_REQ_ARR(i);
	END PROCESS;

	--------------------------------------------------------------------------
	PROCESS(clk, rst)
	BEGIN
		IF rst = '1' THEN
			P_State	<=	reset;
		ELSIF clk = '1' AND clk'EVENT THEN
			P_State	<=	N_State;
		END IF;
		--WAIT ON clk, rst;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS(P_State, INT_IHA_ACK_ADD, INT_REQ_LOC, INT_IHA_ACK)
		VARIABLE	add					:	INTEGER	RANGE 0 TO 15;
	BEGIN
		INT_ACK_ALL						<=	(OTHERS	=>	'0');
		INT_IHA_REQ_ADD					<=	(OTHERS	=>	'0');
		INT_IHA_REQ						<=	'0';
		INT_IHA_Load					<=	'0';
		N_State							<=	P_State;
		add								:=	my_to_uint(INT_IHA_ACK_ADD);
		CASE	P_State	IS
			WHEN	reset				=>													N_State				<=	get_req;
			WHEN	get_req				=>	IF		INT_REQ_LOC		/=	"10000" THEN		N_State				<=	put_req;					END IF;
			WHEN	put_req				=>													INT_IHA_REQ			<=	'1';
											IF		INT_IHA_ACK		=	'1'		THEN		INT_IHA_REQ_ADD		<=	INT_REQ_LOC(3 DOWNTO 0);
																							INT_IHA_Load		<=	'1';
																							N_State				<=	put_ack;					END IF;
			WHEN	put_ack				=>	IF		INT_IHA_ACK		=	'0'		THEN		N_State				<=	get_req;					END IF;
																							INT_ACK_ALL(add)	<=	'1';
		END CASE;
		--WAIT ON P_State, INT_REQ_ARR_LOC, NEXT_INT_ADDRESS, INT_ACK;
	END PROCESS;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
end Behavioral;




