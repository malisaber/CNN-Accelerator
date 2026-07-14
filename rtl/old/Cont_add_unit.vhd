library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.my_pack_v2.ALL;

entity Cont_add_unit is
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		
		--		high level controller
		start							:	IN	std_logic;
		done							:	OUT	std_logic;
		Bank_inc_Rs						:	IN	std_logic_vector(2 DOWNTO 0);
		CNT_PEs_PAUSE					:	IN	std_logic;
		
		--		Config bits
		Maxs							:	IN	MAX_vals;
		CNF_FSM_sel						:	IN	std_logic_vector(1	DOWNTO 0);
		
		--		Data flow control
		CMD_STA_ACK						:	IN	std_logic;
		pipo_ready						:	IN	std_logic;
		Bank_inc_in						:	IN	std_logic;
		GBank_inc_in					:	IN	std_logic;
		all_updated						:	IN	std_logic;
		clr_flag						:	OUT	std_logic;
		Bank_inc_out					:	OUT	std_logic;
		GBank_inc_out					:	OUT	std_logic;
		Bank_add_R1						:	OUT	std_logic_vector(3 DOWNTO 0);
		Bank_add_R2						:	OUT	std_logic_vector(3 DOWNTO 0);
		Bank_add_R3						:	OUT	std_logic_vector(3 DOWNTO 0);
		
		
		--		inter Bank communication
		Inter_GBM_sig					:	OUT	inter_GBM_com);
end Cont_add_unit;

architecture Behavioral of Cont_add_unit is
	
	COMPONENT	Controller_v4 is
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		--	Config Signals
		CNF_FSM_sel						:	IN	std_logic_vector(1	DOWNTO 0);
		--	Status Signals
		start							:	IN	std_logic;
		CNT_PEs_PAUSE					:	IN	std_logic;
		Zpad_eq							:	IN	std_logic;
		Kern_eq							:	IN	std_logic;
		Colm_eq							:	IN	std_logic;
		Chan_eq							:	IN	std_logic;
		Rows_eq							:	IN	std_logic;
		Cntr_eq							:	IN	std_logic;
		GBMs_eq							:	IN	std_logic;
		all_updated						:	IN	std_logic;
		CMD_STA_ACK						:	IN	std_logic;
		pipo_ready						:	IN	std_logic;
		--	Control Signals
		ini								:	OUT	std_logic;
		Zpad_inc						:	OUT	std_logic;
		Kern_inc						:	OUT	std_logic;
		Colm_inc						:	OUT	std_logic;
		Chan_inc						:	OUT	std_logic;
		Rows_inc						:	OUT	std_logic;
		Cntr_inc						:	OUT	std_logic;
		Bank_inc_all					:	OUT	std_logic;
		GBMs_inc						:	OUT	std_logic;
		SHR_enable						:	OUT	std_logic;
		SHR_clear						:	OUT	std_logic;
		PIPR_enable						:	OUT	std_logic;
		OBUF_set						:	OUT	std_logic;
		OBUF_clr						:	OUT	std_logic;
		inject_zero						:	OUT	std_logic;
		swap_ifm						:	OUT	std_logic;
		clr_flag						:	OUT	std_logic;
		PingPong						:	OUT	std_logic;
		SA_start						:	OUT	std_logic;
		done							:	OUT	std_logic);
	END COMPONENT;
	
	
	COMPONENT	address_gen is
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		ini								:	IN	std_logic;
		Zpad_Max						:	IN	std_logic_vector(P_Pad_size-1 DOWNTO 0);
		Zpad_inc						:	IN	std_logic;
		Zpad_val						:	OUT	std_logic_vector(P_Pad_size-1 DOWNTO 0);
		Zpad_eq							:	OUT	std_logic;
		Kern_Max						:	IN	std_logic_vector(P_kernel_size-1 DOWNTO 0);
		Kern_inc						:	IN	std_logic;
		Kern_val						:	OUT	std_logic_vector(P_kernel_size-1 DOWNTO 0);
		Kern_eq							:	OUT	std_logic;
		Colm_Max						:	IN	std_logic_vector(P_column_size-1 DOWNTO 0);
		Colm_inc						:	IN	std_logic;
		Colm_val						:	OUT	std_logic_vector(P_column_size-1 DOWNTO 0);
		Colm_eq							:	OUT	std_logic;
		Chan_Max						:	IN	std_logic_vector(P_channel_size-1 DOWNTO 0);
		Chan_inc						:	IN	std_logic;
		Chan_val						:	OUT	std_logic_vector(P_channel_size-1 DOWNTO 0);
		Chan_eq							:	OUT	std_logic;
		Rows_Max						:	IN	std_logic_vector(P_Row_size-1 DOWNTO 0);
		Rows_inc						:	IN	std_logic;
		Rows_val						:	OUT	std_logic_vector(P_Row_size-1 DOWNTO 0);
		Rows_eq							:	OUT	std_logic;
		Cntr_Max						:	IN	std_logic_vector(P_in_cntr_size-1 DOWNTO 0);
		Cntr_inc						:	IN	std_logic;
		Cntr_eq							:	OUT	std_logic;
		Bank_min						:	IN	std_logic_vector(3 DOWNTO 0);
		Bank_max						:	IN	std_logic_vector(3 DOWNTO 0);
		Bank_inc_all					:	IN	std_logic;
		Bank_inc_R1						:	IN	std_logic;
		Bank_inc_R2						:	IN	std_logic;
		Bank_inc_R3						:	IN	std_logic;
		Bank_add_R1						:	OUT	std_logic_vector(3 DOWNTO 0);
		Bank_add_R2						:	OUT	std_logic_vector(3 DOWNTO 0);
		Bank_add_R3						:	OUT	std_logic_vector(3 DOWNTO 0);
		GBMs_Min						:	IN	std_logic_vector(1 DOWNTO 0);
		GBMs_Max						:	IN	std_logic_vector(1 DOWNTO 0);
		GBMs_inc						:	IN	std_logic;
		GBMs_val						:	OUT	std_logic_vector(1 DOWNTO 0);
		GBMs_eq							:	OUT	std_logic);
	END COMPONENT;
	
	
	SIGNAL	Zpad_val					:	std_logic_vector(P_Pad_size-1 DOWNTO 0);
	SIGNAL	Kern_val					:	std_logic_vector(P_kernel_size-1 DOWNTO 0);
	SIGNAL	Colm_val					:	std_logic_vector(P_column_size-1 DOWNTO 0);
	SIGNAL	Chan_val					:	std_logic_vector(P_channel_size-1 DOWNTO 0);
	SIGNAL	Rows_val					:	std_logic_vector(P_Row_size-1 DOWNTO 0);
	SIGNAL	GBMs_val					:	std_logic_vector(1 DOWNTO 0);
	
	SIGNAL	Zpad_inc					:	std_logic;
	SIGNAL	Kern_inc					:	std_logic;
	SIGNAL	Colm_inc					:	std_logic;
	SIGNAL	Chan_inc					:	std_logic;
	SIGNAL	Rows_inc					:	std_logic;
	SIGNAL	Cntr_inc					:	std_logic;
	SIGNAL	GBMs_inc					:	std_logic;
	
	SIGNAL	Zpad_eq						:	std_logic;
	SIGNAL	Kern_eq						:	std_logic;
	SIGNAL	Colm_eq						:	std_logic;
	SIGNAL	Chan_eq						:	std_logic;
	SIGNAL	Rows_eq						:	std_logic;
	SIGNAL	Cntr_eq						:	std_logic;
	SIGNAL	GBMs_eq						:	std_logic;
	
	SIGNAL	Bank_inc_all:	std_logic;
	SIGNAL	Bank_inc_tmp:	std_logic;
	SIGNAL	GB_inc_tmp					:	std_logic;
	SIGNAL	init						:	std_logic;
	
	SIGNAL	cont_add					:	PE_cont_add_type;
	
	SIGNAL	OB_update					:	std_logic;
	SIGNAL	OBUF_set					:	std_logic;
	SIGNAL	OBUF_clr					:	std_logic;
begin
	
	Inter_GBM_sig.GBank_add				<=	GBMs_val;
	
	
	Inter_GBM_sig.IFM_add				<=	Chan_val & Colm_val;
	cont_add.WFM_add					<=	Chan_val & Kern_val;
	cont_add.OFM_add					<=	Kern_val & Colm_val;
	Inter_GBM_sig.PEs_cont_add			<=	cont_add;
	
	Cont								:	Controller_v4
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		--	Config Signals
		CNF_FSM_sel						=>	CNF_FSM_sel,
		--	Status Signals
		start							=>	start,
		CNT_PEs_PAUSE					=>	CNT_PEs_PAUSE,
		Zpad_eq							=>	Zpad_eq,
		Kern_eq							=>	Kern_eq,
		Colm_eq							=>	Colm_eq,
		Chan_eq							=>	Chan_eq,
		Rows_eq							=>	Rows_eq,
		Cntr_eq							=>	Cntr_eq,
		GBMs_eq							=>	GBMs_eq,
		all_updated						=>	all_updated,
		CMD_STA_ACK						=>	CMD_STA_ACK,
		pipo_ready						=>	pipo_ready,
		--	Control Signals
		ini								=>	init,
		Zpad_inc						=>	Zpad_inc,
		Kern_inc						=>	Kern_inc,
		Colm_inc						=>	Colm_inc,
		Chan_inc						=>	Chan_inc,
		Rows_inc						=>	Rows_inc,
		Cntr_inc						=>	Cntr_inc,
		Bank_inc_all					=>	Bank_inc_all,
		GBMs_inc						=>	GBMs_inc,
		SHR_enable						=>	cont_add.SHR_enable,
		SHR_clear						=>	cont_add.SHR_clear,
		PIPR_enable						=>	cont_add.PIPR_enable,
		OBUF_set						=>	OBUF_set,
		OBUF_clr						=>	OBUF_clr,
		inject_zero						=>	cont_add.inject_zero,
		swap_ifm						=>	cont_add.swap_ifm,
		clr_flag						=>	clr_flag,
		PingPong						=>	cont_add.PingPong,
		SA_start						=>	cont_add.SA_start,
		done							=>	done);
	
	
	add_gen								:	address_gen
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		ini								=>	init,
		Zpad_Max						=>	Maxs.Zpad_Max,
		Zpad_inc						=>	Zpad_inc,
		Zpad_val						=>	Zpad_val,
		Zpad_eq							=>	Zpad_eq,
		Kern_Max						=>	Maxs.Kern_Max,
		Kern_inc						=>	Kern_inc,
		Kern_val						=>	Kern_val,
		Kern_eq							=>	Kern_eq,
		Colm_Max						=>	Maxs.Colm_Max,
		Colm_inc						=>	Colm_inc,
		Colm_val						=>	Colm_val,
		Colm_eq							=>	Colm_eq,
		Chan_Max						=>	Maxs.Chan_Max,
		Chan_inc						=>	Chan_inc,
		Chan_val						=>	Chan_val,
		Chan_eq							=>	Chan_eq,
		Rows_Max						=>	"1111", --Maxs.Rows_Max,
		Rows_inc						=>	Rows_inc,
		Rows_val						=>	Rows_val,
		Rows_eq							=>	Rows_eq,
		Cntr_Max						=>	"1111", --Maxs.Cntr_Max,
		Cntr_inc						=>	Cntr_inc,
		Cntr_eq							=>	Cntr_eq,
		Bank_min						=>	"1111", --Maxs.Bank_min,
		Bank_max						=>	"1111", --Maxs.Bank_max,
		Bank_inc_all					=>	Bank_inc_tmp,
		Bank_inc_R1						=>	Bank_inc_Rs(0),
		Bank_inc_R2						=>	Bank_inc_Rs(1),
		Bank_inc_R3						=>	Bank_inc_Rs(2),
		Bank_add_R1						=>	Bank_add_R1,
		Bank_add_R2						=>	Bank_add_R2,
		Bank_add_R3						=>	Bank_add_R3,
		GBMs_Min						=>	"11", --Maxs.GBMs_Min,
		GBMs_Max						=>	"11", --Maxs.GBMs_Max,
		GBMs_inc						=>	GB_inc_tmp,
		GBMs_val						=>	GBMs_val,
		GBMs_eq							=>	GBMs_eq);
	
	
	Bank_inc_tmp						<=	Bank_inc_all OR Bank_inc_in;
	Bank_inc_out						<=	Bank_inc_all;
	GBank_inc_out						<=	GBMs_inc;
	GB_inc_tmp							<=	GBMs_inc OR GBank_inc_in;
	
	
	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			OB_update					<=	'0';
		ELSIF clk = '1' AND clk'EVENT THEN
			IF init = '1' THEN
				OB_update				<=	'0';
			ELSIF OBUF_set = '1' THEN
				OB_update				<=	'1';
			ELSIF OBUF_clr = '1' THEN
				OB_update				<=	'0';
			END IF;
		END IF;
	END PROCESS;
	cont_add.OB_update					<=	OB_update;
	
	
end Behavioral;









