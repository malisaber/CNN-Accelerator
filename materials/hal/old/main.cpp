#include <cstddef>
#include "Data.h"
#include "Utilities.h"
#include "Accelerator.h"


void intr_PC		(unsigned int intr_addr);
void intr_TBE		(unsigned int intr_addr);
void intr_RBF		(unsigned int intr_addr);
void intr_TXD		(unsigned int intr_addr);
void intr_RXD		(unsigned int intr_addr);
void intr_Timer		(unsigned int intr_addr);
void intr_MPDR		(unsigned int intr_addr);
void intr_DMA		(unsigned int intr_addr);
void intr_PLANE_0	(unsigned int intr_addr);
void intr_PLANE_1	(unsigned int intr_addr);
void intr_PLANE_2	(unsigned int intr_addr);
void intr_PLANE_3	(unsigned int intr_addr);
void (*funcPtrArray[12])(unsigned int);


void Platform_Execute_Layer_3 ();




void Platform_Execute_BseLine (unsigned int bl);


volatile unsigned int DMA_ZDBT_info[16];
volatile unsigned int DMA_handler_cntr[16];
volatile unsigned int DMA_handler_Max [16];
unsigned int EXE_Bline_cntr(0);
volatile unsigned int PC_INT_Cntr;
volatile unsigned int DMA_Done_Cntr;
volatile unsigned int EXE_Done_Cntr(0);
volatile unsigned int PRI_Done_Cntr(0);
volatile unsigned int TIMER_INT_Cntr(0);
volatile unsigned int TIMER_INT_Cntr_Sec(0);


int main()
{
	/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
		Initiation
	/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/*/ 
	EXE_Bline_cntr = 0;
	for (int vlt = 0; vlt < 16; vlt++)
		DMA_handler_cntr[vlt] = 0;

	funcPtrArray[0]  = &intr_PC;
	funcPtrArray[1]  = &intr_TBE;
	funcPtrArray[2]  = &intr_RBF;
	funcPtrArray[3]  = &intr_TXD;
	funcPtrArray[4]  = &intr_RXD;
	funcPtrArray[5]  = &intr_Timer;
	funcPtrArray[6]  = &intr_MPDR;
	funcPtrArray[7]  = &intr_DMA;
	funcPtrArray[8]  = &intr_PLANE_0;
	funcPtrArray[9]  = &intr_PLANE_1;
	funcPtrArray[10] = &intr_PLANE_2;
	funcPtrArray[11] = &intr_PLANE_3;


	/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
		System Control					
	/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/*/ 
	CONT_REG_DRAM_connect();
	for (unsigned int pln = 0; pln < 4; pln++)
	{
		CONT_REG_ACC_Plane_reset (pln);
		CONT_REG_ACC_Plane_normal(pln);
	}


	/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
		Interrupt Handlre Configuration	
	/\/\/\/\/\/\/\/\/\/\//\/\/\/\*/ 
	INTH_enable_intr_pc();
	INTH_enable_intr_timer_group	(0x01);
	INTH_enable_intr_DMA_done_group	(0X0000);
	INTH_enable_PSU_done_group		(PLANE_0,	0xFFFF);
	INTH_enable_PSU_done_group		(PLANE_1,	0xFFFF);
	INTH_enable_PSU_done_group		(PLANE_2,	0xFFFF);
	INTH_enable_PSU_done_group		(PLANE_3,	0xFFFF);
	/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
		Timer
	/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/*/ 
	//timer is set to generate interrupts every 1 ms
	TIMER_config(0, 199999, 10, 1);
	TIMER_start	(0);


	/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
		Execution
	/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/*/ 
	Platform_Execute_Layer_3 ();
	

	/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
		This Is The End
	/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/*/ 
	while(true){}
}


void Platform_Execute_Layer_3()
{
	//
	//	Platform Execute Layer 3
	//
	for (unsigned int bls=0; bls < Capacity_lvl_3; bls++)
		Platform_Execute_BseLine(EXE_Bline_cntr++);
	
}


void Platform_Execute_BseLine (unsigned int bline)
{
	EXE_Done_Cntr = 0;

	/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
		Transfering Zero Blocks
	/\/\/\/\/\/\/\/\/\/\/\/\/\/\/*/ 
	DMA_Done_Cntr = 0;
	if (DMA_max_thread[bline] > 0)
		Bline_DMA_ZDB_Transfer(	  DMA_ZDB_Control[bline]);


	/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
		Initialization of STA and UPA
	/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/*/ 
	Bline_Initiate_STA_UPA(				 Capacity[bline],
									 Control_word[bline],
										   Counts[bline],
											Ivals[bline],
							UPA_Inp_base_addr_ptr[bline],
							UPA_Wgt_base_addr_ptr[bline],
							UPA_Out_base_addr_ptr[bline],
							UPA_Acc_base_addr_ptr[bline]);


	/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
		Config Holder 
	/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/*/ 
	for (size_t pln = 0; pln < 4; pln++)
	{
		for (size_t vlt = 0; vlt < 16; vlt++)
			CONFH_set_conf(pln, vlt, Conf_PE[bline]);
		CONFH_refresh (pln); 
	}


	/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
		Plannar EC Configuration
	/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/*/ 
	PSU_EC_reset_all	(PLANE_0);
	PSU_EC_reset_all	(PLANE_1);
	PSU_EC_reset_all	(PLANE_2);
	PSU_EC_reset_all	(PLANE_3);
	Bline_Initiate_STA_ECs(				 Capacity[bline],
									 Control_word[bline]);


	/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
		Waiting for Completion of DMA transfers
	/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/*/ 
	while(DMA_Done_Cntr < DMA_max_thread[bline])	{}


	/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
		Plannar Processing Element Control
	/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/*/ 
	Bline_Initiate_PE_Start(			 Capacity[bline],
									 Control_word[bline],
										 STA_info[bline]);


	/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
		Wait for Completion
	/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/*/ 
	while(EXE_Done_Cntr < Capacity[bline]) {}
	
}


void intr_PC		(unsigned int intr_addr)
{
	// Host Requested an interrupt
	// ok, what does it want to do?
	// i guasee it is open to furture developments
	PC_INT_Cntr++;
}


void intr_TBE		(unsigned int intr_addr)
{
	
}


void intr_RBF		(unsigned int intr_addr)
{
	
}


void intr_TXD		(unsigned int intr_addr)
{
	
}


void intr_RXD		(unsigned int intr_addr)
{
	
}


void intr_Timer		(unsigned int intr_addr)
{
	// Once more, I DO NOT know what to do.
	// just generate it because i can generate it
	// ok, let increment a counter :D 
	if (++TIMER_INT_Cntr == 1000)
	{
		TIMER_INT_Cntr = 0;
		TIMER_INT_Cntr_Sec++;
	}
}


void intr_MPDR		(unsigned int intr_addr)
{
	PRI_Done_Cntr++;
	MPDR_Stop(intr_addr);
}


void intr_DMA		(unsigned int intr_addr)
{
	// Nothing yet
	int which = intr_addr - 16;
	DMA_CallBack(DMA_ZDBT_info[which]);
}


void intr_PLANE_0	(unsigned int intr_addr)
{
	int which = intr_addr - 32;
	int unit  = which / 16;	
	int pe_add= which % 16;	
	if(unit == STA)
	{
		EXE_Done_Cntr++;
		PE_CONT_PE_start(PLANE_0, pe_add);
	}
}


void intr_PLANE_1	(unsigned int intr_addr)
{
	int which = intr_addr - 32;
	int unit  = which / 16;	
	int pe_add= which % 16;	
	if(unit == STA)
	{
		EXE_Done_Cntr++;
		PE_CONT_PE_start(PLANE_1, pe_add);
	}
}


void intr_PLANE_2	(unsigned int intr_addr)
{
	int which = intr_addr - 32;
	int unit  = which / 16;	
	int pe_add= which % 16;	
	if(unit == STA)
	{
		EXE_Done_Cntr++;
		PE_CONT_PE_start(PLANE_2, pe_add);
	}
}


void intr_PLANE_3	(unsigned int intr_addr)
{
	int which = intr_addr - 32;
	int unit  = which / 16;	
	int pe_add= which % 16;	
	if(unit == STA)
	{
		EXE_Done_Cntr++;
		PE_CONT_PE_start(PLANE_3, pe_add);
	}
}


void DMA_CallBack	(unsigned int cntrol_word_ptr)
{
	unsigned int* control = (unsigned int*) cntrol_word_ptr;
	unsigned int* Array   = (unsigned int*)(cntrol_word_ptr+1);
	*control++;
	unsigned int cnt = (*control >> 24);
	unsigned int vlt = (*control >> 20)	& 0xF;
	unsigned int top = (*control >> 10)	& 0x3FF;
	unsigned int idx = (*control >> 0)	& 0x3FF;
	DMA_start_transfer	(vlt,	vlt * 0x1000000,	Array[idx],	cnt);
	if (idx == top)
	{
		DMA_Done_Cntr++;
		*control = *control & 0x3FF;
		INTH_disable_intr_DMA_done(vlt);
		return;
	}
	// Enabling the interrupt 
	DMA_EC_reset(vlt);
	DMA_EC_CNTR_config(vlt, 1, 1, 0, 1);
}


void EXT_INT_0_handler()
{
	unsigned int this_intr_addr;
	unsigned int this_intr_code;
	INTH_get_intr_address(this_intr_addr, this_intr_code);
	funcPtrArray[this_intr_code](this_intr_addr);
}


void EXT_INT_1_handler(){}
void EXT_INT_2_handler(){}
void EXT_INT_3_handler(){}
void EXT_INT_4_handler(){}
void EXT_INT_5_handler(){}
void EXT_INT_6_handler(){}
void EXT_INT_7_handler(){}
void EXT_INT_8_handler(){}
void EXT_INT_9_handler(){}
void EXT_INT_10_handler(){}
void EXT_INT_11_handler(){}
void EXT_INT_12_handler(){}
void EXT_INT_13_handler(){}
void EXT_INT_14_handler(){}
void EXT_INT_15_handler(){}


	
	
	
	
	
	
