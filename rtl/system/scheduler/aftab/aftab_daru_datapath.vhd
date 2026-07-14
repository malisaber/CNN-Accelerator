-- **************************************************************************************
--	Filename:	aftab_daru_datapath.vhd
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
--	Datapath of the Data Adjustment Read Unit (DARU) of the AFTAB core
--
-- **************************************************************************************

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY aftab_daru_datapath IS
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
END ENTITY aftab_daru_datapath;
--
ARCHITECTURE behavioral OF aftab_daru_datapath IS
	SIGNAL readAddr   : STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
	SIGNAL dataIn     : STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
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
	-----------------------------------------------
	COMPONENT	aftab_daru_error_detector
	GENERIC(len : INTEGER := 32);
	PORT(
		nBytes              : IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
		addrIn              : IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
		dataInstrBar        : IN  STD_LOGIC;
		checkMisalignedDARU : IN  STD_LOGIC;
		instrMisalignedFlag : OUT STD_LOGIC;
		loadMisalignedFlag  : OUT STD_LOGIC);
	END	COMPONENT;
	-----------------------------------------------
BEGIN
	dataIn <= memData;
	
	-- addrReg
	addrReg : aftab_register
		GENERIC
		MAP(len => 32)
		PORT MAP
		(
			clk    => clk,
			rst    => rst,
			zero   => '0',
			load   => ldAddr,
			inReg  => addrIn,
			outReg => readAddr);
	
	
	Reg0 : aftab_register
		GENERIC
		MAP(len => 32)
		PORT
		MAP(
		clk    => clk,
		rst    => rst,
		zero   => '0',
		load   => selldEn,
		inReg  => dataIn,
		outReg => dataOut);
	
	
	coCnt <= '1';		--	douplicated
	errorDecoder : aftab_daru_error_detector
		GENERIC
		MAP(len => 32)
		PORT
		MAP(
		nBytes              => nBytes,
		addrIn              => addrIn(1 DOWNTO 0),
		dataInstrBar        => dataInstrBar,
		checkMisalignedDARU => checkMisalignedDARU,
		instrMisalignedFlag => instrMisalignedFlag,
		loadMisalignedFlag  => loadMisalignedFlag);

	-- Tri-State
	addrOut <= readAddr WHEN enableAddr = '1' ELSE (OTHERS => 'Z');
END ARCHITECTURE behavioral;
