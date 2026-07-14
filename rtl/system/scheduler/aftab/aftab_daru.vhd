-- **************************************************************************************
--	Filename:	aftab_daru.vhd
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
--	Data Adjustment Read Unit (DARU) of the AFTAB core
--
-- **************************************************************************************

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY aftab_daru IS
	PORT(
		clk                 : IN  STD_LOGIC;
		rst                 : IN  STD_LOGIC;
		startDARU           : IN  STD_LOGIC;
		nBytes              : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		addrIn              : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
		memData             : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
		memReady            : IN  STD_LOGIC;
		dataInstrBar        : IN  STD_LOGIC;
		checkMisalignedDARU : IN  STD_LOGIC;
		instrMisalignedFlag : OUT STD_LOGIC;
		loadMisalignedFlag  : OUT STD_LOGIC;
		completeDARU        : OUT STD_LOGIC;
		dataOut             : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		addrOut             : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		readMem             : OUT STD_LOGIC);
END ENTITY aftab_daru;
--
ARCHITECTURE behavioral OF aftab_daru IS
	-----------------------------------------------
	COMPONENT	aftab_daru_controller
	PORT(
		clk          : IN  STD_LOGIC;
		rst          : IN  STD_LOGIC;
		startDARU    : IN  STD_LOGIC;
		coCnt        : IN  STD_LOGIC;
		memReady     : IN  STD_LOGIC;
		ldAddr       : OUT STD_LOGIC;
		selldEn      : OUT STD_LOGIC;
		readMem      : OUT STD_LOGIC;
		enableAddr   : OUT STD_LOGIC;
		completeDARU : OUT STD_LOGIC);
	END	COMPONENT;
	-----------------------------------------------
	-----------------------------------------------
	COMPONENT	aftab_daru_datapath
	GENERIC(
		len					: INTEGER := 32);
	PORT(
		clk                 : IN  STD_LOGIC;
		rst                 : IN  STD_LOGIC;
		nBytes              : IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
		addrIn              : IN  STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
		memData             : IN  STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
		ldAddr              : IN  STD_LOGIC;
		selldEn             : IN  STD_LOGIC;
		enableAddr          : IN  STD_LOGIC;
		dataInstrBar        : IN  STD_LOGIC;
		checkMisalignedDARU : IN  STD_LOGIC;
		instrMisalignedFlag : OUT STD_LOGIC;
		loadMisalignedFlag  : OUT STD_LOGIC;
		coCnt               : OUT STD_LOGIC;
		dataOut             : OUT STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
		addrOut             : OUT STD_LOGIC_VECTOR (len - 1 DOWNTO 0));
	END	COMPONENT;
	-----------------------------------------------
	SIGNAL zeroAddr     : STD_LOGIC;
	SIGNAL ldAddr       : STD_LOGIC;
	SIGNAL selldEn      : STD_LOGIC;
	SIGNAL zeroNumBytes : STD_LOGIC;
	SIGNAL ldNumBytes   : STD_LOGIC;
	SIGNAL zeroCnt      : STD_LOGIC;
	SIGNAL incCnt       : STD_LOGIC;
	SIGNAL initCnt      : STD_LOGIC;
	SIGNAL initReading  : STD_LOGIC;
	SIGNAL enableAddr   : STD_LOGIC;
	SIGNAL enableData   : STD_LOGIC;
	SIGNAL coCnt        : STD_LOGIC;
	SIGNAL sel          : STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL initValueCnt : STD_LOGIC_VECTOR (1 DOWNTO 0);
BEGIN
	DataPath : aftab_daru_datapath
	GENERIC	MAP(
		len => 32)
	PORT MAP(
		clk                 => clk,
		rst                 => rst,
		nBytes              => nBytes,
		addrIn              => addrIn,
		memData             => memData,
		ldAddr              => ldAddr,
		selldEn             => selldEn,
		enableAddr          => enableAddr,
		dataInstrBar        => dataInstrBar,
		checkMisalignedDARU => checkMisalignedDARU,
		instrMisalignedFlag => instrMisalignedFlag,
		loadMisalignedFlag  => loadMisalignedFlag,
		coCnt               => coCnt,
		dataOut             => dataOut,
		addrOut             => addrOut);
	
	Controller : aftab_daru_controller
	PORT	MAP(
		clk          => clk,
		rst          => rst,
		startDARU    => startDARU,
		coCnt        => coCnt,
		memReady     => memReady,
		ldAddr       => ldAddr,
		selldEn      => selldEn,
		readMem      => readMem,
		enableAddr   => enableAddr,
		completeDARU => completeDARU);
END ARCHITECTURE behavioral;
