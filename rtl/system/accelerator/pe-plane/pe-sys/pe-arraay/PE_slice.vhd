library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.math_real.ALL;
USE work.my_pack_v2.ALL;

entity PE_slice is
	GENERIC(
		ifm_wfm							:	INTEGER	:=	1;
		row_pos							:	INTEGER	:=	1;
		col_pos							:	INTEGER	:=	1);
	PORT(				
		clk								:	IN	std_logic;
		clk_w							:	IN	std_logic;
		rst								:	IN	std_logic;
		
		--		Config bit
		PEs_CFB							:	IN	PEs_config_bit;
		
		--		Data from Data provider
		PEs_CA							:	IN	PE_cont_add_type;
		PEs_Di							:	IN	PE_IFM_data;
		PEs_Do							:	OUT	PE_IFM_data;
		
		--		Low Level Memory
		WGT_wen							:	IN	std_logic_3X3;
		WGT_Data						:	IN	WB_Low_level_mem;
		
		--		High Level Cont
		OFM_add							:	IN	std_logic_vector(P_OFM_Add_size-1 DOWNTO 0);
		OFM_data						:	OUT	std_logic_vector(P_word_size-1 DOWNTO 0);
		pipo_ready						:	OUT	std_logic;
		SA_Start						:	OUT	std_logic;
		SA_ACK							:	IN	std_logic);
	end PE_slice;

architecture Behavioral of PE_slice is
	
	COMPONENT	dataPath_v3
	PORT( 
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		mul_in1_NS						:	IN	std_logic;
		mul_in2_NS						:	IN	std_logic;
		op_half_size					:	IN	std_logic;
		Shift_cnt						:	IN	std_logic_vector(P_shift_cnt-1 DOWNTO 0);
		SHR_enable						:	IN	std_logic;
		SHR_clear						:	IN	std_logic;
		PIPR_enable						:	IN	std_logic;
		OB_update						:	IN	std_logic;
		OB_wen							:	OUT	std_logic;
		ROW_Din							:	IN	PE_IFM_data;
		WGT_Din							:	IN	PE_WGT_data;
		OB_Din							:	IN	std_logic_vector(P_word_size-1 DOWNTO 0);
		ROW_Dout						:	OUT	PE_IFM_data;
		OB_Dout							:	OUT	std_logic_vector(P_word_size-1 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT	CH_buffer
	GENERIC(
		ifm_wfm							:	INTEGER	:=	0;
		row_pos							:	INTEGER	:=	0;
		col_pos							:	INTEGER	:=	0;
		wid_pos							:	INTEGER	:=	0;
		word_size						:	INTEGER	:=	8;
		depth							:	INTEGER	:=	16);
	PORT(               				
		clk								:	IN	std_logic;
		clk_w							:	IN	std_logic;
		rst								:	IN	std_logic;
		wen								:	IN	std_logic;
		read_add						:	IN	std_logic_vector(integer(ceil(log2(real(depth))))-1 DOWNTO 0);
		write_add						:	IN	std_logic_vector(integer(ceil(log2(real(depth))))-1 DOWNTO 0);
		data_in							:	IN	std_logic_vector(word_size-1 DOWNTO 0);
		data_out						:	OUT	std_logic_vector(word_size-1 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT	OCH_buffer
	GENERIC(
		row_pos							:	INTEGER	:=	0;
		col_pos							:	INTEGER	:=	0;
		ping_pong						:	INTEGER	:=	0;
		word_size						:	INTEGER	:=	8;
		depth							:	INTEGER	:=	16);
	PORT(               				
		clk								:	IN	std_logic;
		wen								:	IN	std_logic;
		read_add_1						:	IN	std_logic_vector(integer(ceil(log2(real(depth))))-1 DOWNTO 0);
		read_add_2						:	IN	std_logic_vector(integer(ceil(log2(real(depth))))-1 DOWNTO 0);
		write_add						:	IN	std_logic_vector(integer(ceil(log2(real(depth))))-1 DOWNTO 0);
		data_in							:	IN	std_logic_vector(word_size-1 DOWNTO 0);
		data_out_1						:	OUT	std_logic_vector(word_size-1 DOWNTO 0);
		data_out_2						:	OUT	std_logic_vector(word_size-1 DOWNTO 0));
	END COMPONENT;      				
	
	SIGNAL	IFM_Raw						:	PE_IFM_data;
	SIGNAL	IFM_data					:	PE_IFM_data;
	SIGNAL	WFM_data					:	PE_WGT_data;
	SIGNAL	OB_wen						:	std_logic;
	SIGNAL	OB_wen_Ping					:	std_logic;
	SIGNAL	OB_wen_Pong					:	std_logic;
	SIGNAL	OB_add_R					:	std_logic_vector(P_OFM_Add_size-1 DOWNTO 0);
	SIGNAL	OB_add_RR					:	std_logic_vector(P_OFM_Add_size-1 DOWNTO 0);
	SIGNAL	OB_add_RRR					:	std_logic_vector(P_OFM_Add_size-1 DOWNTO 0);
	SIGNAL	OB_Wdata					:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	OB_Rdata_Pi					:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	OB_Rdata_Po					:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	OB_Rdata					:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	OB_Rdata_R					:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	OB_Rdata_RR					:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	OFM_data_Pi					:	std_logic_vector(P_word_size-1 DOWNTO 0);
	SIGNAL	OFM_data_Po					:	std_logic_vector(P_word_size-1 DOWNTO 0);
	
	
	SIGNAL	Ping						:	std_logic;
	SIGNAL	Pong						:	std_logic;
	SIGNAL	Ping_R						:	std_logic;
	SIGNAL	Pong_R						:	std_logic;
	SIGNAL	Ping_RR						:	std_logic;
	SIGNAL	Pong_RR						:	std_logic;
	
	SIGNAL	Ping_full					:	std_logic;
	SIGNAL	Pong_full					:	std_logic;
	
	SIGNAL	SA_Start_R					:	std_logic;
	
	
	SIGNAL	PEs_CA_reg					:	PE_cont_add_type;
	
	
	
begin
	-------------------------------------------------------------------
	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' then
			PEs_CA_reg.SHR_enable		<=	'0';
			PEs_CA_reg.SHR_clear		<=	'0';
			PEs_CA_reg.PIPR_enable		<=	'0';
			PEs_CA_reg.OB_update		<=	'0';
			PEs_CA_reg.inject_zero		<=	'0';
			PEs_CA_reg.swap_ifm			<=	'0';
		ELSIF clk = '1' AND clk'EVENT then
			PEs_CA_reg.SHR_enable		<=	PEs_CA.SHR_enable	;
			PEs_CA_reg.SHR_clear		<=	PEs_CA.SHR_clear	;
			PEs_CA_reg.PIPR_enable		<=	PEs_CA.PIPR_enable	;
			PEs_CA_reg.OB_update		<=	PEs_CA.OB_update	;
			PEs_CA_reg.inject_zero		<=	PEs_CA.inject_zero	;
			PEs_CA_reg.swap_ifm			<=	PEs_CA.swap_ifm		;
		END IF;
	END PROCESS;
	PEs_CA_reg.WFM_add					<=	PEs_CA.WFM_add;
	PEs_CA_reg.OFM_add					<=	PEs_CA.OFM_add;
	-------------------------------------------------------------------
	IFM_Raw								<=	PE_IFM_data_0	WHEN PEs_CA_reg.inject_zero	= '1' ELSE PEs_Di;
	IFM_data.Row1						<=	IFM_Raw.Row1	WHEN PEs_CA_reg.swap_ifm	= '0' ELSE (IFM_Raw.Row1(P_word_size/2-1 DOWNTO 0) & IFM_Raw.Row1(P_word_size-1 DOWNTO P_word_size/2));
	IFM_data.Row2						<=	IFM_Raw.Row2	WHEN PEs_CA_reg.swap_ifm	= '0' ELSE (IFM_Raw.Row2(P_word_size/2-1 DOWNTO 0) & IFM_Raw.Row2(P_word_size-1 DOWNTO P_word_size/2));
	IFM_data.Row3						<=	IFM_Raw.Row3	WHEN PEs_CA_reg.swap_ifm	= '0' ELSE (IFM_Raw.Row3(P_word_size/2-1 DOWNTO 0) & IFM_Raw.Row3(P_word_size-1 DOWNTO P_word_size/2));
	-------------------------------------------------------------------
	DP									:	dataPath_v3
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		mul_in1_NS						=>	PEs_CFB.IFM_NS,
		mul_in2_NS						=>	PEs_CFB.WFM_NS,
		op_half_size					=>	PEs_CFB.OP_mode,
		Shift_cnt						=>	PEs_CFB.Shift_cnt,
		SHR_enable						=>	PEs_CA_reg.SHR_enable,
		SHR_clear						=>	PEs_CA_reg.SHR_clear,
		PIPR_enable						=>	PEs_CA_reg.PIPR_enable,
		OB_update						=>	PEs_CA_reg.OB_update,
		OB_wen							=>	OB_wen,
		ROW_Din							=>	IFM_data,
		WGT_Din							=>	WFM_data,
		OB_Din							=>	OB_Rdata_RR,
		ROW_Dout						=>	PEs_Do,
		OB_Dout							=>	OB_Wdata);
	-------------------------------------------------------------------
	Row_WGT_gen							:	FOR r IN 1 TO 3 GENERATE
		Col_WGT_gen						:	FOR c IN 1 TO 3 GENERATE
			WCH_buff_rc					:	CH_buffer
			GENERIC	MAP(    			
				ifm_wfm					=>	ifm_wfm,
				row_pos					=>	row_pos,
				col_pos					=>	col_pos,
				wid_pos					=>	3*(r-1)+c,
				word_size				=>	P_word_size,
				depth					=>	2**P_WFM_Add_size)
			PORT	MAP(    			
				clk						=>	clk,
				clk_w					=>	clk_w,
				rst						=>	rst,
				wen						=>	WGT_wen(r,c),
				read_add				=>	PEs_CA_reg.WFM_add,
				write_add				=>	WGT_Data.Wadd,
				data_in					=>	WGT_Data.Wdata,
				data_out				=>	WFM_data(r,c));
		END GENERATE;
	END GENERATE;
	-------------------------------------------------------------------
	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			OB_add_R					<=	(OTHERS => '0');
			OB_add_RR					<=	(OTHERS => '0');
			OB_add_RRR					<=	(OTHERS => '0');
			OB_Rdata_R					<=	(OTHERS => '0');
			OB_Rdata_RR					<=	(OTHERS => '0');
		ELSIF clk = '1' AND clk'EVENT THEN
			OB_add_R					<=	PEs_CA_reg.OFM_add;
			OB_add_RR					<=	OB_add_R;
			OB_add_RRR					<=	OB_add_RR;
			OB_Rdata_R					<=	OB_Rdata;
			OB_Rdata_RR					<=	OB_Rdata_R;
		END IF;
	END PROCESS;
	-------------------------------------------------------------------
	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			Ping						<=	'1';
			Pong						<=	'0';
			Ping_R						<=	'1';
			Pong_R						<=	'0';
			Ping_RR						<=	'1';
			Pong_RR						<=	'0';
			Ping_full					<=	'0';
			Pong_full					<=	'0';
		ELSIF clk = '1' AND clk'EVENT THEN
			IF SA_ACK	=	'1'			THEN
				IF Ping = '1'			THEN
					Pong_full			<=	'0';
				END IF;
				IF Pong = '1'			THEN
					Ping_full			<=	'0';
				END IF;
			END	IF;
			IF PEs_CA.PingPong = '1' THEN
				Ping					<=	Pong;
				Pong					<=	Ping;
				Ping_full				<=	Ping_full OR Pong;
				Pong_full				<=	Pong_full OR Ping;
			END IF;			
			Ping_R						<=	Pong;
			Pong_R						<=	Ping;
			Ping_RR						<=	Pong_R;
			Pong_RR						<=	Ping_R;
		END IF;
	END PROCESS;
	-------------------------------------------------------------------
	pipo_ready							<=	(Pong AND (NOT Ping_full)) OR (Ping AND (NOT Pong_full));
	-------------------------------------------------------------------
	--	OB_PingPong
	-------------------------------------------------------------------
	OB_wen_Ping							<=	OB_wen AND Ping_RR;
	OCH_buff_Ping						:	OCH_buffer
	GENERIC	MAP(				
		row_pos							=>	row_pos,
		col_pos							=>	col_pos,
		ping_pong						=>	0,
		word_size						=>	P_word_size,
		depth							=>	2**P_OFM_Add_size)
	PORT	MAP(				
		clk								=>	clk,
		wen								=>	OB_wen_Ping,
		write_add						=>	OB_add_RRR,
		read_add_1						=>	PEs_CA_reg.OFM_add,
		read_add_2						=>	OFM_add,
		data_in							=>	OB_Wdata,
		data_out_1						=>	OB_Rdata_Pi,
		data_out_2						=>	OFM_data_Pi);
	-------------------------------------------------------------------
	OB_wen_Pong							<=	OB_wen AND Pong_RR;
	OCH_buff_Pong						:	OCH_buffer
	GENERIC	MAP(				
		row_pos							=>	row_pos,
		col_pos							=>	col_pos,
		ping_pong						=>	1,
		word_size						=>	P_word_size,
		depth							=>	2**P_OFM_Add_size)
	PORT	MAP(				
		clk								=>	clk,
		wen								=>	OB_wen_Pong,
		write_add						=>	OB_add_RRR,
		read_add_1						=>	PEs_CA_reg.OFM_add,
		read_add_2						=>	OFM_add,
		data_in							=>	OB_Wdata,
		data_out_1						=>	OB_Rdata_Po,
		data_out_2						=>	OFM_data_Po);
	
	OB_Rdata							<=	OB_Rdata_Pi WHEN Ping = '1' ELSE OB_Rdata_Po;
	OFM_data							<=	OFM_data_Pi	WHEN Pong = '1' ELSE OFM_data_Po;
	-------------------------------------------------------------------
	PROCESS(clk, rst)
	BEGIN
		IF rst = '1' THEN
			SA_Start_R	<=	'0';
		ELSIF clk = '1' AND clk'EVENT THEN
			SA_Start_R	<=	PEs_CA.SA_start;
		END IF;
	END PROCESS;
	SA_Start	<=	SA_Start_R;
	-------------------------------------------------------------------
end Behavioral;

