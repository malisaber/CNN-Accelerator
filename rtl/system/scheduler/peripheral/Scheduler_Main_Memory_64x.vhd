 library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.my_pack_v2.ALL;
USE STD.TEXTIO.ALL;

entity Scheduler_Main_Memory_64x is
	GENERIC(
		MAIN_BASE_ADDRESS				:	INTEGER	:=	to_integer(SIGNED(X_check(X"FFFF0000")));
		DNoC_BASE_ADDRESS				:	INTEGER	:=	to_integer(SIGNED(X_check(X"FFFF0000")));
		LINE_COUNT						:	INTEGER	:=	4096);
	PORT(
		--	MAIN PORT
		MAIN_PORT_clk					:	IN	std_logic;
		MAIN_PORT_Dot_Rdy				:	OUT	std_logic;
		MAIN_PORT_SEL_This				:	OUT	std_logic;
		MAIN_PORT_Address				:	IN	std_logic_vector(31	DOWNTO	0);
		MAIN_PORT_Data_in				:	IN	std_logic_vector(31	DOWNTO	0);
		MAIN_PORT_WEN					:	IN	std_logic;
		MAIN_PORT_OEN					:	IN	std_logic;
		MAIN_PORT_Data_out				:	OUT	std_logic_vector(31	DOWNTO	0);
		
		--	DNoC PORT
		DNoC_PORT_clk					:	IN	std_logic;
		DNoC_PORT_Dot_Rdy				:	OUT	std_logic;
		DNoC_PORT_SEL_This				:	OUT	std_logic;
		DNoC_PORT_Address				:	IN	std_logic_vector(31	DOWNTO	0);
		DNoC_PORT_Data_in				:	IN	std_logic_vector(31	DOWNTO	0);
		DNoC_PORT_WEN					:	IN	std_logic;
		DNoC_PORT_OEN					:	IN	std_logic;
		DNoC_PORT_Data_out				:	OUT	std_logic_vector(31	DOWNTO	0);
		
		--	uProcessor PORT
		uPROC_PORT_clk					:	IN	std_logic;
		uPROC_PORT_rst					:	IN	std_logic;
		uPROC_PORT_rd_i					:	IN	std_logic;
		uPROC_PORT_flush_i				:	IN	std_logic;
		uPROC_PORT_invalidate_i			:	IN	std_logic;
		uPROC_PORT_valid_o				:	OUT	std_logic;
		uPROC_PORT_error_o				:	OUT	std_logic;
		uPROC_PORT_accept_o				:	OUT	std_logic;
		uPROC_PORT_Address				:	IN	std_logic_vector(31	DOWNTO	0);
		uPROC_PORT_Data_out				:	OUT	std_logic_vector(63	DOWNTO	0));
end Scheduler_Main_Memory_64x;

architecture Behavioral of Scheduler_Main_Memory_64x is
	--------------------------------------------------------------------------
	--		CONSTANTs
	--------------------------------------------------------------------------
	CONSTANT	NUMB_ints				:	INTEGER	:=	LINE_COUNT;
	CONSTANT	MAIN_ENDx_ADDRESS		:	INTEGER	:=	MAIN_BASE_ADDRESS + 4*NUMB_ints;
	CONSTANT	DNoC_ENDx_ADDRESS		:	INTEGER	:=	DNoC_BASE_ADDRESS + 4*NUMB_ints;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		COMPONENTs
	--------------------------------------------------------------------------
	COMPONENT	Scheduler_mem_core_verilog_64x	
	GENERIC(
		line_count						:	INTEGER	:=	100);
	PORT(
		clk1							:	IN	std_logic;
		addr1							:	IN	std_logic_vector(31	DOWNTO	0);
		data_in1						:	IN	std_logic_vector(31	DOWNTO	0);
		write_enable1					:	IN	std_logic;
		data_out1						:	OUT	std_logic_vector(31	DOWNTO	0);
		
		clk2							:	IN	std_logic;
		addr2							:	IN	std_logic_vector(31	DOWNTO	0);
		data_in2						:	IN	std_logic_vector(31	DOWNTO	0);
		write_enable2					:	IN	std_logic;
		data_out2						:	OUT	std_logic_vector(31	DOWNTO	0);
		
		addr3							:	IN	std_logic_vector(31	DOWNTO	0);
		data_out3						:	OUT	std_logic_vector(63	DOWNTO	0));
	END	COMPONENT;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		SIGNALs
	--------------------------------------------------------------------------
	SIGNAL	EWen_1						:	std_logic;
	SIGNAL	EAdd_1						:	std_logic_vector(31	DOWNTO	0);
	SIGNAL	Dout_1						:	std_logic_vector(31	DOWNTO	0);
	--------------------------------------------------------------------------
	SIGNAL	EWen_2						:	std_logic;
	SIGNAL	EAdd_2						:	std_logic_vector(31	DOWNTO	0);
	SIGNAL	Dout_2						:	std_logic_vector(31	DOWNTO	0);
	--------------------------------------------------------------------------
	SIGNAL	Dout_3						:	std_logic_vector(63	DOWNTO	0);
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
begin
	--------------------------------------------------------------------------
	MEM_CORE							:	Scheduler_mem_core_verilog_64x	
	GENERIC	MAP(
		line_count						=>	LINE_COUNT)
	PORT	MAP(
		clk1							=>	MAIN_PORT_clk,
		addr1							=>	Eadd_1,
		data_in1						=>	MAIN_PORT_Data_in,
		write_enable1					=>	EWen_1,
		data_out1						=>	Dout_1,
		clk2							=>	DNoC_PORT_clk,
		addr2							=>	Eadd_2,
		data_in2						=>	DNoC_PORT_Data_in,
		write_enable2					=>	EWen_2,
		data_out2						=>	Dout_2,
		addr3							=>	uPROC_PORT_Address,
		data_out3						=>	Dout_3);
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	PROCESS(MAIN_PORT_Address, MAIN_PORT_WEN)
		VARIABLE	add					:	INTEGER;
		VARIABLE	Eadd				:	INTEGER;
	BEGIN
		add								:=	to_integer(SIGNED(X_check(MAIN_PORT_Address)));
		IF MAIN_PORT_WEN = '1' AND add  >= MAIN_BASE_ADDRESS AND add < MAIN_ENDx_ADDRESS THEN 
			EWen_1						<=	'1';
		ELSE
			EWen_1						<=	'0';
		END IF;
		--WAIT ON MAIN_PORT_Address, MAIN_PORT_WEN;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS(MAIN_PORT_Address, MAIN_PORT_OEN, Dout_1)
		VARIABLE	add					:	INTEGER;
	BEGIN
		add								:=	to_integer(SIGNED(X_check(MAIN_PORT_Address)));
		IF MAIN_PORT_OEN = '1' AND add  >= MAIN_BASE_ADDRESS AND add < MAIN_ENDx_ADDRESS THEN 
			MAIN_PORT_Data_out			<=	Dout_1;
		ELSE
			MAIN_PORT_Data_out			<=	(OTHERS	=>	'Z');
		END IF;
		--WAIT ON	MAIN_PORT_Address, MAIN_PORT_OEN, Dout_1;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS(MAIN_PORT_Address, MAIN_PORT_OEN)
		VARIABLE	add					:	INTEGER;
	BEGIN
		add								:=	to_integer(SIGNED(X_check(MAIN_PORT_Address)));
		IF add  >= MAIN_BASE_ADDRESS AND add < MAIN_ENDx_ADDRESS THEN
			MAIN_PORT_Dot_Rdy			<=	MAIN_PORT_OEN;
			MAIN_PORT_SEL_This			<=	'1';
		ELSE
			MAIN_PORT_Dot_Rdy			<=	'0';
			MAIN_PORT_SEL_This			<=	'0';
		END IF;
		--WAIT ON	MAIN_PORT_Address, MAIN_PORT_OEN;
	END PROCESS;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	Eadd_1								<=	std_logic_vector(unsigned(MAIN_PORT_Address)/4 - MAIN_BASE_ADDRESS/4);
	Eadd_2								<=	std_logic_vector(unsigned(MAIN_PORT_Address)/4 - MAIN_BASE_ADDRESS/4);
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	PROCESS(DNoC_PORT_Address, DNoC_PORT_WEN)
		VARIABLE	add					:	INTEGER;
	BEGIN
		add								:=	to_integer(SIGNED(X_check(DNoC_PORT_Address)));
		IF DNoC_PORT_WEN = '1' AND add  >= DNoC_BASE_ADDRESS AND add < DNoC_ENDx_ADDRESS THEN 
			EWen_2						<=	'1';
		ELSE
			EWen_2						<=	'0';
		END IF;
		--WAIT ON DNoC_PORT_Address, DNoC_PORT_WEN;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS(DNoC_PORT_Address, DNoC_PORT_OEN, Dout_2)
		VARIABLE	add					:	INTEGER;
	BEGIN
		add								:=	to_integer(SIGNED(X_check(DNoC_PORT_Address)));
		IF DNoC_PORT_OEN = '1' AND add  >= DNoC_BASE_ADDRESS AND add < DNoC_ENDx_ADDRESS THEN 
			DNoC_PORT_Data_out			<=	Dout_2;
		ELSE
			DNoC_PORT_Data_out			<=	(OTHERS	=>	'Z');
		END IF;
		--WAIT ON	DNoC_PORT_Address, DNoC_PORT_OEN, Dout_2;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS(DNoC_PORT_Address, DNoC_PORT_OEN)
		VARIABLE	add					:	INTEGER;
	BEGIN
		add								:=	to_integer(SIGNED(X_check(DNoC_PORT_Address)));
		IF add  >= DNoC_BASE_ADDRESS AND add < DNoC_ENDx_ADDRESS THEN
			DNoC_PORT_Dot_Rdy			<=	DNoC_PORT_OEN;
			DNoC_PORT_SEL_This			<=	'1';
		ELSE
			DNoC_PORT_Dot_Rdy			<=	'0';
			DNoC_PORT_SEL_This			<=	'0';
		END IF;
		--WAIT ON	DNoC_PORT_Address, DNoC_PORT_OEN;
	END PROCESS;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	PROCESS(uPROC_PORT_clk, uPROC_PORT_rst)
	BEGIN
		IF uPROC_PORT_rst = '1' THEN
			uPROC_PORT_valid_o			<=	'0';
			uPROC_PORT_Data_out			<=	(OTHERS	=>	'0');
		ELSIF uPROC_PORT_clk = '1' AND uPROC_PORT_clk'EVENT THEN
			uPROC_PORT_valid_o			<=	uPROC_PORT_rd_i;
			uPROC_PORT_Data_out			<=	Dout_3;
		END IF;
	END PROCESS;
	uPROC_PORT_error_o					<=	'0';
	uPROC_PORT_accept_o					<=	'1';
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
end Behavioral;


	
	