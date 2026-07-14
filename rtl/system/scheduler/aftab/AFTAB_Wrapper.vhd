library IEEE;
use IEEE.std_logic_1164.ALL;

entity AFTAB_Wrapper is
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
		MAIN_PORT_Data_out				:	OUT	std_logic_vector(31	DOWNTO	0));
end AFTAB_Wrapper;
 
architecture Behavioral of AFTAB_Wrapper is
	------------------------------------------------------------------------
	--	COMPONENTS
	------------------------------------------------------------------------
	COMPONENT	aftab_core
	GENERIC(
		len								:	INTEGER	:=	32);
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		memReady						:	IN	std_logic;
		memDataIn						:	IN	std_logic_vector(len-1	DOWNTO	0);
		memDataOut						:	OUT	std_logic_vector(len-1	DOWNTO	0);
		memRead							:	OUT	std_logic;
		memWrite						:	OUT	std_logic;
		memAddr							:	OUT	std_logic_vector(len-1	DOWNTO	0);
		--interruptinputsandoutputs
		machineExternalInterrupt		:	IN	std_logic;
		machineTimerInterrupt			:	IN	std_logic;
		machineSoftwareInterrupt		:	IN	std_logic;
		userExternalInterrupt			:	IN	std_logic;
		userTimerInterrupt				:	IN	std_logic;
		userSoftwareInterrupt			:	IN	std_logic;
		platformInterruptSignals		:	IN	std_logic_vector(15	DOWNTO	0);
		interruptProcessing				:	OUT	std_logic);
	END	COMPONENT;
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	--	SIGNALs
	------------------------------------------------------------------------
	SIGNAL	REQs						:	std_logic_vector(15 DOWNTO 0);
	------------------------------------------------------------------------
	------------------------------------------------------------------------
begin
	------------------------------------------------------------------------
	--	INSTANCEs
	------------------------------------------------------------------------
	RISC_V_core							:	aftab_core
	GENERIC	MAP(
		len								=>	32)
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		memReady						=>	MAIN_PORT_MEM_Rdy,
		memDataIn						=>	MAIN_PORT_Data_in,
		memDataOut						=>	MAIN_PORT_Data_out,
		memRead							=>	MAIN_PORT_OEN,
		memWrite						=>	MAIN_PORT_WEN,
		memAddr							=>	MAIN_PORT_Address,
		--interruptinputsandoutputs
		machineExternalInterrupt		=>	'0',
		machineTimerInterrupt			=>	'0',
		machineSoftwareInterrupt		=>	'0',
		userExternalInterrupt			=>	'0',
		userTimerInterrupt				=>	'0',
		userSoftwareInterrupt			=>	'0',
		platformInterruptSignals		=>	REQs,
		interruptProcessing				=>	INT_ACK);
	------------------------------------------------------------------------
	REQs(15	DOWNTO	1)					<=	(OTHERS => '0');
	REQs(0)								<=	INT_REQ;
	------------------------------------------------------------------------
	------------------------------------------------------------------------
end Behavioral;


