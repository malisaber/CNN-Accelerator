library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.my_pack_v2.ALL;

entity LMN_Master is
	PORT(
		clk				:	IN	std_logic;
		rst				:	IN	std_logic;
		
		--	BUS Side
		BUS_req			:	OUT	std_logic;
		BUS_grant		:	IN	std_logic;
		BUS_done		:	IN	std_logic;
		BUS_wait		:	IN	std_logic;
		BUS_read		:	OUT	std_logic;
		BUS_write		:	OUT	std_logic;
		BUS_Add			:	OUT	std_logic_vector(P_Phy_Add_size-1	DOWNTO 0);
		BUS_cnt			:	OUT	std_logic_vector(P_Phy_Cnt_size-1	DOWNTO 0);
		BUS_MD_in		:	IN	std_logic_vector(P_word_size-1		DOWNTO 0);
		BUS_MD_in_rdy	:	IN	std_logic;
		BUS_MD_out		:	OUT	std_logic_vector(P_word_size-1		DOWNTO 0);
		BUS_MD_out_rdy	:	OUT	std_logic;
		
		--	Native side
		NAT_ready		:	OUT	std_logic;
		NAT_wait		:	OUT	std_logic;
		NAT_push		:	IN	std_logic;
		NAT_ack			:	OUT	std_logic;
		NAT_read		:	IN	std_logic;
		NAT_write		:	IN	std_logic;
		NAT_Add			:	IN	std_logic_vector(P_Phy_Add_size-1	DOWNTO 0);
		NAT_Cnt			:	IN	std_logic_vector(P_Phy_Cnt_size-1	DOWNTO 0);
		NAT_data_out	:	OUT	std_logic_vector(P_word_size-1		DOWNTO 0);
		NAT_data_rdy	:	OUT	std_logic;
		NAT_data_in		:	IN	std_logic_vector(P_word_size-1		DOWNTO 0);
		NAT_data_wen	:	IN	std_logic);
end LMN_Master;

architecture Behavioral of LMN_Master is
	
	TYPE	FSM			IS (idle, load, comp, accept, trans, cmpTR0, cmpTR1, cmpTR2, cmpTR3);
	
	SIGNAL	P_S			:	FSM;
	SIGNAL	N_S			:	FSM;
	
	SIGNAL	REG_read	:	std_logic;
	SIGNAL	REG_write	:	std_logic;
	SIGNAL	REG_Add		:	std_logic_vector(P_Phy_Add_size-1	DOWNTO 0);
	SIGNAL	REG_Cnt		:	std_logic_vector(P_Phy_Cnt_size-1	DOWNTO 0);
	SIGNAL	REG_data_out:	std_logic_vector(P_word_size-1		DOWNTO 0);
	SIGNAL	REG_data_rdy:	std_logic;
	SIGNAL	REG_data_in	:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	REG_data_wen:	std_logic;
	
	SIGNAL	load_cmd	:	std_logic;
	SIGNAL	load_Data	:	std_logic;
	SIGNAL	clar_CD		:	std_logic;
	
begin
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			P_S			<=	idle;
		ELSIF clk = '1' AND clk'EVENT THEN
			P_S			<=	N_S;
		END IF;
	END PROCESS;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	PROCESS (P_S, NAT_push, BUS_grant, BUS_done, BUS_wait)
	BEGIN
		NAT_ready		<=	'0';
		NAT_wait		<=	'1';
		N_S				<=	idle;
		BUS_req			<=	'0';
		NAT_ack			<=	'0';
		load_cmd		<=	'0';
		load_Data		<=	'0';
		clar_CD			<=	'0';
		CASE P_S IS
			WHEN	idle	=>	IF NAT_push = '1'	THEN	N_S	<=	load;	ELSE	N_S	<=	idle;	END IF;
			WHEN	load	=>								N_S	<=	comp;
			WHEN	comp	=>								N_S	<=	accept;
			WHEN	accept	=>	IF BUS_grant = '1'	THEN	N_S	<=	trans;	ELSE	N_S	<=	accept;	END IF;
			WHEN	trans	=>	IF BUS_done = '0'	THEN	N_S	<=	trans;	ELSE	N_S	<=	cmpTR0;	END IF;
			WHEN	cmpTR0	=>	IF BUS_done = '0'	THEN	N_S	<=	trans;	ELSE	N_S	<=	idle;	END IF;
			WHEN	cmpTR1	=>	IF BUS_done = '0'	THEN	N_S	<=	trans;	ELSE	N_S	<=	idle;	END IF;
			WHEN	cmpTR2	=>	IF BUS_done = '0'	THEN	N_S	<=	trans;	ELSE	N_S	<=	idle;	END IF;
			WHEN	cmpTR3	=>	IF BUS_done = '0'	THEN	N_S	<=	trans;	ELSE	N_S	<=	idle;	END IF;
			END CASE;
		CASE P_S IS	
			WHEN	idle	=>	clar_CD		<=	'1';
								NAT_ready	<=	'1';
			WHEN	load	=>	NAT_ack		<=	'1';
								load_cmd	<=	'1';
			WHEN	comp	=>	BUS_req		<=	'0';
			WHEN	accept	=>	BUS_req		<=	'1';
			WHEN	trans	=>	BUS_req		<=	'1';
								load_Data	<=	'1';
								NAT_wait	<=	BUS_wait;
			WHEN	cmpTR0	=>	BUS_req		<=	'1';
								load_Data	<=	'1';
								NAT_wait	<=	BUS_wait;
			WHEN	cmpTR1	=>	BUS_req		<=	'1';
								load_Data	<=	'1';
								NAT_wait	<=	BUS_wait;
			WHEN	cmpTR2	=>	BUS_req		<=	'1';
								load_Data	<=	'1';
								NAT_wait	<=	BUS_wait;
			WHEN	cmpTR3	=>	BUS_req		<=	'1';
								load_Data	<=	'1';
								NAT_wait	<=	BUS_wait;
			END CASE;
	END PROCESS;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			REG_read			<=	'0';
			REG_write			<=	'0';
			REG_Add				<=	(OTHERS => '0');
			REG_Cnt				<=	(OTHERS => '0');
		ELSIF clk = '1' AND clk'EVENT THEN
			IF clar_CD = '1' THEN
				REG_read		<=	'0';
				REG_write		<=	'0';
				REG_Add			<=	(OTHERS => '0');
				REG_Cnt			<=	(OTHERS => '0');
			ELSE
				IF load_cmd = '1' THEN
					REG_read	<=	NAT_read;
					REG_write	<=	NAT_write;
					REG_Add		<=	NAT_Add;
					REG_Cnt		<=	NAT_Cnt;
				END IF;
			END IF;
		END IF;
	END PROCESS;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	BUS_read		<=	REG_read;
	BUS_write		<=	REG_write;
	BUS_Add			<=	REG_Add;
	BUS_cnt			<=	REG_Cnt;
	
	NAT_data_out	<=	BUS_MD_in		WHEN	load_Data = '1'	ELSE	(OTHERS => '0');
	NAT_data_rdy	<=	BUS_MD_in_rdy	WHEN	load_Data = '1'	ELSE	'0';
	BUS_MD_out		<=	NAT_data_in		WHEN	load_Data = '1'	ELSE	(OTHERS => '0');
	BUS_MD_out_rdy	<=	NAT_data_wen	WHEN	load_Data = '1'	ELSE	'0';
	
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
end Behavioral;

