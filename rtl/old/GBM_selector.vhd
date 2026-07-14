library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.my_pack_v2.ALL;


entity GBM_selector is
	PORT(
		SRC_Sel_1		:	IN	std_logic_vector(1 DOWNTO 0);
		SRC_Sel_2		:	IN	std_logic_vector(1 DOWNTO 0);
		SRC_Sel_3		:	IN	std_logic_vector(1 DOWNTO 0);
		SRC_Sel_4		:	IN	std_logic_vector(1 DOWNTO 0);
		
		GBM_G1			:	IN	PE_IFM_data;
		GBM_G2			:	IN	PE_IFM_data;
		GBM_G3			:	IN	PE_IFM_data;
		GBM_G4			:	IN	PE_IFM_data;
		
			
		PE_1_Din		:	OUT	PE_IFM_data;
		PE_2_Din		:	OUT	PE_IFM_data;
		PE_3_Din		:	OUT	PE_IFM_data;
		PE_4_Din		:	OUT	PE_IFM_data);
end GBM_selector;

architecture Behavioral of GBM_selector is
begin
	
	PROCESS (	GBM_G1,		GBM_G2,		GBM_G3,		GBM_G4,
				SRC_Sel_1,	SRC_Sel_2,	SRC_Sel_3,	SRC_Sel_4)
	BEGIN
		CASE	SRC_Sel_1	IS 
			WHEN	"00"	=>	PE_1_Din	<=	GBM_G1;
			WHEN	"01"	=>	PE_1_Din	<=	GBM_G2;
			WHEN	"10"	=>	PE_1_Din	<=	GBM_G3;
			WHEN	"11"	=>	PE_1_Din	<=	GBM_G4;
			WHEN	OTHERS	=>	PE_1_Din	<=	GBM_G1;
		END CASE;
		
		CASE	SRC_Sel_2	IS 
			WHEN	"00"	=>	PE_2_Din	<=	GBM_G1;
			WHEN	"01"	=>	PE_2_Din	<=	GBM_G2;
			WHEN	"10"	=>	PE_2_Din	<=	GBM_G3;
			WHEN	"11"	=>	PE_2_Din	<=	GBM_G4;
			WHEN	OTHERS	=>	PE_2_Din	<=	GBM_G1;
		END CASE;
		
		CASE	SRC_Sel_3	IS 
			WHEN	"00"	=>	PE_3_Din	<=	GBM_G1;
			WHEN	"01"	=>	PE_3_Din	<=	GBM_G2;
			WHEN	"10"	=>	PE_3_Din	<=	GBM_G3;
			WHEN	"11"	=>	PE_3_Din	<=	GBM_G4;
			WHEN	OTHERS	=>	PE_3_Din	<=	GBM_G1;
		END CASE;
		
		CASE	SRC_Sel_4	IS 
			WHEN	"00"	=>	PE_4_Din	<=	GBM_G1;
			WHEN	"01"	=>	PE_4_Din	<=	GBM_G2;
			WHEN	"10"	=>	PE_4_Din	<=	GBM_G3;
			WHEN	"11"	=>	PE_4_Din	<=	GBM_G4;
			WHEN	OTHERS	=>	PE_4_Din	<=	GBM_G1;
		END CASE;
		
		
	END PROCESS;
	
		
end Behavioral;

