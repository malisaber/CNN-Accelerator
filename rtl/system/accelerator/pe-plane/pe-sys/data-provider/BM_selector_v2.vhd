library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.my_pack_v2.ALL;

entity BM_selector_v2 is
	PORT(
		Sel_banks		:	IN	std_logic_vector(1				DOWNTO 0);
		
		Bank_0_data		:	IN	std_logic_vector(P_word_size-1	DOWNTO 0);
		Bank_1_data		:	IN	std_logic_vector(P_word_size-1	DOWNTO 0);
		Bank_2_data		:	IN	std_logic_vector(P_word_size-1	DOWNTO 0);
		Bank_3_data		:	IN	std_logic_vector(P_word_size-1	DOWNTO 0);
		
		clear_Bank		:	IN	std_logic;
		clear_Bank_Enc	:	OUT	std_logic_vector(3				DOWNTO 0);
		
		Bank_stat		:	IN	std_logic_vector(3				DOWNTO 0);
		All_Updated		:	OUT	std_logic;
		
		BM_Dout			:	OUT	PE_IFM_data);
end BM_selector_v2;

architecture Behavioral of BM_selector_v2 is
	
	SIGNAL	Row_1_rdy	:	std_logic;
	SIGNAL	Row_2_rdy	:	std_logic;
	SIGNAL	Row_3_rdy	:	std_logic;
	
begin
	
	PROCESS (	Bank_0_data,	Bank_1_data,	Bank_2_data,	Bank_3_data,
				Sel_banks,		clear_Bank,		Bank_stat)
	BEGIN
		
		
		CASE Sel_banks IS
			WHEN	"00"	=>	clear_Bank_Enc	<=	(clear_Bank & clear_Bank & clear_Bank & clear_Bank) AND "0001";
			WHEN	"01"	=>	clear_Bank_Enc	<=	(clear_Bank & clear_Bank & clear_Bank & clear_Bank) AND "0010";
			WHEN	"10"	=>	clear_Bank_Enc	<=	(clear_Bank & clear_Bank & clear_Bank & clear_Bank) AND "0100";
			WHEN	"11"	=>	clear_Bank_Enc	<=	(clear_Bank & clear_Bank & clear_Bank & clear_Bank) AND "1000";
			WHEN	OTHERS	=>	clear_Bank_Enc	<=	"0000";
		END CASE;
		
		
		
		
		
		
		CASE Sel_banks IS
			WHEN	"00"	=>	BM_Dout.Row1	<=	Bank_0_data;
								Row_1_rdy		<=	Bank_stat(0);
			WHEN	"01"	=>	BM_Dout.Row1	<=	Bank_1_data;
								Row_1_rdy		<=	Bank_stat(1);
			WHEN	"10"	=>	BM_Dout.Row1	<=	Bank_2_data;
								Row_1_rdy		<=	Bank_stat(2);
			WHEN	"11"	=>	BM_Dout.Row1	<=	Bank_3_data;
								Row_1_rdy		<=	Bank_stat(3);
			WHEN	OTHERS	=>	BM_Dout.Row1	<=	Bank_0_data;
								Row_1_rdy		<=	Bank_stat(0);
		END CASE;
		
		
		
		
		
		CASE Sel_banks IS
			WHEN	"00"	=>	BM_Dout.Row2	<=	Bank_1_data;
								Row_2_rdy		<=	Bank_stat(1);
			WHEN	"01"	=>	BM_Dout.Row2	<=	Bank_2_data;
								Row_2_rdy		<=	Bank_stat(2);
			WHEN	"10"	=>	BM_Dout.Row2	<=	Bank_3_data;
								Row_2_rdy		<=	Bank_stat(3);
			WHEN	"11"	=>	BM_Dout.Row2	<=	Bank_0_data;
								Row_2_rdy		<=	Bank_stat(0);
			WHEN	OTHERS	=>	BM_Dout.Row2	<=	Bank_0_data;
								Row_2_rdy		<=	Bank_stat(0);
		END CASE;
		
		
		
		
		
		CASE Sel_banks IS
			WHEN	"00"	=>	BM_Dout.Row3	<=	Bank_2_data;
								Row_2_rdy		<=	Bank_stat(2);
			WHEN	"01"	=>	BM_Dout.Row3	<=	Bank_3_data;
								Row_2_rdy		<=	Bank_stat(3);
			WHEN	"10"	=>	BM_Dout.Row3	<=	Bank_0_data;
								Row_2_rdy		<=	Bank_stat(0);
			WHEN	"11"	=>	BM_Dout.Row3	<=	Bank_1_data;
								Row_2_rdy		<=	Bank_stat(1);
			WHEN	OTHERS	=>	BM_Dout.Row3	<=	Bank_0_data;
								Row_2_rdy		<=	Bank_stat(0);
		END CASE;
		
		
		
		
		
		
	END PROCESS;
	
	All_Updated		<=	Row_1_rdy AND Row_2_rdy AND Row_3_rdy;
	
end Behavioral;

