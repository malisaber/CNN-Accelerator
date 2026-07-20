
#include "common.h"



unsigned int UART_Cont_Word_gen(UART_Config conf)
{
	unsigned int word = 0;
	word |= conf.Tx_enable					<< C_TRx_Unit_Tx_Enable_pos;
	word |= conf.Rx_enable					<< C_TRx_Unit_Rx_Enable_pos;
	word |= conf.TBE_intr_enable			<< C_TRx_Unit_Tx_Buff_Empty_Intr_en_pos;
	word |= conf.RBF_intr_enable			<< C_TRx_Unit_Rx_Buff_Full_Intr_en_pos;
	word |= conf.Tx_done_intr_enable		<< C_TRx_Unit_Tx_Data_Sent_Intr_en_pos;
	word |= conf.Rx_done_intr_enable		<< C_TRx_Unit_Rx_Data_Received_Intr_en_pos;
	word |= 1								<< C_TRx_Unit_Interrupt_clear_pos;
	word |= (conf.Clk_Div	& 0xF)			<< C_TRx_Unit_Clk_Div_pos;
	word |= (conf.TOP		& 0xFFFF)		<< C_TRx_Unit_Top_pos;
	return word;
}

