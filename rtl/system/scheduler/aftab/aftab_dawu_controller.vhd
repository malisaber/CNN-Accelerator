-- **************************************************************************************
--	Filename:	aftab_dawu_controller.vhd
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
--	Controller of the Data Adjustment Write Unit (DAWU) of the AFTAB core
--
-- **************************************************************************************

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY aftab_dawu_controller IS
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
END ENTITY aftab_dawu_controller;
--
ARCHITECTURE behavioral OF aftab_dawu_controller IS
	TYPE state IS (waitForStart, waitForWrite);
	SIGNAL pstate, nstate : state;
BEGIN
	PROCESS (pstate, coCnt, startDAWU, memReady) BEGIN
		nstate <= waitForStart;
		CASE pstate IS
			WHEN waitForStart =>
				IF startDAWU = '1' THEN
					nstate <= waitForWrite;
				ELSE
					nstate <= waitForStart;
				END IF;
			WHEN waitForWrite =>
				IF (coCnt = '1' AND memReady = '1') THEN
					nstate <= waitForStart;
				ELSE
					nstate <= waitForWrite;
				END IF;
			WHEN OTHERS =>
				nstate <= waitForStart;
		END CASE;
	END PROCESS;
	PROCESS (pstate, coCnt, startDAWU, memReady) BEGIN
		ldData       <= '0';
		ldAddr       <= '0';
		enableData   <= '0';
		enableAddr   <= '0';
		writeMem     <= '0';
		completeDAWU <= '0';
		CASE pstate IS
			WHEN waitForStart =>
				ldAddr      <= startDAWU;
				ldData      <= startDAWU;
			WHEN waitForWrite =>
				enableData <= '1';
				enableAddr <= '1';
				writeMem   <= '1';
				IF (coCnt = '1' AND memReady = '1') THEN
					completeDAWU <= '1';
				ELSE
					completeDAWU <= '0';
				END IF;
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS;
	sequential : PROCESS (clk, rst) BEGIN
		IF (rst = '1') THEN
			pstate <= waitForStart;
		ELSIF (clk = '1' AND clk'EVENT) THEN
			pstate <= nstate;
		END IF;
	END PROCESS sequential;
END ARCHITECTURE behavioral;
