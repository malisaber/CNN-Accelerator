library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.my_pack_v2.ALL;

entity GMN_pass_DAM is
	PORT(
		clk				:	IN	std_logic;
		rst				:	IN	std_logic;
		
		--	Master Port (read)
		MR_req			:	OUT	std_logic;
		MR_grant		:	IN	std_logic;
		MR_done			:	IN	std_logic;
		MR_wait			:	IN	std_logic;
		MR_read			:	OUT	std_logic;
		MR_write		:	OUT	std_logic;
		MR_Add			:	OUT	std_logic_vector(P_Phy_Add_size-1 DOWNTO 0);
		MR_Cnt			:	OUT	std_logic_vector(P_Phy_Cnt_size-1 DOWNTO 0);
		MR_Din			:	IN	std_logic_vector(P_word_size-1 DOWNTO 0);
		MR_Din_rdy		:	IN	std_logic;
		MR_Dout			:	OUT	std_logic_vector(P_word_size-1 DOWNTO 0);
		MR_Dout_rdy		:	OUT	std_logic;
		
		
		--	Master Port (write)
		MW_req			:	OUT	std_logic;
		MW_grant		:	IN	std_logic;
		MW_done			:	IN	std_logic;
		MW_wait			:	IN	std_logic;
		MW_read			:	OUT	std_logic;
		MW_write		:	OUT	std_logic;
		MW_Add			:	OUT	std_logic_vector(P_Phy_Add_size-1 DOWNTO 0);
		MW_Cnt			:	OUT	std_logic_vector(P_Phy_Cnt_size-1 DOWNTO 0);
		MW_Din			:	IN	std_logic_vector(P_word_size-1 DOWNTO 0);
		MW_Din_rdy		:	IN	std_logic;
		MW_Dout			:	OUT	std_logic_vector(P_word_size-1 DOWNTO 0);
		MW_Dout_rdy		:	OUT	std_logic;
		
		
		--	Transaction	req
		TR_start		:	IN	std_logic;
		TR_ready		:	OUT	std_logic;
		TR_R_Add		:	IN	std_logic_vector(P_Phy_Add_size-1 DOWNTO 0);
		TR_R_Cnt		:	IN	std_logic_vector(P_Phy_Cnt_size-1 DOWNTO 0);
		TR_W_Add		:	IN	std_logic_vector(P_Phy_Add_size-1 DOWNTO 0);
		TR_W_Cnt		:	IN	std_logic_vector(P_Phy_Cnt_size-1 DOWNTO 0));
end GMN_pass_DAM;

architecture Behavioral of GMN_pass_DAM is
	
	TYPE	FSM			IS	(idle, load, cmp1, Wgnt, Wwit, Rgnt, tran, cmp2);
	
	SIGNAL	P_S			:	FSM;
	SIGNAL	N_S			:	FSM;
	
	SIGNAL	clr			:	std_logic;
	SIGNAL	trn			:	std_logic;
	SIGNAL	TR_granted	:	std_logic;
	SIGNAL	ld_cmd		:	std_logic;
	
	SIGNAL	R_Add		:	std_logic_vector(P_Phy_Add_size-1 DOWNTO 0);
	SIGNAL	R_Cnt		:	std_logic_vector(P_Phy_Cnt_size-1 DOWNTO 0);
	SIGNAL	W_Add		:	std_logic_vector(P_Phy_Add_size-1 DOWNTO 0);
	SIGNAL	W_Cnt		:	std_logic_vector(P_Phy_Cnt_size-1 DOWNTO 0);
	
	SIGNAL	TR_Data		:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	TR_Data_rdy	:	std_logic;
	
begin
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	MR_write			<=	'0';
	MR_Dout				<=	(OTHERS => '0');
	MR_Dout_rdy			<=	'0';
	MW_read				<=	'0';
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	PROCESS(clk, rst)
	BEGIN
		IF rst = '1' THEN
			P_S	<=	idle;
		ELSIF clk = '1' AND clk'EVENT THEN
			P_S	<=	N_S;
		END IF;
	END PROCESS;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	PROCESS(P_S, TR_start,	MW_grant,	MW_wait,	MR_grant,	MR_done)
	BEGIN
		----------------------------------------------------------------------------------
		clr				<=	'0';
		trn				<=	'0';
		ld_cmd			<=	'0';
		TR_ready		<=	'0';
		MR_req			<=	'0';
		MW_req			<=	'0';
		----------------------------------------------------------------------------------
		CASE P_S IS
			WHEN	idle	=>	IF TR_start = '1'	THEN	N_S <= load;	ELSE	N_S <= idle;	END IF;
			WHEN	load	=>								N_S <= cmp1;
			WHEN	cmp1	=>								N_S <= Wgnt;
			WHEN	Wgnt	=>	IF MW_grant = '1'	THEN	N_S <= Wwit;	ELSE	N_S <= Wgnt;	END IF;
			WHEN	Wwit	=>	IF MW_wait = '0'	THEN	N_S	<= Rgnt;	ELSE	N_S	<= Wwit;	END IF;
			WHEN	Rgnt	=>	IF MR_grant = '1'	THEN	N_S	<= tran;	ELSE	N_S	<= Rgnt;	END IF;
			WHEN	tran	=>	IF MR_done = '1'	THEN	N_S <= cmp2;	ELSE	N_S <= tran;	END IF;
			WHEN	cmp2	=>								N_S <= idle;
		END CASE;
		----------------------------------------------------------------------------------
		CASE P_S IS
			WHEN	idle	=>	TR_ready	<=	'1';
								clr			<=	'1';
			WHEN	load	=>	ld_cmd		<=	'1';
			WHEN	cmp1	=>	NULL;
			WHEN	Wgnt	=>	MW_req		<=	'1';
			WHEN	Wwit	=>	MW_req		<=	'1';
			WHEN	Rgnt	=>	MW_req		<=	'1';
								MR_req		<=	'1';
			WHEN	tran	=>	trn			<=	'1';
								MR_req		<=	'1';
								MW_req		<=	'1';
			WHEN	cmp2	=>	trn			<=	'1';
								MW_req		<=	'1';
		END CASE;
		----------------------------------------------------------------------------------
	END PROCESS;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	PROCESS(clk, rst)
	BEGIN
		IF rst = '1' THEN
			MR_read				<=	'0';
			MR_Add				<=	(OTHERS => '0');
			MR_Cnt				<=	(OTHERS => '0');
			MW_write			<=	'0';
			MW_Add				<=	(OTHERS => '0');
			MW_Cnt				<=	(OTHERS => '0');
			TR_Data				<=	(OTHERS => '0');
			TR_Data_rdy			<=	'0';
		ELSIF clk = '1' AND clk'EVENT THEN
			IF clr = '1' THEN
				MR_read			<=	'0';
				MR_Add			<=	(OTHERS => '0');
				MR_Cnt			<=	(OTHERS => '0');
				MW_write		<=	'0';
				MW_Add			<=	(OTHERS => '0');
				MW_Cnt			<=	(OTHERS => '0');
				TR_Data			<=	(OTHERS => '0');
				TR_Data_rdy		<=	'0';
			ELSE
				IF ld_cmd = '1' THEN
					MR_read		<=	'1';
					MR_Add		<=	TR_R_Add;
					MR_Cnt		<=	TR_R_Cnt;
					MW_write	<=	'1';
					MW_Add		<=	TR_W_Add;
					MW_Cnt		<=	TR_W_Cnt;
				END IF;
				IF trn = '1' THEN
					TR_Data		<=	MR_Din;
					TR_Data_rdy	<=	MR_Din_rdy;
				ELSE
					TR_Data			<=	(OTHERS => '0');
					TR_Data_rdy		<=	'0';
				END IF;
			END IF;
		END IF;
	END PROCESS;
	MW_Dout			<=	TR_Data;
	MW_Dout_rdy		<=	TR_Data_rdy;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
end Behavioral;
