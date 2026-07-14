-- **************************************************************************************
--	Filename:	aftab_divider.vhd
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
--	Generic integer divider for the AFTAB core
--
-- **************************************************************************************

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY aftab_divider IS
	GENERIC
		(len : INTEGER := 33);
	PORT(
		clk       : IN  STD_LOGIC;
		rst       : IN  STD_LOGIC;
		startDiv  : IN  STD_LOGIC;
		doneDiv   : OUT STD_LOGIC;
		dividend  : IN  STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
		divisor   : IN  STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
		Q         : OUT STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
		Remainder : OUT STD_LOGIC_VECTOR (len DOWNTO 0));
END ENTITY aftab_divider;
--
ARCHITECTURE behavioral OF aftab_divider IS
	SIGNAL R33         : STD_LOGIC;
	SIGNAL shRRegR     : STD_LOGIC;
	SIGNAL ShLRegR     : STD_LOGIC;
	SIGNAL ldRegR      : STD_LOGIC;
	SIGNAL zeroRegR    : STD_LOGIC;
	SIGNAL QQ0         : STD_LOGIC;
	SIGNAL seldividend : STD_LOGIC;
	SIGNAL selline1    : STD_LOGIC;
	SIGNAL shRRegQ     : STD_LOGIC;
	SIGNAL ShLRegQ     : STD_LOGIC;
	SIGNAL ldRegQ      : STD_LOGIC;
	SIGNAL zeroRegQ    : STD_LOGIC;
	SIGNAL zeroRegM    : STD_LOGIC;
	SIGNAL ldRegM      : STD_LOGIC;
	-----------------------------------------------
	COMPONENT	aftab_divider_controller
	GENERIC (len : INTEGER := 33; lenCnt : INTEGER := 6);
	PORT (
		clk        : IN  STD_LOGIC;
		rst        : IN  STD_LOGIC;
		startDiv   : IN  STD_LOGIC;
		R33        : IN  STD_LOGIC;
		doneDiv    : OUT STD_LOGIC;
		shRRegR    : OUT STD_LOGIC;
		ShLRegR    : OUT STD_LOGIC;
		ldRegR     : OUT STD_LOGIC;
		zeroRegR   : OUT STD_LOGIC;
		seldividend: OUT STD_LOGIC;
		selline1   : OUT STD_LOGIC;
		shRRegQ    : OUT STD_LOGIC;
		ShLRegQ    : OUT STD_LOGIC;
		ldRegQ     : OUT STD_LOGIC;
		zeroRegQ   : OUT STD_LOGIC;
		zeroRegM   : OUT STD_LOGIC;
		ldRegM     : OUT STD_LOGIC;
		QQ0        : OUT STD_LOGIC);
	END	COMPONENT;
	-----------------------------------------------
	-----------------------------------------------
	COMPONENT	aftab_divider_datapath
	GENERIC(
		len			: INTEGER := 33);
	PORT(
		clk         : IN  STD_LOGIC;
		rst         : IN  STD_LOGIC;
		dividend    : IN  STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
		divisor     : IN  STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
		shRRegR     : IN  STD_LOGIC;
		ShLRegR     : IN  STD_LOGIC;
		ldRegR      : IN  STD_LOGIC;
		zeroRegR    : IN  STD_LOGIC;
		QQ0         : IN  STD_LOGIC;
		seldividend : IN  STD_LOGIC;
		selline1    : IN  STD_LOGIC;
		shRRegQ     : IN  STD_LOGIC;
		ShLRegQ     : IN  STD_LOGIC;
		ldRegQ      : IN  STD_LOGIC;
		zeroRegQ    : IN  STD_LOGIC;
		zeroRegM    : IN  STD_LOGIC;
		ldRegM      : IN  STD_LOGIC;
		R33         : OUT STD_LOGIC;
		Q           : OUT STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
		Remainder   : OUT STD_LOGIC_VECTOR (len DOWNTO 0));
	END	COMPONENT;
	-----------------------------------------------
BEGIN
	DataPathDiv : aftab_divider_datapath
		GENERIC
		MAP(len => len)
		PORT MAP
		(
			clk         => clk,
			rst         => rst,
			dividend    => dividend,
			divisor     => divisor,
			shRRegR     => shRRegR,
			ShLRegR     => ShLRegR,
			ldRegR      => ldRegR,
			zeroRegR    => zeroRegR,
			QQ0         => QQ0,
			seldividend => seldividend,
			selline1    => selline1,
			shRRegQ     => shRRegQ,
			ShLRegQ     => ShLRegQ,
			ldRegQ      => ldRegQ,
			zeroRegQ    => zeroRegQ,
			zeroRegM    => zeroRegM,
			ldRegM      => ldRegM,
			R33         => R33,
			Q           => Q,
			Remainder   => Remainder);
	ControllerDiv : aftab_divider_controller
		GENERIC
		MAP(len => len)
		PORT
		MAP(
		clk         => clk,
		rst         => rst,
		startDiv    => startDiv,
		R33         => R33,
		doneDiv     => doneDiv,
		shRRegR     => shRRegR,
		ShLRegR     => ShLRegR,
		ldRegR      => ldRegR,
		zeroRegR    => zeroRegR,
		seldividend => seldividend,
		selline1    => selline1,
		shRRegQ     => shRRegQ,
		ShLRegQ     => ShLRegQ,
		ldRegQ      => ldRegQ,
		zeroRegQ    => zeroRegQ,
		zeroRegM    => zeroRegM,
		ldRegM      => ldRegM,
		QQ0         => QQ0);
END ARCHITECTURE behavioral;
