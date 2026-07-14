library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE work.my_pack_v2.ALL;

entity config_holder_v2 is
	GENERIC(
		BASE_ADDRESS					:	INTEGER	:=	to_integer(SIGNED(X_check(X"FFFF0000"))));
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		
		--	MAIN PORT
		MAIN_PORT_Dot_Rdy				:	OUT	std_logic;
		MAIN_PORT_SEL_This				:	OUT	std_logic;
		MAIN_PORT_Address				:	IN	std_logic_vector(31	DOWNTO	0);
		MAIN_PORT_Data_in				:	IN	std_logic_vector(31	DOWNTO	0);
		MAIN_PORT_WEN					:	IN	std_logic;
		MAIN_PORT_OEN					:	IN	std_logic;
		MAIN_PORT_Data_out				:	OUT	std_logic_vector(31	DOWNTO	0);
		
		--	Configuration
		all_configs						:	OUT	all_configs_type);
end config_holder_v2;

architecture Behavioral of config_holder_v2 is
	--------------------------------------------------------------------------
	--		CONSTANTs
	--------------------------------------------------------------------------
	CONSTANT	NUMB_ints				:	INTEGER	:=	16;
	CONSTANT	ENDx_ADDRESS			:	INTEGER	:=	BASE_ADDRESS + 4*NUMB_ints;
	-------------------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--																		--
	--																		--
	--																		--
	--------------------------------------------------------------------------
	--		BASE_ADDRESS	+	00		:	PE(1,1)
	--		BASE_ADDRESS	+	04		:	PE(1,2)
	--		BASE_ADDRESS	+	08		:	PE(1,3)
	--		BASE_ADDRESS	+	0C		:	PE(1,4)
	--		BASE_ADDRESS	+	10		:	PE(2,1)
	--		BASE_ADDRESS	+	14		:	PE(2,2)
	--		BASE_ADDRESS	+	18		:	PE(2,3)
	--		BASE_ADDRESS	+	1C		:	PE(2,4)
	--		BASE_ADDRESS	+	20		:	PE(3,1)
	--		BASE_ADDRESS	+	24		:	PE(3,2)
	--		BASE_ADDRESS	+	28		:	PE(3,3)
	--		BASE_ADDRESS	+	2C		:	PE(3,4)
	--		BASE_ADDRESS	+	30		:	PE(4,1)
	--		BASE_ADDRESS	+	34		:	PE(4,2)
	--		BASE_ADDRESS	+	38		:	PE(4,3)
	--		BASE_ADDRESS	+	3C		:	PE(4,4)
	------------------------------------------------------------------------------------------------------------------------------------------	
	------------------------------------------------------------------------------------------------------------------------------------------	
	--		
	--	L	|	31		30	|	29		28		27		26		25	|	24	|	23	|	22	|	21		20		19		18		17		16	 |
	--	O	|=== FSM Sel ===|============= Shift Count =============|= F/H =| IFMNS | WFMNS |=================== RESERVED ===================|
	--	W	
	--	E	
	--	R	|	15		14	|	13		12	|	11		10		9		8	|	7		6		5		4	|	3		2		1		0	 |
	--		|=== RESERVED ==|=== Zpad max ==|========== Kernel Max =========|========= Column Max ==========|========= Channel Max ==========|
	--		
	------------------------------------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------------------------------
	--		TYPEs
	--------------------------------------------------------------------------
	TYPE	mem_type					IS	ARRAY (0 TO 15)	OF	std_logic_vector(31	DOWNTO	0);
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		SIGNALs
	--------------------------------------------------------------------------
	SIGNAL	mem							:	mem_type;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
begin
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	PROCESS (clk, rst)
		VARIABLE	add					:	INTEGER;
		VARIABLE	Eadd				:	INTEGER;
	BEGIN
		IF rst = '1' THEN
			mem							<=	(OTHERS	=>	(OTHERS	=>	'0'));
		ELSIF clk = '1' AND clk'EVENT THEN
			add							:=	to_integer(SIGNED(X_check(MAIN_PORT_Address)));
			Eadd						:=	(add - BASE_ADDRESS)/4;
			IF MAIN_PORT_WEN = '1' AND add >= BASE_ADDRESS AND add < ENDx_ADDRESS THEN
				mem(Eadd)				<=	MAIN_PORT_Data_in;
			END IF;
		END IF;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS(MAIN_PORT_Address, MAIN_PORT_OEN, mem)
		VARIABLE	add					:	INTEGER;
		VARIABLE	Eadd				:	INTEGER;
	BEGIN
		add								:=	to_integer(SIGNED(X_check(MAIN_PORT_Address)));
		Eadd							:=	(add/4) - (BASE_ADDRESS/4);
		IF MAIN_PORT_OEN = '1' AND add  >= BASE_ADDRESS AND add < ENDx_ADDRESS THEN
			MAIN_PORT_Data_out			<=	mem(Eadd);
		ELSE
			MAIN_PORT_Data_out			<=	(OTHERS	=>	'Z');
		END IF;
	END PROCESS;
	--------------------------------------------------------------------------
	PROCESS(MAIN_PORT_Address, MAIN_PORT_OEN)
		VARIABLE	add					:	INTEGER;
	BEGIN
		add								:=	to_integer(SIGNED(X_check(MAIN_PORT_Address)));
		IF add  >= BASE_ADDRESS AND add < ENDx_ADDRESS THEN
			MAIN_PORT_Dot_Rdy			<=	MAIN_PORT_OEN;
			MAIN_PORT_SEL_This			<=	'1';
		ELSE
			MAIN_PORT_Dot_Rdy			<=	'0';
			MAIN_PORT_SEL_This			<=	'0';
		END IF;
	END PROCESS;
	--------------------------------------------------------------------------
	CNF_ROW_GEN										:	FOR r IN 1 TO 4	GENERATE
		CNF_COL_GEN									:	FOR c IN 1 TO 4	GENERATE
			all_configs.FSM_sel		(r,c)			<=	mem(4*r+c-5)(31	DOWNTO	30);
			all_configs.PEs_CFB		(r,c).Shift_cnt	<=	mem(4*r+c-5)(29	DOWNTO	25);
			all_configs.PEs_CFB		(r,c).OP_mode	<=	mem(4*r+c-5)(24);
			all_configs.PEs_CFB		(r,c).IFM_NS	<=	mem(4*r+c-5)(23);
			all_configs.PEs_CFB		(r,c).WFM_NS	<=	mem(4*r+c-5)(22);
			all_configs.Maxs		(r,c).Zpad_Max	<=	mem(4*r+c-5)(13	DOWNTO	12);
			all_configs.Maxs		(r,c).Kern_Max	<=	mem(4*r+c-5)(11	DOWNTO	8);
			all_configs.Maxs		(r,c).Colm_Max	<=	mem(4*r+c-5)(7	DOWNTO	4);
			all_configs.Maxs		(r,c).Chan_Max	<=	mem(4*r+c-5)(3	DOWNTO	0);
		END GENERATE;
	END GENERATE;
	--------------------------------------------------------------------------
end Behavioral;
