library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.my_pack_v2.ALL;

entity PEs is
	PORT(
		clk								:	IN	std_logic;
		clk_w							:	IN	std_logic;
		rst								:	IN	std_logic;
		
		--		Config 
		PEs_CFB							:	IN	PEs_config_bit_4X4;
		PEs_SRCs						:	IN	std_logic_4X4;
		
		--		From Data Provider
		PEs_pipo_ready					:	OUT	std_logic_4X4;
		PEs_DCA							:	IN	PEs_DCA_4X4;
		
		--		Low Level Memory
		WB_low_lvl_wen					:	IN	std_logic_4X4of3X3;
		WB_low_lvl_sig					:	IN	WB_Low_level_mem_4X4;
		
		--		High Level Controller
		PEs_OFM_add						:	IN	PEs_OFM_add_4X4;
		PEs_OFM_data					:	OUT	PEs_OFM_data_4X4;
		PEs_SA_start					:	OUT	std_logic_4X4;
		PEs_SA_ACK						:	IN	std_logic_4X4);
end PEs;

architecture Behavioral of PEs is
	
	COMPONENT	PE_slice
	GENERIC(
		ifm_wfm							:	INTEGER	:=	0;
		row_pos							:	INTEGER	:=	0;
		col_pos							:	INTEGER	:=	0);
	PORT(				
		clk								:	IN	std_logic;
		clk_w							:	IN	std_logic;
		rst								:	IN	std_logic;
		PEs_CFB							:	IN	PEs_config_bit;
		PEs_CA							:	IN	PE_cont_add_type;
		PEs_Di							:	IN	PE_IFM_data;
		PEs_Do							:	OUT	PE_IFM_data;
		WGT_wen							:	IN	std_logic_3X3;
		WGT_Data						:	IN	WB_Low_level_mem;
		OFM_add							:	IN	std_logic_vector(P_OFM_Add_size-1 DOWNTO 0);
		OFM_data						:	OUT	std_logic_vector(P_word_size-1 DOWNTO 0);
		pipo_ready						:	OUT	std_logic;
		SA_Start						:	OUT	std_logic;
		SA_ACK							:	IN	std_logic);
	END COMPONENT;
	
	COMPONENT	Row_NoC
	PORT(
		PE1_Source						:	IN	std_logic;
		PE2_Source						:	IN	std_logic;
		PE3_Source						:	IN	std_logic;
		PE4_Source						:	IN	std_logic;
		PE1_Mem_data					:	IN	PE_IFM_data;
		PE2_Mem_data					:	IN	PE_IFM_data;
		PE3_Mem_data					:	IN	PE_IFM_data;
		PE4_Mem_data					:	IN	PE_IFM_data;
		PE1_Dout						:	IN	PE_IFM_data;
		PE2_Dout						:	IN	PE_IFM_data;
		PE3_Dout						:	IN	PE_IFM_data;
		PE4_Dout						:	IN	PE_IFM_data;
		PE1_Din							:	OUT	PE_IFM_data;
		PE2_Din							:	OUT	PE_IFM_data;
		PE3_Din							:	OUT	PE_IFM_data;
		PE4_Din							:	OUT	PE_IFM_data);
	END COMPONENT;
	
	SIGNAL	PE_Data_in					:	PEs_Data_4X4;
	SIGNAL	PE_Data_out					:	PEs_Data_4X4;
	
begin
	
	Row_PEs_Gen							:	FOR r IN 1 TO 4 GENERATE
		Col_PEs_Gen						:	FOR c IN 1 TO 4 GENERATE
			
			PE_Slice_rc					:	PE_slice
			GENERIC	MAP(
				ifm_wfm					=>	1,
				row_pos					=>	r,
				col_pos					=>	c)
			PORT	MAP(		
				clk						=>	clk,
				clk_w					=>	clk_w,
				rst						=>	rst,
				PEs_CFB					=>	PEs_CFB			(r,c),
				PEs_CA					=>	PEs_DCA			(r,c).cont,
				PEs_Di					=>	PE_Data_in		(r,c),
				PEs_Do					=>	PE_Data_out		(r,c),
				WGT_wen					=>	WB_low_lvl_wen	(r,c),
				WGT_Data				=>	WB_low_lvl_sig	(r,c),
				OFM_add					=>	PEs_OFM_add		(r,c),
				OFM_data				=>	PEs_OFM_data	(r,c),
				pipo_ready				=>	PEs_pipo_ready	(r,c),
				SA_Start				=>	PEs_SA_start	(r,c),
				SA_ACK					=>	PEs_SA_ACK		(r,c));
			
		END GENERATE;
		
		Row_NoC_r						:	Row_NoC
		PORT	MAP(		
			PE1_Source					=>	PEs_SRCs		(r,1),
			PE2_Source					=>	PEs_SRCs		(r,2),
			PE3_Source					=>	PEs_SRCs		(r,3),
			PE4_Source					=>	PEs_SRCs		(r,4),
			PE1_Mem_data				=>	PEs_DCA			(r,1).data,
			PE2_Mem_data				=>	PEs_DCA			(r,2).data,
			PE3_Mem_data				=>	PEs_DCA			(r,3).data,
			PE4_Mem_data				=>	PEs_DCA			(r,4).data,
			PE1_Dout					=>	PE_Data_out		(r,1),
			PE2_Dout					=>	PE_Data_out		(r,2),
			PE3_Dout					=>	PE_Data_out		(r,3),
			PE4_Dout					=>	PE_Data_out		(r,4),
			PE1_Din						=>	PE_Data_in		(r,1),
			PE2_Din						=>	PE_Data_in		(r,2),
			PE3_Din						=>	PE_Data_in		(r,3),
			PE4_Din						=>	PE_Data_in		(r,4));
		
	END GENERATE;
	
	
end Behavioral;

