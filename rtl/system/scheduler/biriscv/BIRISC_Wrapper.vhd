library IEEE;
use IEEE.std_logic_1164.ALL;
USE work.my_pack_v2.ALL;


entity BIRISC_Wrapper is
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		
		--	Interrupt Port
        INT_REQ							:	IN	std_logic;
        INT_ACK							:	OUT	std_logic;
		
		--	Memory Interface
		MAIN_PORT_MEM_Rdy				:	IN	std_logic;
		MAIN_PORT_DIN_Rdy				:	IN	std_logic;
		MAIN_PORT_Address				:	OUT	std_logic_vector(31	DOWNTO	0);
		MAIN_PORT_Data_in				:	IN	std_logic_vector(31	DOWNTO	0);
		MAIN_PORT_WEN					:	OUT	std_logic;
		MAIN_PORT_OEN					:	OUT	std_logic;
		MAIN_PORT_Data_out				:	OUT	std_logic_vector(31	DOWNTO	0);
		--	uProcessor PORT
		uPROC_PORT_rd					:	OUT	std_logic;
		uPROC_PORT_flush				:	OUT	std_logic;
		uPROC_PORT_invalidate			:	OUT	std_logic;
		uPROC_PORT_valid				:	IN	std_logic;
		uPROC_PORT_error				:	IN	std_logic;
		uPROC_PORT_accept				:	IN	std_logic;
		uPROC_PORT_Address				:	OUT	std_logic_vector(31	DOWNTO	0);
		uPROC_PORT_Data_out				:	IN	std_logic_vector(63	DOWNTO	0));
end BIRISC_Wrapper;
 
architecture Behavioral of BIRISC_Wrapper is
	------------------------------------------------------------------------
	--	COMPONENTS
	------------------------------------------------------------------------
	COMPONENT	riscv_core
	GENERIC(
		SUPPORT_BRANCH_PREDICTION		:	INTEGER	:=	P_Birisc_param.SUPPORT_BRANCH_PREDICTION;
		SUPPORT_MULDIV					:	INTEGER	:=	P_Birisc_param.SUPPORT_MULDIV;
		SUPPORT_SUPER					:	INTEGER	:=	P_Birisc_param.SUPPORT_SUPER;
		SUPPORT_MMU						:	INTEGER	:=	P_Birisc_param.SUPPORT_MMU;
		SUPPORT_DUAL_ISSUE				:	INTEGER	:=	P_Birisc_param.SUPPORT_DUAL_ISSUE;
		SUPPORT_LOAD_BYPASS				:	INTEGER	:=	P_Birisc_param.SUPPORT_LOAD_BYPASS;
		SUPPORT_MUL_BYPASS				:	INTEGER	:=	P_Birisc_param.SUPPORT_MUL_BYPASS;
		SUPPORT_REGFILE_XILINX			:	INTEGER	:=	P_Birisc_param.SUPPORT_REGFILE_XILINX;
		EXTRA_DECODE_STAGE				:	INTEGER	:=	P_Birisc_param.EXTRA_DECODE_STAGE;
		MEM_CACHE_ADDR_MIN				:	INTEGER	:=	P_Birisc_param.MEM_CACHE_ADDR_MIN;
		MEM_CACHE_ADDR_MAX				:	INTEGER	:=	P_Birisc_param.MEM_CACHE_ADDR_MAX;
		NUM_BTB_ENTRIES					:	INTEGER	:=	P_Birisc_param.NUM_BTB_ENTRIES;
		NUM_BTB_ENTRIES_W				:	INTEGER	:=	P_Birisc_param.NUM_BTB_ENTRIES_W;
		NUM_BHT_ENTRIES					:	INTEGER	:=	P_Birisc_param.NUM_BHT_ENTRIES;
		NUM_BHT_ENTRIES_W				:	INTEGER	:=	P_Birisc_param.NUM_BHT_ENTRIES_W;
		RAS_ENABLE						:	INTEGER	:=	P_Birisc_param.RAS_ENABLE;
		GSHARE_ENABLE					:	INTEGER	:=	P_Birisc_param.GSHARE_ENABLE;
		BHT_ENABLE						:	INTEGER	:=	P_Birisc_param.BHT_ENABLE;
		NUM_RAS_ENTRIES					:	INTEGER	:=	P_Birisc_param.NUM_RAS_ENTRIES;
		NUM_RAS_ENTRIES_W				:	INTEGER	:=	P_Birisc_param.NUM_RAS_ENTRIES_W);
	PORT(
		clk_i							:	IN	std_logic;
		rst_i							:	IN	std_logic;
		intr_i							:	IN	std_logic;
		reset_vector_i					:	IN	std_logic_vector(31	DOWNTO	0);
		cpu_id_i						:	IN	std_logic_vector(31	DOWNTO	0);
		--	Data Mem
		mem_d_data_rd_i					:	IN	std_logic_vector(31	DOWNTO	0);
		mem_d_accept_i					:	IN	std_logic;
		mem_d_ack_i						:	IN	std_logic;
		mem_d_error_i					:	IN	std_logic;
		mem_d_resp_tag_i				:	IN	std_logic_vector(10	DOWNTO	0);
		mem_d_addr_o					:	OUT	std_logic_vector(31	DOWNTO	0);
		mem_d_data_wr_o					:	OUT	std_logic_vector(31	DOWNTO	0);
		mem_d_rd_o						:	OUT	std_logic;
		mem_d_wr_o						:	OUT	std_logic_vector(3	DOWNTO	0);
		mem_d_cacheable_o				:	OUT	std_logic;
		mem_d_req_tag_o					:	OUT	std_logic_vector(10	DOWNTO	0);
		mem_d_invalidate_o				:	OUT	std_logic;
		mem_d_writeback_o				:	OUT	std_logic;
		mem_d_flush_o					:	OUT	std_logic;
		--	Inst Mem
		mem_i_accept_i					:	IN	std_logic;
		mem_i_valid_i					:	IN	std_logic;
		mem_i_error_i					:	IN	std_logic;
		mem_i_inst_i					:	IN	std_logic_vector(63	DOWNTO	0);
		mem_i_rd_o						:	OUT	std_logic;
		mem_i_flush_o					:	OUT	std_logic;
		mem_i_invalidate_o				:	OUT	std_logic;
		mem_i_pc_o						:	OUT	std_logic_vector(31	DOWNTO	0));
	END	COMPONENT;
	------------------------------------------------------------------------
	COMPONENT	uPROC_Port_Tracker
	PORT(
		clk								:	IN	std_logic;
		uPROC_PORT_Address				:	IN	std_logic_vector(31	DOWNTO	0);
		uPROC_PORT_Data_out				:	IN	std_logic_vector(63	DOWNTO	0));
	END	COMPONENT;
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	--	SIGNALs
	------------------------------------------------------------------------
	SIGNAL	MAIN_PORT_WEN_4x			:	std_logic_vector(3	DOWNTO	0);
	SIGNAL	MAIN_PORT_OEN_tmp			:	std_logic;
	SIGNAL	MAIN_PORT_Data_in_regd		:	std_logic_vector(31	DOWNTO	0);
	------------------------------------------------------------------------
	SIGNAL	mem_d_accept				:	std_logic;
	SIGNAL	mem_d_ack					:	std_logic;
	SIGNAL	mem_d_error					:	std_logic;
	SIGNAL	mem_d_resp_tag				:	std_logic_vector(10	DOWNTO	0);
	SIGNAL	mem_d_cacheable				:	std_logic;
	SIGNAL	mem_d_req_tag				:	std_logic_vector(10	DOWNTO	0);
	SIGNAL	mem_d_invalidate			:	std_logic;
	SIGNAL	mem_d_writeback				:	std_logic;
	SIGNAL	mem_d_flush					:	std_logic;
	------------------------------------------------------------------------
	SIGNAL	mem_d_ack_q					:	std_logic;
	SIGNAL	mem_d_tag_q					:	std_logic_vector(10	DOWNTO	0);
	SIGNAL	cond						:	std_logic;
	SIGNAL	mem_d_wr_cond				:	std_logic;
	------------------------------------------------------------------------
	SIGNAL	uPROC_T_PORT_rd				:	std_logic;
	SIGNAL	uPROC_T_PORT_flush			:	std_logic;
	SIGNAL	uPROC_T_PORT_invalidate		:	std_logic;
	SIGNAL	uPROC_T_PORT_valid			:	std_logic;
	SIGNAL	uPROC_T_PORT_error			:	std_logic;
	SIGNAL	uPROC_T_PORT_accept			:	std_logic;
	SIGNAL	uPROC_T_PORT_Address		:	std_logic_vector(31	DOWNTO	0);
	SIGNAL	uPROC_T_PORT_Data_out		:	std_logic_vector(63	DOWNTO	0);
	------------------------------------------------------------------------
	------------------------------------------------------------------------
begin
	------------------------------------------------------------------------
	--	INSTANCEs
	------------------------------------------------------------------------
	RISC_V_core							:	riscv_core
	GENERIC	MAP(
		SUPPORT_BRANCH_PREDICTION		=>	P_Birisc_param.SUPPORT_BRANCH_PREDICTION,
		SUPPORT_MULDIV					=>	P_Birisc_param.SUPPORT_MULDIV,
		SUPPORT_SUPER					=>	P_Birisc_param.SUPPORT_SUPER,
		SUPPORT_MMU						=>	P_Birisc_param.SUPPORT_MMU,
		SUPPORT_DUAL_ISSUE				=>	P_Birisc_param.SUPPORT_DUAL_ISSUE,
		SUPPORT_LOAD_BYPASS				=>	P_Birisc_param.SUPPORT_LOAD_BYPASS,
		SUPPORT_MUL_BYPASS				=>	P_Birisc_param.SUPPORT_MUL_BYPASS,
		SUPPORT_REGFILE_XILINX			=>	P_Birisc_param.SUPPORT_REGFILE_XILINX,
		EXTRA_DECODE_STAGE				=>	P_Birisc_param.EXTRA_DECODE_STAGE,
		MEM_CACHE_ADDR_MIN				=>	P_Birisc_param.MEM_CACHE_ADDR_MIN,
		MEM_CACHE_ADDR_MAX				=>	P_Birisc_param.MEM_CACHE_ADDR_MAX,
		NUM_BTB_ENTRIES					=>	P_Birisc_param.NUM_BTB_ENTRIES,
		NUM_BTB_ENTRIES_W				=>	P_Birisc_param.NUM_BTB_ENTRIES_W,
		NUM_BHT_ENTRIES					=>	P_Birisc_param.NUM_BHT_ENTRIES,
		NUM_BHT_ENTRIES_W				=>	P_Birisc_param.NUM_BHT_ENTRIES_W,
		RAS_ENABLE						=>	P_Birisc_param.RAS_ENABLE,
		GSHARE_ENABLE					=>	P_Birisc_param.GSHARE_ENABLE,
		BHT_ENABLE						=>	P_Birisc_param.BHT_ENABLE,
		NUM_RAS_ENTRIES					=>	P_Birisc_param.NUM_RAS_ENTRIES,
		NUM_RAS_ENTRIES_W				=>	P_Birisc_param.NUM_RAS_ENTRIES_W)
	PORT	MAP(
		clk_i							=>	clk,
		rst_i							=>	rst,
		intr_i							=>	INT_REQ,
		reset_vector_i					=>	X"00000000",
		cpu_id_i						=>	X"00000000",
		--	Data Mem
		mem_d_data_rd_i					=>	MAIN_PORT_Data_in_regd,
		mem_d_accept_i					=>	mem_d_accept,
		mem_d_ack_i						=>	mem_d_ack,
		mem_d_error_i					=>	mem_d_error,
		mem_d_resp_tag_i				=>	mem_d_resp_tag,
		mem_d_addr_o					=>	MAIN_PORT_Address,
		mem_d_data_wr_o					=>	MAIN_PORT_Data_out,
		mem_d_rd_o						=>	MAIN_PORT_OEN_tmp,
		mem_d_wr_o						=>	MAIN_PORT_WEN_4x,
		mem_d_cacheable_o				=>	mem_d_cacheable,
		mem_d_req_tag_o					=>	mem_d_req_tag,
		mem_d_invalidate_o				=>	mem_d_invalidate,
		mem_d_writeback_o				=>	mem_d_writeback,
		mem_d_flush_o					=>	mem_d_flush,
		--	Inst Mem
		mem_i_accept_i					=>	uPROC_T_PORT_accept,
		mem_i_valid_i					=>	uPROC_T_PORT_valid,
		mem_i_error_i					=>	uPROC_T_PORT_error,
		mem_i_inst_i					=>	uPROC_T_PORT_Data_out,
		mem_i_rd_o						=>	uPROC_T_PORT_rd,
		mem_i_flush_o					=>	uPROC_T_PORT_flush,
		mem_i_invalidate_o				=>	uPROC_T_PORT_invalidate,
		mem_i_pc_o						=>	uPROC_T_PORT_Address);
	------------------------------------------------------------------------
	uPROC_Tracker						:	uPROC_Port_Tracker
	PORT	MAP(
		clk								=>	clk,
		uPROC_PORT_Address				=>	uPROC_T_PORT_Address,
		uPROC_PORT_Data_out				=>	uPROC_T_PORT_Data_out);
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	uPROC_T_PORT_accept					<=	uPROC_PORT_accept;
	uPROC_T_PORT_valid					<=	uPROC_PORT_valid;
	uPROC_T_PORT_error					<=	uPROC_PORT_error;
	uPROC_T_PORT_Data_out				<=	uPROC_PORT_Data_out;
	uPROC_PORT_rd						<=	uPROC_T_PORT_rd;
	uPROC_PORT_flush					<=	uPROC_T_PORT_flush;
	uPROC_PORT_invalidate				<=	uPROC_T_PORT_invalidate;
	uPROC_PORT_Address					<=	uPROC_T_PORT_Address;
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	mem_d_accept						<=	'1';
	mem_d_ack							<=	mem_d_ack_q;
	mem_d_error							<=	'0';
	mem_d_resp_tag						<=	mem_d_tag_q;
	MAIN_PORT_WEN						<=	MAIN_PORT_WEN_4x(3)	OR	MAIN_PORT_WEN_4x(2)	OR	MAIN_PORT_WEN_4x(1)	OR	MAIN_PORT_WEN_4x(0);
	MAIN_PORT_OEN						<=	MAIN_PORT_OEN_tmp;
	INT_ACK								<=	'0';
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	PROCESS(clk, rst)
	BEGIN
		IF rst = '1' THEN
			mem_d_ack_q					<=	'0';
			mem_d_tag_q					<=	(OTHERS	=>	'0');
			MAIN_PORT_Data_in_regd		<=	(OTHERS	=>	'0');
		ELSIF clk = '1' AND clk'EVENT THEN
			MAIN_PORT_Data_in_regd		<=	MAIN_PORT_Data_in;
			IF cond = '1'	THEN
				mem_d_ack_q				<=	'1';
				mem_d_tag_q				<=	mem_d_req_tag;
			ELSE
				mem_d_ack_q				<=	'0';
			END IF;
		END IF;
	END PROCESS;
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	mem_d_wr_cond						<=	MAIN_PORT_WEN_4x(3)	OR	MAIN_PORT_WEN_4x(2)	OR	MAIN_PORT_WEN_4x(1)	OR	MAIN_PORT_WEN_4x(0);
	cond								<=	(MAIN_PORT_OEN_tmp OR mem_d_wr_cond OR mem_d_flush OR mem_d_invalidate OR mem_d_writeback) AND mem_d_accept;
	------------------------------------------------------------------------
	------------------------------------------------------------------------
end Behavioral;

