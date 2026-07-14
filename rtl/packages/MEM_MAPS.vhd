library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;
USE std.textio.ALL;
USE work.my_pack_v2.ALL;
 

package MEM_MAPS	IS
	
	----------------------------------------------------------
	----------------------------------------------------------
	--						ATTENTION						--
	--														--
	--		Change the Interrupt handler code in the 		--
	--		Assembler's file too if you are changing		--
	--		the memory map  info  of  the  Interrupt		--
	--		Handler Unit.									--
	----------------------------------------------------------
	----------------------------------------------------------
	
	--	Memory Map Information
	------	Singular 
	CONSTANT	SING_MEMx_BASE_ADDRESS			:	INTEGER	:=		my_to_uint(X"00000000");	--	Base Address of memory of the system	(16K	Words)
	CONSTANT	SING_DMAx_BASE_ADDRESS			:	INTEGER	:=		my_to_uint(X"FFFF0000");	--	Base Address of DMA Control Box			( 4		Words)
	CONSTANT	SING_MPDR_BASE_ADDRESS			:	INTEGER	:=		my_to_uint(X"FFFF0010");	--	Base Address of MPDR Control Box		( 4		Words)
	CONSTANT	SING_TIMR_BASE_ADDRESS			:	INTEGER	:=		my_to_uint(X"FFFF0020");	--	Base Address of Timer Controller		(16		Words)
	CONSTANT	SING_DMEV_BASE_ADDRESS			:	INTEGER	:=		my_to_uint(X"FFFF0060");	--	Base Address of DMA's Event Counter		(16		Words)
	CONSTANT	SING_MPEV_BASE_ADDRESS			:	INTEGER	:=		my_to_uint(X"FFFF00A0");	--	Base Address of MPDR's Event Counter	(16		Words)
	CONSTANT	SING_COST_BASE_ADDRESS			:	INTEGER	:=		my_to_uint(X"FFFF00E0");	--	Base Address of Control & Statue Box	( 4		Words)
	CONSTANT	SING_TRxU_BASE_ADDRESS			:	INTEGER	:=		my_to_uint(X"FFFF00F0");	--	Base Address of Interrupt handler		( 4		Words)
	CONSTANT	SING_INTH_BASE_ADDRESS			:	INTEGER	:=		my_to_uint(X"FFFF0100");	--	Base Address of Interrupt handler		( 8		Words)
	CONSTANT	SING_PLNR_BASE_ADDRESS			:	INTEGER	:=		my_to_uint(X"FFFF0200");	--	Base Address of Plannar Event
	
	------	Plannar Offset
	CONSTANT	PLAN_PLAN_OFFSET_ADDRESS		:	INTEGER	:=		my_to_uint(X"100");			-- Offset of Each Plane						(64		Words)
	CONSTANT	PLAN_CONF_OFFSET_ADDRESS		:	INTEGER	:=		my_to_uint(X"000");			-- Offset of Config holder					(16		Words)
	CONSTANT	PLAN_INIT_OFFSET_ADDRESS		:	INTEGER	:=		my_to_uint(X"040");			-- Offset of initiator						( 4		Words)
	CONSTANT	PLAN_PECO_OFFSET_ADDRESS		:	INTEGER	:=		my_to_uint(X"050");			-- Offset of PE Control 					(16		Words)
	CONSTANT	PLAN_EVNT_OFFSET_ADDRESS		:	INTEGER	:=		my_to_uint(X"090");			-- Offset of PE Control 					(16		Words)
	CONSTANT	PLAN_ENDx_OFFSET_ADDRESS		:	INTEGER	:=		my_to_uint(X"0D0");			-- Next Address
	
end MEM_MAPS;

package body MEM_MAPS	IS
	
end MEM_MAPS;






