library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.my_pack_v2.ALL;
USE IEEE.math_real.ALL;

entity SIM_SYSTEM is 
	--GENERIC();
end SIM_SYSTEM;
 
architecture Behavioral of SIM_SYSTEM is
	--------------------------------------------------------------------------
	--		CONSTANTs
	--------------------------------------------------------------------------
	CONSTANT	clk_per					:	TIME	:=	10 NS;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		COMPONENTS
	--------------------------------------------------------------------------
	COMPONENT	SYSTEM
	GENERIC(
		DNoC_BASE_ADDRESS				:	INTEGER			:=	my_to_uint(X"00000000"));
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		
		--	CONFIG
		ACCELERATOR_CONNECT				:	OUT	std_logic;
		
		
		--	Tx line
		Rx_Rx							:	IN	std_logic;
		Tx_Tx							:	OUT	std_logic;
		
		--	NoC
		------	DRAM MEMORY NoC
		DNoC_PORT_clk					:	IN	std_logic;
		DNoC_PORT_Dot_Rdy				:	OUT	std_logic;
		DNoC_PORT_SEL_This				:	OUT	std_logic;
		DNoC_PORT_Address				:	IN	std_logic_vector(31	DOWNTO	0);
		DNoC_PORT_Data_in				:	IN	std_logic_vector(31	DOWNTO	0);
		DNoC_PORT_WEN					:	IN	std_logic;
		DNoC_PORT_OEN					:	IN	std_logic;
		DNoC_PORT_Data_out				:	OUT	std_logic_vector(31	DOWNTO	0);
		------	CONTROL
		RUN_SYS_ALLOW					:	IN	std_logic;
		INT_REQ_SYS_PC					:	IN	std_logic;
		INT_ACK_SYS_PC					:	OUT	std_logic;
		
		
		--	To Vault Controller 
		--	OCM	Memory	(to out of chip memory controller)
		------	Out Gate	to Memory Controller Unit
		OGM_2VCU_req					:	OUT	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);
		OGM_2VCU_grant					:	IN	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);
		OGM_2VCU_done					:	IN	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);
		OGM_2VCU_wait					:	IN	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);
		OGM_2VCU_read					:	OUT	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);
		OGM_2VCU_write					:	OUT	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);
		OGM_2VCU_Add					:	OUT	Unc_2D_P_Addr_array	(3	DOWNTO	0,	3	DOWNTO 0);
		OGM_2VCU_Cnt					:	OUT	Unc_2D_P_Cont_array	(3	DOWNTO	0,	3	DOWNTO 0);
		OGM_2VCU_MD_in					:	IN	Unc_2D_P_Data_array	(3	DOWNTO	0,	3	DOWNTO 0);
		OGM_2VCU_MD_in_rdy				:	IN	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);
		OGM_2VCU_MD_out					:	OUT	Unc_2D_P_Data_array	(3	DOWNTO	0,	3	DOWNTO 0);
		OGM_2VCU_MD_out_rdy				:	OUT	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0));
	END	COMPONENT;
	--------------------------------------------------------------------------
	COMPONENT	Semi_serializer
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
	END	COMPONENT;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		SIGNALS
	--------------------------------------------------------------------------
	SIGNAL	clk							:	std_logic;
	SIGNAL	rst							:	std_logic;
	SIGNAL	Rx_Rx						:	std_logic	:=	'1';
	SIGNAL	Tx_Tx						:	std_logic;
	SIGNAL	ACCELERATOR_CONNECT			:	std_logic;
	SIGNAL	DNoC_PORT_clk				:	std_logic;
	SIGNAL	DNoC_PORT_Dot_Rdy			:	std_logic;
	SIGNAL	DNoC_PORT_SEL_This			:	std_logic;
	SIGNAL	DNoC_PORT_Address			:	std_logic_vector(31	DOWNTO	0);
	SIGNAL	DNoC_PORT_Data_in			:	std_logic_vector(31	DOWNTO	0);
	SIGNAL	DNoC_PORT_WEN				:	std_logic;
	SIGNAL	DNoC_PORT_OEN				:	std_logic;
	SIGNAL	DNoC_PORT_Data_out			:	std_logic_vector(31	DOWNTO	0);
	SIGNAL	RUN_SYS_ALLOW				:	std_logic;
	SIGNAL	INT_REQ_SYS_PC				:	std_logic;
	SIGNAL	INT_ACK_SYS_PC				:	std_logic;
	SIGNAL	OGM_2VCU_req				:	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);
	SIGNAL	OGM_2VCU_grant				:	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);
	SIGNAL	OGM_2VCU_done				:	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);
	SIGNAL	OGM_2VCU_wait				:	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);
	SIGNAL	OGM_2VCU_read				:	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);
	SIGNAL	OGM_2VCU_write				:	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);
	SIGNAL	OGM_2VCU_Add				:	Unc_2D_P_Addr_array	(3	DOWNTO	0,	3	DOWNTO 0);
	SIGNAL	OGM_2VCU_Cnt				:	Unc_2D_P_Cont_array	(3	DOWNTO	0,	3	DOWNTO 0);
	SIGNAL	OGM_2VCU_MD_in				:	Unc_2D_P_Data_array	(3	DOWNTO	0,	3	DOWNTO 0);
	SIGNAL	OGM_2VCU_MD_in_rdy			:	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);
	SIGNAL	OGM_2VCU_MD_out				:	Unc_2D_P_Data_array	(3	DOWNTO	0,	3	DOWNTO 0);
	SIGNAL	OGM_2VCU_MD_out_rdy			:	Unc_2D_array		(3	DOWNTO	0,	3	DOWNTO 0);
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
BEGIN
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	UUT									:	SYSTEM
	GENERIC	MAP(
		DNoC_BASE_ADDRESS				=>	my_to_uint(X"00000000"))
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		--	CONFIG
		ACCELERATOR_CONNECT				=>	ACCELERATOR_CONNECT,
		--	Tx line
		Rx_Rx							=>	Rx_Rx,
		Tx_Tx							=>	Tx_Tx,
		--	NoC
		------	DRAM MEMORY NoC
		DNoC_PORT_clk					=>	DNoC_PORT_clk,
		DNoC_PORT_Dot_Rdy				=>	DNoC_PORT_Dot_Rdy,
		DNoC_PORT_SEL_This				=>	DNoC_PORT_SEL_This,
		DNoC_PORT_Address				=>	DNoC_PORT_Address,
		DNoC_PORT_Data_in				=>	DNoC_PORT_Data_in,
		DNoC_PORT_WEN					=>	DNoC_PORT_WEN,
		DNoC_PORT_OEN					=>	DNoC_PORT_OEN,
		DNoC_PORT_Data_out				=>	DNoC_PORT_Data_out,
		------	CONTROL
		RUN_SYS_ALLOW					=>	RUN_SYS_ALLOW,
		INT_REQ_SYS_PC					=>	INT_REQ_SYS_PC,
		INT_ACK_SYS_PC					=>	INT_ACK_SYS_PC,
		--	To Vault Controller
		OGM_2VCU_req					=>	OGM_2VCU_req,
		OGM_2VCU_grant					=>	OGM_2VCU_grant,
		OGM_2VCU_done					=>	OGM_2VCU_done,
		OGM_2VCU_wait					=>	OGM_2VCU_wait,
		OGM_2VCU_read					=>	OGM_2VCU_read,
		OGM_2VCU_write					=>	OGM_2VCU_write,
		OGM_2VCU_Add					=>	OGM_2VCU_Add,
		OGM_2VCU_Cnt					=>	OGM_2VCU_Cnt,
		OGM_2VCU_MD_in					=>	OGM_2VCU_MD_out,
		OGM_2VCU_MD_in_rdy				=>	OGM_2VCU_MD_out_rdy,
		OGM_2VCU_MD_out					=>	OGM_2VCU_MD_in,
		OGM_2VCU_MD_out_rdy				=>	OGM_2VCU_MD_in_rdy);
	--------------------------------------------------------------------------
	SEMI_SERIALIZER_GEN_ROW				:	FOR	r	IN	3	DOWNTO	0	GENERATE
		SEMI_SERIALIZER_GEN_COL			:	FOR	c	IN	3	DOWNTO	0	GENERATE
			semi_ser					:	Semi_serializer
			GENERIC	MAP(
				BASE_ADDRESS			=>	1,
				ENDx_ADDRESS			=>	1,
				handler_id				=>	4*r+c)
			PORT	MAP(
				clk						=>	clk,
				rst						=>	rst,
				--	To Vault Controller 
				--	OCM	Memory	(to out of chip memory controller)
				------	Out Gate	to Memory Controller Unit
				OGM_2VCU_req			=>	OGM_2VCU_req			(r,c),
				OGM_2VCU_grant			=>	OGM_2VCU_grant			(r,c),
				OGM_2VCU_done			=>	OGM_2VCU_done			(r,c),
				OGM_2VCU_wait			=>	OGM_2VCU_wait			(r,c),
				OGM_2VCU_read			=>	OGM_2VCU_read			(r,c),
				OGM_2VCU_write			=>	OGM_2VCU_write			(r,c),
				OGM_2VCU_Add			=>	OGM_2VCU_Add			(r,c),
				OGM_2VCU_Cnt			=>	OGM_2VCU_Cnt			(r,c),
				OGM_2VCU_MD_in			=>	OGM_2VCU_MD_in			(r,c),
				OGM_2VCU_MD_in_rdy		=>	OGM_2VCU_MD_in_rdy		(r,c),
				OGM_2VCU_MD_out			=>	OGM_2VCU_MD_out			(r,c),
				OGM_2VCU_MD_out_rdy		=>	OGM_2VCU_MD_out_rdy		(r,c));
		END GENERATE;
	END GENERATE;
	--------------------------------------------------------------------------
	PROCESS
	BEGIN
		clk	<=	'0';
		WAIT FOR clk_per/2;
		clk	<=	'1';
		WAIT FOR clk_per/2;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS
	BEGIN
		rst					<=	'1';
		WAIT FOR 5 * clk_per;
		rst					<=	'0';
		WAIT;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS
	BEGIN
		RUN_SYS_ALLOW		<=	'0';
		WAIT FOR 10 * clk_per;
		RUN_SYS_ALLOW		<=	'1';
		WAIT;
	END PROCESS;
	--------------------------------------------------------------------------
	DNoC_PORT_clk			<=	clk;	--:	IN	std_logic;
	DNoC_PORT_WEN			<=	'0';
	DNoC_PORT_OEN			<=	'0';
	DNoC_PORT_Address		<=	(OTHERS	=>	'0');
	DNoC_PORT_Data_in		<=	(OTHERS	=>	'0');
	--------------------------------------------------------------------------
	PROCESS
	BEGIN
		INT_REQ_SYS_PC		<=	'0';
		WAIT FOR 20 US;
		INT_REQ_SYS_PC		<=	'1';
		WAIT ON	 INT_ACK_SYS_PC;
		WAIT FOR clk_per;
		INT_REQ_SYS_PC		<=	'0';
		WAIT;
	END PROCESS;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
END Behavioral;