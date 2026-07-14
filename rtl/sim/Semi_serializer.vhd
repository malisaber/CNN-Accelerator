library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.my_pack_v2.ALL;
USE IEEE.math_real.ALL;

entity Semi_serializer is 
	GENERIC(
		BASE_ADDRESS					:	INTEGER			:=	my_to_uint(X"00000000");
		ENDx_ADDRESS					:	INTEGER			:=	my_to_uint(X"00000000");
		handler_id						:	INTEGER			:=	0);
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		--	To Vault Controller 
		--	OCM	Memory	(to out of chip memory controller)
		------	Out Gate	to Memory Controller Unit
		OGM_2VCU_req					:	IN	std_logic;
		OGM_2VCU_grant					:	OUT	std_logic;
		OGM_2VCU_done					:	OUT	std_logic;
		OGM_2VCU_wait					:	OUT	std_logic;
		OGM_2VCU_read					:	IN	std_logic;
		OGM_2VCU_write					:	IN	std_logic;
		OGM_2VCU_Add					:	IN	std_logic_vector(P_Phy_Add_size-1	DOWNTO 0);
		OGM_2VCU_Cnt					:	IN	std_logic_vector(P_Phy_Cnt_size-1	DOWNTO 0);
		OGM_2VCU_MD_in					:	IN	std_logic_vector(P_word_size-1		DOWNTO 0);
		OGM_2VCU_MD_in_rdy				:	IN	std_logic;
		OGM_2VCU_MD_out					:	OUT	std_logic_vector(P_word_size-1		DOWNTO 0);
		OGM_2VCU_MD_out_rdy				:	OUT	std_logic);
end Semi_serializer;
 
architecture Behavioral of Semi_serializer is
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--	COMPONENTS
	--------------------------------------------------------------------------
	COMPONENT	SEMI_Mem_IF
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
	END	COMPONENT;
	--------------------------------------------------------------------------
	COMPONENT	FILE_IO_Handler	
	GENERIC(
		per_file_width					:	INTEGER	:=	10;
		handler_id						:	INTEGER	:=	0);
	PORT(
		clk								:	IN	std_logic;
		cs								:	IN	std_logic;
		MEM_Add							:	IN	std_logic_vector(P_Phy_Add_size-1	DOWNTO 0);
		MEM_wen							:	IN	std_logic;
		MEM_Din							:	IN	std_logic_vector(P_word_size-1		DOWNTO 0);
		MEM_Dout						:	OUT	std_logic_vector(P_word_size-1		DOWNTO 0));
	END	COMPONENT;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--	SIGNALs
	--------------------------------------------------------------------------
	SIGNAL	MEM_Add						:	std_logic_vector(P_Phy_Add_size-1		DOWNTO 0);
	SIGNAL	MEM_wen						:	std_logic;
	SIGNAL	MEM_Din						:	std_logic_vector(P_word_size-1			DOWNTO 0);
	SIGNAL	MEM_Dout					:	std_logic_vector(P_word_size-1			DOWNTO 0);
	SIGNAL	OGM_2VCU_MD_out_temp		:	std_logic_vector(P_word_size-1			DOWNTO 0);
	SIGNAL	OGM_2VCU_MD_out_rdy_tmp		:	std_logic;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
begin
	--------------------------------------------------------------------------
	--	INSTANCEs
	--------------------------------------------------------------------------
	mem_if								:	SEMI_Mem_IF
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		--	BUS	
		BUS_CS							=>	OGM_2VCU_req,
		BUS_done						=>	OGM_2VCU_done,
		BUS_wait						=>	OGM_2VCU_wait,
		BUS_read						=>	OGM_2VCU_read,
		BUS_write						=>	OGM_2VCU_write,
		BUS_Add							=>	OGM_2VCU_Add,
		BUS_Cnt							=>	OGM_2VCU_Cnt,
		BUS_SD_out						=>	OGM_2VCU_MD_out_temp,
		BUS_SD_out_rdy					=>	OGM_2VCU_MD_out_rdy_tmp,
		BUS_SD_in						=>	OGM_2VCU_MD_in,
		BUS_SD_in_rdy					=>	OGM_2VCU_MD_in_rdy,
		--	MEM
		MEM_Add							=>	MEM_Add,
		MEM_wen							=>	MEM_wen,
		MEM_Din							=>	MEM_Dout,
		MEM_Dout						=>	MEM_Din);
	--------------------------------------------------------------------------
	FILE_HANDLER						:	FILE_IO_Handler
	GENERIC	MAP(
		per_file_width					=>	8,
		handler_id						=>	handler_id)
	PORT	MAP(
		clk								=>	clk,
		cs								=>	OGM_2VCU_req,
		MEM_Add							=>	MEM_Add,
		MEM_wen							=>	MEM_wen,
		MEM_Din							=>	MEM_Din,
		MEM_Dout						=>	MEM_Dout);
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	OGM_2VCU_grant						<=	OGM_2VCU_req;
	--------------------------------------------------------------------------
	OGM_2VCU_MD_out						<=	OGM_2VCU_MD_out_temp;
	OGM_2VCU_MD_out_rdy					<=	OGM_2VCU_MD_out_rdy_tmp;
	--------------------------------------------------------------------------
end Behavioral;

