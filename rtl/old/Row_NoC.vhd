library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.my_pack_v2.ALL;

entity Row_NoC is
	PORT(
		PE1_Source		:	IN	std_logic;
		PE2_Source		:	IN	std_logic;
		PE3_Source		:	IN	std_logic;
		PE4_Source		:	IN	std_logic;
		
		PE1_Mem_data	:	IN	PE_IFM_data;
		PE2_Mem_data	:	IN	PE_IFM_data;
		PE3_Mem_data	:	IN	PE_IFM_data;
		PE4_Mem_data	:	IN	PE_IFM_data;
		
		PE1_Dout		:	IN	PE_IFM_data;
		PE2_Dout		:	IN	PE_IFM_data;
		PE3_Dout		:	IN	PE_IFM_data;
		PE4_Dout		:	IN	PE_IFM_data;
		
		PE1_Din			:	OUT	PE_IFM_data;
		PE2_Din			:	OUT	PE_IFM_data;
		PE3_Din			:	OUT	PE_IFM_data;
		PE4_Din			:	OUT	PE_IFM_data);
end Row_NoC;

architecture Behavioral of Row_NoC is
begin
	
	PE4_Din	<=	PE3_Dout WHEN PE4_Source = '1' ELSE PE4_Mem_data;
	PE3_Din	<=	PE2_Dout WHEN PE3_Source = '1' ELSE PE3_Mem_data;
	PE2_Din	<=	PE1_Dout WHEN PE2_Source = '1' ELSE PE2_Mem_data;
	PE1_Din	<=	PE4_Dout WHEN PE1_Source = '1' ELSE PE1_Mem_data;
	
end Behavioral;

