-- **************************************************************************************
--	Filename:	aftab_booth_multiplier.vhd
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
--	Generic Booth multiplier for the AFTAB core
--
-- **************************************************************************************

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY aftab_booth_multiplier IS
	GENERIC
		(len : INTEGER := 33);
	PORT(
	   clk        : IN  STD_LOGIC;
	   rst        : IN  STD_LOGIC;
	   startBooth : IN  STD_LOGIC;
	   M          : IN  STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
	   Mr         : IN  STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
	   P          : OUT STD_LOGIC_VECTOR (2 * len - 1 DOWNTO 0);
	   doneBooth  : OUT STD_LOGIC);
END ENTITY aftab_booth_multiplier;
-- 
ARCHITECTURE behavioral OF aftab_booth_multiplier IS
	SIGNAL op     : STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL shrMr  : STD_LOGIC;
	SIGNAL ldMr   : STD_LOGIC;
	SIGNAL ldM    : STD_LOGIC;
	SIGNAL ldP    : STD_LOGIC;
	SIGNAL zeroP  : STD_LOGIC;
	SIGNAL sel    : STD_LOGIC;
	SIGNAL subSel : STD_LOGIC;
BEGIN
	
	
	P			<=	std_logic_vector(SIGNED(M) * SIGNED(Mr));
	doneBooth	<=	'1';
	
END ARCHITECTURE behavioral;
