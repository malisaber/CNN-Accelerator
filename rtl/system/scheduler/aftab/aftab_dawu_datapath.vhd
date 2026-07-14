-- **************************************************************************************
--	Filename:	aftab_dawu_datapath.vhd
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
--	Datapath of the Data Adjustment Write Unit (DAWU) of the AFTAB core
--
-- **************************************************************************************

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY aftab_dawu_datapath IS
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
END ENTITY aftab_dawu_datapath;
--
ARCHITECTURE Behavioral OF aftab_dawu_datapath IS
	SIGNAL muxOut     : STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
	SIGNAL outReg     : STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
	SIGNAL addrOutReg : STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
	SIGNAL writeAddr  : STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
	SIGNAL nBytesOut  : STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL outCnt     : STD_LOGIC_VECTOR (1 DOWNTO 0);
	-----------------------------------------------
	COMPONENT	aftab_dawu_error_detector
	GENERIC(len : INTEGER := 32);
	PORT(
		nBytes              : IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
		addrIn              : IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
		checkMisalignedDAWU : IN  STD_LOGIC;
		storeMisalignedFlag : OUT STD_LOGIC);
	END	COMPONENT;
	-----------------------------------------------
	-----------------------------------------------
	COMPONENT	aftab_register
	GENERIC
		(len : INTEGER := 32);
	PORT
	(
		clk    : IN  STD_LOGIC;
		rst    : IN  STD_LOGIC;
		zero   : IN  STD_LOGIC;
		load   : IN  STD_LOGIC;
		inReg  : IN  STD_LOGIC_VECTOR(len - 1 DOWNTO 0);
		outReg : OUT STD_LOGIC_VECTOR(len - 1 DOWNTO 0));
	END	COMPONENT;
	-----------------------------------------------
BEGIN
	addrReg : aftab_register
		GENERIC
		MAP(len => len)
		PORT
		MAP(
		clk    => clk,
		rst    => rst,
		zero   => '0',
		load   => ldAddr,
		inReg  => addrIn,
		outReg => addrOutReg);
	
	reg0 : aftab_register
		GENERIC
		MAP(len => 32)
		PORT
		MAP(
		clk    => clk,
		rst    => rst,
		zero   => '0',
		load   => ldData,
		inReg  => dataIn,
		outReg => outReg);
		
	coCnt <= '1';
	
	errorDecoder : aftab_dawu_error_detector
		GENERIC
		MAP (len => len)
		PORT
		MAP (
		nBytes              => nBytesIn,
		addrIn              => addrIn (1 DOWNTO 0),
		checkMisalignedDAWU => checkMisalignedDAWU,
		storeMisalignedFlag => storeMisalignedFlag
		);
	
	addrOut <= addrOutReg WHEN (enableAddr = '1') ELSE (OTHERS => 'Z');
	dataOut <= outReg WHEN (enableData = '1') ELSE(OTHERS     => 'Z');
END ARCHITECTURE Behavioral;
