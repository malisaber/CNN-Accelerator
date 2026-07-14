library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.math_real.ALL;
USE work.my_pack_v2.ALL;

entity SEMI_Mem_IF is
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		
		BUS_CS							:	IN	std_logic;
		BUS_done						:	OUT	std_logic;
		BUS_wait						:	OUT	std_logic;
		BUS_read						:	IN	std_logic;
		BUS_write						:	IN	std_logic;
		BUS_Add							:	IN	std_logic_vector(P_Phy_Add_size-1	DOWNTO 0);
		BUS_Cnt							:	IN	std_logic_vector(P_Phy_Cnt_size-1	DOWNTO 0);
		BUS_SD_out						:	OUT	std_logic_vector(P_word_size-1		DOWNTO 0);
		BUS_SD_out_rdy					:	OUT	std_logic;
		BUS_SD_in						:	IN	std_logic_vector(P_word_size-1		DOWNTO 0);
		BUS_SD_in_rdy					:	IN	std_logic;
		
		MEM_Add							:	OUT	std_logic_vector(P_Phy_Add_size-1	DOWNTO 0);
		MEM_wen							:	OUT	std_logic;
		MEM_Din							:	IN	std_logic_vector(P_word_size-1 DOWNTO 0);
		MEM_Dout						:	OUT	std_logic_vector(P_word_size-1 DOWNTO 0));
end SEMI_Mem_IF;

architecture Behavioral of SEMI_Mem_IF is
	
	TYPE	FSM							IS	(idle, LD, mem, comp);
	
	SIGNAL	P_S							:	FSM;
	SIGNAL	N_S							:	FSM;
	
	SIGNAL	Addr						:	std_logic_vector(P_Phy_Add_size-1	DOWNTO 0);
	SIGNAL	Cntr						:	std_logic_vector(P_Phy_Cnt_size		DOWNTO 0);
	SIGNAL	load						:	std_logic;
	SIGNAL	cnt							:	std_logic;
	SIGNAL	eq							:	std_logic;
	
	SIGNAL	SDout_rdy					:	std_logic;
	
begin
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			P_S							<=	idle;
		ELSIF clk = '1' AND clk'EVENT THEN
			P_S							<=	N_S;
		END IF;
	END PROCESS;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	PROCESS (P_S, BUS_CS, eq, BUS_read, BUS_write, BUS_SD_in_rdy)
	BEGIN
		BUS_done						<=	'0';
		load							<=	'0';
		cnt								<=	'0';
		SDout_rdy						<=	'0';
		BUS_wait						<=	'1';
		MEM_wen							<=	'0';
		CASE P_S IS
			WHEN	idle				=>	IF BUS_CS = '1' THEN	N_S		<=	LD;		ELSE	N_S <=	idle;			END IF;
			WHEN	LD					=>							N_S		<=	mem;					
			WHEN	mem					=>	IF eq = '1' 	THEN	N_S		<=	comp;	ELSE	N_S <=	mem;			END IF;
			WHEN	comp				=>	IF BUS_CS = '1' THEN	N_S		<=	comp;	ELSE	N_S	<=	idle;			END IF;
		END CASE;			
					
		CASE P_S IS			
			WHEN	idle				=>	BUS_done						<=	'1';
			WHEN	LD					=>	load							<=	'1';
			WHEN	mem					=>	SDout_rdy						<=	BUS_read;
											BUS_wait						<=	'0';
											IF BUS_read	= '1' THEN	cnt		<=	'1';	ELSE	cnt	<=	BUS_SD_in_rdy;	EnD IF;
											MEM_wen							<=	BUS_write AND BUS_SD_in_rdy;
			WHEN	comp				=>	BUS_done						<=	'1';
		END CASE;
	END PROCESS;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			BUS_SD_out_rdy				<=	'0';
			BUS_SD_out					<=	(OTHERS	=>	'0');
		ELSIF clk = '1' AND clk'EVENT THEN
			BUS_SD_out_rdy				<=	SDout_rdy;
			BUS_SD_out					<=	MEM_Din;
		END IF;
	END PROCESS;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			Addr						<=	(OTHERS => '0');
			cntr						<=	(OTHERS => '0');
		ELSIF CLK = '1' AND clk'EVENT THEN
			IF load = '1' THEN
				Addr					<=	BUS_Add;
				cntr					<=	std_logic_vector(UNSIGNED('0' & BUS_Cnt)	+ 1);	
			ELSIF cnt = '1' THEN	
				Addr					<=	std_logic_vector(UNSIGNED(Addr)				+ 1);
				cntr					<=	std_logic_vector(UNSIGNED(cntr)				- 1);
			END IF;
		END IF;
	END PROCESS;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	eq									<=	'1'	WHEN	UNSIGNED(cntr) = 1 ELSE '0'; 
	MEM_Dout							<=	BUS_SD_in;
	MEM_Add								<=	Addr;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
end Behavioral;
