
#include "Accelerator.h"



//***************************************************/
//						ACC_DMA						//
//***************************************************/

void DMA_reset_all						()
{
	*C_PERIPHERAL_REG_DMA_READ_ADDRESS = 0;
	*C_PERIPHERAL_REG_DMA_WRITE_ADDRESS= 0;
}

void DMA_wait_for_done					(unsigned int DMA_add)
{
	unsigned int val;
	while(true)
	{
		val = *(C_PERIPHERAL_REG_EVENT_COUNTER_DMA_0_DONE + DMA_add);
		val &= (1 << C_Event_Event_Value_pos);
		if (val)
			break;
	}
}

void DMA_start_transfer					(unsigned int DMA_add, unsigned int read_add, unsigned int write_add, unsigned int cnt)
{
	DMA_wait_for_done(DMA_add);
	*C_PERIPHERAL_REG_DMA_READ_ADDRESS = read_add;
	*C_PERIPHERAL_REG_DMA_WRITE_ADDRESS= write_add;
	*C_PERIPHERAL_REG_DMA_TRANS_COUNT  = cnt;
	*C_PERIPHERAL_REG_DMA_CONTROL = (1 << C_DMA_Start_pos) | (DMA_add << 0);
}


//***************************************************/
// ACC_MPDR
//***************************************************/

void MPDR_reset_all						()
{
	*C_PERIPHERAL_REG_MPDR_DATABLOCK_ADDRESS	=	0;	
	*C_PERIPHERAL_REG_MPDR_CONFIG				=	0;	
	*C_PERIPHERAL_REG_MPDR_CONTTOL				=	0;	
}

void MPDR_wait_for_done					(unsigned int MPDR_add)
{
	unsigned int val;
	while(true)
	{
		val = *(C_PERIPHERAL_REG_EVENT_COUNTER_MPDR_0_DONE + MPDR_add);
		val &= (1 << C_Event_Event_Value_pos);
		if (val)
			break;
	}
}

void MPDR_Initiate						(unsigned int MPDR_add, S_Addressing_Info R1C1, S_Addressing_Info R1C2, S_Addressing_Info R2C1, S_Addressing_Info R2C2, S_Addressing_Info out)
{
	unsigned int val;

	val = (MPDR_add << C_MPDR_Unit_Addres_pos)	| (0 << C_MPDR_Target_pos);
	*C_PERIPHERAL_REG_MPDR_DATABLOCK_ADDRESS	= R1C1.base_add;
	*C_PERIPHERAL_REG_MPDR_CONFIG				= val | (1 << C_MPDR_BA_Wen_pos);
	*C_PERIPHERAL_REG_MPDR_DATABLOCK_ADDRESS	= R1C1.count;
	*C_PERIPHERAL_REG_MPDR_CONFIG				= val | (1 << C_MPDR_CA_Wen_pos);
	*C_PERIPHERAL_REG_MPDR_DATABLOCK_ADDRESS	= R1C1.interval;
	*C_PERIPHERAL_REG_MPDR_CONFIG				= val | (1 << C_MPDR_IA_Wen_pos);

	val = (MPDR_add << C_MPDR_Unit_Addres_pos)	| (1 << C_MPDR_Target_pos);
	*C_PERIPHERAL_REG_MPDR_DATABLOCK_ADDRESS	= R1C2.base_add;
	*C_PERIPHERAL_REG_MPDR_CONFIG				= val | (1 << C_MPDR_BA_Wen_pos);
	*C_PERIPHERAL_REG_MPDR_DATABLOCK_ADDRESS	= R1C2.count;
	*C_PERIPHERAL_REG_MPDR_CONFIG				= val | (1 << C_MPDR_CA_Wen_pos);
	*C_PERIPHERAL_REG_MPDR_DATABLOCK_ADDRESS	= R1C2.interval;
	*C_PERIPHERAL_REG_MPDR_CONFIG				= val | (1 << C_MPDR_IA_Wen_pos);

	val = (MPDR_add << C_MPDR_Unit_Addres_pos)	| (2 << C_MPDR_Target_pos);
	*C_PERIPHERAL_REG_MPDR_DATABLOCK_ADDRESS	= R2C1.base_add;
	*C_PERIPHERAL_REG_MPDR_CONFIG				= val | (1 << C_MPDR_BA_Wen_pos);
	*C_PERIPHERAL_REG_MPDR_DATABLOCK_ADDRESS	= R2C1.count;
	*C_PERIPHERAL_REG_MPDR_CONFIG				= val | (1 << C_MPDR_CA_Wen_pos);
	*C_PERIPHERAL_REG_MPDR_DATABLOCK_ADDRESS	= R2C1.interval;
	*C_PERIPHERAL_REG_MPDR_CONFIG				= val | (1 << C_MPDR_IA_Wen_pos);

	val = (MPDR_add << C_MPDR_Unit_Addres_pos)	| (3 << C_MPDR_Target_pos);
	*C_PERIPHERAL_REG_MPDR_DATABLOCK_ADDRESS	= R2C2.base_add;
	*C_PERIPHERAL_REG_MPDR_CONFIG				= val | (1 << C_MPDR_BA_Wen_pos);
	*C_PERIPHERAL_REG_MPDR_DATABLOCK_ADDRESS	= R2C2.count;
	*C_PERIPHERAL_REG_MPDR_CONFIG				= val | (1 << C_MPDR_CA_Wen_pos);
	*C_PERIPHERAL_REG_MPDR_DATABLOCK_ADDRESS	= R2C2.interval;
	*C_PERIPHERAL_REG_MPDR_CONFIG				= val | (1 << C_MPDR_IA_Wen_pos);

	val = (MPDR_add << C_MPDR_Unit_Addres_pos)	| (7 << C_MPDR_Target_pos);
	*C_PERIPHERAL_REG_MPDR_DATABLOCK_ADDRESS	= out.base_add;
	*C_PERIPHERAL_REG_MPDR_CONFIG				= val | (1 << C_MPDR_BA_Wen_pos);
	*C_PERIPHERAL_REG_MPDR_DATABLOCK_ADDRESS	= out.count;
	*C_PERIPHERAL_REG_MPDR_CONFIG				= val | (1 << C_MPDR_CA_Wen_pos);
	*C_PERIPHERAL_REG_MPDR_DATABLOCK_ADDRESS	= out.interval;
	*C_PERIPHERAL_REG_MPDR_CONFIG				= val | (1 << C_MPDR_IA_Wen_pos);
}

void MPDR_Start							(unsigned int MPDR_add, unsigned int Max_Colm, unsigned int Max_Chan, unsigned int keep)
{
	unsigned int val =	(MPDR_add <<	C_MPDR_Unit_Addres_pos) |
						(1 << C_MPDR_Start_pos) | 
						(keep << C_MPDR_Keep_pos) | 
						(1 << C_MPDR_Load_pos) | 
						(Max_Chan << C_MPDR_Max_Chan_pos) | 
						(Max_Colm << C_MPDR_Max_Colm_pos);
	*C_PERIPHERAL_REG_MPDR_CONTTOL = val;
}

void MPDR_Stop							(unsigned int MPDR_add)
{
	*C_PERIPHERAL_REG_MPDR_CONTTOL = 0;
}

void MPDR_Initiate_Start				(unsigned int H_Ivals,	unsigned int L_Ivals,	const unsigned int* BAs)
{
	//field			:	vlt			Col			chan,		rounds		Out_Ival
	//Hex pos		:	00,			0,			0,			00,			00	

	unsigned int MPDR_add	= ((H_Ivals >> 24) & 0xFF);
	unsigned int Max_colm	= ((H_Ivals >> 20) & 0xF);
	unsigned int Max_chan	= ((H_Ivals >> 16) & 0xF);
	unsigned int Outs_Ival	= ((H_Ivals >>  0) & 0xFF) << 8;
	unsigned int R1C1_Ival	= ((L_Ivals >> 24) & 0xFF) << 8;
	unsigned int R1C2_Ival	= ((L_Ivals >> 16) & 0xFF) << 8;
	unsigned int R2C1_Ival	= ((L_Ivals >>  8) & 0xFF) << 8;
	unsigned int R2C2_Ival	= ((L_Ivals >>  0) & 0xFF) << 8;

	unsigned int cnt = ((Max_colm+1) * (Max_chan+1))-1;
	unsigned int val;
	
	val = (MPDR_add << C_MPDR_Unit_Addres_pos)	| (1 << C_MPDR_BA_Wen_pos);
	*C_PERIPHERAL_REG_MPDR_DATABLOCK_ADDRESS	= BAs[0];
	*C_PERIPHERAL_REG_MPDR_CONFIG				= val | (7 << C_MPDR_Target_pos);
	*C_PERIPHERAL_REG_MPDR_DATABLOCK_ADDRESS	= BAs[1];
	*C_PERIPHERAL_REG_MPDR_CONFIG				= val | (0 << C_MPDR_Target_pos);
	*C_PERIPHERAL_REG_MPDR_DATABLOCK_ADDRESS	= BAs[2];
	*C_PERIPHERAL_REG_MPDR_CONFIG				= val | (1 << C_MPDR_Target_pos);
	*C_PERIPHERAL_REG_MPDR_DATABLOCK_ADDRESS	= BAs[3];
	*C_PERIPHERAL_REG_MPDR_CONFIG				= val | (2 << C_MPDR_Target_pos);
	*C_PERIPHERAL_REG_MPDR_DATABLOCK_ADDRESS	= BAs[4];
	*C_PERIPHERAL_REG_MPDR_CONFIG				= val | (3 << C_MPDR_Target_pos);

	val = (MPDR_add << C_MPDR_Unit_Addres_pos)	| (1 << C_MPDR_IA_Wen_pos);
	*C_PERIPHERAL_REG_MPDR_DATABLOCK_ADDRESS	= R1C1_Ival;
	*C_PERIPHERAL_REG_MPDR_CONFIG				= val | (0 << C_MPDR_Target_pos);
	*C_PERIPHERAL_REG_MPDR_DATABLOCK_ADDRESS	= R1C2_Ival;
	*C_PERIPHERAL_REG_MPDR_CONFIG				= val | (1 << C_MPDR_Target_pos);
	*C_PERIPHERAL_REG_MPDR_DATABLOCK_ADDRESS	= R2C1_Ival;
	*C_PERIPHERAL_REG_MPDR_CONFIG				= val | (2 << C_MPDR_Target_pos);
	*C_PERIPHERAL_REG_MPDR_DATABLOCK_ADDRESS	= R2C2_Ival;
	*C_PERIPHERAL_REG_MPDR_CONFIG				= val | (3 << C_MPDR_Target_pos);
	*C_PERIPHERAL_REG_MPDR_DATABLOCK_ADDRESS	= Outs_Ival;
	*C_PERIPHERAL_REG_MPDR_CONFIG				= val | (7 << C_MPDR_Target_pos);

	val = (MPDR_add << C_MPDR_Unit_Addres_pos)	| (1 << C_MPDR_CA_Wen_pos);
	*C_PERIPHERAL_REG_MPDR_DATABLOCK_ADDRESS	= cnt;
	*C_PERIPHERAL_REG_MPDR_CONFIG				= val | (0 << C_MPDR_Target_pos);
	*C_PERIPHERAL_REG_MPDR_CONFIG				= val | (1 << C_MPDR_Target_pos);
	*C_PERIPHERAL_REG_MPDR_CONFIG				= val | (2 << C_MPDR_Target_pos);
	*C_PERIPHERAL_REG_MPDR_CONFIG				= val | (3 << C_MPDR_Target_pos);
	*C_PERIPHERAL_REG_MPDR_CONFIG				= val | (7 << C_MPDR_Target_pos);


	val =	(MPDR_add 	<<	C_MPDR_Unit_Addres_pos) |
			(1			<< C_MPDR_Start_pos) | 
			(1			<< C_MPDR_Keep_pos) | 
			(1			<< C_MPDR_Load_pos) | 
			(Max_chan	<< C_MPDR_Max_Chan_pos) | 
			(Max_colm	<< C_MPDR_Max_Colm_pos);
	*C_PERIPHERAL_REG_MPDR_CONTTOL = val;
}



//***************************************************/
//						ACC_TIMERs					//
//***************************************************/

void TIMER_reset_all					()
{
	for (unsigned int i=0; i<16; i++)
		*(C_PERIPHERAL_REG_TIMER_0_CONTROL+i) = 0;
}

void TIMER_config						(unsigned int timer_add, unsigned int top, unsigned int clk_dev, unsigned int intr_en)
{
	//	clk_dev:
	//		n	->	clk_timer	=	clk_system / (2**n);
	unsigned int tmp = 0;
	tmp |= (1 << C_Timer_Init_pos);
	tmp |= (intr_en << C_Timer_Int_Enable_pos);
	tmp |= (1 << C_Timer_Int_clear_pos);
	tmp |= ((clk_dev & 0xFFFF) << C_Timer_Clk_Div_pos);
	tmp |= top & 0XFFFFF;
	*(C_PERIPHERAL_REG_TIMER_0_CONTROL + 2*timer_add) = tmp;
}

void TIMER_start						(unsigned int timer_add)
{
	unsigned int tmp = *(C_PERIPHERAL_REG_TIMER_0_CONTROL + 2*timer_add);
	tmp |= (1 << C_Timer_Enable_pos);
	*(C_PERIPHERAL_REG_TIMER_0_CONTROL + 2*timer_add) = tmp;
}

void TIMER_stop							(unsigned int timer_add)
{
	unsigned int tmp = *(C_PERIPHERAL_REG_TIMER_0_CONTROL + 2*timer_add);
	tmp &= ~(1 << C_Timer_Enable_pos);
	*(C_PERIPHERAL_REG_TIMER_0_CONTROL + 2*timer_add) = tmp;
}

void TIMER_restart						(unsigned int timer_add)
{
	unsigned int tmp = *(C_PERIPHERAL_REG_TIMER_0_CONTROL + 2*timer_add);
	tmp |= (1 << C_Timer_Int_clear_pos);
	tmp |= (1 << C_Timer_Init_pos);
	*(C_PERIPHERAL_REG_TIMER_0_CONTROL + 2*timer_add) = tmp;
}

void TIMER_get_value					(unsigned int timer_add, unsigned int& value, unsigned int& intr_status)
{
	unsigned int tmp = *(C_PERIPHERAL_REG_TIMER_0_VALUE + 2*timer_add);
	value = tmp & 0xFFFFF;
	intr_status = ((tmp & (1 << C_Timer_Int_Val_pos)) >> C_Timer_Int_Val_pos);
}



//***************************************************/
//						ACC_DMA_EC					//
//***************************************************/

void DMA_EC_reset_all					()
{
	for (unsigned int i=0; i<16; i++)
		*(C_PERIPHERAL_REG_EVENT_COUNTER_DMA_0_DONE+i) = 0;
}

void DMA_EC_reset						(unsigned int EC_add)
{
	*(C_PERIPHERAL_REG_EVENT_COUNTER_DMA_0_DONE+EC_add) = 0;
}

void DMA_EC_CNTR_config					(unsigned int EC_add, unsigned int max, unsigned int sense_level, unsigned int repeat, unsigned int intr_en)
{
	//	sense level:
	//			0	->	faling Edge
	//			1	->	rising Edge
	unsigned int tmp = 0;
	tmp |= ((max & 0xFF) << C_Event_Max_pos);
	tmp |= (sense_level << C_Event_Sensitity_pos);
	tmp |= (1 << C_Event_Int_Clear_pos);
	tmp |= (intr_en << C_Event_Int_Enabel_pos);
	tmp |= (repeat << C_Event_Stuck_at_Top_pos);
	tmp |= (1 << C_Event_Init_pos);
	*(C_PERIPHERAL_REG_EVENT_COUNTER_DMA_0_DONE + EC_add) = tmp;
}

void DMA_EC_CNTR_start					(unsigned int EC_add)
{
	unsigned int tmp = *(C_PERIPHERAL_REG_EVENT_COUNTER_DMA_0_DONE + EC_add);
	tmp |= (1 << C_Event_Enable_pos);
	*(C_PERIPHERAL_REG_EVENT_COUNTER_DMA_0_DONE + EC_add) = tmp;
}

void DMA_EC_CNTR_stop					(unsigned int EC_add)
{
	unsigned int tmp = *(C_PERIPHERAL_REG_EVENT_COUNTER_DMA_0_DONE + EC_add);
	tmp &= ~(1 << C_Event_Enable_pos);
	*(C_PERIPHERAL_REG_EVENT_COUNTER_DMA_0_DONE + EC_add) = tmp;
}

void DMA_EC_CNTR_restart				(unsigned int EC_add)
{
	 unsigned int tmp = *(C_PERIPHERAL_REG_EVENT_COUNTER_DMA_0_DONE + EC_add);
	tmp |= (1 << C_Event_Int_Clear_pos);
	tmp |= (1 << C_Event_Init_pos);
	*(C_PERIPHERAL_REG_EVENT_COUNTER_DMA_0_DONE + EC_add) = tmp;
}

void DMA_EC_CNTR_get_value				(unsigned int EC_add, unsigned int& value, unsigned int& event_status, unsigned int& intr_status)
{
	unsigned int tmp = *(C_PERIPHERAL_REG_EVENT_COUNTER_DMA_0_DONE + EC_add);
	value = tmp % (1 << C_Event_Max_pos);
	event_status = ((tmp & (1 << C_Event_Event_Value_pos)) >> C_Event_Event_Value_pos); 
	intr_status = ((tmp & (1 << C_Event_Int_Value_pos)) >> C_Event_Int_Value_pos);
}

void PDR_EC_CNTR_config_start			(unsigned int H_Cont_Word)
{
	//	sense level:
	//			0	->	faling Edge
	//			1	->	rising Edge

	unsigned int EC_add		= ((H_Cont_Word >> 24) & 0xFF);
	unsigned int TOP		= ((H_Cont_Word >>  8) & 0xFF);

	unsigned int tmp = 0;
	tmp |= (TOP << C_Event_Max_pos);
	tmp |= (1 << C_Event_Sensitity_pos);
	tmp |= (1 << C_Event_Int_Clear_pos);
	tmp |= (1 << C_Event_Int_Enabel_pos);
	tmp |= (0 << C_Event_Stuck_at_Top_pos);
	tmp |= (1 << C_Event_Init_pos);
	*(C_PERIPHERAL_REG_EVENT_COUNTER_DMA_0_DONE + EC_add) = tmp;
	tmp |= (1 << C_Event_Enable_pos);
	*(C_PERIPHERAL_REG_EVENT_COUNTER_DMA_0_DONE + EC_add) = tmp;
}



//***************************************************/
//						ACC_MPDR_EC					//
//***************************************************/

void MPDR_EC_reset_all					()
{
	for (unsigned int i=0; i<16; i++)
		*(C_PERIPHERAL_REG_EVENT_COUNTER_MPDR_0_DONE+i) = 0;
}

void MPDR_EC_reset_all					(unsigned int EC_add)
{
	*(C_PERIPHERAL_REG_EVENT_COUNTER_MPDR_0_DONE+EC_add) = 0;
}

void MPDR_EC_CNTR_config				(unsigned int EC_add, unsigned int max, unsigned int sense_level, unsigned int repeat, unsigned int intr_en)
{
	//	sense level:
	//			0	->	faling Edge
	//			1	->	rising Edge
	unsigned int tmp = 0;
	tmp |= ((max & 0xFFF) << C_Event_Max_pos);
	tmp |= (sense_level << C_Event_Sensitity_pos);
	tmp |= (1 << C_Event_Int_Clear_pos);
	tmp |= (intr_en << C_Event_Int_Enabel_pos);
	tmp |= (repeat << C_Event_Stuck_at_Top_pos);
	tmp |= (1 << C_Event_Init_pos);
	*(C_PERIPHERAL_REG_EVENT_COUNTER_MPDR_0_DONE + EC_add) = tmp;
}

void MPDR_EC_CNTR_start					(unsigned int EC_add)
{
	unsigned int tmp = *(C_PERIPHERAL_REG_EVENT_COUNTER_MPDR_0_DONE + EC_add);
	tmp |= (1 << C_Event_Enable_pos);
	*(C_PERIPHERAL_REG_EVENT_COUNTER_MPDR_0_DONE + EC_add) = tmp;
}

void MPDR_EC_CNTR_stop					(unsigned int EC_add)
{
	unsigned int tmp = *(C_PERIPHERAL_REG_EVENT_COUNTER_MPDR_0_DONE + EC_add);
	tmp &= ~(1 << C_Event_Enable_pos);
	*(C_PERIPHERAL_REG_EVENT_COUNTER_MPDR_0_DONE + EC_add) = tmp;
}

void MPDR_EC_CNTR_restart				(unsigned int EC_add)
{
	 unsigned int tmp = *(C_PERIPHERAL_REG_EVENT_COUNTER_MPDR_0_DONE + EC_add);
	tmp |= (1 << C_Event_Int_Clear_pos);
	tmp |= (1 << C_Event_Init_pos);
	*(C_PERIPHERAL_REG_EVENT_COUNTER_MPDR_0_DONE + EC_add) = tmp;
}

void MPDR_EC_CNTR_get_value				(unsigned int EC_add, unsigned int& value, unsigned int& event_status, unsigned int& intr_status)
{
	unsigned int tmp = *(C_PERIPHERAL_REG_EVENT_COUNTER_MPDR_0_DONE + EC_add);
	value = tmp % (1 << C_Event_Max_pos);
	event_status = ((tmp & (1 << C_Event_Event_Value_pos)) >> C_Event_Event_Value_pos); 
	intr_status = ((tmp & (1 << C_Event_Int_Value_pos)) >> C_Event_Int_Value_pos);
}



//***************************************************/
//						ACC_CONTROL_REG				//
//***************************************************/

void CONT_REG_ACC_Plane_normal			(unsigned int plane)
{
	*C_PERIPHERAL_REG_CONTROL_REGISTE = *C_PERIPHERAL_REG_CONTROL_REGISTE | (1 << plane);
}

void CONT_REG_ACC_Plane_reset			(unsigned int plane)
{
	*C_PERIPHERAL_REG_CONTROL_REGISTE = *C_PERIPHERAL_REG_CONTROL_REGISTE & (~(1 << plane));
}

void CONT_REG_DRAM_connect				()
{
	*C_PERIPHERAL_REG_CONTROL_REGISTE = *C_PERIPHERAL_REG_CONTROL_REGISTE | (1 << C_Accelerator_Connect_pos);
}

void CONT_REG_DRAM_disconnect			()
{
	*C_PERIPHERAL_REG_CONTROL_REGISTE = *C_PERIPHERAL_REG_CONTROL_REGISTE & (~(1 << C_Accelerator_Connect_pos));
}



//***************************************************/
//						ACC_USART					//
//***************************************************/

void UART_reset							()
{
	*C_PERIPHERAL_REG_TRx_UNIT_CONT_WORD = 0;
}

void UART_Initiate						(unsigned int Cont_Word)
{
	*C_PERIPHERAL_REG_TRx_UNIT_CONT_WORD = Cont_Word;
}

void UART_read_flags					(unsigned int& TBE_flg, unsigned int& TBF_flg, unsigned int& RBE_flg, unsigned int& RBF_flg)
{
	unsigned int word = *C_PERIPHERAL_REG_TRx_UNIT_CONT_WORD;
	TBE_flg = (word >> C_TRx_Unit_Tx_Buff_Empty_Flg_pos	) & 0x1;
	TBF_flg = (word >> C_TRx_Unit_Tx_Buff_Full_Flg_pos	) & 0x1;
	RBE_flg = (word >> C_TRx_Unit_Rx_Buff_Empty_Flg_pos	) & 0x1;
	RBF_flg = (word >> C_TRx_Unit_Rx_Buff_Full_Flg_pos	) & 0x1;
}

void UART_write_data					(unsigned int Data_Word)
{
	*C_PERIPHERAL_REG_TRx_UNIT_DATA_WORD = Data_Word;
}

void UART_read_data						(unsigned int& Data_Word, unsigned int& DOR_error)
{
	Data_Word = *C_PERIPHERAL_REG_TRx_UNIT_DATA_WORD;
	DOR_error = Data_Word >> C_TRx_Unit_Rx_DORE_Flg_pos;
	Data_Word = Data_Word & 0Xff;
}

void UART_read_TBF_flag					(unsigned int& TBF_flg)
{
	TBF_flg = (*C_PERIPHERAL_REG_TRx_UNIT_CONT_WORD >> C_TRx_Unit_Tx_Buff_Full_Flg_pos	) & 0x1;
}

void UART_read_RBE_flag					(unsigned int& RBE_flg)
{
	RBE_flg = (*C_PERIPHERAL_REG_TRx_UNIT_CONT_WORD >> C_TRx_Unit_Rx_Buff_Empty_Flg_pos	) & 0x1;
}





//***************************************************/
//						ACC_INTR_HANDLER			//
//***************************************************/

void INTH_reset_all						()
{
	*(C_PERIPHERAL_REG_INTERRUPT_ENABLE_PC			) = 0;
	*(C_PERIPHERAL_REG_INTERRUPT_ENABLE_TIMER		) = 0;
	*(C_PERIPHERAL_REG_INTERRUPT_ENABLE_MPDR		) = 0;
	*(C_PERIPHERAL_REG_INTERRUPT_ENABLE_DMA			) = 0;
	*(C_PERIPHERAL_REG_INTERRUPT_ENABLE_PSU_PLANE_0	) = 0;
	*(C_PERIPHERAL_REG_INTERRUPT_ENABLE_PSU_PLANE_1	) = 0;
	*(C_PERIPHERAL_REG_INTERRUPT_ENABLE_PSU_PLANE_2	) = 0;
	*(C_PERIPHERAL_REG_INTERRUPT_ENABLE_PSU_PLANE_3	) = 0;
}

void INTH_enable_intr_pc				()
{
	*C_PERIPHERAL_REG_INTERRUPT_ENABLE_PC = *C_PERIPHERAL_REG_INTERRUPT_ENABLE_PC | (1 << C_INT_PC_Req_pos);
}

void INTH_enable_intr_TBE				()
{
	*C_PERIPHERAL_REG_INTERRUPT_ENABLE_PC = *C_PERIPHERAL_REG_INTERRUPT_ENABLE_PC | (1 << C_INT_TBE_pos);
}

void INTH_enable_intr_RBF				()
{
	*C_PERIPHERAL_REG_INTERRUPT_ENABLE_PC = *C_PERIPHERAL_REG_INTERRUPT_ENABLE_PC | (1 << C_INT_RBF_pos);
}

void INTH_enable_intr_Tx_Done			()
{
	*C_PERIPHERAL_REG_INTERRUPT_ENABLE_PC = *C_PERIPHERAL_REG_INTERRUPT_ENABLE_PC | (1 << C_INT_TXD_pos);
}

void INTH_enable_intr_Rx_Done			()
{
	*C_PERIPHERAL_REG_INTERRUPT_ENABLE_PC = *C_PERIPHERAL_REG_INTERRUPT_ENABLE_PC | (1 << C_INT_RXD_pos);
}

void INTH_enable_intr_timer				(unsigned int timer_add)
{
	*C_PERIPHERAL_REG_INTERRUPT_ENABLE_TIMER = *C_PERIPHERAL_REG_INTERRUPT_ENABLE_TIMER | (1 << (C_INT_Timer_0_pos+timer_add));
}

void INTH_enable_intr_timer_group		(unsigned int timer_group)
{
	unsigned int group = timer_group & 0xFF;
	*C_PERIPHERAL_REG_INTERRUPT_ENABLE_TIMER = *C_PERIPHERAL_REG_INTERRUPT_ENABLE_TIMER | (group << C_INT_Timer_0_pos);
}

void INTH_enable_intr_MPDR_done			(unsigned int mpdr_add)
{
	*C_PERIPHERAL_REG_INTERRUPT_ENABLE_MPDR = *C_PERIPHERAL_REG_INTERRUPT_ENABLE_MPDR | (1 << (C_INT_MPDR_0_Done_pos+mpdr_add));
}

void INTH_enable_intr_MPDR_done_group	(unsigned int mpdr_group)
{
	unsigned int group = mpdr_group & 65535;
	*C_PERIPHERAL_REG_INTERRUPT_ENABLE_MPDR = *C_PERIPHERAL_REG_INTERRUPT_ENABLE_MPDR | (group << C_INT_MPDR_0_Done_pos);
}

void INTH_enable_intr_DMA_done			(unsigned int dma_add)
{
	*C_PERIPHERAL_REG_INTERRUPT_ENABLE_DMA = *C_PERIPHERAL_REG_INTERRUPT_ENABLE_DMA | (1 << (C_INT_DMA_0_Done_pos+dma_add));
}

void INTH_enable_intr_DMA_done_group	(unsigned int dma_group)
{
	unsigned int group = dma_group & 65535;
	*C_PERIPHERAL_REG_INTERRUPT_ENABLE_DMA = *C_PERIPHERAL_REG_INTERRUPT_ENABLE_DMA | (group << C_INT_DMA_0_Done_pos);
}

void INTH_enable_PSU_done				(unsigned int plane, unsigned int pe_add)
{
	*(C_PERIPHERAL_REG_INTERRUPT_ENABLE_PSU_PLANE_0+plane) = *(C_PERIPHERAL_REG_INTERRUPT_ENABLE_PSU_PLANE_0+plane) | (1 << (C_INT_PSU_1_1_Done_pos+pe_add));
}

void INTH_enable_PSU_done_group			(unsigned int plane, unsigned int pe_group)
{
	unsigned int group = pe_group & 0xFFFF;
	*(C_PERIPHERAL_REG_INTERRUPT_ENABLE_PSU_PLANE_0+plane) = *(C_PERIPHERAL_REG_INTERRUPT_ENABLE_PSU_PLANE_0+plane) | (group << C_INT_PSU_1_1_Done_pos);
}

void INTH_disable_intr_pc				()
{
	 *C_PERIPHERAL_REG_INTERRUPT_ENABLE_PC = *C_PERIPHERAL_REG_INTERRUPT_ENABLE_PC & (~(1 << C_INT_PC_Req_pos));
}

void INTH_disable_intr_TBE				()
{
	 *C_PERIPHERAL_REG_INTERRUPT_ENABLE_PC = *C_PERIPHERAL_REG_INTERRUPT_ENABLE_PC & (~(1 << C_INT_TBE_pos));
}

void INTH_disable_intr_RBF				()
{
	 *C_PERIPHERAL_REG_INTERRUPT_ENABLE_PC = *C_PERIPHERAL_REG_INTERRUPT_ENABLE_PC & (~(1 << C_INT_RBF_pos));
}

void INTH_disable_Tx_Done				()
{
	 *C_PERIPHERAL_REG_INTERRUPT_ENABLE_PC = *C_PERIPHERAL_REG_INTERRUPT_ENABLE_PC & (~(1 << C_INT_TXD_pos));
}

void INTH_disable_Rx_Done				()
{
	 *C_PERIPHERAL_REG_INTERRUPT_ENABLE_PC = *C_PERIPHERAL_REG_INTERRUPT_ENABLE_PC & (~(1 << C_INT_RXD_pos));
}

void INTH_disable_intr_timer			(unsigned int timer_add)
{
	*C_PERIPHERAL_REG_INTERRUPT_ENABLE_TIMER = *C_PERIPHERAL_REG_INTERRUPT_ENABLE_TIMER & (~(1 << (C_INT_Timer_0_pos+timer_add)));
}

void INTH_disable_intr_timer_group		(unsigned int timer_group)
{
	unsigned int group = timer_group & 0xFF;
	*C_PERIPHERAL_REG_INTERRUPT_ENABLE_TIMER = *C_PERIPHERAL_REG_INTERRUPT_ENABLE_TIMER & (~(group << C_INT_Timer_0_pos));
}

void INTH_disable_intr_MPDR_done		(unsigned int mpdr_add)
{
	*C_PERIPHERAL_REG_INTERRUPT_ENABLE_MPDR = *C_PERIPHERAL_REG_INTERRUPT_ENABLE_MPDR & (~(1 << (C_INT_MPDR_0_Done_pos+mpdr_add)));
}

void INTH_disable_intr_MPDR_done_group	(unsigned int mpdr_group)
{
	unsigned int group = mpdr_group & 0xFFFF;
	*C_PERIPHERAL_REG_INTERRUPT_ENABLE_MPDR = *C_PERIPHERAL_REG_INTERRUPT_ENABLE_MPDR & (~(group << C_INT_MPDR_0_Done_pos));
}

void INTH_disable_intr_DMA_done			(unsigned int dma_add)
{
	*C_PERIPHERAL_REG_INTERRUPT_ENABLE_DMA = *C_PERIPHERAL_REG_INTERRUPT_ENABLE_DMA & (~(1 << (C_INT_DMA_0_Done_pos+dma_add)));
}

void INTH_disable_intr_DMA_done_group	(unsigned int dma_group)
{
	unsigned int group = dma_group & 0xFFFF;
	*C_PERIPHERAL_REG_INTERRUPT_ENABLE_DMA = *C_PERIPHERAL_REG_INTERRUPT_ENABLE_DMA & (~(group << C_INT_DMA_0_Done_pos));
}

void INTH_disable_PSU_done				(unsigned int plane, unsigned int pe_add)
{
	*(C_PERIPHERAL_REG_INTERRUPT_ENABLE_PSU_PLANE_0+plane) = *(C_PERIPHERAL_REG_INTERRUPT_ENABLE_PSU_PLANE_0+plane) & (~(1 << (C_INT_PSU_1_1_Done_pos+pe_add)));
}

void INTH_disable_PSU_done_group		(unsigned int plane, unsigned int pe_group)
{
	unsigned int group = pe_group & 0xFFFF;
	*(C_PERIPHERAL_REG_INTERRUPT_ENABLE_PSU_PLANE_0+plane) = *(C_PERIPHERAL_REG_INTERRUPT_ENABLE_PSU_PLANE_0+plane) & (~(group << C_INT_PSU_1_1_Done_pos));
}

void INTH_get_intr_address				(unsigned int& next_intr_address, unsigned int& this_intr_address, unsigned int& next_intr_code, unsigned int& this_intr_code)
{
	unsigned int value = *(C_PERIPHERAL_REG_INTERRUPT_ADDRESS);
	next_intr_address	=	(value >> C_INT_NEXT_Address_pos)	& 0x000000FF;
	this_intr_address	=	(value >> C_INT_THIS_Address_pos)	& 0x000000FF;
	next_intr_code		=	(value >> C_INT_NEXT_code_pos)		& 0x0000000F;
	this_intr_code		=	(value >> C_INT_THIS_code_pos)		& 0x0000000F;
}

void INTH_get_intr_address				(unsigned int& this_intr_address, unsigned int& this_intr_code)
{
	unsigned int value = *(C_PERIPHERAL_REG_INTERRUPT_ADDRESS);
	this_intr_address	=	(value >> C_INT_THIS_Address_pos)	& 0x000000FF;
	this_intr_code		=	(value >> C_INT_THIS_code_pos)		& 0x0000000F;
}



//***************************************************/
//						CONF_HOLDER					//
//***************************************************/

void CONFH_reset_all					(unsigned int plane_add)
{
	for (unsigned int i=0; i<16; i++)
		*(C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + i) = 0;
}

void CONFH_set_conf						(unsigned int plane_add, unsigned int pe_add, S_PE_cofig cnf)
{
	unsigned int val = 0;
	val	|=	(cnf.E_Chnl_max		<<	C_Channel_MAX_pos		);
	val	|=	(cnf.E_Colm_max		<<	C_Column_MAX_pos		);
	val	|=	(cnf.E_Kern_max		<<	C_Kernel_MAX_pos		);
	val	|=	(cnf.E_Zpad_max		<<	C_ZPad_MAX_pos			);
	val	|=	(cnf.WFM_NS			<<	C_WFM_Numeric_pos		);
	val	|=	(cnf.IFM_NS			<<	C_IFM_Numeric_pos		);
	val	|=	(cnf.FH_Arith		<<	C_Computation_Size_pos	);
	val	|=	(cnf.E_Shift_cnt	<<	C_Shift_Count_pos		);
	val	|=	(cnf.FSM_Src		<<	C_FSM_SEL_pos			);
	*(C_PERIPHERAL_PLANE_0_REG_CONFIG_HOLDER_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add) = val;
}

void CONFH_refresh						(unsigned int plane_add)
{
	CONT_REG_ACC_Plane_reset(plane_add);
	CONT_REG_ACC_Plane_normal(plane_add);
}



//***************************************************/
//						PE_INIT						//
//***************************************************/

void PE_INIT_reset_all					(unsigned int plane_add)
{
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_BIAS_VALUE			+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL)) = 0;
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_BIAS_CONTROL		+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL)) = 0;
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT		+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL)) = 0;
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR	+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL)) = 0;
}

void PE_INIT_SA_load_bias_data			(unsigned int plane_add, unsigned int pe_add, unsigned int biases[16], unsigned int count)
{
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR	+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL)) = (pe_add << C_SUU_Address_Point_Unit_Add_pos);
	for (unsigned int i=0; i< count; i++)
	{
		*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_BIAS_VALUE		+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL)) = biases[i];
		*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_BIAS_CONTROL	+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL)) = (1 << C_SAU_Bias_Wen_pos) | (i << C_SAU_Bias_Kernel_Add_pos);
	}
}

void PE_INIT_SA_load_address 			(unsigned int plane_add, unsigned int pe_add, S_Addressing_Info load_add,   S_Addressing_Info store_add)
{
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT		+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   load_add.base_add;
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR	+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   (1 << C_SUU_Address_Point_Base_Wen_pos) |
																												(0 << C_SUU_Address_Point_Count_Wen_pos) |
																												(0 << C_SUU_Address_Point_Interval_Wen_pos) |
																												(1 << C_SUU_Address_Point_SA_UAb_pos) |
																												(pe_add << C_SUU_Address_Point_Unit_Add_pos) |
																												(0 << C_SUU_Address_Point_Target_Add_pos);
	
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT		+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   load_add.count;
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR	+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   (0 << C_SUU_Address_Point_Base_Wen_pos) |
																												(1 << C_SUU_Address_Point_Count_Wen_pos) |
																												(0 << C_SUU_Address_Point_Interval_Wen_pos) |
																												(1 << C_SUU_Address_Point_SA_UAb_pos) |
																												(pe_add << C_SUU_Address_Point_Unit_Add_pos) |
																												(0 << C_SUU_Address_Point_Target_Add_pos);
	
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT		+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   load_add.interval;
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR	+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   (0 << C_SUU_Address_Point_Base_Wen_pos) |
																												(0 << C_SUU_Address_Point_Count_Wen_pos) |
																												(1 << C_SUU_Address_Point_Interval_Wen_pos) |
																												(1 << C_SUU_Address_Point_SA_UAb_pos) |
																												(pe_add << C_SUU_Address_Point_Unit_Add_pos) |
																												(0 << C_SUU_Address_Point_Target_Add_pos);
	
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT		+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   store_add.base_add;
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR	+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   (1 << C_SUU_Address_Point_Base_Wen_pos) |
																												(0 << C_SUU_Address_Point_Count_Wen_pos) |
																												(0 << C_SUU_Address_Point_Interval_Wen_pos) |
																												(1 << C_SUU_Address_Point_SA_UAb_pos) |
																												(pe_add << C_SUU_Address_Point_Unit_Add_pos) |
																												(1 << C_SUU_Address_Point_Target_Add_pos);
	
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT		+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   store_add.count;
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR	+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   (0 << C_SUU_Address_Point_Base_Wen_pos) |
																												(1 << C_SUU_Address_Point_Count_Wen_pos) |
																												(0 << C_SUU_Address_Point_Interval_Wen_pos) |
																												(1 << C_SUU_Address_Point_SA_UAb_pos) |
																												(pe_add << C_SUU_Address_Point_Unit_Add_pos) |
																												(1 << C_SUU_Address_Point_Target_Add_pos);
	
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT		+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   store_add.interval;
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR	+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   (0 << C_SUU_Address_Point_Base_Wen_pos) |
																												(0 << C_SUU_Address_Point_Count_Wen_pos) |
																												(1 << C_SUU_Address_Point_Interval_Wen_pos) |
																												(1 << C_SUU_Address_Point_SA_UAb_pos) |
																												(pe_add << C_SUU_Address_Point_Unit_Add_pos) |
																												(1 << C_SUU_Address_Point_Target_Add_pos);
}

void PE_INIT_UA_load_address 			(unsigned int plane_add, unsigned int pe_add, S_Addressing_Info wgt_add[9], S_Addressing_Info inp_add)
{
	for (unsigned int i=0; i<9; i++)
	{
		*(plane_add + C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT)									=   wgt_add[i].base_add;
		*(plane_add + C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR)								=   (1 << C_SUU_Address_Point_Base_Wen_pos) |
																												(0 << C_SUU_Address_Point_Count_Wen_pos) |
																												(0 << C_SUU_Address_Point_Interval_Wen_pos) |
																												(0 << C_SUU_Address_Point_SA_UAb_pos) |
																												(pe_add << C_SUU_Address_Point_Unit_Add_pos) |
																												(i << C_SUU_Address_Point_Target_Add_pos);

		*(plane_add + C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT)									=   wgt_add[i].count;
		*(plane_add + C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR)								=   (0 << C_SUU_Address_Point_Base_Wen_pos) |
																												(1 << C_SUU_Address_Point_Count_Wen_pos) |
																												(0 << C_SUU_Address_Point_Interval_Wen_pos) |
																												(0 << C_SUU_Address_Point_SA_UAb_pos) |
																												(pe_add << C_SUU_Address_Point_Unit_Add_pos) |
																												(i << C_SUU_Address_Point_Target_Add_pos);

		*(plane_add + C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT)	   								=   wgt_add[i].interval;
		*(plane_add + C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR) 							=   (0 << C_SUU_Address_Point_Base_Wen_pos) |
																												(0 << C_SUU_Address_Point_Count_Wen_pos) |
																												(1 << C_SUU_Address_Point_Interval_Wen_pos) |
																												(0 << C_SUU_Address_Point_SA_UAb_pos) |
																												(pe_add << C_SUU_Address_Point_Unit_Add_pos) |
																												(i << C_SUU_Address_Point_Target_Add_pos);
	}
	
	
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT		+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   inp_add.base_add;
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR	+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   (1 << C_SUU_Address_Point_Base_Wen_pos) |
																												(0 << C_SUU_Address_Point_Count_Wen_pos) |
																												(0 << C_SUU_Address_Point_Interval_Wen_pos) |
																												(0 << C_SUU_Address_Point_SA_UAb_pos) |
																												(pe_add << C_SUU_Address_Point_Unit_Add_pos) |
																												(15 << C_SUU_Address_Point_Target_Add_pos);
	
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT		+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   inp_add.count;
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR	+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   (0 << C_SUU_Address_Point_Base_Wen_pos) |
																												(1 << C_SUU_Address_Point_Count_Wen_pos) |
																												(0 << C_SUU_Address_Point_Interval_Wen_pos) |
																												(0 << C_SUU_Address_Point_SA_UAb_pos) |
																												(pe_add << C_SUU_Address_Point_Unit_Add_pos) |
																												(15 << C_SUU_Address_Point_Target_Add_pos);
	
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT		+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   inp_add.interval;
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR	+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   (0 << C_SUU_Address_Point_Base_Wen_pos) |
																												(0 << C_SUU_Address_Point_Count_Wen_pos) |
																												(1 << C_SUU_Address_Point_Interval_Wen_pos) |
																												(0 << C_SUU_Address_Point_SA_UAb_pos) |
																												(pe_add << C_SUU_Address_Point_Unit_Add_pos) |
																												(15 << C_SUU_Address_Point_Target_Add_pos);
	
}

void PE_INIT_SA_load_address 			(unsigned int plane_add,				unsigned int pe_add, 
										unsigned int load_base_add,				unsigned int load_Count,	unsigned int load_Ival,   
										unsigned int store_base_add,			unsigned int store_Count,	unsigned int store_Ival)
{
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT		+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   load_base_add;
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR	+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   (1 << C_SUU_Address_Point_Base_Wen_pos) |
																												(0 << C_SUU_Address_Point_Count_Wen_pos) |
																												(0 << C_SUU_Address_Point_Interval_Wen_pos) |
																												(1 << C_SUU_Address_Point_SA_UAb_pos) |
																												(pe_add << C_SUU_Address_Point_Unit_Add_pos) |
																												(0 << C_SUU_Address_Point_Target_Add_pos);
	
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT		+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   load_Count;
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR	+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   (0 << C_SUU_Address_Point_Base_Wen_pos) |
																												(1 << C_SUU_Address_Point_Count_Wen_pos) |
																												(0 << C_SUU_Address_Point_Interval_Wen_pos) |
																												(1 << C_SUU_Address_Point_SA_UAb_pos) |
																												(pe_add << C_SUU_Address_Point_Unit_Add_pos) |
																												(0 << C_SUU_Address_Point_Target_Add_pos);
	
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT		+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   load_Ival;
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR	+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   (0 << C_SUU_Address_Point_Base_Wen_pos) |
																												(0 << C_SUU_Address_Point_Count_Wen_pos) |
																												(1 << C_SUU_Address_Point_Interval_Wen_pos) |
																												(1 << C_SUU_Address_Point_SA_UAb_pos) |
																												(pe_add << C_SUU_Address_Point_Unit_Add_pos) |
																												(0 << C_SUU_Address_Point_Target_Add_pos);
	
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT		+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   store_base_add;
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR	+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   (1 << C_SUU_Address_Point_Base_Wen_pos) |
																												(0 << C_SUU_Address_Point_Count_Wen_pos) |
																												(0 << C_SUU_Address_Point_Interval_Wen_pos) |
																												(1 << C_SUU_Address_Point_SA_UAb_pos) |
																												(pe_add << C_SUU_Address_Point_Unit_Add_pos) |
																												(1 << C_SUU_Address_Point_Target_Add_pos);
	
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT		+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   store_Count;
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR	+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   (0 << C_SUU_Address_Point_Base_Wen_pos) |
																												(1 << C_SUU_Address_Point_Count_Wen_pos) |
																												(0 << C_SUU_Address_Point_Interval_Wen_pos) |
																												(1 << C_SUU_Address_Point_SA_UAb_pos) |
																												(pe_add << C_SUU_Address_Point_Unit_Add_pos) |
																												(1 << C_SUU_Address_Point_Target_Add_pos);
	
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT		+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   store_Ival;
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR	+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   (0 << C_SUU_Address_Point_Base_Wen_pos) |
																												(0 << C_SUU_Address_Point_Count_Wen_pos) |
																												(1 << C_SUU_Address_Point_Interval_Wen_pos) |
																												(1 << C_SUU_Address_Point_SA_UAb_pos) |
																												(pe_add << C_SUU_Address_Point_Unit_Add_pos) |
																												(1 << C_SUU_Address_Point_Target_Add_pos);
}

void PE_INIT_UA_Inp_load_address		(unsigned int plane_add,				unsigned int pe_add,   
										unsigned int Input_base_add,			unsigned int Input_Count,	unsigned int Input_Ival)
{
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT		+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   Input_base_add;
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR	+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   (1 << C_SUU_Address_Point_Base_Wen_pos) |
																												(0 << C_SUU_Address_Point_Count_Wen_pos) |
																												(0 << C_SUU_Address_Point_Interval_Wen_pos) |
																												(0 << C_SUU_Address_Point_SA_UAb_pos) |
																												(pe_add << C_SUU_Address_Point_Unit_Add_pos) |
																												(15 << C_SUU_Address_Point_Target_Add_pos);
	
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT		+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   Input_Count;
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR	+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   (0 << C_SUU_Address_Point_Base_Wen_pos) |
																												(1 << C_SUU_Address_Point_Count_Wen_pos) |
																												(0 << C_SUU_Address_Point_Interval_Wen_pos) |
																												(0 << C_SUU_Address_Point_SA_UAb_pos) |
																												(pe_add << C_SUU_Address_Point_Unit_Add_pos) |
																												(15 << C_SUU_Address_Point_Target_Add_pos);
	
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT		+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   Input_Ival;
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR	+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   (0 << C_SUU_Address_Point_Base_Wen_pos) |
																												(0 << C_SUU_Address_Point_Count_Wen_pos) |
																												(1 << C_SUU_Address_Point_Interval_Wen_pos) |
																												(0 << C_SUU_Address_Point_SA_UAb_pos) |
																												(pe_add << C_SUU_Address_Point_Unit_Add_pos) |
																												(15 << C_SUU_Address_Point_Target_Add_pos);
	
}

void PE_INIT_UA_Wgt_load_address		(unsigned int plane_add,				unsigned int pe_add,
										const unsigned int* Weight_base_add,	unsigned int Weight_Count,	unsigned int Weight_Ival)
{
	*(plane_add + C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT)										=   Weight_Count;
	for (unsigned int i=0; i<9; i++)
	{
		*(plane_add + C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR)								=   (0 << C_SUU_Address_Point_Base_Wen_pos) |
																												(1 << C_SUU_Address_Point_Count_Wen_pos) |
																												(0 << C_SUU_Address_Point_Interval_Wen_pos) |
																												(0 << C_SUU_Address_Point_SA_UAb_pos) |
																												(pe_add << C_SUU_Address_Point_Unit_Add_pos) |
																												(i << C_SUU_Address_Point_Target_Add_pos);
	}


	*(plane_add + C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT)	   									=   Weight_Ival;
	for (unsigned int i=0; i<9; i++)
	{
		*(plane_add + C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR) 							=   (0 << C_SUU_Address_Point_Base_Wen_pos) |
																												(0 << C_SUU_Address_Point_Count_Wen_pos) |
																												(1 << C_SUU_Address_Point_Interval_Wen_pos) |
																												(0 << C_SUU_Address_Point_SA_UAb_pos) |
																												(pe_add << C_SUU_Address_Point_Unit_Add_pos) |
																												(i << C_SUU_Address_Point_Target_Add_pos);
	}

	for (unsigned int i=0; i<9; i++)
	{
		*(plane_add + C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT)									=   Weight_base_add[i];
		*(plane_add + C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR)								=   (1 << C_SUU_Address_Point_Base_Wen_pos) |
																												(0 << C_SUU_Address_Point_Count_Wen_pos) |
																												(0 << C_SUU_Address_Point_Interval_Wen_pos) |
																												(0 << C_SUU_Address_Point_SA_UAb_pos) |
																												(pe_add << C_SUU_Address_Point_Unit_Add_pos) |
																												(i << C_SUU_Address_Point_Target_Add_pos);		
	}
}

void PE_INIT_SA_Out_load_address 		(unsigned int plane_add,				unsigned int pe_add, 
										unsigned int store_base_add,			unsigned int store_Count,	unsigned int store_Ival)
{
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT		+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   store_base_add;
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR	+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   (1 << C_SUU_Address_Point_Base_Wen_pos) |
																												(0 << C_SUU_Address_Point_Count_Wen_pos) |
																												(0 << C_SUU_Address_Point_Interval_Wen_pos) |
																												(1 << C_SUU_Address_Point_SA_UAb_pos) |
																												(pe_add << C_SUU_Address_Point_Unit_Add_pos) |
																												(1 << C_SUU_Address_Point_Target_Add_pos);
	
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT		+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   store_Count;
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR	+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   (0 << C_SUU_Address_Point_Base_Wen_pos) |
																												(1 << C_SUU_Address_Point_Count_Wen_pos) |
																												(0 << C_SUU_Address_Point_Interval_Wen_pos) |
																												(1 << C_SUU_Address_Point_SA_UAb_pos) |
																												(pe_add << C_SUU_Address_Point_Unit_Add_pos) |
																												(1 << C_SUU_Address_Point_Target_Add_pos);
	
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT		+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   store_Ival;
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR	+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   (0 << C_SUU_Address_Point_Base_Wen_pos) |
																												(0 << C_SUU_Address_Point_Count_Wen_pos) |
																												(1 << C_SUU_Address_Point_Interval_Wen_pos) |
																												(1 << C_SUU_Address_Point_SA_UAb_pos) |
																												(pe_add << C_SUU_Address_Point_Unit_Add_pos) |
																												(1 << C_SUU_Address_Point_Target_Add_pos);
}

void PE_INIT_SA_Acc_load_address 		(unsigned int plane_add,				unsigned int pe_add, 
										unsigned int load_base_add,				unsigned int load_Count,	unsigned int load_Ival)
{
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT		+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   load_base_add;
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR	+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   (1 << C_SUU_Address_Point_Base_Wen_pos) |
																												(0 << C_SUU_Address_Point_Count_Wen_pos) |
																												(0 << C_SUU_Address_Point_Interval_Wen_pos) |
																												(1 << C_SUU_Address_Point_SA_UAb_pos) |
																												(pe_add << C_SUU_Address_Point_Unit_Add_pos) |
																												(0 << C_SUU_Address_Point_Target_Add_pos);
	
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT		+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   load_Count;
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR	+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   (0 << C_SUU_Address_Point_Base_Wen_pos) |
																												(1 << C_SUU_Address_Point_Count_Wen_pos) |
																												(0 << C_SUU_Address_Point_Interval_Wen_pos) |
																												(1 << C_SUU_Address_Point_SA_UAb_pos) |
																												(pe_add << C_SUU_Address_Point_Unit_Add_pos) |
																												(0 << C_SUU_Address_Point_Target_Add_pos);
	
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT		+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   load_Ival;
	*(C_PERIPHERAL_PLANE_0_REG_SAU_INITIATE_ADDRESS_POINT_CNTR	+ (plane_add * C_PERIPHERAL_PLAN_INTERVAL))	=   (0 << C_SUU_Address_Point_Base_Wen_pos) |
																												(0 << C_SUU_Address_Point_Count_Wen_pos) |
																												(1 << C_SUU_Address_Point_Interval_Wen_pos) |
																												(1 << C_SUU_Address_Point_SA_UAb_pos) |
																												(pe_add << C_SUU_Address_Point_Unit_Add_pos) |
																												(0 << C_SUU_Address_Point_Target_Add_pos);
	
}



//***************************************************/
//						PE_CONT						//
//***************************************************/

void PE_CONT_reset_all					(unsigned int plane_add)
{
	for(unsigned int i=0; i<16; i++)
		*(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + i) = 0;
}

void PE_CONT_PE_pause					(unsigned int plane_add, unsigned int pe_add)
{
	unsigned int tmp = *(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add);
	tmp |= (1 << C_Pause_PE_pos);
	*(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add) = tmp;
}

void PE_CONT_PE_resume					(unsigned int plane_add, unsigned int pe_add)
{
	unsigned int tmp = *(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add);
	tmp &= ~(1 << C_Pause_PE_pos);
	*(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add) = tmp;
}

void PE_CONT_PE_start					(unsigned int plane_add, unsigned int pe_add)
{
	unsigned int tmp = *(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add);
	tmp |= (1 << C_Start_PE_pos);
	*(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add) = tmp;
}

void PE_CONT_PE_stop					(unsigned int plane_add, unsigned int pe_add)
{
	unsigned int tmp = *(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add);
	tmp &= ~(1 << C_Start_PE_pos);
	*(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add) = tmp;
}

void PE_CONT_STA_pause					(unsigned int plane_add, unsigned int pe_add)
{
	unsigned int tmp = *(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add);
	tmp |= (1 << C_Pause_STA_pos);
	*(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add) = tmp;
}

void PE_CONT_STA_resume					(unsigned int plane_add, unsigned int pe_add)
{
	unsigned int tmp = *(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add);
	tmp &= ~(1 << C_Pause_STA_pos);
	*(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add) = tmp;
}

void PE_CONT_STA_load_config			(unsigned int plane_add, unsigned int pe_add, S_CONF_STA_info info)
{
	unsigned int tmp = *(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add);
	tmp &= ~(   (1 << C_Update_Store_Base_Address_pos) | 
				(1 << C_Update_load_Base_Address_pos) |
				(1 << C_Store_Row_pos) |
				(1 << C_Enable_Activation_pos) |
				(1 << C_Save_Row_pos) |
				(1 << C_Bias_Accumulation_Enable_pos) |
				(1 << C_PEout_Accumulation_Enable_pos) |
				(1 << C_Buffer_Accumulation_Enable_pos) |
				(1 << C_Load_Row_pos) |
				(1 << C_AUTOMATIC_STA_pos));
	tmp |=  (   (info.update_store_address << C_Update_Store_Base_Address_pos) | 
				(info.update_load_address << C_Update_load_Base_Address_pos) |
				(info.store_enable << C_Store_Row_pos) |
				(info.activation_enable << C_Enable_Activation_pos) |
				(info.save_on_buffer << C_Save_Row_pos) |
				(info.accumulate_with_bias << C_Bias_Accumulation_Enable_pos) |
				(info.accumulate_with_OBM << C_PEout_Accumulation_Enable_pos) |
				(info.accumulate_with_buffer << C_Buffer_Accumulation_Enable_pos) |
				(info.load_enable << C_Load_Row_pos) |
				(info.Automatic << C_AUTOMATIC_STA_pos));
	*(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add) = tmp;
}

void PE_CONT_STA_ACK					(unsigned int plane_add, unsigned int pe_add)
{
	unsigned int tmp = *(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add);
	tmp |=  (1 << C_ACK_STA_pos);
	*(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add) = tmp;
}

void PE_CONT_UPA_pause					(unsigned int plane_add, unsigned int pe_add)
{
	unsigned int tmp = *(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add);
	tmp |= (1 << C_Pause_UPA_pos);
	*(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add) = tmp;
}

void PE_CONT_UPA_resume					(unsigned int plane_add, unsigned int pe_add)
{
	unsigned int tmp = *(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add);
	tmp &= ~(1 << C_Pause_UPA_pos);
	*(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add) = tmp;
}

void PE_CONT_UPA_start_updating_IFM		(unsigned int plane_add, unsigned int pe_add)
{
	unsigned int tmp = *(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add);
	tmp |= (1 << C_Update_IFM_pos);
	*(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add) = tmp;
}

void PE_CONT_UPA_start_updating_WFM		(unsigned int plane_add, unsigned int pe_add)
{
	unsigned int tmp = *(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add);
	tmp |= (1 << C_Update_WFM_pos);
	*(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add) = tmp;
}

void PE_CONT_UPA_stop_updating_IFM		(unsigned int plane_add, unsigned int pe_add)
{
	unsigned int tmp = *(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add);
	tmp &= ~(1 << C_Update_IFM_pos);
	*(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add) = tmp;
}

void PE_CONT_UPA_stop_updating_WFM		(unsigned int plane_add, unsigned int pe_add)
{
	unsigned int tmp = *(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add);
	tmp &= ~(1 << C_Update_WFM_pos);
	*(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add) = tmp;
}

void PE_CONT_UPA_start_updating			(unsigned int plane_add, unsigned int pe_add)
{
	unsigned int lod = *(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add);
	unsigned int tmp;
	tmp = lod | (1 << C_Update_WFM_pos);
	*(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add) = tmp;
	*(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add) = lod;
	tmp = lod | (1 << C_Update_IFM_pos);
	*(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add) = tmp;
}

void PE_CONT_Configure_Update_Start		(unsigned int plane_add, unsigned int pe_add, S_CONF_STA_info info)
{
	unsigned int lod;
	unsigned int tmp;
	// Config
	lod	=	(	(info.update_store_address << C_Update_Store_Base_Address_pos) | 
				(info.update_load_address << C_Update_load_Base_Address_pos) |
				(info.store_enable << C_Store_Row_pos) |
				(info.activation_enable << C_Enable_Activation_pos) |
				(info.save_on_buffer << C_Save_Row_pos) |
				(info.accumulate_with_bias << C_Bias_Accumulation_Enable_pos) |
				(info.accumulate_with_OBM << C_PEout_Accumulation_Enable_pos) |
				(info.accumulate_with_buffer << C_Buffer_Accumulation_Enable_pos) |
				(info.load_enable << C_Load_Row_pos) |
				(info.Automatic << C_AUTOMATIC_STA_pos));
	*(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add) = lod;

	/// Update
	tmp =	lod	| (1 << C_Update_WFM_pos);
	*(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add) = tmp;
	*(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add) = lod;
	tmp	= 	lod | (1 << C_Update_IFM_pos);
	*(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add) = tmp;

	// Start
	tmp	=	tmp	| (1 << C_Start_PE_pos);
	*(C_PERIPHERAL_PLANE_0_REG_PEs_CONTROL_PE_1_1 + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + pe_add) = tmp;
}



//***************************************************/
//						PSU_EC						//
//***************************************************/

void PSU_EC_reset_all					(unsigned int plane_add)
{
	for (unsigned int i=0; i<16; i++)
		*(C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_PSU_1_1_DONE + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + i) = 0;
}

void PSU_EC_reset						(unsigned int plane_add, unsigned int SEC_add)
{
	*(C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_PSU_1_1_DONE + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + SEC_add) = 0;
}

void PSU_EC_CNTR_start_with_config		(unsigned int plane_add, E_PSU_EC_target targ, unsigned int SEC_add, unsigned int max, unsigned int sens_level, unsigned int repeat, unsigned int intr_en)
{
	unsigned int tmp = 0;
	tmp |= ((max & 0xFFF) << C_Event_Max_pos);
	tmp |= (sens_level << C_Event_Sensitity_pos);
	tmp |= (1 << C_Event_Int_Clear_pos);
	tmp |= (intr_en << C_Event_Int_Enabel_pos);
	tmp |= (repeat << C_Event_Stuck_at_Top_pos);
	tmp |= (1 << C_Event_Init_pos);
	tmp |= (targ << C_Event_Event_Source_pos);
	*(C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_PSU_1_1_DONE + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + SEC_add) = tmp;
	tmp |= (1 << C_Event_Enable_pos);
	*(C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_PSU_1_1_DONE + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + SEC_add) = tmp;
}

void PSU_EC_CNTR_config					(unsigned int plane_add, E_PSU_EC_target targ, unsigned int SEC_add, unsigned int max, unsigned int sens_level, unsigned int repeat, unsigned int intr_en)
{
	unsigned int tmp = 0;
	tmp |= ((max & 0xFFF) << C_Event_Max_pos);
	tmp |= (sens_level << C_Event_Sensitity_pos);
	tmp |= (1 << C_Event_Int_Clear_pos);
	tmp |= (intr_en << C_Event_Int_Enabel_pos);
	tmp |= (repeat << C_Event_Stuck_at_Top_pos);
	tmp |= (1 << C_Event_Init_pos);
	tmp |= (targ << C_Event_Event_Source_pos);
	*(C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_PSU_1_1_DONE + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + SEC_add) = tmp;
}

void PSU_EC_CNTR_start					(unsigned int plane_add, unsigned int SEC_add)
{
	unsigned int tmp = *(C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_PSU_1_1_DONE + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + SEC_add);
	tmp |= (1 << C_Event_Enable_pos);
	*(C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_PSU_1_1_DONE + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + SEC_add) = tmp;
}

void PSU_EC_CNTR_stop					(unsigned int plane_add, unsigned int SEC_add)
{
	unsigned int tmp = *(C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_PSU_1_1_DONE + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + SEC_add);
	tmp &= ~(1 << C_Event_Enable_pos);
	*(C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_PSU_1_1_DONE + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + SEC_add) = tmp;
}

void PSU_EC_CNTR_restart				(unsigned int plane_add, unsigned int SEC_add)
{
	 unsigned int tmp = *(C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_PSU_1_1_DONE + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + SEC_add);
	tmp |= (1 << C_Event_Int_Clear_pos);
	tmp |= (1 << C_Event_Init_pos);
	*(C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_PSU_1_1_DONE + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + SEC_add) = tmp;
}

void PSU_EC_CNTR_get_value				(unsigned int plane_add, unsigned int SEC_add, unsigned int& value, unsigned int& event_status, unsigned int& intr_status, unsigned int& Source)
{
	unsigned int tmp = *(C_PERIPHERAL_PLANE_0_REG_EVENT_COUNTER_PSU_1_1_DONE + (plane_add * C_PERIPHERAL_PLAN_INTERVAL) + SEC_add);
	value = tmp % (1 << C_Event_Max_pos);
	event_status = ((tmp & (1 << C_Event_Event_Value_pos)) >> C_Event_Event_Value_pos); 
	intr_status = ((tmp & (1 << C_Event_Int_Value_pos)) >> C_Event_Int_Value_pos);
	Source =  ((tmp & (3 << C_Event_Event_Source_pos)) >> C_Event_Event_Source_pos); 
}








