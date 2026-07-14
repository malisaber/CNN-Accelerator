library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.my_pack_v2.ALL;

entity BM_selector is
	PORT(
		Row1_sel		:	IN	std_logic_vector(3 DOWNTO 0);
		Row2_sel		:	IN	std_logic_vector(3 DOWNTO 0);
		Row3_sel		:	IN	std_logic_vector(3 DOWNTO 0);
		
		All_Bank_data	:	IN	All_bank_data_type;
		All_Bank_stat	:	IN	All_bank_1b_type;
		
		BM_Dout			:	OUT	PE_IFM_data;
		BM_redy			:	OUT	std_logic);
end BM_selector;

architecture Behavioral of BM_selector is
	
	SIGNAL	Row_1_rdy	:	std_logic;
	SIGNAL	Row_2_rdy	:	std_logic;
	SIGNAL	Row_3_rdy	:	std_logic;
	
begin
	
	PROCESS (	All_Bank_data(0),	All_Bank_data(4),	All_Bank_data(8),	All_Bank_data(12),
				All_Bank_data(1),	All_Bank_data(5),	All_Bank_data(9),	All_Bank_data(13),
				All_Bank_data(2),	All_Bank_data(6),	All_Bank_data(10),	All_Bank_data(14),
				All_Bank_data(3),	All_Bank_data(7),	All_Bank_data(11),	All_Bank_data(15),
				All_Bank_stat(0),	All_Bank_stat(4),	All_Bank_stat(8),	All_Bank_stat(12),
				All_Bank_stat(1),	All_Bank_stat(5),	All_Bank_stat(9),	All_Bank_stat(13),
				All_Bank_stat(2),	All_Bank_stat(6),	All_Bank_stat(10),	All_Bank_stat(14),
				All_Bank_stat(3),	All_Bank_stat(7),	All_Bank_stat(11),	All_Bank_stat(15),
				Row1_sel,			Row2_sel,			Row3_sel)
	BEGIN
		
		CASE Row1_sel IS
			WHEN	"0000"	=>	BM_Dout.Row1	<=	All_Bank_data(0);
								Row_1_rdy		<=	All_Bank_stat(0);
			WHEN	"0001"	=>	BM_Dout.Row1	<=	All_Bank_data(1);
								Row_1_rdy		<=	All_Bank_stat(1);
			WHEN	"0010"	=>	BM_Dout.Row1	<=	All_Bank_data(2);
								Row_1_rdy		<=	All_Bank_stat(2);
			WHEN	"0011"	=>	BM_Dout.Row1	<=	All_Bank_data(3);
								Row_1_rdy		<=	All_Bank_stat(3);
			WHEN	"0100"	=>	BM_Dout.Row1	<=	All_Bank_data(4);
								Row_1_rdy		<=	All_Bank_stat(4);
			WHEN	"0101"	=>	BM_Dout.Row1	<=	All_Bank_data(5);
								Row_1_rdy		<=	All_Bank_stat(5);
			WHEN	"0110"	=>	BM_Dout.Row1	<=	All_Bank_data(6);
								Row_1_rdy		<=	All_Bank_stat(6);
			WHEN	"0111"	=>	BM_Dout.Row1	<=	All_Bank_data(7);
								Row_1_rdy		<=	All_Bank_stat(7);
			WHEN	"1000"	=>	BM_Dout.Row1	<=	All_Bank_data(8);
								Row_1_rdy		<=	All_Bank_stat(8);
			WHEN	"1001"	=>	BM_Dout.Row1	<=	All_Bank_data(9);
								Row_1_rdy		<=	All_Bank_stat(9);
			WHEN	"1010"	=>	BM_Dout.Row1	<=	All_Bank_data(10);
								Row_1_rdy		<=	All_Bank_stat(10);
			WHEN	"1011"	=>	BM_Dout.Row1	<=	All_Bank_data(11);
								Row_1_rdy		<=	All_Bank_stat(11);
			WHEN	"1100"	=>	BM_Dout.Row1	<=	All_Bank_data(12);
								Row_1_rdy		<=	All_Bank_stat(12);
			WHEN	"1101"	=>	BM_Dout.Row1	<=	All_Bank_data(13);
								Row_1_rdy		<=	All_Bank_stat(13);
			WHEN	"1110"	=>	BM_Dout.Row1	<=	All_Bank_data(14);
								Row_1_rdy		<=	All_Bank_stat(14);
			WHEN	"1111"	=>	BM_Dout.Row1	<=	All_Bank_data(15);
								Row_1_rdy		<=	All_Bank_stat(15);
			WHEN	OTHERS	=>	BM_Dout.Row1	<=	All_Bank_data(0);
								Row_1_rdy		<=	All_Bank_stat(0);
		END CASE;
		
		CASE Row2_sel IS
			WHEN	"0000"	=>	BM_Dout.Row2	<=	All_Bank_data(0);
								Row_2_rdy		<=	All_Bank_stat(0);
			WHEN	"0001"	=>	BM_Dout.Row2	<=	All_Bank_data(1);
								Row_2_rdy		<=	All_Bank_stat(1);
			WHEN	"0010"	=>	BM_Dout.Row2	<=	All_Bank_data(2);
								Row_2_rdy		<=	All_Bank_stat(2);
			WHEN	"0011"	=>	BM_Dout.Row2	<=	All_Bank_data(3);
								Row_2_rdy		<=	All_Bank_stat(3);
			WHEN	"0100"	=>	BM_Dout.Row2	<=	All_Bank_data(4);
								Row_2_rdy		<=	All_Bank_stat(4);
			WHEN	"0101"	=>	BM_Dout.Row2	<=	All_Bank_data(5);
								Row_2_rdy		<=	All_Bank_stat(5);
			WHEN	"0110"	=>	BM_Dout.Row2	<=	All_Bank_data(6);
								Row_2_rdy		<=	All_Bank_stat(6);
			WHEN	"0111"	=>	BM_Dout.Row2	<=	All_Bank_data(7);
								Row_2_rdy		<=	All_Bank_stat(7);
			WHEN	"1000"	=>	BM_Dout.Row2	<=	All_Bank_data(8);
								Row_2_rdy		<=	All_Bank_stat(8);
			WHEN	"1001"	=>	BM_Dout.Row2	<=	All_Bank_data(9);
								Row_2_rdy		<=	All_Bank_stat(9);
			WHEN	"1010"	=>	BM_Dout.Row2	<=	All_Bank_data(10);
								Row_2_rdy		<=	All_Bank_stat(10);
			WHEN	"1011"	=>	BM_Dout.Row2	<=	All_Bank_data(11);
								Row_2_rdy		<=	All_Bank_stat(11);
			WHEN	"1100"	=>	BM_Dout.Row2	<=	All_Bank_data(12);
								Row_2_rdy		<=	All_Bank_stat(12);
			WHEN	"1101"	=>	BM_Dout.Row2	<=	All_Bank_data(13);
								Row_2_rdy		<=	All_Bank_stat(13);
			WHEN	"1110"	=>	BM_Dout.Row2	<=	All_Bank_data(14);
								Row_2_rdy		<=	All_Bank_stat(14);
			WHEN	"1111"	=>	BM_Dout.Row2	<=	All_Bank_data(15);
								Row_2_rdy		<=	All_Bank_stat(15);
			WHEN	OTHERS	=>	BM_Dout.Row2	<=	All_Bank_data(0);
								Row_2_rdy		<=	All_Bank_stat(0);
		END CASE;
		
		CASE Row3_sel IS
			WHEN	"0000"	=>	BM_Dout.Row3	<=	All_Bank_data(0);
								Row_3_rdy		<=	All_Bank_stat(0);
			WHEN	"0001"	=>	BM_Dout.Row3	<=	All_Bank_data(1);
								Row_3_rdy		<=	All_Bank_stat(1);
			WHEN	"0010"	=>	BM_Dout.Row3	<=	All_Bank_data(2);
								Row_3_rdy		<=	All_Bank_stat(2);
			WHEN	"0011"	=>	BM_Dout.Row3	<=	All_Bank_data(3);
								Row_3_rdy		<=	All_Bank_stat(3);
			WHEN	"0100"	=>	BM_Dout.Row3	<=	All_Bank_data(4);
								Row_3_rdy		<=	All_Bank_stat(4);
			WHEN	"0101"	=>	BM_Dout.Row3	<=	All_Bank_data(5);
								Row_3_rdy		<=	All_Bank_stat(5);
			WHEN	"0110"	=>	BM_Dout.Row3	<=	All_Bank_data(6);
								Row_3_rdy		<=	All_Bank_stat(6);
			WHEN	"0111"	=>	BM_Dout.Row3	<=	All_Bank_data(7);
								Row_3_rdy		<=	All_Bank_stat(7);
			WHEN	"1000"	=>	BM_Dout.Row3	<=	All_Bank_data(8);
								Row_3_rdy		<=	All_Bank_stat(8);
			WHEN	"1001"	=>	BM_Dout.Row3	<=	All_Bank_data(9);
								Row_3_rdy		<=	All_Bank_stat(9);
			WHEN	"1010"	=>	BM_Dout.Row3	<=	All_Bank_data(10);
								Row_3_rdy		<=	All_Bank_stat(10);
			WHEN	"1011"	=>	BM_Dout.Row3	<=	All_Bank_data(11);
								Row_3_rdy		<=	All_Bank_stat(11);
			WHEN	"1100"	=>	BM_Dout.Row3	<=	All_Bank_data(12);
								Row_3_rdy		<=	All_Bank_stat(12);
			WHEN	"1101"	=>	BM_Dout.Row3	<=	All_Bank_data(13);
								Row_3_rdy		<=	All_Bank_stat(13);
			WHEN	"1110"	=>	BM_Dout.Row3	<=	All_Bank_data(14);
								Row_3_rdy		<=	All_Bank_stat(14);
			WHEN	"1111"	=>	BM_Dout.Row3	<=	All_Bank_data(15);
								Row_3_rdy		<=	All_Bank_stat(15);
			WHEN	OTHERS	=>	BM_Dout.Row3	<=	All_Bank_data(0);
								Row_3_rdy		<=	All_Bank_stat(0);
		END CASE;
		
	END PROCESS;
	
	BM_redy		<=	Row_1_rdy AND Row_2_rdy AND Row_3_rdy;
	
end Behavioral;

