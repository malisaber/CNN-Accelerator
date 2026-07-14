-- **************************************************************************************
--	Filename:	aftab_core.vhd
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
-- File content description:
-- Top entity of the AFTAB core
--
-- **************************************************************************************

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY aftab_core IS
	GENERIC
		(len : INTEGER := 32);
	PORT
	(
		clk                      : IN  STD_LOGIC;
		rst                      : IN  STD_LOGIC;
		memReady       	         : IN  STD_LOGIC;
		memDataIn                : IN  STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
		memDataOut               : OUT STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
		memRead                  : OUT STD_LOGIC;
		memWrite                 : OUT STD_LOGIC;
		memAddr                  : OUT STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
		--interrupt inputs and outputs
		machineExternalInterrupt : IN  STD_LOGIC;
		machineTimerInterrupt    : IN  STD_LOGIC;
		machineSoftwareInterrupt : IN  STD_LOGIC;
		userExternalInterrupt    : IN  STD_LOGIC;
		userTimerInterrupt       : IN  STD_LOGIC;
		userSoftwareInterrupt    : IN  STD_LOGIC;
		platformInterruptSignals : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
		interruptProcessing      : OUT STD_LOGIC
	);
END ENTITY;
--
ARCHITECTURE procedural OF aftab_core IS
	-----------------------------------------------
	COMPONENT	aftab_controller
	GENERIC(
		len							   : INTEGER := 32);
	PORT(
		clk                            : IN  STD_LOGIC;
		rst                            : IN  STD_LOGIC;
		completeDARU                   : IN  STD_LOGIC;
		completeDAWU                   : IN  STD_LOGIC;
		completeAAU                    : IN  STD_LOGIC;
		lt                             : IN  STD_LOGIC;
		eq                             : IN  STD_LOGIC;
		gt                             : IN  STD_LOGIC;
		IR                             : IN  STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
		muxCode                        : OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
		nBytes                         : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
		selLogic                       : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
		selShift                       : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
		selPC                          : OUT STD_LOGIC;
		selI4                          : OUT STD_LOGIC;
		selP1                          : OUT STD_LOGIC;
		selP2                          : OUT STD_LOGIC;
		selJL                          : OUT STD_LOGIC;
		selADR                         : OUT STD_LOGIC;
		selPCJ                         : OUT STD_LOGIC;
		selImm                         : OUT STD_LOGIC;
		selAdd                         : OUT STD_LOGIC;
		selInc4PC                      : OUT STD_LOGIC;
		selBSU                         : OUT STD_LOGIC;
		selLLU                         : OUT STD_LOGIC;
		selASU                         : OUT STD_LOGIC;
		selAAU                         : OUT STD_LOGIC;
		selDARU                        : OUT STD_LOGIC;
		dataInstrBar                   : OUT STD_LOGIC;
		writeRegFile                   : OUT STD_LOGIC;
		addSubBar                      : OUT STD_LOGIC;
		pass                           : OUT STD_LOGIC;
		selAuipc                       : OUT STD_LOGIC;
		comparedsignedunsignedbar      : OUT STD_LOGIC;
		ldIR                           : OUT STD_LOGIC;
		ldADR                          : OUT STD_LOGIC;
		ldPC                           : OUT STD_LOGIC;
		ldDr                           : OUT STD_LOGIC;
		ldByteSigned                   : OUT STD_LOGIC;
		ldHalfSigned                   : OUT STD_LOGIC;
		load                           : OUT STD_LOGIC;
		setOne                         : OUT STD_LOGIC;
		setZero                        : OUT STD_LOGIC;
		startDARU                      : OUT STD_LOGIC;
		startDAWU                      : OUT STD_LOGIC;
		startMultiplyAAU               : OUT STD_LOGIC;
		startDivideAAU                 : OUT STD_LOGIC;
		signedSigned                   : OUT STD_LOGIC;
		signedUnsigned                 : OUT STD_LOGIC;
		unsignedUnsigned               : OUT STD_LOGIC;
		selAAL                         : OUT STD_LOGIC;
		selAAH                         : OUT STD_LOGIC;
		--- Interrupts
		interruptRaise                 : IN  STD_LOGIC;
		exceptionRaise                 : IN  STD_LOGIC;
		ecallFlag                      : OUT STD_LOGIC;
		illegalInstrFlag               : OUT STD_LOGIC;
		instrMisalignedOut             : IN  STD_LOGIC;
		loadMisalignedOut              : IN  STD_LOGIC;
		storeMisalignedOut             : IN  STD_LOGIC;
		dividedByZeroOut               : IN  STD_LOGIC;
		validAccessCSR                 : IN  STD_LOGIC;		
		readOnlyCSR                    : IN  STD_LOGIC;
		mirror                         : IN  STD_LOGIC;
		ldMieReg                       : IN  STD_LOGIC;
		ldMieUieField                  : IN  STD_LOGIC;
		delegationMode                 : IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
		previousPRV                    : IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
		modeTvec                       : IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
		mipCCLdDisable                 : OUT STD_LOGIC;
		selCCMip_CSR                   : OUT STD_LOGIC;
		selCause_CSR                   : OUT STD_LOGIC;
		selPC_CSR                      : OUT STD_LOGIC;
		selTval_CSR                    : OUT STD_LOGIC;
		selMedeleg_CSR                 : OUT STD_LOGIC;
		selMideleg_CSR                 : OUT STD_LOGIC;
		ldValueCSR                     : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		ldCntCSR                       : OUT STD_LOGIC;
		dnCntCSR                       : OUT STD_LOGIC;
		upCntCSR                       : OUT STD_LOGIC;
		ldFlags                        : OUT STD_LOGIC;
		zeroFlags                      : OUT STD_LOGIC;
		ldDelegation                   : OUT STD_LOGIC;
		ldMachine                      : OUT STD_LOGIC;
		ldUser                         : OUT STD_LOGIC;
		loadMieReg                     : OUT STD_LOGIC;
		loadMieUieField                : OUT STD_LOGIC;
		mirrorUser                     : OUT STD_LOGIC;
		selCSR                         : OUT STD_LOGIC;
		selP1CSR                       : OUT STD_LOGIC;
		selReadWriteCSR                : OUT STD_LOGIC;
		selImmCSR                      : OUT STD_LOGIC;
		setCSR                         : OUT STD_LOGIC;
		clrCSR                         : OUT STD_LOGIC;
		writeRegBank                   : OUT STD_LOGIC;
		selCSRAddrFromInst             : OUT STD_LOGIC;
		selRomAddress                  : OUT STD_LOGIC;
		selMepc_CSR                    : OUT STD_LOGIC;
		selInterruptAddressDirect      : OUT STD_LOGIC;
		selInterruptAddressVectored    : OUT STD_LOGIC;
		checkMisalignedDARU            : OUT STD_LOGIC;
		checkMisalignedDAWU            : OUT STD_LOGIC;
		machineStatusAlterationPreCSR  : OUT STD_LOGIC;
		userStatusAlterationPreCSR     : OUT STD_LOGIC;
		machineStatusAlterationPostCSR : OUT STD_LOGIC;
		userStatusAlterationPostCSR    : OUT STD_LOGIC;
		zeroCntCSR                     : OUT STD_LOGIC);
	END	COMPONENT;
	-----------------------------------------------
	-----------------------------------------------
	COMPONENT	aftab_datapath
	GENERIC
		(len : INTEGER := 32);
	PORT(
		clk                            : IN  STD_LOGIC;
		rst                            : IN  STD_LOGIC;
		writeRegFile                   : IN  STD_LOGIC;
		setOne                         : IN  STD_LOGIC;
		setZero                        : IN  STD_LOGIC;
		ComparedSignedUnsignedBar      : IN  STD_LOGIC;
		selPC                          : IN  STD_LOGIC;
		selI4                          : IN  STD_LOGIC;
		selAdd                         : IN  STD_LOGIC;
		selJL                          : IN  STD_LOGIC;
		selADR                         : IN  STD_LOGIC;
		selPCJ                         : IN  STD_LOGIC;
		selInc4PC                      : IN  STD_LOGIC;
		selBSU                         : IN  STD_LOGIC;
		selLLU                         : IN  STD_LOGIC;
		selASU                         : IN  STD_LOGIC;
		selAAU                         : IN  STD_LOGIC;
		selDARU                        : IN  STD_LOGIC;
		selP1                          : IN  STD_LOGIC;
		selP2                          : IN  STD_LOGIC;
		selImm                         : IN  STD_LOGIC;
		ldPC                           : IN  STD_LOGIC;
		zeroPC                         : IN  STD_LOGIC;
		ldADR                          : IN  STD_LOGIC;
		zeroADR                        : IN  STD_LOGIC;
		ldDR                           : IN  STD_LOGIC;
		zeroDR                         : IN  STD_LOGIC;
		ldIR                           : IN  STD_LOGIC;
		zeroIR                         : IN  STD_LOGIC;
		ldByteSigned                   : IN  STD_LOGIC;
		ldHalfSigned                   : IN  STD_LOGIC;
		load                           : IN  STD_LOGIC;
		selShift                       : IN  STD_LOGIC_VECTOR (1 DOWNTO 0);--
		addSubBar                      : IN  STD_LOGIC;
		pass                           : IN  STD_LOGIC;
		selAuipc                       : IN  STD_LOGIC;
		muxCode                        : IN  STD_LOGIC_VECTOR (11 DOWNTO 0);
		selLogic                       : IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
		startDAWU                      : IN  STD_LOGIC;
		startDARU                 	   : IN  STD_LOGIC;
		startMultiplyAAU               : IN  STD_LOGIC;
		startDivideAAU                 : IN  STD_LOGIC;
		signedSigned                   : IN  STD_LOGIC;
		signedUnsigned                 : IN  STD_LOGIC;
		unsignedUnsigned               : IN  STD_LOGIC;
		selAAL                         : IN  STD_LOGIC;
		selAAH                         : IN  STD_LOGIC;
		dataInstrBar                   : IN  STD_LOGIC;
		nBytes                         : IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
		memReady                       : IN  STD_LOGIC;
		memDataIn                      : IN  STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
		memDataOut                     : OUT STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
		memAddrDAWU                    : OUT STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
		memAddrDARU                    : OUT STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
		writeMem                       : OUT STD_LOGIC;
		readMem                        : OUT STD_LOGIC;
		IR                             : OUT STD_LOGIC_VECTOR (len - 1 DOWNTO 0);
		lt                             : OUT STD_LOGIC;
		eq                             : OUT STD_LOGIC;
		gt                             : OUT STD_LOGIC;
		completeDAWU                   : OUT STD_LOGIC;
		completeDARU                   : OUT STD_LOGIC;
		completeAAU                    : OUT STD_LOGIC;
		--CSR and Interrupt inputs and outputs
		selCSR                         : IN  STD_LOGIC;
		machineExternalInterrupt       : IN  STD_LOGIC;
		machineTimerInterrupt          : IN  STD_LOGIC;
		machineSoftwareInterrupt       : IN  STD_LOGIC;
		userExternalInterrupt          : IN  STD_LOGIC;
		userTimerInterrupt             : IN  STD_LOGIC;
		userSoftwareInterrupt          : IN  STD_LOGIC;
		platformInterruptSignals       : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
		ldValueCSR                     : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);
		mipCCLdDisable                 : IN  STD_LOGIC;
		selImmCSR                      : IN  STD_LOGIC;
		selP1CSR                       : IN  STD_LOGIC;
		selReadWriteCSR                : IN  STD_LOGIC;
		clrCSR                         : IN  STD_LOGIC;
		setCSR                         : IN  STD_LOGIC;
		selPC_CSR                      : IN  STD_LOGIC;
		selTval_CSR                    : IN  STD_LOGIC;
		selMedeleg_CSR                 : IN  STD_LOGIC;
		selMideleg_CSR                 : IN  STD_LOGIC;
		selCCMip_CSR                   : IN  STD_LOGIC;
		selCause_CSR                   : IN  STD_LOGIC;
		selMepc_CSR                    : IN  STD_LOGIC;
		selInterruptAddressDirect      : IN  STD_LOGIC;
		selInterruptAddressVectored    : IN  STD_LOGIC;
		writeRegBank                   : IN  STD_LOGIC;
		dnCntCSR                       : IN  STD_LOGIC;
		upCntCSR                       : IN  STD_LOGIC;
		ldCntCSR                       : IN  STD_LOGIC;
		zeroCntCSR                     : IN  STD_LOGIC;
		ldFlags                        : IN  STD_LOGIC;
		zeroFlags                      : IN  STD_LOGIC;
		ldDelegation                   : IN  STD_LOGIC;
		ldMachine                      : IN  STD_LOGIC;
		ldUser                         : IN  STD_LOGIC;
		loadMieReg                     : IN  STD_LOGIC;
		loadMieUieField                : IN  STD_LOGIC;
		mirrorUser                     : IN  STD_LOGIC;
		machineStatusAlterationPreCSR  : IN  STD_LOGIC;
		userStatusAlterationPreCSR     : IN  STD_LOGIC;
		machineStatusAlterationPostCSR : IN  STD_LOGIC;
		userStatusAlterationPostCSR    : IN  STD_LOGIC;
		checkMisalignedDARU            : IN  STD_LOGIC;
		checkMisalignedDAWU            : IN  STD_LOGIC;
		selCSRAddrFromInst             : IN  STD_LOGIC;
		selRomAddress                  : IN  STD_LOGIC;
		ecallFlag                      : IN  STD_LOGIC;
		illegalInstrFlag               : IN  STD_LOGIC;
		instrMisalignedOut             : OUT STD_LOGIC;
		loadMisalignedOut              : OUT STD_LOGIC;
		storeMisalignedOut             : OUT STD_LOGIC;
		dividedByZeroOut               : OUT STD_LOGIC;
		validAccessCSR                 : OUT STD_LOGIC;
		readOnlyCSR                    : OUT STD_LOGIC;
		mirror                         : OUT STD_LOGIC;
		ldMieReg                       : OUT STD_LOGIC;
		ldMieUieField                  : OUT STD_LOGIC;
		interruptRaise                 : OUT STD_LOGIC;
		exceptionRaise                 : OUT STD_LOGIC;
		delegationMode                 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
		previousPRV                    : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
		modeTvec                       : OUT STD_LOGIC_VECTOR (1 DOWNTO 0));
	END	COMPONENT;
	-----------------------------------------------
	SIGNAL selPC                          : STD_LOGIC;
	SIGNAL selI4                          : STD_LOGIC;
	SIGNAL selP2                          : STD_LOGIC;
	SIGNAL selP1                          : STD_LOGIC;
	SIGNAL selJL                          : STD_LOGIC;
	SIGNAL selADR                         : STD_LOGIC;
	SIGNAL selPCJ                         : STD_LOGIC;
	SIGNAL selImm                         : STD_LOGIC;
	SIGNAL selAdd                         : STD_LOGIC;
	SIGNAL selI4PC                        : STD_LOGIC;
	SIGNAL selInc4pc                      : STD_LOGIC;
	SIGNAL selData                        : STD_LOGIC;
	SIGNAL selBSU                         : STD_LOGIC;
	SIGNAL selLLU                         : STD_LOGIC;
	SIGNAL selDARU                        : STD_LOGIC;
	SIGNAL selASU                         : STD_LOGIC;
	SIGNAL selAAU                         : STD_LOGIC;
	SIGNAL shr                            : STD_LOGIC;
	SIGNAL shl                            : STD_LOGIC;
	SIGNAL dataInstrBar                   : STD_LOGIC;
	SIGNAL writeRegFile                   : STD_LOGIC;
	SIGNAL addSubBar                      : STD_LOGIC;
	SIGNAL pass                           : STD_LOGIC;
	SIGNAL selAuipc                       : STD_LOGIC;
	SIGNAL comparedsignedunsignedbar      : STD_LOGIC;
	SIGNAL ldIR                           : STD_LOGIC;
	SIGNAL ldADR                          : STD_LOGIC;
	SIGNAL ldPC                           : STD_LOGIC;
	SIGNAL ldDr                           : STD_LOGIC;
	SIGNAL ldByteSigned                   : STD_LOGIC;
	SIGNAL ldHalfSigned                   : STD_LOGIC;
	SIGNAL load                           : STD_LOGIC;
	SIGNAL setOne                         : STD_LOGIC;
	SIGNAL setZero                        : STD_LOGIC;
	SIGNAL startDARU                      : STD_LOGIC;
	SIGNAL startDAWU                      : STD_LOGIC;
	SIGNAL completeDARU                   : STD_LOGIC;
	SIGNAL completeDAWU                   : STD_LOGIC;
	SIGNAL startMultiplyAAU               : STD_LOGIC;
	SIGNAL startDivideAAU                 : STD_LOGIC;
	SIGNAL completeAAU                    : STD_LOGIC;
	SIGNAL signedSigned                   : STD_LOGIC;
	SIGNAL signedUnsigned                 : STD_LOGIC;
	SIGNAL unsignedUnsigned               : STD_LOGIC;
	SIGNAL selAAL                         : STD_LOGIC;
	SIGNAL selAAH                         : STD_LOGIC;
	SIGNAL eq                             : STD_LOGIC;
	SIGNAL gt                             : STD_LOGIC;
	SIGNAL lt                             : STD_LOGIC;
	SIGNAL dataerror                      : STD_LOGIC;
	SIGNAL nBytes                         : STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL selLogic                       : STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL selShift                       : STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL muxCode                        : STD_LOGIC_VECTOR (11 DOWNTO 0);
	SIGNAL modeTvec                       : STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL previousPRV                    : STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL delegationMode                 : STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL IR                             : STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL selCSR                         : STD_LOGIC;
	SIGNAL interruptRaise                 : STD_LOGIC;
	SIGNAL mipCCLdDisable                 : STD_LOGIC;
	SIGNAL ldValueCSR                     : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL selImmCSR                      : STD_LOGIC;
	SIGNAL selReadWriteCSR                : STD_LOGIC;
	SIGNAL selP1CSR                       : STD_LOGIC;
	SIGNAL clrCSR                         : STD_LOGIC;
	SIGNAL setCSR                         : STD_LOGIC;
	SIGNAL selPC_CSR                      : STD_LOGIC;
	SIGNAL selCCMip_CSR                   : STD_LOGIC;
	SIGNAL selCause_CSR                   : STD_LOGIC;
	SIGNAL selMepc_CSR                    : STD_LOGIC;
	SIGNAL machineStatusAlterationPreCSR  : STD_LOGIC;
	SIGNAL userStatusAlterationPreCSR     : STD_LOGIC;
	SIGNAL machineStatusAlterationPostCSR : STD_LOGIC;
	SIGNAL userStatusAlterationPostCSR    : STD_LOGIC;
	SIGNAL writeRegBank                   : STD_LOGIC;
	SIGNAL dnCntCSR                       : STD_LOGIC;
	SIGNAL upCntCSR                       : STD_LOGIC;
	SIGNAL ldCntCSR                       : STD_LOGIC;
	SIGNAL zeroCntCSR                     : STD_LOGIC;
	SIGNAL ldFlags                        : STD_LOGIC;
	SIGNAL zeroFlags                      : STD_LOGIC;
	SIGNAL ldDelegation                   : STD_LOGIC;
	SIGNAL ldMachine                      : STD_LOGIC;
	SIGNAL ldUser                         : STD_LOGIC;
	SIGNAL loadMieReg                     : STD_LOGIC;
	SIGNAL loadMieUieField                : STD_LOGIC;
	SIGNAL mirrorUser                     : STD_LOGIC;
	SIGNAL selCSRAddrFromInst             : STD_LOGIC;
	SIGNAL selRomAddress                  : STD_LOGIC;
	SIGNAL validAccessCSR                 : STD_LOGIC;
	SIGNAL readOnlyCSR                    : STD_LOGIC;
	SIGNAL selInterruptAddressDirect      : STD_LOGIC;
	SIGNAL selInterruptAddressVectored    : STD_LOGIC;
	SIGNAL ecallFlag                      : STD_LOGIC;
	SIGNAL illegalInstrFlag               : STD_LOGIC;
	SIGNAL instrMisalignedOut             : STD_LOGIC;
	SIGNAL loadMisalignedOut              : STD_LOGIC;
	SIGNAL storeMisalignedOut             : STD_LOGIC;
	SIGNAL selTval_CSR                    : STD_LOGIC;
	SIGNAL exceptionRaise                 : STD_LOGIC;
	SIGNAL checkMisalignedDARU            : STD_LOGIC;
	SIGNAL checkMisalignedDAWU            : STD_LOGIC;
	SIGNAL dividedByZeroOut               : STD_LOGIC;
	SIGNAL mirror                         : STD_LOGIC;
	SIGNAL ldMieReg                       : STD_LOGIC;
	SIGNAL ldMieUieField                  : STD_LOGIC;
	SIGNAL selMedeleg_CSR                 : STD_LOGIC;
	SIGNAL selMideleg_CSR                 : STD_LOGIC;
BEGIN
	datapathAFTAB : aftab_datapath
		PORT MAP
		(
			clk                            => clk,
			rst                            => rst,
			writeRegFile                   => writeRegFile,
			setOne                         => setOne,
			setZero                        => setZero,
			ComparedSignedUnsignedBar      => ComparedSignedUnsignedBar,
			selPC                          => selPC,
			selI4                          => selI4,
			selAdd                         => selAdd,
			selJL                          => selJL,
			selADR                         => selADR,
			selPCJ                         => selPCJ,
			selInc4pc                      => selInc4pc,
			selBSU                         => selBSU,
			selLLU                         => selLLU,
			selASU                         => selASU,
			selAAU                         => selAAU,
			selDARU                        => selDARU,
			selP1                          => selP1,
			selP2                          => selP2,
			selImm                         => selImm,
			ldPC                           => ldPC,
			zeroPC                         => '0',
			ldADR                          => ldADR,
			zeroADR                        => '0',
			ldDR                           => ldDR,
			zeroDR                         => '0',
			ldIR                           => ldIR,
			zeroIR                         => '0',
			ldByteSigned                   => ldByteSigned,
			ldHalfSigned                   => ldHalfSigned,
			load                           => load,
			selShift                       => selShift,
			addSubBar                      => addSubBar,
			pass                           => pass,
			selAuipc                       => selAuipc,
			muxCode                        => muxCode,
			selLogic                       => selLogic,
			startDAWU                      => startDAWU,
			startDARU                      => startDARU,
			startMultiplyAAU               => startMultiplyAAU,
			startDivideAAU                 => startDivideAAU,
			signedSigned                   => signedSigned,
			signedUnsigned                 => signedUnsigned,
			unsignedUnsigned               => unsignedUnsigned,
			selAAL                         => selAAL,
			selAAH                         => selAAH,
			dataInstrBar                   => dataInstrBar,
			completeAAU                    => completeAAU,
			nBytes                         => nBytes,
			memReady                       => memReady,
			memDataIn                      => memDataIn,
			memDataOut                     => memDataOut,
			memAddrDAWU                    => memAddr,
			memAddrDARU                    => memAddr,
			writeMem                       => memWrite,
			readMem                        => memRead,
			IR                             => IR,
			lt                             => lt,
			eq                             => eq,
			gt                             => gt,
			completeDAWU                   => completeDAWU,
			completeDARU                   => completeDARU,
			selCSR                         => selCSR,
			machineExternalInterrupt       => machineExternalInterrupt,
			machineTimerInterrupt          => machineTimerInterrupt,
			machineSoftwareInterrupt       => machineSoftwareInterrupt,
			userExternalInterrupt          => userExternalInterrupt,
			userTimerInterrupt             => userTimerInterrupt,
			userSoftwareInterrupt          => userSoftwareInterrupt,
			platformInterruptSignals       => platformInterruptSignals,
			ldValueCSR                     => ldValueCSR,
			mipCCLdDisable                 => mipCCLdDisable,
			selImmCSR                      => selImmCSR,
			selP1CSR                       => selP1CSR,
			selReadWriteCSR                => selReadWriteCSR,
			clrCSR                         => clrCSR,
			setCSR                         => setCSR,
			selPC_CSR                      => selPC_CSR,
			selTval_CSR                    => selTval_CSR,
			selMedeleg_CSR                 => selMedeleg_CSR,
			selMideleg_CSR                 => selMideleg_CSR,
			selCCMip_CSR                   => selCCMip_CSR,
			selCause_CSR                   => selCause_CSR,
			selMepc_CSR                    => selMepc_CSR,
			selInterruptAddressDirect      => selInterruptAddressDirect,
			selInterruptAddressVectored    => selInterruptAddressVectored,
			writeRegBank                   => writeRegBank,
			dnCntCSR                       => dnCntCSR,
			upCntCSR                       => upCntCSR,
			ldCntCSR                       => ldCntCSR,
			zeroCntCSR                     => zeroCntCSR,
			ldFlags                        => ldFlags,
			zeroFlags                      => zeroFlags,
			ldDelegation                   => ldDelegation,
			ldMachine                      => ldMachine,
			ldUser                         => ldUser,
			loadMieReg                     => loadMieReg,
			loadMieUieField                => loadMieUieField,
			mirrorUser                     => mirrorUser,
			machineStatusAlterationPreCSR  => machineStatusAlterationPreCSR,
			userStatusAlterationPreCSR     => userStatusAlterationPreCSR,
			machineStatusAlterationPostCSR => machineStatusAlterationPostCSR,
			userStatusAlterationPostCSR    => userStatusAlterationPostCSR,
			checkMisalignedDARU            => checkMisalignedDARU,
			checkMisalignedDAWU            => checkMisalignedDAWU,
			selCSRAddrFromInst             => selCSRAddrFromInst,
			selRomAddress                  => selRomAddress,
			ecallFlag                      => ecallFlag,
			illegalInstrFlag               => illegalInstrFlag,
			instrMisalignedOut             => instrMisalignedOut,
			loadMisalignedOut              => OPEN,
			storeMisalignedOut             => OPEN,
			dividedByZeroOut               => dividedByZeroOut,
			validAccessCSR                 => validAccessCSR,
			readOnlyCSR                    => readOnlyCSR,
			mirror                         => mirror,
			ldMieReg                       => ldMieReg,
			ldMieUieField                  => ldMieUieField,
			interruptRaise                 => interruptRaise,
			exceptionRaise                 => exceptionRaise,
			delegationMode                 => delegationMode,
			previousPRV                    => previousPRV,
			modeTvec                       => modeTvec
		);
	controllerAFTAB : aftab_controller
		PORT
	MAP(
	clk                            => clk,
	rst                            => rst,
	completeDARU                   => completeDARU,
	completeDAWU                   => completeDAWU,
	completeAAU                    => completeAAU,
	lt                             => lt,
	eq                             => eq,
	gt                             => gt,
	IR                             => IR,
	muxCode                        => muxCode,
	nBytes                         => nBytes,
	selLogic                       => selLogic,
	selShift                       => selShift,
	selPC                          => selPC,
	selI4                          => selI4,
	selP1                          => selP1,
	selP2                          => selP2,
	selJL                          => selJL,
	selADR                         => selADR,
	selPCJ                         => selPCJ,
	selImm                         => selImm,
	selAdd                         => selAdd,
	selInc4PC                      => selInc4PC,
	selBSU                         => selBSU,
	selLLU                         => selLLU,
	selASU                         => selASU,
	selAAU                         => selAAU,
	selDARU                        => selDARU,
	dataInstrBar                   => dataInstrBar,
	writeRegFile                   => writeRegFile,
	addSubBar                      => addSubBar,
	pass                           => pass,
	selAuipc                       => selAuipc,
	comparedsignedunsignedbar      => comparedsignedunsignedbar,
	ldIR                           => ldIR,
	ldADR                          => ldADR,
	ldPC                           => ldPC,
	ldDr                           => ldDr,
	ldByteSigned                   => ldByteSigned,
	ldHalfSigned                   => ldHalfSigned,
	load                           => load,
	setOne                         => setOne,
	setZero                        => setZero,
	startDARU                      => startDARU,
	startDAWU                      => startDAWU,
	startMultiplyAAU               => startMultiplyAAU,
	startDivideAAU                 => startDivideAAU,
	signedSigned                   => signedSigned,
	signedUnsigned                 => signedUnsigned,
	unsignedUnsigned               => unsignedUnsigned,
	selAAL                         => selAAL,
	selAAH                         => selAAH,
	interruptRaise                 => interruptRaise,
	exceptionRaise                 => exceptionRaise,
	ecallFlag                      => ecallFlag,
	illegalInstrFlag               => illegalInstrFlag,
	instrMisalignedOut             => instrMisalignedOut,
	loadMisalignedOut              => '0',
	storeMisalignedOut             => '0',
	dividedByZeroOut               => dividedByZeroOut,
	validAccessCSR                 => validAccessCSR,
	readOnlyCSR                    => readOnlyCSR,
	mirror                         => mirror,
	ldMieReg                       => ldMieReg,
	ldMieUieField                  => ldMieUieField,
	delegationMode                 => delegationMode,
	previousPRV                    => previousPRV,
	modeTvec                       => modeTvec,
	mipCCLdDisable                 => mipCCLdDisable,
	selCCMip_CSR                   => selCCMip_CSR,
	selCause_CSR                   => selCause_CSR,
	selPC_CSR                      => selPC_CSR,
	selTval_CSR                    => selTval_CSR,
	selMedeleg_CSR                 => selMedeleg_CSR,
	selMideleg_CSR                 => selMideleg_CSR,
	ldValueCSR                     => ldValueCSR,
	ldCntCSR                       => ldCntCSR,
	dnCntCSR                       => dnCntCSR,
	upCntCSR                       => upCntCSR,
	ldFlags                        => ldFlags,
	zeroFlags                      => zeroFlags,
	ldDelegation                   => ldDelegation,
	ldMachine                      => ldMachine,
	ldUser                         => ldUser,
	loadMieReg                     => loadMieReg,
	loadMieUieField                => loadMieUieField,
	mirrorUser                     => mirrorUser,
	selCSR                         => selCSR,
	selP1CSR                       => selP1CSR,
	selReadWriteCSR                => selReadWriteCSR,
	selImmCSR                      => selImmCSR,
	setCSR                         => setCSR,
	clrCSR                         => clrCSR,
	writeRegBank                   => writeRegBank,
	selCSRAddrFromInst             => selCSRAddrFromInst,
	selRomAddress                  => selRomAddress,
	selMepc_CSR                    => selMepc_CSR,
	selInterruptAddressDirect      => selInterruptAddressDirect,
	selInterruptAddressVectored    => selInterruptAddressVectored,
	checkMisalignedDARU            => checkMisalignedDARU,
	checkMisalignedDAWU            => checkMisalignedDAWU,
	machineStatusAlterationPreCSR  => machineStatusAlterationPreCSR,
	userStatusAlterationPreCSR     => userStatusAlterationPreCSR,
	machineStatusAlterationPostCSR => machineStatusAlterationPostCSR,
	userStatusAlterationPostCSR    => userStatusAlterationPostCSR,
	zeroCntCSR                     => zeroCntCSR
	);
	interruptProcessing <= mipCCLdDisable;
END ARCHITECTURE procedural;
