-- **************************************************************************************
--	Filename:	aftab_dawu.vhd
--	Project:	CNL_RISC-V
--  Version:	1.0
--	Date:		25 March 2022
--
-- Copyright (C) 2022 CINI Cybersecurity National Laboratory and University of Tehran
--
-- This source file may be used and distributed without
-- restriction provided that this copyright statement is not
-- removed from the file and that any derivative work contains
-- the original copyright notice and the associated disclaimer.
--
-- This source file is free software; you can redistribute it
-- and/or modify it under the terms of the GNU Lesser General
-- Public License as published by the Free Software Foundation;
-- either version 3.0 of the License, or (at your option) any
-- later version.
--
-- This source is distributed in the hope that it will be
-- useful, but WITHOUT ANY WARRANTY; without even the implied
-- warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
-- PURPOSE. See the GNU Lesser General Public License for more
-- details.
--
-- You should have received a copy of the GNU Lesser General
-- Public License along with this source; if not, download it
-- from https://www.gnu.org/licenses/lgpl-3.0.txt
--
-- **************************************************************************************
--
--	File content description:
--	Data Adjustment Write Unit (DAWU) of the AFTAB core
--
-- **************************************************************************************

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY aftab_dawu IS
	GENERIC(len : INTEGER := 32);
	PORT(
		clk                 : IN  STD_LOGIC;
		rst                 : IN  STD_LOGIC;
		startDAWU           : IN  STD_LOGIC;
		memReady            : IN  STD_LOGIC;
		nBytes              : IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
		addrIn              : IN  STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
		dataIn              : IN  STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
		checkMisalignedDAWU : IN  STD_LOGIC;
		addrOut             : OUT STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
		dataOut             : OUT STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
		storeMisalignedFlag : OUT STD_LOGIC;
		writeMem            : OUT STD_LOGIC;
		completeDAWU        : OUT STD_LOGIC);
END ENTITY aftab_dawu;
--
ARCHITECTURE Behavioral OF aftab_dawu IS
	SIGNAL enableData   : STD_LOGIC;
	SIGNAL enableAddr   : STD_LOGIC;
	SIGNAL ldAddr       : STD_LOGIC;
	SIGNAL ldData       : STD_LOGIC;
	SIGNAL coCnt        : STD_LOGIC;
	-----------------------------------------------
	COMPONENT	aftab_dawu_controller
	PORT(
		clk          : IN  STD_LOGIC;
		rst          : IN  STD_LOGIC;
		coCnt        : IN  STD_LOGIC;
		startDAWU    : IN  STD_LOGIC;
		memReady     : IN  STD_LOGIC;
		ldData       : OUT STD_LOGIC;
		enableData   : OUT STD_LOGIC;
		enableAddr   : OUT STD_LOGIC;
		ldAddr       : OUT STD_LOGIC;
		writeMem     : OUT STD_LOGIC;
		completeDAWU : OUT STD_LOGIC);
	END	COMPONENT;
	-----------------------------------------------
	-----------------------------------------------
	COMPONENT	aftab_dawu_datapath
	GENERIC(len : INTEGER := 32);
	PORT(
		clk                 : IN  STD_LOGIC;
		rst                 : IN  STD_LOGIC;
		ldData              : IN  STD_LOGIC;
		enableData          : IN  STD_LOGIC;
		enableAddr          : IN  STD_LOGIC;
		ldAddr              : IN  STD_LOGIC;
		nBytesIn            : IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
		dataIn              : IN  STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
		addrIn              : IN  STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
		checkMisalignedDAWU : IN  STD_LOGIC;
		storeMisalignedFlag : OUT STD_LOGIC;
		coCnt               : OUT STD_LOGIC;
		dataOut             : OUT STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
		addrOut             : OUT STD_LOGIC_VECTOR (len - 1 DOWNTO 0));
	END	COMPONENT;
	-----------------------------------------------
BEGIN
	Datapath : aftab_dawu_datapath
	GENERIC	MAP (
		len => len)
	PORT MAP	(
		clk                 => clk,
		rst                 => rst,
		ldData              => ldData,
		enableData          => enableData,
		enableAddr          => enableAddr,
		ldAddr              => ldAddr,
		nBytesIn            => nBytes,
		dataIn              => dataIn,
		addrIn              => addrIn,
		checkMisalignedDAWU => checkMisalignedDAWU,
		storeMisalignedFlag => storeMisalignedFlag,
		coCnt               => coCnt,
		dataOut             => dataOut,
		addrOut             => addrOut);
	
	Controller : aftab_dawu_controller
	PORT	MAP(
		clk          => clk,
		rst          => rst,
		coCnt        => coCnt,
		startDAWU    => startDAWU,
		memReady     => memReady,
		ldData       => ldData,
		enableData   => enableData,
		enableAddr   => enableAddr,
		ldAddr       => ldAddr,
		writeMem     => writeMem,
		completeDAWU => completeDAWU);
		
END ARCHITECTURE Behavioral;
