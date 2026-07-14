library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.math_real.ALL;
USE work.my_pack_v2.ALL;

entity LMN_Gate is
	PORT(
		clk				:	IN	std_logic;
		rst				:	IN	std_logic;
		
		--	Slave BUS Side
		SBUS_CS			:	IN	std_logic;
		SBUS_done		:	OUT	std_logic;
		SBUS_wait		:	OUT	std_logic;
		SBUS_read		:	IN	std_logic;
		SBUS_write		:	IN	std_logic;
		SBUS_Add		:	IN	std_logic_vector(P_Phy_Add_size-1	DOWNTO 0);
		SBUS_Cnt		:	IN	std_logic_vector(P_Phy_Cnt_size-1	DOWNTO 0);
		SBUS_SD_out		:	OUT	std_logic_vector(P_word_size-1		DOWNTO 0);
		SBUS_SD_out_rdy	:	OUT	std_logic;
		SBUS_SD_in		:	IN	std_logic_vector(P_word_size-1		DOWNTO 0);
		SBUS_SD_in_rdy	:	IN	std_logic;
		
		
		--	Master BUS Side
		MBUS_req		:	OUT	std_logic;
		MBUS_grant		:	IN	std_logic;
		MBUS_done		:	IN	std_logic;
		MBUS_wait		:	IN	std_logic;
		MBUS_read		:	OUT	std_logic;
		MBUS_write		:	OUT	std_logic;
		MBUS_Add		:	OUT	std_logic_vector(P_Phy_Add_size-1	DOWNTO 0);
		MBUS_Cnt		:	OUT	std_logic_vector(P_Phy_Cnt_size-1	DOWNTO 0);
		MBUS_MD_in		:	IN	std_logic_vector(P_word_size-1		DOWNTO 0);
		MBUS_MD_in_rdy	:	IN	std_logic;
		MBUS_MD_out		:	OUT	std_logic_vector(P_word_size-1		DOWNTO 0);
		MBUS_MD_out_rdy	:	OUT	std_logic);
end LMN_Gate;

architecture Behavioral of LMN_Gate is
	
	TYPE	FSM			IS (idle, load, ld_cmp, acc, tra, tr_cmp1, tr_cmp2, tr_cmp3);
	
	SIGNAL	P_S			:	FSM;
	SIGNAL	N_S			:	FSM;
	
	SIGNAL	load_SS		:	std_logic;
	SIGNAL	load_MS		:	std_logic;
	SIGNAL	trans_data	:	std_logic;
	
	SIGNAL	SReg_read	:	std_logic;
	SIGNAL	SReg_write	:	std_logic;
	SIGNAL	SReg_add	:	std_logic_vector(P_Phy_Add_size-1	DOWNTO 0);
	SIGNAL	SReg_cnt	:	std_logic_vector(P_Phy_Cnt_size-1	DOWNTO 0);
	
	SIGNAL	MReg_read	:	std_logic;
	SIGNAL	MReg_write	:	std_logic;
	SIGNAL	MReg_add	:	std_logic_vector(P_Phy_Add_size-1	DOWNTO 0);
	SIGNAL	MReg_Cnt	:	std_logic_vector(P_Phy_Cnt_size-1	DOWNTO 0);
	
	SIGNAL	TLB_add_in	:	std_logic_vector(P_Phy_Add_size-1	DOWNTO 0);
	SIGNAL	TLB_add_out	:	std_logic_vector(P_Phy_Add_size-1	DOWNTO 0);
begin
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			SReg_read		<=	'0';
			SReg_write		<=	'0';
			SReg_add		<=	(OTHERS => '0');
			SReg_cnt		<=	(OTHERS => '0');
		ELSIF clk = '1' AND clk'EVENT THEN
			IF load_SS = '1' THEN
				SReg_read	<=	SBUS_read;
				SReg_write	<=	SBUS_write;
				SReg_add	<=	SBUS_Add;
				SReg_cnt	<=	SBUS_Cnt;
			END IF;
		END IF;
	END PROCESS;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	MReg_read	<=	SReg_read;
	MReg_write	<=	SReg_write;
	MReg_Cnt	<=	SReg_cnt;
	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			MReg_Add		<=	(OTHERS => '0');
		ELSIF clk = '1' AND clk'EVENT THEN
			IF load_MS = '1' THEN
				MReg_Add	<=	SReg_add;
			END IF;
		END IF;
	END PROCESS;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			P_S	<=	idle;
		ELSIF clk = '1' AND clk'EVENT THEN
			P_S	<= N_S;
		END IF;
	END PROCESS;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	PROCESS (P_S,	SBUS_CS,	MBUS_grant,	MBUS_done, MBUS_wait)
	BEGIN
		load_SS		<=	'0';
		load_MS		<=	'0';
		trans_data	<=	'0';
		SBUS_done	<=	'0';
		MBUS_req	<=	'0';
		SBUS_wait	<=	'1';
		
		CASE	P_S	IS
			WHEN	idle	=>	IF SBUS_CS = '1'	THEN	N_S <= load;	ELSE N_S <=	idle;	END IF;
			WHEN	load	=>								N_S <= ld_cmp;
			WHEN	ld_cmp	=>								N_S <= acc;
			WHEN	acc		=>	IF MBUS_grant = '1'	THEN	N_S <= tra;		ELSE N_S <=	acc;	END IF;
			WHEN	tra		=>	IF MBUS_done = '1'	THEN	N_S <= tr_cmp1;	ELSE N_S <=	tra;	END IF;
			WHEN	tr_cmp1	=>								N_S <= tr_cmp2;
			WHEN	tr_cmp2	=>								N_S <= tr_cmp3;
			WHEN	tr_cmp3	=>								N_S <= idle;
			END CASE;
		
		CASE	P_S	IS
			WHEN	idle	=>	SBUS_done	<=	'1';
			WHEN	load	=>	load_SS		<=	'1';
								load_MS		<=	'1';
			--WHEN	tlb		=>	load_MS		<=	'1';
			WHEN	ld_cmp	=>	SBUS_done	<=	'0';
			WHEN	acc		=>	MBUS_req	<=	'1';
			WHEN	tra		=>	trans_data	<=	'1';
								MBUS_req	<=	'1';
								SBUS_wait	<=	MBUS_wait;
			WHEN	tr_cmp1	=>	SBUS_done	<=	'1';
			WHEN	tr_cmp2	=>	SBUS_done	<=	'1';
			WHEN	tr_cmp3	=>	SBUS_done	<=	'1';
			END CASE;
		
	END PROCESS;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	SBUS_SD_out		<=	MBUS_MD_in		WHEN	trans_data = '1' ELSE (OTHERS => '0');
	SBUS_SD_out_rdy	<=	MBUS_MD_in_rdy	WHEN	trans_data = '1' ELSE '0';
	
	MBUS_MD_out		<=	SBUS_SD_in		WHEN	trans_data = '1' ELSE (OTHERS => '0');
	MBUS_MD_out_rdy	<=	SBUS_SD_in_rdy	WHEN	trans_data = '1' ELSE '0';
	
	MBUS_read		<=	MReg_read;
	MBUS_write		<=	MReg_write;
	MBUS_Add		<=	MReg_Add;
	MBUS_Cnt		<=	MReg_Cnt;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
end Behavioral;

