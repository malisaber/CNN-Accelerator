#pragma once

//////////////////////////////
//	Peripheral Address Map	//
//////////////////////////////

#define C_PERIPHERAL_REG_BASE_ADD		0XFFFF0000
#define C_PERIPHERAL_PLAN0_BASE_ADD		0XFFFF0000

	/*--------------------------------------------------------------------------
	----		
	----		COMPONENTs	MEMORY MAP	AND BIT POSITIONNING 
	----		
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--							  MAIN	MEMORY
	--------------------------------------------------------------------------
	--		BASE_ADDRESS_MEMx	+	X"0000"	->	(X"00000000")	:	
	--								  ||||						:	C
	--								  ||||						:	O
	--								  ||||						:	D
	--								  ||||						:	E
	--								  ||||						:	
	--								  ||||						:	&
	--								  ||||						:	
	--								  ||||						:	D
	--								  ||||						:	A
	--								  ||||						:	T
	--								  ||||						:	A
	--		BASE_ADDRESS_MEMx	+	X"3FFF"	->	(X"00000000")	:	
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--						MEMORY NODE DMA CONTROL							--
	--------------------------------------------------------------------------
	--		BASE_ADDRESS_DMAx	+	X"00"		->	(X"FFFF0000")	:	DMA	R (TAG & Idx)
	--		BASE_ADDRESS_DMAx	+	X"04"		->	(X"FFFF0004")	:	DMA	W (TAG & Idx)
	--		BASE_ADDRESS_DMAx	+	X"08"		->	(X"FFFF0008")	:	DMA	TR Count
	--		BASE_ADDRESS_DMAx	+	X"0C"		->	(X"FFFF000C")	:	CONTROL
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--								TIMERs									--
	--------------------------------------------------------------------------
	--		BASE_ADDRESS_TIMR	+	X"00"		->	(X"FFFF0010")	:	TIMER	0	CNT				(WO)
	--		BASE_ADDRESS_TIMR	+	X"04"		->	(X"FFFF0014")	:	TIMER	0	VAL				(RO)
	--		BASE_ADDRESS_TIMR	+	X"08"		->	(X"FFFF0018")	:	TIMER	1	CNT				(WO)
	--		BASE_ADDRESS_TIMR	+	X"0C"		->	(X"FFFF001C")	:	TIMER	1	VAL				(RO)
	--		BASE_ADDRESS_TIMR	+	X"10"		->	(X"FFFF0020")	:	TIMER	2	CNT				(WO)
	--		BASE_ADDRESS_TIMR	+	X"14"		->	(X"FFFF0024")	:	TIMER	2	VAL				(RO)
	--		BASE_ADDRESS_TIMR	+	X"18"		->	(X"FFFF0028")	:	TIMER	3	CNT				(WO)
	--		BASE_ADDRESS_TIMR	+	X"1C"		->	(X"FFFF002C")	:	TIMER	3	VAL				(RO)
	--		BASE_ADDRESS_TIMR	+	X"20"		->	(X"FFFF0030")	:	TIMER	4	CNT				(WO)
	--		BASE_ADDRESS_TIMR	+	X"24"		->	(X"FFFF0034")	:	TIMER	4	VAL				(RO)
	--		BASE_ADDRESS_TIMR	+	X"28"		->	(X"FFFF0038")	:	TIMER	5	CNT				(WO)
	--		BASE_ADDRESS_TIMR	+	X"2C"		->	(X"FFFF003C")	:	TIMER	5	VAL				(RO)
	--		BASE_ADDRESS_TIMR	+	X"30"		->	(X"FFFF0040")	:	TIMER	6	CNT				(WO)
	--		BASE_ADDRESS_TIMR	+	X"34"		->	(X"FFFF0044")	:	TIMER	6	VAL				(RO)
	--		BASE_ADDRESS_TIMR	+	X"38"		->	(X"FFFF0048")	:	TIMER	7	CNT				(WO)
	--		BASE_ADDRESS_TIMR	+	X"3C"		->	(X"FFFF004C")	:	TIMER	7	VAL				(RO)
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--							EVENT	COUNTERs							--
	--------------------------------------------------------------------------
	--		BASE_ADDRESS_EVNT	+	X"00"		->	(X"FFFF0050")	:	DMA_Ready(1,1)
	--		BASE_ADDRESS_EVNT	+	X"04"		->	(X"FFFF0054")	:	DMA_Ready(1,2)
	--		BASE_ADDRESS_EVNT	+	X"08"		->	(X"FFFF0058")	:	DMA_Ready(1,3)
	--		BASE_ADDRESS_EVNT	+	X"0C"		->	(X"FFFF005C")	:	DMA_Ready(1,4)
	--		BASE_ADDRESS_EVNT	+	X"10"		->	(X"FFFF0060")	:	DMA_Ready(2,1)
	--		BASE_ADDRESS_EVNT	+	X"14"		->	(X"FFFF0064")	:	DMA_Ready(2,2)
	--		BASE_ADDRESS_EVNT	+	X"18"		->	(X"FFFF0068")	:	DMA_Ready(2,3)
	--		BASE_ADDRESS_EVNT	+	X"1C"		->	(X"FFFF006C")	:	DMA_Ready(2,4)
	--		BASE_ADDRESS_EVNT	+	X"20"		->	(X"FFFF0070")	:	DMA_Ready(3,1)
	--		BASE_ADDRESS_EVNT	+	X"24"		->	(X"FFFF0074")	:	DMA_Ready(3,2)
	--		BASE_ADDRESS_EVNT	+	X"28"		->	(X"FFFF0078")	:	DMA_Ready(3,3)
	--		BASE_ADDRESS_EVNT	+	X"2C"		->	(X"FFFF007C")	:	DMA_Ready(3,4)
	--		BASE_ADDRESS_EVNT	+	X"30"		->	(X"FFFF0080")	:	DMA_Ready(4,1)
	--		BASE_ADDRESS_EVNT	+	X"34"		->	(X"FFFF0084")	:	DMA_Ready(4,2)
	--		BASE_ADDRESS_EVNT	+	X"38"		->	(X"FFFF0088")	:	DMA_Ready(4,3)
	--		BASE_ADDRESS_EVNT	+	X"3C"		->	(X"FFFF008C")	:	DMA_Ready(4,4)
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--							CONTROL REGISTER							--
	--------------------------------------------------------------------------
	--		BASE_ADDRESS_COST	+	X"00"		=>	(X"FFFF0090")	:	Status And Control
	--		BASE_ADDRESS_COST	+	X"04"		=>	(X"FFFF0094")	:	RESERVED
	--		BASE_ADDRESS_COST	+	X"08"		=>	(X"FFFF0098")	:	RESERVED
	--		BASE_ADDRESS_COST	+	X"0C"		=>	(X"FFFF009C")	:	RESERVED
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--							INTERRUPT	HANDLER							--
	--------------------------------------------------------------------------
	--		BASE_ADDRESS_INTH	+	X"00"		=>	(X"FFFF00A0")	:	INT ENABLE	0
	--		BASE_ADDRESS_INTH	+	X"04"		=>	(X"FFFF00A4")	:	INT ENABLE	1
	--		BASE_ADDRESS_INTH	+	X"08"		=>	(X"FFFF00A8")	:	INT ENABLE	2
	--		BASE_ADDRESS_INTH	+	X"0C"		=>	(X"FFFF00AC")	:	INT ENABLE	3
	--		BASE_ADDRESS_INTH	+	X"10"		=>	(X"FFFF00B0")	:	INT ENABLE	4
	--		BASE_ADDRESS_INTH	+	X"14"		=>	(X"FFFF00B4")	:	INT ENABLE	5
	--		BASE_ADDRESS_INTH	+	X"18"		=>	(X"FFFF00B8")	:	INT ENABLE	6
	--		BASE_ADDRESS_INTH	+	X"1C"		=>	(X"FFFF00BC")	:	INT ENABLE	7
	--		BASE_ADDRESS_INTH	+	X"20"		=>	(X"FFFF00C0")	:	INT ENABLE	8
	--		BASE_ADDRESS_INTH	+	X"24"		=>	(X"FFFF00C4")	:	INT ADDRESS
	--		BASE_ADDRESS_INTH	+	X"28"		=>	(X"FFFF00C8")	:	INT	ACKNOWLEDGE
	--		BASE_ADDRESS_INTH	+	X"2C"		=>	(X"FFFF00CC")	:	RESERVED
	--------------------------------------------------------------------------
	--		|‾‾‾‾‾‾‾‾‾‾‾‾‾‾\	|‾|				|‾‾‾‾‾‾‾‾‾‾‾‾‾|		|‾‾‾\			  |‾|		|‾‾‾‾‾‾‾‾‾‾‾‾‾|		|‾‾‾‾‾‾‾‾‾‾‾‾‾‾\			
	--		| |‾‾‾‾‾‾‾‾‾‾\ |	| |				| |‾‾‾‾‾‾‾‾‾| |		| |\ \		      | |       | |‾‾‾‾‾‾‾‾‾| |     | |‾‾‾‾‾‾‾‾‾‾\ |			
	--		| |			 | |	| |				| |			| |		| |	\ \			  | |		| |			| |		| |			 | |			
	--		| |			 | |	| |				| |			| |		| |	 \ \		  | |		| |			| |		| |			 | |			
	--		| |			 | |	| |				| |			| |		| |	  \	\		  | |		| |			| |		| |			 | |			
	--		| |			 | |	| |				| |			| |		| |	   \ \		  | |		| |			| |		| |			 | |			
	--		| |__________/ |	| |				| |_________| |		| |		\ \		  | |		| |_________| |		| |__________/ |			
	--		| |____________/	| |				| |_________| |		| |		 \ \	  | |		| |_________| |		| | ___________/			
	--		| |					| |				| |			| |		| |		  \	\	  | |		| |			| |		| |\ \	  					
	--		| |					| |				| |			| |		| |		   \ \	  | |		| |			| |		| | \ \	  					
	--		| |					| |				| |			| |		| |			\ \	  | |		| |			| |		| |  \ \	  				
	--		| |					| |				| |			| |		| |			 \ \  | |		| |			| |		| |	  \ \  					
	--		| |					| |				| |			| |		| |			  \	\ | |		| |			| |		| |	   \ \ 					
	--		| |					| |_________	| |			| |		| |			   \ \| |		| |			| |		| |	    \ \					
	--		|_|					|___________|	|_|			|_|		|_|				\___|		|_|			|_|		|_|	     \_\	
	--------------------------------------------------------------------------
	--							Planar	CSR		Box							--
	--------------------------------------------------------------------------
	--
	--						CONFIGURATION	HILDER	
	--
	--		BASE_ADDRESS_PLAN	+	X"000"		->		HIGH	PE(1,1)
	--		BASE_ADDRESS_PLAN	+	X"004"		->		LOW		PE(1,1)
	--		BASE_ADDRESS_PLAN	+	X"008"		->		HIGH	PE(1,2)
	--		BASE_ADDRESS_PLAN	+	X"00C"		->		LOW		PE(1,2)
	--		BASE_ADDRESS_PLAN	+	X"010"		->		HIGH	PE(1,3)
	--		BASE_ADDRESS_PLAN	+	X"014"		->		LOW		PE(1,3)
	--		BASE_ADDRESS_PLAN	+	X"018"		->		HIGH	PE(1,4)
	--		BASE_ADDRESS_PLAN	+	X"01C"		->		LOW		PE(1,4)
	--		BASE_ADDRESS_PLAN	+	X"020"		->		HIGH	PE(2,1)
	--		BASE_ADDRESS_PLAN	+	X"024"		->		LOW		PE(2,1)
	--		BASE_ADDRESS_PLAN	+	X"028"		->		HIGH	PE(2,2)
	--		BASE_ADDRESS_PLAN	+	X"02C"		->		LOW		PE(2,2)
	--		BASE_ADDRESS_PLAN	+	X"030"		->		HIGH	PE(2,3)
	--		BASE_ADDRESS_PLAN	+	X"034"		->		LOW		PE(2,3)
	--		BASE_ADDRESS_PLAN	+	X"038"		->		HIGH	PE(2,4)
	--		BASE_ADDRESS_PLAN	+	X"03C"		->		LOW		PE(2,4)
	--		BASE_ADDRESS_PLAN	+	X"040"		->		HIGH	PE(3,1)
	--		BASE_ADDRESS_PLAN	+	X"044"		->		LOW		PE(3,1)
	--		BASE_ADDRESS_PLAN	+	X"048"		->		HIGH	PE(3,2)
	--		BASE_ADDRESS_PLAN	+	X"04C"		->		LOW		PE(3,2)
	--		BASE_ADDRESS_PLAN	+	X"050"		->		HIGH	PE(3,3)
	--		BASE_ADDRESS_PLAN	+	X"054"		->		LOW		PE(3,3)
	--		BASE_ADDRESS_PLAN	+	X"058"		->		HIGH	PE(3,4)
	--		BASE_ADDRESS_PLAN	+	X"05C"		->		LOW		PE(3,4)
	--		BASE_ADDRESS_PLAN	+	X"060"		->		HIGH	PE(4,1)
	--		BASE_ADDRESS_PLAN	+	X"064"		->		LOW		PE(4,1)
	--		BASE_ADDRESS_PLAN	+	X"068"		->		HIGH	PE(4,2)
	--		BASE_ADDRESS_PLAN	+	X"06C"		->		LOW		PE(4,2)
	--		BASE_ADDRESS_PLAN	+	X"070"		->		HIGH	PE(4,3)
	--		BASE_ADDRESS_PLAN	+	X"074"		->		LOW		PE(4,3)
	--		BASE_ADDRESS_PLAN	+	X"078"		->		HIGH	PE(4,4)
	--		BASE_ADDRESS_PLAN	+	X"07C"		->		LOW		PE(4,4)
	--
	--							PE	INITIATOR
	--
	--		BASE_ADDRESS_PLAN	+	X"090"		->		Store Agent BIASes Value	(WO)
	--		BASE_ADDRESS_PLAN	+	X"094"		->		Store Agent BIASes Control	(WO)
	--		BASE_ADDRESS_PLAN	+	X"098"		->		Address Point				(WO)
	--		BASE_ADDRESS_PLAN	+	X"09C"		->		Address Point Control		(WO)
	--
	--							PE CONTROL
	--
	--		BASE_ADDRESS_PLAN	+	X"0B0"		->		PE(1,1)
	--		BASE_ADDRESS_PLAN	+	X"0B4"		->		PE(1,2)
	--		BASE_ADDRESS_PLAN	+	X"0B8"		->		PE(1,3)
	--		BASE_ADDRESS_PLAN	+	X"0BC"		->		PE(1,4)
	--		BASE_ADDRESS_PLAN	+	X"0C0"		->		PE(2,1)
	--		BASE_ADDRESS_PLAN	+	X"0C4"		->		PE(2,2)
	--		BASE_ADDRESS_PLAN	+	X"0C8"		->		PE(2,3)
	--		BASE_ADDRESS_PLAN	+	X"0CC"		->		PE(2,4)
	--		BASE_ADDRESS_PLAN	+	X"0D0"		->		PE(3,1)
	--		BASE_ADDRESS_PLAN	+	X"0D4"		->		PE(3,2)
	--		BASE_ADDRESS_PLAN	+	X"0D8"		->		PE(3,3)
	--		BASE_ADDRESS_PLAN	+	X"0DC"		->		PE(3,4)
	--		BASE_ADDRESS_PLAN	+	X"0E0"		->		PE(4,1)
	--		BASE_ADDRESS_PLAN	+	X"0E4"		->		PE(4,2)
	--		BASE_ADDRESS_PLAN	+	X"0E8"		->		PE(4,3)
	--		BASE_ADDRESS_PLAN	+	X"0EC"		->		PE(4,4)
	--
	--							EVENT	COUNTERs
	--
	--		BASE_ADDRESS_PLAN	+	X"100"		->		PEs_Done(1,1)
	--		BASE_ADDRESS_PLAN	+	X"104"		->		PEs_Done(1,2)
	--		BASE_ADDRESS_PLAN	+	X"108"		->		PEs_Done(1,3)
	--		BASE_ADDRESS_PLAN	+	X"10C"		->		PEs_Done(1,4)
	--		BASE_ADDRESS_PLAN	+	X"110"		->		PEs_Done(2,1)
	--		BASE_ADDRESS_PLAN	+	X"114"		->		PEs_Done(2,2)
	--		BASE_ADDRESS_PLAN	+	X"118"		->		PEs_Done(2,3)
	--		BASE_ADDRESS_PLAN	+	X"11C"		->		PEs_Done(2,4)
	--		BASE_ADDRESS_PLAN	+	X"120"		->		PEs_Done(3,1)
	--		BASE_ADDRESS_PLAN	+	X"124"		->		PEs_Done(3,2)
	--		BASE_ADDRESS_PLAN	+	X"128"		->		PEs_Done(3,3)
	--		BASE_ADDRESS_PLAN	+	X"12C"		->		PEs_Done(3,4)
	--		BASE_ADDRESS_PLAN	+	X"130"		->		PEs_Done(4,1)
	--		BASE_ADDRESS_PLAN	+	X"134"		->		PEs_Done(4,2)
	--		BASE_ADDRESS_PLAN	+	X"138"		->		PEs_Done(4,3)
	--		BASE_ADDRESS_PLAN	+	X"13C"		->		PEs_Done(4,4)
	--		BASE_ADDRESS_PLAN	+	X"140"		->		STA_Done(1,1)
	--		BASE_ADDRESS_PLAN	+	X"144"		->		STA_Done(1,2)
	--		BASE_ADDRESS_PLAN	+	X"148"		->		STA_Done(1,3)
	--		BASE_ADDRESS_PLAN	+	X"14C"		->		STA_Done(1,4)
	--		BASE_ADDRESS_PLAN	+	X"150"		->		STA_Done(2,1)
	--		BASE_ADDRESS_PLAN	+	X"154"		->		STA_Done(2,2)
	--		BASE_ADDRESS_PLAN	+	X"158"		->		STA_Done(2,3)
	--		BASE_ADDRESS_PLAN	+	X"15C"		->		STA_Done(2,4)
	--		BASE_ADDRESS_PLAN	+	X"160"		->		STA_Done(3,1)
	--		BASE_ADDRESS_PLAN	+	X"164"		->		STA_Done(3,2)
	--		BASE_ADDRESS_PLAN	+	X"168"		->		STA_Done(3,3)
	--		BASE_ADDRESS_PLAN	+	X"16C"		->		STA_Done(3,4)
	--		BASE_ADDRESS_PLAN	+	X"170"		->		STA_Done(4,1)
	--		BASE_ADDRESS_PLAN	+	X"174"		->		STA_Done(4,2)
	--		BASE_ADDRESS_PLAN	+	X"178"		->		STA_Done(4,3)
	--		BASE_ADDRESS_PLAN	+	X"17C"		->		STA_Done(4,4)
	--		BASE_ADDRESS_PLAN	+	X"180"		->		UPA_Done(1,1)
	--		BASE_ADDRESS_PLAN	+	X"184"		->		UPA_Done(1,2)
	--		BASE_ADDRESS_PLAN	+	X"188"		->		UPA_Done(1,3)
	--		BASE_ADDRESS_PLAN	+	X"18C"		->		UPA_Done(1,4)
	--		BASE_ADDRESS_PLAN	+	X"190"		->		UPA_Done(2,1)
	--		BASE_ADDRESS_PLAN	+	X"194"		->		UPA_Done(2,2)
	--		BASE_ADDRESS_PLAN	+	X"198"		->		UPA_Done(2,3)
	--		BASE_ADDRESS_PLAN	+	X"19C"		->		UPA_Done(2,4)
	--		BASE_ADDRESS_PLAN	+	X"1A0"		->		UPA_Done(3,1)
	--		BASE_ADDRESS_PLAN	+	X"1A4"		->		UPA_Done(3,2)
	--		BASE_ADDRESS_PLAN	+	X"1A8"		->		UPA_Done(3,3)
	--		BASE_ADDRESS_PLAN	+	X"1AC"		->		UPA_Done(3,4)
	--		BASE_ADDRESS_PLAN	+	X"1B0"		->		UPA_Done(4,1)
	--		BASE_ADDRESS_PLAN	+	X"1B4"		->		UPA_Done(4,2)
	--		BASE_ADDRESS_PLAN	+	X"1B8"		->		UPA_Done(4,3)
	--		BASE_ADDRESS_PLAN	+	X"1BC"		->		UPA_Done(4,4)
	--------------------------------------------------------------------------*/


/*******	DMAs CONTROL	*******/
volatile unsigned int* const C_PERIPHERAL_REG_DMA_READ_ADDRESS							= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X000);
volatile unsigned int* const C_PERIPHERAL_REG_DMA_WRITE_ADDRESS							= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X004);
volatile unsigned int* const C_PERIPHERAL_REG_DMA_TRANS_COUNT							= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X008);
volatile unsigned int* const C_PERIPHERAL_REG_DMA_CONTROL								= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X00C);
		
		
		
/*******	TIMER CONTROL	*******/		
volatile unsigned int* const C_PERIPHERAL_REG_TIMER_0_CONTROL							= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X010);
volatile unsigned int* const C_PERIPHERAL_REG_TIMER_0_VALUE								= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X014);
volatile unsigned int* const C_PERIPHERAL_REG_TIMER_1_CONTROL							= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X018);
volatile unsigned int* const C_PERIPHERAL_REG_TIMER_1_VALUE								= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X01C);
volatile unsigned int* const C_PERIPHERAL_REG_TIMER_2_CONTROL							= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X020);
volatile unsigned int* const C_PERIPHERAL_REG_TIMER_2_VALUE								= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X024);
volatile unsigned int* const C_PERIPHERAL_REG_TIMER_3_CONTROL							= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X028);
volatile unsigned int* const C_PERIPHERAL_REG_TIMER_3_VALUE								= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X02C);
volatile unsigned int* const C_PERIPHERAL_REG_TIMER_4_CONTROL							= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X030);
volatile unsigned int* const C_PERIPHERAL_REG_TIMER_4_VALUE								= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X034);
volatile unsigned int* const C_PERIPHERAL_REG_TIMER_5_CONTROL							= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X038);
volatile unsigned int* const C_PERIPHERAL_REG_TIMER_5_VALUE								= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X03C);
volatile unsigned int* const C_PERIPHERAL_REG_TIMER_6_CONTROL							= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X040);
volatile unsigned int* const C_PERIPHERAL_REG_TIMER_6_VALUE								= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X044);
volatile unsigned int* const C_PERIPHERAL_REG_TIMER_7_CONTROL							= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X048);
volatile unsigned int* const C_PERIPHERAL_REG_TIMER_7_VALUE								= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X04C);
		
		
		
/*******	EVENT COUNTER	*******/		
volatile unsigned int* const C_PERIPHERAL_REG_EVENT_COUNTER_DMA_0_DONE					= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X050);
volatile unsigned int* const C_PERIPHERAL_REG_EVENT_COUNTER_DMA_1_DONE					= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X054);
volatile unsigned int* const C_PERIPHERAL_REG_EVENT_COUNTER_DMA_2_DONE					= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X058);
volatile unsigned int* const C_PERIPHERAL_REG_EVENT_COUNTER_DMA_3_DONE					= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X05C);
volatile unsigned int* const C_PERIPHERAL_REG_EVENT_COUNTER_DMA_4_DONE					= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X060);
volatile unsigned int* const C_PERIPHERAL_REG_EVENT_COUNTER_DMA_5_DONE					= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X064);
volatile unsigned int* const C_PERIPHERAL_REG_EVENT_COUNTER_DMA_6_DONE					= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X068);
volatile unsigned int* const C_PERIPHERAL_REG_EVENT_COUNTER_DMA_7_DONE					= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X06C);
volatile unsigned int* const C_PERIPHERAL_REG_EVENT_COUNTER_DMA_8_DONE					= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X070);
volatile unsigned int* const C_PERIPHERAL_REG_EVENT_COUNTER_DMA_9_DONE					= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X074);
volatile unsigned int* const C_PERIPHERAL_REG_EVENT_COUNTER_DMA_10_DONE					= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X078);
volatile unsigned int* const C_PERIPHERAL_REG_EVENT_COUNTER_DMA_11_DONE					= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X07C);
volatile unsigned int* const C_PERIPHERAL_REG_EVENT_COUNTER_DMA_12_DONE					= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X080);
volatile unsigned int* const C_PERIPHERAL_REG_EVENT_COUNTER_DMA_13_DONE					= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X084);
volatile unsigned int* const C_PERIPHERAL_REG_EVENT_COUNTER_DMA_14_DONE					= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X088);
volatile unsigned int* const C_PERIPHERAL_REG_EVENT_COUNTER_DMA_15_DONE					= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X08C);
		
		
/*******	CONTROL_REGISTER	*******/		
volatile unsigned int* const C_PERIPHERAL_REG_CONTROL_REGISTE							= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X090);
		
		
/*******	INTERRUPT HANDLER	*******/		
volatile unsigned int* const C_PERIPHERAL_REG_INTERRUPT_ENABLE_0						= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X0A0);
volatile unsigned int* const C_PERIPHERAL_REG_INTERRUPT_ENABLE_1						= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X0A4);
volatile unsigned int* const C_PERIPHERAL_REG_INTERRUPT_ENABLE_2						= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X0A8);
volatile unsigned int* const C_PERIPHERAL_REG_INTERRUPT_ENABLE_3						= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X0AC);
volatile unsigned int* const C_PERIPHERAL_REG_INTERRUPT_ENABLE_4						= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X0B0);
volatile unsigned int* const C_PERIPHERAL_REG_INTERRUPT_ENABLE_5						= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X0B4);
volatile unsigned int* const C_PERIPHERAL_REG_INTERRUPT_ENABLE_6						= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X0B8);
volatile unsigned int* const C_PERIPHERAL_REG_INTERRUPT_ENABLE_7						= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X0BC);
volatile unsigned int* const C_PERIPHERAL_REG_INTERRUPT_ENABLE_8						= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X0C0);
volatile unsigned int* const C_PERIPHERAL_REG_INTERRUPT_ADDRESS							= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X0C4);
volatile unsigned int* const C_PERIPHERAL_REG_INTERRUPT_ACKNOWLEDGE						= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_REG_BASE_ADD		+	0X0C8);



//	PLANE	0	:	
/*******	CONFIG HOLDER	*******/
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_1_1_H			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X000);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_1_1_L			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X004);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_1_2_H			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X008);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_1_2_L			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X00C);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_1_3_H			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X010);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_1_3_L			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X014);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_1_4_H			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X018);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_1_4_L			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X01C);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_2_1_H			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X020);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_2_1_L			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X024);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_2_2_H			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X028);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_2_2_L			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X02C);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_2_3_H			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X030);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_2_3_L			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X034);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_2_4_H			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X038);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_2_4_L			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X03C);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_3_1_H			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X040);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_3_1_L			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X044);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_3_2_H			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X048);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_3_2_L			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X04C);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_3_3_H			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X050);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_3_3_L			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X054);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_3_4_H			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X058);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_3_4_L			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X05C);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_4_1_H			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X060);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_4_1_L			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X064);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_4_2_H			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X068);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_4_2_L			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X06C);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_4_3_H			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X070);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_4_3_L			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X074);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_4_4_H			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X078);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_4_4_L			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X07C);

/*******	SAUs INITIATION	*******/
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_BIAS_VALUE			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X090);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_BIAS_CONTROL			= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X094);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X098);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR	= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X09C);


/*******	PE CONTROL	*******/
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1				= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X0B0);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_2				= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X0B4);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_3				= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X0B8);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_4				= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X0BC);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_2_1				= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X0C0);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_2_2				= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X0C4);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_2_3				= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X0C8);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_2_4				= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X0CC);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_3_1				= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X0D0);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_3_2				= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X0D4);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_3_3				= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X0D8);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_3_4				= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X0DC);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_4_1				= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X0E0);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_4_2				= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X0E4);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_4_3				= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X0E8);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_4_4				= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X0EC);


/*******	EVENT COUNTER	*******/
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_PEs_1_1_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X100);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_PEs_1_2_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X104);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_PEs_1_3_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X108);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_PEs_1_4_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X10C);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_PEs_2_1_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X110);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_PEs_2_2_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X114);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_PEs_2_3_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X118);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_PEs_2_4_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X11C);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_PEs_3_1_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X120);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_PEs_3_2_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X124);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_PEs_3_3_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X128);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_PEs_3_4_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X12C);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_PEs_4_1_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X130);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_PEs_4_2_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X134);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_PEs_4_3_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X138);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_PEs_4_4_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X13C);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_STA_1_1_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X140);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_STA_1_2_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X144);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_STA_1_3_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X148);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_STA_1_4_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X14C);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_STA_2_1_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X150);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_STA_2_2_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X154);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_STA_2_3_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X158);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_STA_2_4_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X15C);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_STA_3_1_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X160);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_STA_3_2_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X164);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_STA_3_3_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X168);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_STA_3_4_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X16C);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_STA_4_1_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X170);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_STA_4_2_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X174);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_STA_4_3_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X178);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_STA_4_4_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X17C);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_UPA_1_1_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X180);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_UPA_1_2_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X184);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_UPA_1_3_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X188);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_UPA_1_4_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X18C);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_UPA_2_1_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X190);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_UPA_2_2_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X194);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_UPA_2_3_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X198);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_UPA_2_4_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X19C);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_UPA_3_1_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X1A0);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_UPA_3_2_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X1A4);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_UPA_3_3_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X1A8);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_UPA_3_4_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X1AC);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_UPA_4_1_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X1B0);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_UPA_4_2_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X1B4);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_UPA_4_3_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X1B8);
volatile unsigned int* const C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_UPA_4_4_DONE		= reinterpret_cast< volatile unsigned int* >	(C_PERIPHERAL_PLAN0_BASE_ADD	+	0X1BC);


//////////////////////
//	Bit Positions	//
//////////////////////

/*------------------------------------------------------------------------------------------------------------------------------------------
	--\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/--
	--/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\--
	------------------------------------------------------------------------------------------------------------------------------------------
	--	**************************
	--	****** DMA	CONTROL ******
	--	**************************
	------------------------------------------------------------------------------------------------------------------------------------------
	--	Control
	--	O	|	31	|	30		29		28		27		26		25		24		23		22		21	 	20	 	19		18		17		16	 |
	--	N	| start |======================================================= RESERVED =======================================================|
	--	T	
	--	R	
	--	O	|	15		14		13		12		11		10		9		8		7		6		5	|	4		3		2		1		0	 |
	--	L	|======================================= RESERVED ======================================|============= DMA Address ==============|
	--
	--		DMA Address			TARGET
	--				0			LMN(1,1)->DMA(0)
	--				1			LMN(1,1)->DMA(1)
	--				2			LMN(1,1)->DMA(2)
	--				3			LMN(1,1)->DMA(3)
	--				4			LMN(1,2)->DMA(4)
	--				5			LMN(1,2)->DMA(5)
	--				6			LMN(1,2)->DMA(6)
	--				7			LMN(1,2)->DMA(7)
	--				8			LMN(2,1)->DMA(8)
	--				9			LMN(2,1)->DMA(9)
	--				10			LMN(2,1)->DMA(10)
	--				11			LMN(2,1)->DMA(11)
	--				12			LMN(2,2)->DMA(12)
	--				13			LMN(2,2)->DMA(13)
	--				14			LMN(2,2)->DMA(14)
	--				15			LMN(2,2)->DMA(15)
	--				----------------------------
	--	NOTE:
	--		if the actual number of DMAs is less than 4 and 16 in MMNs and GMN
	--		respectively, the starting addresses for each MMNs remain constant.
	--		Additionally, any references or addresses pointing to DMAs beyond
	--		the existing ones won't have any impact on the system.
	------------------------------------------------------------------------------------------------------------------------------------------
	--\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/--
	--/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\--
	------------------------------------------------------------------------------------------------------------------------------------------
	--	*******************
	--	****** TIMER ******
	--	*******************
	------------------------------------------------------------------------------------------------------------------------------------------
	--	Control 	(Write Only)
	--	O	|	31	|	30	 |	29	 |	28	 |	27		26		25		24	|	23		22		21	 	20	 | 	19		18		17		16	 |
	--	N	|Enable |= init =| INT E | INT C |========= RESERVED ===========|=========== Clk Div ============|========= TOP(19:16) ==========|
	--	T	
	--	R	
	--	O	|	15		14		13		12		11		10		9		8		7		6		5		4		3		2		1		0	 |
	--	L	|========================================================== TOP(15:0) ===========================================================|
	--
	--			clk Div
	--				0	:	clk
	--				1	:	clk / 2
	--					:	
	--				i	:	clk / (2**i)
	--					:	
	--				15	:	clk / 65536
	--
	--------------------------------------------------------------------------------------------------------------------------------------------
	--	Value		(Read Only)
	--	a	|	31	|	30		29		28		27		26		25		24		23		22		21		20	 |	19		18		17		16	 |
	--	l	| INT V |======================================= RESERVED =======================================|========= Val(19:16) ==========|
	--	u	 
	--	e	
	--		|	15		14		13		12		11		10		9		8		7		6		5		4		3		2		1		0	 |
	--		|========================================================== Val(15:0) ===========================================================|
	--
	------------------------------------------------------------------------------------------------------------------------------------------
	--\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/--
	--/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\--
	------------------------------------------------------------------------------------------------------------------------------------------
	--	***************************
	--	****** EVENT COUNTER ******
	--	***************************
	------------------------------------------------------------------------------------------------------------------------------------------
	--	Control
	--	O	|	31	|	30	 |	29	 |	28	 |	27	 |	26	|	25	|	24	 |	23		22		21	 	20	 	19		18		17		16	 |
	--	N	|Enable |= init =| Stuck | INT E | INT C | SENS | INT V | Evnt V |========================== MAX(11:4) ==========================|
	--	T	
	--	R	
	--	O	|	15		14		13		12	|	11		10		9		8		7		6		5		4		3		2		1		0	 |
	--	L	|========== MAX(11:4) ==========|============================================= VAL ==============================================|
	--
	--		Sensitivity		:		sensitive to
	--				0		:		falling edge
	--				1		:		rising edge
	------------------------------------------------------------------------------------------------------------------------------------------
	--\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/--
	--/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\--
	------------------------------------------------------------------------------------------------------------------------------------------
	--	******************************
	--	****** CONTROL REGISTER ******
	--	******************************
	------------------------------------------------------------------------------------------------------------------------------------------
	--	Control 	(Write Only)
	--	O	|	31	|	30	|	29		28		27		26		25		24		23		22		21	 	20	 	19		18		17		16	 |
	--	N	|Normal |Connect|=================================================== RESERVED ===================================================|
	--	T	
	--	R	
	--	O	|	15		14		13		12		11		10		9		8		7		6		5		4		3		2		1		0	 |
	--	L	|========================================================== RESERVED ============================================================|
	--
	--------------------------------------------------------------------------------------------------------------------------------------------
	--	RESERVED
	--	E	|	31		30		29		28		27		26		25		24		23		22		21		20		19		18		17		16	 |
	--	S	|=========================================================== RESERVED ===========================================================|
	--	E	 
	--	R	
	--	V	|	15		14		13		12		11		10		9		8		7		6		5		4		3		2		1		0	 |
	--	E	|=========================================================== RESERVED ===========================================================|
	--	D
	------------------------------------------------------------------------------------------------------------------------------------------
	--\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/--
	--/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\--
	------------------------------------------------------------------------------------------------------------------------------------------
	--	*******************************
	--	****** INTERRUPT HANDLER ******
	--	*******************************
	------------------------------------------------------------------------------------------------------------------------------------------
	--	INT ENABLE 0
	--	N	|		31		|		30		|		29		|		28		|		27		|		26		|		25		|		24		|
	--	T	|= DMA 4,4 Rdy =|= DMA 4,3 Rdy =|= DMA 4,2 Rdy =|= DMA 4,1 Rdy =|= DMA 3,4 Rdy =|= DMA 3,3 Rdy =|= DMA 3,2 Rdy =|= DMA 3,1 Rdy =|
	--		
	--	E	|		23		|		22		|		21		|		20		|		19		|		18		|		17		|		16		|
	--	N	|= DMA 2,4 Rdy =|= DMA 2,3 Rdy =|= DMA 2,2 Rdy =|= DMA 2,1 Rdy =|= DMA 1,4 Rdy =|= DMA 1,3 Rdy =|= DMA 1,2 Rdy =|= DMA 1,1 Rdy =|
	--	A
	--	B	|		15		|		14		|		13		|		12		|		11		|		10		|		9		|		8		|
	--	L	|=== TIMER 7 ===|=== TIMER 6 ===|=== TIMER 5 ===|=== TIMER 4 ===|=== TIMER 3 ===|=== TIMER 2 ===|=== TIMER 1 ===|=== TIMER 0 ===|
	--	E	
	--		|		7		|		6		|		5		|		4		|		3		|		2		|		1		|		0		|
	--	0	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|=== PC  Req ===|
	--		
	------------------------------------------------------------------------------------------------------------------------------------------
	--	INT ENABLE 1
	--	N	|		31		|		30		|		29		|		28		|		27		|		26		|		25		|		24		|
	--	T	|STA 1,4,4 Done |STA 1,4,3 Done |STA 1,4,2 Done |STA 1,4,1 Done |STA 1,3,4 Done |STA 1,3,3 Done |STA 1,3,2 Done |STA 1,3,1 Done |
	--		
	--	E	|		23		|		22		|		21		|		20		|		19		|		18		|		17		|		16		|
	--	N	|STA 1,2,4 Done |STA 1,2,3 Done |STA 1,2,2 Done |STA 1,2,1 Done |STA 1,1,4 Done |STA 1,1,3 Done |STA 1,1,2 Done |STA 1,1,1 Done |
	--	A	
	--	B	|		15		|		14		|		13		|		12		|		11		|		10		|		9		|		8		|
	--	L	| PE 1,4,4 Done | PE 1,4,3 Done | PE 1,4,2 Done | PE 1,4,1 Done | PE 1,3,4 Done | PE 1,3,3 Done | PE 1,3,2 Done | PE 1,3,1 Done |
	--	E	
	--		|		7		|		6		|		5		|		4		|		3		|		2		|		1		|		0		|
	--	1	| PE 1,2,4 Done | PE 1,2,3 Done | PE 1,2,2 Done | PE 1,2,1 Done | PE 1,1,4 Done | PE 1,1,3 Done | PE 1,1,2 Done | PE 1,1,1 Done |
	--		
	------------------------------------------------------------------------------------------------------------------------------------------
	--	INT ENABLE 2
	--	N	|		31		|		30		|		29		|		28		|		27		|		26		|		25		|		24		|
	--	T	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|
	--		
	--	E	|		23		|		22		|		21		|		20		|		19		|		18		|		17		|		16		|
	--	N	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|
	--	A	
	--	B	|		15		|		14		|		13		|		12		|		11		|		10		|		9		|		8		|
	--	L	|UPA 1,4,4 Done |UPA 1,4,3 Done |UPA 1,4,2 Done |UPA 1,4,1 Done |UPA 1,3,4 Done |UPA 1,3,3 Done |UPA 1,3,2 Done |UPA 1,3,1 Done |
	--	E	
	--		|		7		|		6		|		5		|		4		|		3		|		2		|		1		|		0		|
	--	2	|UPA 1,2,4 Done |UPA 1,2,3 Done |UPA 1,2,2 Done |UPA 1,2,1 Done |UPA 1,1,4 Done |UPA 1,1,3 Done |UPA 1,1,2 Done |UPA 1,1,1 Done |
	--		
	------------------------------------------------------------------------------------------------------------------------------------------
	--	INT ENABLE 3
	--	N	|		31		|		30		|		29		|		28		|		27		|		26		|		25		|		24		|
	--	T	|STA 2,4,4 Done |STA 2,4,3 Done |STA 2,4,2 Done |STA 2,4,1 Done |STA 2,3,4 Done |STA 2,3,3 Done |STA 2,3,2 Done |STA 2,3,1 Done |
	--		
	--	E	|		23		|		22		|		21		|		20		|		19		|		18		|		17		|		16		|
	--	N	|STA 2,2,4 Done |STA 2,2,3 Done |STA 2,2,2 Done |STA 2,2,1 Done |STA 2,1,4 Done |STA 2,1,3 Done |STA 2,1,2 Done |STA 2,1,1 Done |
	--	A	
	--	B	|		15		|		14		|		13		|		12		|		11		|		10		|		9		|		8		|
	--	L	| PE 2,4,4 Done | PE 2,4,3 Done | PE 2,4,2 Done | PE 2,4,1 Done | PE 2,3,4 Done | PE 2,3,3 Done | PE 2,3,2 Done | PE 2,3,1 Done |
	--	E	
	--		|		7		|		6		|		5		|		4		|		3		|		2		|		1		|		0		|
	--	3	| PE 2,2,4 Done | PE 2,2,3 Done | PE 2,2,2 Done | PE 2,2,1 Done | PE 2,1,4 Done | PE 2,1,3 Done | PE 2,1,2 Done | PE 2,1,1 Done |
	--		
	------------------------------------------------------------------------------------------------------------------------------------------
	--	INT ENABLE 4
	--	N	|		31		|		30		|		29		|		28		|		27		|		26		|		25		|		24		|
	--	T	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|
	--		
	--	E	|		23		|		22		|		21		|		20		|		19		|		18		|		17		|		16		|
	--	N	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|
	--	A	
	--	B	|		15		|		14		|		13		|		12		|		11		|		10		|		9		|		8		|
	--	L	|UPA 2,4,4 Done |UPA 2,4,3 Done |UPA 2,4,2 Done |UPA 2,4,1 Done |UPA 2,3,4 Done |UPA 2,3,3 Done |UPA 2,3,2 Done |UPA 2,3,1 Done |
	--	E	
	--		|		7		|		6		|		5		|		4		|		3		|		2		|		1		|		0		|
	--	4	|UPA 2,2,4 Done |UPA 2,2,3 Done |UPA 2,2,2 Done |UPA 2,2,1 Done |UPA 2,1,4 Done |UPA 2,1,3 Done |UPA 2,1,2 Done |UPA 2,1,1 Done |
	--		
	------------------------------------------------------------------------------------------------------------------------------------------
	--	INT ENABLE 5
	--	N	|		31		|		30		|		29		|		28		|		27		|		26		|		25		|		24		|
	--	T	|STA 3,4,4 Done |STA 3,4,3 Done |STA 3,4,2 Done |STA 3,4,1 Done |STA 3,3,4 Done |STA 3,3,3 Done |STA 3,3,2 Done |STA 3,3,1 Done |
	--		
	--	E	|		23		|		22		|		21		|		20		|		19		|		18		|		17		|		16		|
	--	N	|STA 3,2,4 Done |STA 3,2,3 Done |STA 3,2,2 Done |STA 3,2,1 Done |STA 3,1,4 Done |STA 3,1,3 Done |STA 3,1,2 Done |STA 3,1,1 Done |
	--	A	
	--	B	|		15		|		14		|		13		|		12		|		11		|		10		|		9		|		8		|
	--	L	| PE 3,4,4 Done | PE 3,4,3 Done | PE 3,4,2 Done | PE 3,4,1 Done | PE 3,3,4 Done | PE 3,3,3 Done | PE 3,3,2 Done | PE 3,3,1 Done |
	--	E	
	--		|		7		|		6		|		5		|		4		|		3		|		2		|		1		|		0		|
	--	5	| PE 3,2,4 Done | PE 3,2,3 Done | PE 3,2,2 Done | PE 3,2,1 Done | PE 3,1,4 Done | PE 3,1,3 Done | PE 3,1,2 Done | PE 3,1,1 Done |
	--		
	------------------------------------------------------------------------------------------------------------------------------------------
	--	INT ENABLE 6
	--	N	|		31		|		30		|		29		|		28		|		27		|		26		|		25		|		24		|
	--	T	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|
	--		
	--	E	|		23		|		22		|		21		|		20		|		19		|		18		|		17		|		16		|
	--	N	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|
	--	A	
	--	B	|		15		|		14		|		13		|		12		|		11		|		10		|		9		|		8		|
	--	L	|UPA 3,4,4 Done |UPA 3,4,3 Done |UPA 3,4,2 Done |UPA 3,4,1 Done |UPA 3,3,4 Done |UPA 3,3,3 Done |UPA 3,3,2 Done |UPA 3,3,1 Done |
	--	E	
	--		|		7		|		6		|		5		|		4		|		3		|		2		|		1		|		0		|
	--	6	|UPA 3,2,4 Done |UPA 3,2,3 Done |UPA 3,2,2 Done |UPA 3,2,1 Done |UPA 3,1,4 Done |UPA 3,1,3 Done |UPA 3,1,2 Done |UPA 3,1,1 Done |
	--		
	------------------------------------------------------------------------------------------------------------------------------------------
	--	INT ENABLE 7
	--	N	|		31		|		30		|		29		|		28		|		27		|		26		|		25		|		24		|
	--	T	|STA 4,4,4 Done |STA 4,4,3 Done |STA 4,4,2 Done |STA 4,4,1 Done |STA 4,3,4 Done |STA 4,3,3 Done |STA 4,3,2 Done |STA 4,3,1 Done |
	--		
	--	E	|		23		|		22		|		21		|		20		|		19		|		18		|		17		|		16		|
	--	N	|STA 4,2,4 Done |STA 4,2,3 Done |STA 4,2,2 Done |STA 4,2,1 Done |STA 4,1,4 Done |STA 4,1,3 Done |STA 4,1,2 Done |STA 4,1,1 Done |
	--	A	
	--	B	|		15		|		14		|		13		|		12		|		11		|		10		|		9		|		8		|
	--	L	| PE 4,4,4 Done | PE 4,4,3 Done | PE 4,4,2 Done | PE 4,4,1 Done | PE 4,3,4 Done | PE 4,3,3 Done | PE 4,3,2 Done | PE 4,3,1 Done |
	--	E	
	--		|		7		|		6		|		5		|		4		|		3		|		2		|		1		|		0		|
	--	7	| PE 4,2,4 Done | PE 4,2,3 Done | PE 4,2,2 Done | PE 4,2,1 Done | PE 4,1,4 Done | PE 4,1,3 Done | PE 4,1,2 Done | PE 4,1,1 Done |
	--		
	------------------------------------------------------------------------------------------------------------------------------------------
	--	INT ENABLE 8
	--	N	|		31		|		30		|		29		|		28		|		27		|		26		|		25		|		24		|
	--	T	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|
	--		
	--	E	|		23		|		22		|		21		|		20		|		19		|		18		|		17		|		16		|
	--	N	|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|== RESERVED ===|
	--	A	
	--	B	|		15		|		14		|		13		|		12		|		11		|		10		|		9		|		8		|
	--	L	|UPA 4,4,4 Done |UPA 4,4,3 Done |UPA 4,4,2 Done |UPA 4,4,1 Done |UPA 4,3,4 Done |UPA 4,3,3 Done |UPA 4,3,2 Done |UPA 4,3,1 Done |
	--	E	
	--		|		7		|		6		|		5		|		4		|		3		|		2		|		1		|		0		|
	--	8	|UPA 4,2,4 Done |UPA 4,2,3 Done |UPA 4,2,2 Done |UPA 4,2,1 Done |UPA 4,1,4 Done |UPA 4,1,3 Done |UPA 4,1,2 Done |UPA 4,1,1 Done |
	--		
	--	
	--	Interrupt Priority:
	--		INT_EN_0_b0	> INT_EN_0_b1 > ... > INT_EN_0_b31 > INT_EN_1_b0 > > INT_EN_1_b1 > ... > INT_EN_8_b0 > INT_EN_8_b1 > ... > INT_EN_8_b31
	--		Higher		>																										 > LOWER
	------------------------------------------------------------------------------------------------------------------------------------------
	--	INT ADDRESS
	--	N	|	31		30		29		28		27		26		25		24		23		22		21	 	20	 	19		18		17		16	 |
	--	T	|==================== Previous Int Address =====================|========================= INT Address ==========================|
	--		
	--	A	
	--	D	|	15		14		13		12		11		10		9		8		7		6		5		4		3	|	2		1		0	 |
	--	D	|============================================== RESERVED ===============================================|== INT Address Decode ==|
	--
	------------------------------------------------------------------------------------------------------------------------------------------
	--	INT ACKNOWLEDGE
	--	N	|	31		30		29		28		27		26		25		24		23		22		21	 	20	 	19		18		17		16	 |
	--	T	|========================================================== RESERVED ============================================================|
	--		
	--	A	
	--	C	|	15		14		13		12		11		10		9		8		7		6		5		4		3		2		1	|	0	 |
	--	K	|====================================================== RESERVED =======================================================|= ACK  =|
	--
	------------------------------------------------------------------------------------------------------------------------------------------
	--	RESERVED
	--	E	|	31		30		29		28		27		26		25		24		23		22		21		20		19		18		17		16	 |
	--	S	|=========================================================== RESERVED ===========================================================|
	--	E	 
	--	R	
	--	V	|	15		14		13		12		11		10		9		8		7		6		5		4		3		2		1		0	 |
	--	E	|=========================================================== RESERVED ===========================================================|
	--	D
	------------------------------------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------------------------------
	--\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/--
	--/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\--
	------------------------------------------------------------------------------------------------------------------------------------------
	--																																			
	--																																			
	--		|‾‾‾‾‾‾‾‾‾‾‾‾‾‾\	|‾|				|‾‾‾‾‾‾‾‾‾‾‾‾‾|		|‾‾‾\			  |‾|		|‾‾‾‾‾‾‾‾‾‾‾‾‾|		|‾‾‾‾‾‾‾‾‾‾‾‾‾‾\							
	--		| |‾‾‾‾‾‾‾‾‾‾\ |	| |				| |‾‾‾‾‾‾‾‾‾| |		| |\ \		      | |       | |‾‾‾‾‾‾‾‾‾| |     | |‾‾‾‾‾‾‾‾‾‾\ |			
	--		| |			 | |	| |				| |			| |		| |	\ \			  | |		| |			| |		| |			 | |			
	--		| |			 | |	| |				| |			| |		| |	 \ \		  | |		| |			| |		| |			 | |			
	--		| |			 | |	| |				| |			| |		| |	  \	\		  | |		| |			| |		| |			 | |			
	--		| |			 | |	| |				| |			| |		| |	   \ \		  | |		| |			| |		| |			 | |			
	--		| |__________/ |	| |				| |_________| |		| |		\ \		  | |		| |_________| |		| |__________/ |			
	--		| |____________/	| |				| |_________| |		| |		 \ \	  | |		| |_________| |		| | ___________/			
	--		| |					| |				| |			| |		| |		  \	\	  | |		| |			| |		| |\ \	  					
	--		| |					| |				| |			| |		| |		   \ \	  | |		| |			| |		| | \ \	  					
	--		| |					| |				| |			| |		| |			\ \	  | |		| |			| |		| |  \ \	  				
	--		| |					| |				| |			| |		| |			 \ \  | |		| |			| |		| |	  \ \  					
	--		| |					| |				| |			| |		| |			  \	\ | |		| |			| |		| |	   \ \ 					
	--		| |					| |_________	| |			| |		| |			   \ \| |		| |			| |		| |	    \ \					
	--		|_|					|___________|	|_|			|_|		|_|				\___|		|_|			|_|		|_|	     \_\				
	--																																			
	--																																			
	------------------------------------------------------------------------------------------------------------------------------------------
	--\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/--
	--/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\--
	------------------------------------------------------------------------------------------------------------------------------------------
	--	**********************************
	--	****** CONFIGURATION HOLDER ******
	--	**********************************
	------------------------------------------------------------------------------------------------------------------------------------------
	--		
	--	H	|	63		62		61		60		59		58		57		56		55		54		53		52		51		50		49		48	 |
	--	I	|====================================================	RESERVED	=============================================================|
	--	G	
	--	H	
	--	E	|	47		46		45	|	44	|	43		42		41		40		39	|	38	|	37	|	36	|	35		34	|	33		32	 |
	--	R	| RSRVD |=== FSM Sel ===| PESrc |============= Shift Count =============|= F/H =|IFM_NS |WFM_NS |= Address sel =|= Zero pad max =|
	--		
	--		
	--	---------------------------------------------------------------------------------------------------------------------------------------	
	--		
	--	L	|	31		30		29		28	|	27		26		25		24	|	23		22		21		20	|	19		18		17		16	 |
	--	O	|========== Kernel Max =========|========== Column Max =========|========= Channel Max =========|=========== Row Max ============|
	--	W	
	--	E	
	--	E	|	15		14		13		12	|	11		10		9		8	|	7		6		5		4	|	3		2	|	1		0	 |
	--		|========= counter Max =========|=========== Bank Min ==========|=========== Bank Max ==========|== GBank Min ==|== GBank Max ===|
	--		
	------------------------------------------------------------------------------------------------------------------------------------------
	--\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/--
	--/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\--
	------------------------------------------------------------------------------------------------------------------------------------------
	--	***********************
	--	****** INITIATOR ******
	--	***********************
	--	NOTE:
	--		this Sizes are conceptional and are not based on their true signal length 
	--		(for the sake of start positioning, to see actual sizees visit MY_PACK_V2.VHD)
	------------------------------------------------------------------------------------------------------------------------------------------
	--	Store Agent BIAS Value
	--	A	|	31		30		29		28		27		26		25		24		23		22		21	 	20	 	19		18		17		16	 |
	--	B	|=========================================================== RESERVED ===========================================================|
	--	V	
	--		
	--		|	15		14		13		12		11		10		9		8		7		6		5		4		3		2		1		0	 |
	--		|========================================================= Bias Value ===========================================================|
	--
	--------------------------------------------------------------------------------------------------------------------------------------------
	--	Store Agent BIAS Control
	--	A	|	31	|	30		29		28		27		26		25		24		23		22		21		20		19		18		17		16	 |
	--	B	|= Wen =|======================================================= RESERVED =======================================================|
	--	C	 
	--		
	--		|	15		14		13		12		11		10		9		8		7		6		5		4	|	3		2		1		0	 |
	--		|========================================== RESERVED ===========================================|======== Kernel Address ========|
	------------------------------------------------------------------------------------------------------------------------------------------
	--	Address Point
	--	P	|	31		30		29		28		27		26		25		24		23		22		21	 	20	 	19		18		17		16	 |
	--		|=========================================================== RESERVED ===========================================================|
	--		
	--		
	--		|	15		14		13		12		11		10		9		8		7		6		5		4		3		2		1		0	 |
	--		|======================================================== Address Value =========================================================|
	--
	--------------------------------------------------------------------------------------------------------------------------------------------
	--	Address Point Control
	--	P	|	31	|	30	|	29	|	28	|	27		26		25		24		23		22		21		20	 |	19		18		17		16	 |
	--	C	| B Wen | C Wen | I Wen |SA/ ~UA|=========================== RESERVED ===========================|======== Unit Address =========|
	--		
	--		
	--		|	15		14		13		12		11		10		9		8		7		6		5		4	 |	3		2		1		0	 |
	--		|================================================== RESERVED ====================================|======= Target Address ========|
	--
	--			TARGGET	ADDRESS	(Update Agent)
	--						0		:	WEIGHT MEMORY BANK #(1,1)
	--						1		:	WEIGHT MEMORY BANK #(1,2)
	--						2		:	WEIGHT MEMORY BANK #(1,3)
	--						3		:	WEIGHT MEMORY BANK #(2,1)
	--						4		:	WEIGHT MEMORY BANK #(2,2)
	--						5		:	WEIGHT MEMORY BANK #(2,3)
	--						6		:	WEIGHT MEMORY BANK #(3,1)
	--						7		:	WEIGHT MEMORY BANK #(3,2)
	--						8		:	WEIGHT MEMORY BANK #(3,3)
	--						9		:	RESERVED
	--						10		:	CONTROL UNIT MEMORY
	--						11		:	RESERVED
	--						12		:	INPUT MEMORY BANK #4
	--						13		:	INPUT MEMORY BANK #3
	--						14		:	INPUT MEMORY BANK #2
	--						15		:	INPUT MEMORY BANK #1
	--------------------------------------------------------------------------
	--			TARGGET	ADDRESS	(Store Agent)
	--						0		:	LOAD	ROW from
	--						1		:	STORE	ROW at
	--						2		:	RESERVED
	--						3		:	RESERVED
	--						4		:	RESERVED
	--						5		:	RESERVED
	--						6		:	RESERVED
	--						7		:	RESERVED
	--						8		:	RESERVED
	--						9		:	RESERVED
	--						10		:	RESERVED
	--						11		:	RESERVED
	--						12		:	RESERVED
	--						13		:	RESERVED
	--						14		:	RESERVED
	--						15		:	RESERVED
	--------------------------------------------------------------------------
	--			Unit Address			row		col
	--						0000	:	1		1
	--						0001	:	1		2
	--						0010	:	1		3
	--						0011	:	1		4
	--						0100	:	2		1
	--						0101	:	2		2
	--						0110	:	2		3
	--						0111	:	2		4
	--						1000	:	3		1
	--						1001	:	3		2
	--						1010	:	3		3
	--						1011	:	3		4
	--						1100	:	4		1
	--						1101	:	4		2
	--						1110	:	4		3
	--						1111	:	4		4
	--------------------------------------------------------------------------
	--	Initialization procedure:
	--		BIASes:
	--			1)	SET		Unit Address					@		C_PERIPHERAL_REG_SAU_INITIATE_ADDRESS_POINT_CNTR
	--			2)	PUT		Bias Value						@		C_PERIPHERAL_REG_SAU_INITIATE_BIAS_VALUE
	--			3)	SET		Kernel Address &	Wen			@		C_PERIPHERAL_REG_SAU_INITIATE_BIAS_CONTROL
	--			4)	repeat 2 and 3			until you initiate all kernel biases for unit r,c
	--			5)	repeat 1, 2, 3 and 4	until you initiate all kernel biases for all units
	--			
	--		ASSRESSes:
	--			1)	PUT		Address Value					@		C_PERIPHERAL_REG_SAU_INITIATE_ADDRESS_POINT
	--			2)	SET		different part of				@		C_PERIPHERAL_REG_SAU_INITIATE_ADDRESS_POINT_CNTR
	--			3)	repeat 1 and 2 for all Target Address of SU and CU in each Unit Address. (total of 64 times)
	--			
	------------------------------------------------------------------------------------------------------------------------------------------
	--\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/--
	--/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\--
	------------------------------------------------------------------------------------------------------------------------------------------
	--	************************
	--	****** PE CONTROL ******
	--	************************
	----------------------------------------------------------------------------------------------------------------------------------------------------------------
	--	31					30					29					28					27					26					25					24
	--	RSRVD,				RSRVD,				RSRVD,				PAUSE_PEs,			CMD_PEs_start,		CMD_inc_Rows2,		CMD_inc_Rows1,		CMD_inc_Rows0
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--	23					22					21					20					19					18					17					16
	--	RSRVD,				RSRVD,				RSRVD,				RSRVD,				RSRVD,				RSRVD,				PAUSE_STA,			CMD_STA_load	
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--	15					14					13					12					11					10					9					8
	--	CMD_STA_MEM_en,		CMD_STA_OBM_en,		CMD_STA_BIS_en,		CMD_STA_save,		CMD_STA_active,		CMD_STA_store,		CMD_STA_load_UA,	CMD_STA_stor_UA,   	
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--	7					6					5					4					3					2					1					0
	--	RSRVD,				RSRVD,				PAUSE_UPA,			CMD_UPA_Up_IFM,		CMD_UPA_Up_WFM,		RSRVD,				CMD_UPA_status1,	CMD_UPA_status0
	----------------------------------------------------------------------------------------------------------------------------------------------------------------
	--\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/--
	--/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\--
	------------------------------------------------------------------------------------------------------------------------------------------
	--	***************************
	--	****** EVENT COUNTER ******
	--	***************************
	------------------------------------------------------------------------------------------------------------------------------------------
	--	Control
	--	O	|	31	|	30	 |	29	 |	28	 |	27	 |	26	|	25	|	24	 |	23		22		21	 	20	 	19		18		17		16	 |
	--	N	|Enable |= init =| Stuck | INT E | INT C | SENS | INT V | Evnt V |========================== MAX(11:4) ==========================|
	--	T	
	--	R	
	--	O	|	15		14		13		12	|	11		10		9		8		7		6		5		4		3		2		1		0	 |
	--	L	|========== MAX(11:4) ==========|============================================= VAL ==============================================|
	--
	--		Sensitivity		:		sensitive to
	--				0		:		falling edge
	--				1		:		rising edge
	------------------------------------------------------------------------------------------------------------------------------------------
	--\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/--
	--/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\--
	------------------------------------------------------------------------------------------------------------------------------------------*/

/*******	DMAs CONTROL	*******/
#define	C_DMA_Address_pos						0
#define	C_DMA_Start_pos							31

/*******	TIMER CONTROL	*******/
#define	C_Timer_Top_pos							0
#define	C_Timer_Clk_Div_pos						20
#define	C_Timer_Int_clear_pos					28
#define	C_Timer_Int_Enable_pos					29
#define	C_Timer_Init_pos						30
#define	C_Timer_Enable_pos						31
#define	C_Timer_Val_pos							0
#define	C_Timer_Int_Val_pos						31

/*******	EVENT COUNTER	*******/
#define	C_Event_Val_pos							0
#define	C_Event_Max_pos							12
#define	C_Event_Event_Value_pos					24
#define	C_Event_Int_Value_pos					25
#define	C_Event_Sensitity_pos					26	//Sensitivity:	0:falling edge,	1:rising edge
#define	C_Event_Int_Clear_pos					27
#define	C_Event_Int_Enabel_pos					28
#define	C_Event_Stuck_at_Top_pos				29
#define	C_Event_Init_pos						30
#define	C_Event_Enable_pos						31

/*******	CONTROL_REGISTER	*******/
#define	C_Accelerator_Normal_pos				31
#define	C_Accelerator_Connect_pos				30

/*******	INTERRUPT HANDLER	*******/
#define	C_INT_PC_Req_pos						0	//	Highest Priority
#define	C_INT_Timer_0_pos						8
#define	C_INT_Timer_1_pos						9
#define	C_INT_Timer_2_pos						10
#define	C_INT_Timer_3_pos						11
#define	C_INT_Timer_4_pos						12
#define	C_INT_Timer_5_pos						13
#define	C_INT_Timer_6_pos						14
#define	C_INT_Timer_7_pos						15
#define	C_INT_GMN_DMA_0_Done_pos				16
#define	C_INT_GMN_DMA_1_Done_pos				17
#define	C_INT_GMN_DMA_2_Done_pos				18
#define	C_INT_GMN_DMA_3_Done_pos				19
#define	C_INT_GMN_DMA_4_Done_pos				20
#define	C_INT_GMN_DMA_5_Done_pos				21
#define	C_INT_GMN_DMA_6_Done_pos				22
#define	C_INT_GMN_DMA_7_Done_pos				23
#define	C_INT_GMN_DMA_8_Done_pos				24
#define	C_INT_GMN_DMA_9_Done_pos				25
#define	C_INT_GMN_DMA_10_Done_pos				26
#define	C_INT_GMN_DMA_11_Done_pos				27
#define	C_INT_GMN_DMA_12_Done_pos				28
#define	C_INT_GMN_DMA_13_Done_pos				29
#define	C_INT_GMN_DMA_14_Done_pos				30
#define	C_INT_GMN_DMA_15_Done_pos				31

#define	C_INT_PE_1_1_Done_pos					0
#define	C_INT_PE_1_2_Done_pos					1
#define	C_INT_PE_1_3_Done_pos					2
#define	C_INT_PE_1_4_Done_pos					3
#define	C_INT_PE_2_1_Done_pos					4
#define	C_INT_PE_2_2_Done_pos					5
#define	C_INT_PE_2_3_Done_pos					6
#define	C_INT_PE_2_4_Done_pos					7
#define	C_INT_PE_3_1_Done_pos					8
#define	C_INT_PE_3_2_Done_pos					9
#define	C_INT_PE_3_3_Done_pos					10
#define	C_INT_PE_3_4_Done_pos					11
#define	C_INT_PE_4_1_Done_pos					12
#define	C_INT_PE_4_2_Done_pos					13
#define	C_INT_PE_4_3_Done_pos					14
#define	C_INT_PE_4_4_Done_pos					15
#define	C_INT_STA_1_1_Done_pos					16
#define	C_INT_STA_1_2_Done_pos					17
#define	C_INT_STA_1_3_Done_pos					18
#define	C_INT_STA_1_4_Done_pos					19
#define	C_INT_STA_2_1_Done_pos					20
#define	C_INT_STA_2_2_Done_pos					21
#define	C_INT_STA_2_3_Done_pos					22
#define	C_INT_STA_2_4_Done_pos					23
#define	C_INT_STA_3_1_Done_pos					24
#define	C_INT_STA_3_2_Done_pos					25
#define	C_INT_STA_3_3_Done_pos					26
#define	C_INT_STA_3_4_Done_pos					27
#define	C_INT_STA_4_1_Done_pos					28
#define	C_INT_STA_4_2_Done_pos					29
#define	C_INT_STA_4_3_Done_pos					30
#define	C_INT_STA_4_4_Done_pos					31
#define	C_INT_UPA_1_1_Done_pos					0
#define	C_INT_UPA_1_2_Done_pos					1
#define	C_INT_UPA_1_3_Done_pos					2
#define	C_INT_UPA_1_4_Done_pos					3
#define	C_INT_UPA_2_1_Done_pos					4
#define	C_INT_UPA_2_2_Done_pos					5
#define	C_INT_UPA_2_3_Done_pos					6
#define	C_INT_UPA_2_4_Done_pos					7
#define	C_INT_UPA_3_1_Done_pos					8
#define	C_INT_UPA_3_2_Done_pos					9
#define	C_INT_UPA_3_3_Done_pos					10
#define	C_INT_UPA_3_4_Done_pos					11
#define	C_INT_UPA_4_1_Done_pos					12
#define	C_INT_UPA_4_2_Done_pos					13
#define	C_INT_UPA_4_3_Done_pos					14
#define	C_INT_UPA_4_4_Done_pos					15
#define	C_INT_ACK_pos							0
#define	C_INT_INT_ADD_Decode_pos				0
#define	C_INT_THIS_Address_pos					16
#define	C_INT_PREV_Address_pos					24

/*******	CONFIG HOLDER	*******/
#define C_GBank_Max_pos							0
#define	C_GBank_Min_pos							2
#define	C_Bank_Max_pos							4
#define	C_Bank_Min_pos							8
#define	C_COUNTER_MAX_pos						12
#define	C_ROW_MAX_pos							16
#define	C_Channel_MAX_pos						20
#define	C_Column_MAX_pos						24
#define	C_Kernel_MAX_pos						28
#define	C_ZPad_MAX_pos							0
#define	C_Address_Sel_pos						2
#define	C_WFM_Numeric_pos						4
#define	C_IFM_Numeric_pos						5
#define	C_Computation_Size_pos					6
#define	C_Shift_Count_pos						7
#define	C_PE_Source_pos							12
#define	C_FSM_SEL_pos							13

/*******	SAUs INITIATION	*******/
#define	C_SAU_Bias_Value_pos					0
#define	C_SAU_Bias_Kernel_Add_pos				0
#define	C_SAU_Bias_Wen_pos						31
#define	C_SUU_Address_Point_pos					0
#define	C_SUU_Address_Point_Target_Add_pos		0
#define	C_SUU_Address_Point_Unit_Add_pos		16
#define	C_SUU_Address_Point_SA_UAb_pos			28
#define	C_SUU_Address_Point_Interval_Wen_pos	29
#define	C_SUU_Address_Point_Count_Wen_pos		30
#define	C_SUU_Address_Point_Base_Wen_pos		31





/*******	PE CONTROL	*******/
#define	C_UPA_Status_pos						0
#define	C_Update_WFM_pos						3
#define	C_Update_IFM_pos						4
#define	C_Pause_UPA_pos							5
#define	C_Update_Store_Base_Address_pos			8
#define	C_Update_load_Base_Address_pos			9
#define	C_Store_Row_pos							10	//	store internal Buffer
#define	C_Enable_Activation_pos					11
#define	C_Save_Row_pos							12	//	save it in the inrternal Buffer
#define	C_Bias_Accumulation_Enable_pos			13	//	Accumulate with Bias
#define	C_PEout_Accumulation_Enable_pos			14	//	Accumulate with PE output
#define	C_Buffer_Accumulation_Enable_pos		15	//	Accumulate with Internal Buffer
#define	C_Load_Row_pos							16	//	preload internal Buffer
#define	C_Pause_STA_pos							17
#define	C_Inc_Row_0_pos							24
#define	C_Inc_Row_1_pos							25
#define	C_Inc_Row_2_pos							26
#define	C_Start_PE_pos							27
#define	C_Pause_PE_pos							28











//	Function Decleration
extern	"C"	{	void EXT_INT_0_handler();	}	//	Interrupt 0
extern	"C"	{	void EXT_INT_1_handler();	}	//	Interrupt 1
extern	"C"	{	void EXT_INT_2_handler();	}	//	Interrupt 2
extern	"C"	{	void EXT_INT_3_handler();	}	//	Interrupt 3
extern	"C"	{	void EXT_INT_4_handler();	}	//	Interrupt 4
extern	"C"	{	void EXT_INT_5_handler();	}	//	Interrupt 5
extern	"C"	{	void EXT_INT_6_handler();	}	//	Interrupt 6
extern	"C"	{	void EXT_INT_7_handler();	}	//	Interrupt 7
extern	"C"	{	void EXT_INT_8_handler();	}	//	Interrupt 8
extern	"C"	{	void EXT_INT_9_handler();	}	//	Interrupt 9
extern	"C"	{	void EXT_INT_10_handler();	}	//	Interrupt 10
extern	"C"	{	void EXT_INT_11_handler();	}	//	Interrupt 11
extern	"C"	{	void EXT_INT_12_handler();	}	//	Interrupt 12
extern	"C"	{	void EXT_INT_13_handler();	}	//	Interrupt 13
extern	"C"	{	void EXT_INT_14_handler();	}	//	Interrupt 14
extern	"C"	{	void EXT_INT_15_handler();	}	//	Interrupt 15



/*	HOW TO USE THESE 
		unsigned int* addr1 = reinterpret_cast< volatile unsigned int* >0xDEADBEEF;
		unsigned int* addr2 = reinterpret_cast< volatile unsigned int* >0xDEADBEEF;
		int value = *addr1;
		*addr2 = value;
		*/


enum	E_PE_Src		{	MEM=0,		LPE=1	};
int		E_Shift_cnt;
enum	E_FH_Arith		{	HALF=0,		FULL=1	};
enum	E_IFM_NS		{	UNSIGN=0,	SIGN=1	};
enum	E_WFM_NS		{	UNSIGN=0,	SIGN=1	};
enum	E_Add_Sel		{	SELF=0,		PROW=1,		PCOL=3,		RSRV=4	}
int		E_Zpad_max;
int		E_Kern_max;
int		E_Colm_max;
int		E_Chnl_max;
int		E_Rows_max;
int		E_Cntr_max;
int		E_Bank_min;
int		E_Bank_max;
int		E_GBnk_min;
int		E_GBnk_max;


struct	S_PE_cofig
{
	E_PE_Src	PE_Src		=	MEM;
	int 		E_Shift_cnt	=	0;
	E_FH_Arith	FH_Arith	=	FULL;
	E_IFM_NS	IFM_NS		=	UNSIGN;
	E_WFM_NS	WFM_NS		=	UNSIGN;
	E_Add_Sel	Add_Sel		=	SELF;
	int 		E_Zpad_max	=	3;
	int 		E_Kern_max	=	15;
	int 		E_Colm_max	=	15;
	int 		E_Chnl_max	=	15;
	int 		E_Rows_max	=	15;
	int 		E_Cntr_max	=	15;
	int 		E_Bank_min	=	15;
	int 		E_Bank_max	=	0;
	int 		E_GBnk_min	=	3;
	int 		E_GBnk_max	=	0;
}



S_PE_cofig	C_PE_1_1_cnfig;
S_PE_cofig	C_PE_1_2_cnfig;
S_PE_cofig	C_PE_1_3_cnfig;
S_PE_cofig	C_PE_1_4_cnfig;
S_PE_cofig	C_PE_2_1_cnfig;
S_PE_cofig	C_PE_2_2_cnfig;
S_PE_cofig	C_PE_2_3_cnfig;
S_PE_cofig	C_PE_2_4_cnfig;
S_PE_cofig	C_PE_3_1_cnfig;
S_PE_cofig	C_PE_3_2_cnfig;
S_PE_cofig	C_PE_3_3_cnfig;
S_PE_cofig	C_PE_3_4_cnfig;
S_PE_cofig	C_PE_4_1_cnfig;
S_PE_cofig	C_PE_4_2_cnfig;
S_PE_cofig	C_PE_4_3_cnfig;
S_PE_cofig	C_PE_4_4_cnfig;



int	config_low_word_gen(S_PE_cofig cnf)
{
	int word = 0;
	word	=	word	+	(cnf.E_GBnk_max		<<	C_GBank_Max_pos			);
	word	=	word	+	(cnf.E_GBnk_min		<<	C_GBank_Min_pos			);
	word	=	word	+	(cnf.E_Bank_max		<<	C_Bank_Max_pos			);
	word	=	word	+	(cnf.E_Bank_min		<<	C_Bank_Min_pos			);
	word	=	word	+	(cnf.E_Cntr_max		<<	C_COUNTER_MAX_pos		);
	word	=	word	+	(cnf.E_Rows_max		<<	C_ROW_MAX_pos			);
	word	=	word	+	(cnf.E_Chnl_max		<<	C_Channel_MAX_pos		);
	word	=	word	+	(cnf.E_Colm_max		<<	C_Column_MAX_pos		);
	word	=	word	+	(cnf.E_Kern_max		<<	C_Kernel_MAX_pos		);
	return word;
}

int	config_high_word_gen(S_PE_cofig cnf)
{
	int word = 0;
	word	=	word	+	(cnf.E_Zpad_max		<<	C_ZPad_MAX_pos			);
	word	=	word	+	(cnf.Add_Sel		<<	C_Address_Sel_pos		);
	word	=	word	+	(cnf.WFM_NS			<<	C_WFM_Numeric_pos		);
	word	=	word	+	(cnf.IFM_NS			<<	C_IFM_Numeric_pos		);
	word	=	word	+	(cnf.FH_Arith		<<	C_Computation_Size_pos	);
	word	=	word	+	(cnf.E_Shift_cnt	<<	C_Shift_Count_pos		);
	word	=	word	+	(cnf.PE_Src			<<	C_PE_Source_pos			);
	return word;
}

