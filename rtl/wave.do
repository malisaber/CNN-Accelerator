onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sim_system/UUT/Scheduler_Unit/clk
add wave -noupdate /sim_system/UUT/Scheduler_Unit/rst
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/BASE_ADDRESS_MEMx
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/BASE_ADDRESS_DMAx
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/BASE_ADDRESS_MPDR
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/BASE_ADDRESS_TIMR
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/BASE_ADDRESS_DMEV
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/BASE_ADDRESS_MPEV
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/BASE_ADDRESS_COST
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/BASE_ADDRESS_TRxU
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/BASE_ADDRESS_INTH
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/BASE_ADDRESS_PLNR
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/ERROR
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/ERROR_cmb
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/ERROR_flg
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/INT_ACK
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/INT_ACK_DMA_Ready
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/INT_ACK_MPDR_Ready
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/INT_ACK_PSU_Done
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/INT_ACK_RBF
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/INT_ACK_RXD
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/INT_ACK_TBE
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/INT_ACK_TIMER
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/INT_ACK_TXD
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/INT_ADD
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/INT_En
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/INT_EXT_RST
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/INT_REQ
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/INT_REQ_DMA_Ready
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/INT_REQ_MPDR_Ready
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/INT_REQ_PSU_Done
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/INT_REQ_RBF
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/INT_REQ_RXD
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/INT_REQ_TBE
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/INT_REQ_TIMER
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/INT_REQ_TXD
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/MAIN_PORT_Address
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/MAIN_PORT_Data_in
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/MAIN_PORT_Data_out
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/MAIN_PORT_DIN_Rdy
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/MAIN_PORT_Dot_Redy_CSB
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/MAIN_PORT_Dot_Redy_DCB
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/MAIN_PORT_Dot_Redy_ECB
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/MAIN_PORT_Dot_Redy_IRH
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/MAIN_PORT_Dot_Redy_MCB
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/MAIN_PORT_Dot_Redy_MEM
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/MAIN_PORT_Dot_Redy_PCB
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/MAIN_PORT_Dot_Redy_PLN
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/MAIN_PORT_Dot_Redy_PLNp
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/MAIN_PORT_Dot_Redy_TCB
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/MAIN_PORT_Dot_Redy_TRx
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/MAIN_PORT_SEL_This_CSB
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/MAIN_PORT_SEL_This_DCB
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/MAIN_PORT_SEL_This_ECB
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/MAIN_PORT_SEL_This_IRH
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/MAIN_PORT_SEL_This_MCB
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/MAIN_PORT_SEL_This_MEM
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/MAIN_PORT_SEL_This_PCB
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/MAIN_PORT_SEL_This_PLN
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/MAIN_PORT_SEL_This_PLNp
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/MAIN_PORT_SEL_This_TCB
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/MAIN_PORT_SEL_This_TRx
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/MAIN_PORT_WEN
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/MAIN_PORT_OEN
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/OFFSET_PLANE
add wave -noupdate -group Scheduler /sim_system/UUT/Scheduler_Unit/RISCV_rst
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/INT_ACK
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/INT_REQ_DMA_Ready
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/INT_REQ_MPDR_Ready
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/INT_REQ_PSU_Done
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/INT_REQ_RBF
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/INT_REQ_RXD
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/INT_REQ_SYS_PC
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/INT_REQ_SYS_TIMER
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/INT_REQ_TBE
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/INT_REQ_TXD
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/MAIN_PORT_Address
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/MAIN_PORT_Data_in
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/MAIN_PORT_OEN
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/MAIN_PORT_WEN
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/rst
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/INT_ACK_DMA_Ready
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/INT_ACK_MPDR_Ready
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/INT_ACK_PSU_Done
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/INT_ACK_RBF
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/INT_ACK_RXD
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/INT_ACK_SYS_PC
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/INT_ACK_SYS_TIMER
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/INT_ACK_TBE
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/INT_ACK_TXD
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/INT_REQ
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/MAIN_PORT_Data_out
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/MAIN_PORT_Dot_Rdy
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/MAIN_PORT_SEL_This
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/ENDx_ADDRESS
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/INT_ACK_ALL
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/INT_ADD_L
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/INT_ADD_load
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/INT_APP_ACK
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/INT_DEC_L
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/INT_ENABLEs
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/INT_REQ_ALL
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/INT_REQ_ARR
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/INT_REQ_ARR_LOC
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/N_State
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/NEXT_INT_ADDRESS
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/NEXT_INT_Code
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/NUMB_ints
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/P_State
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/THIS_INT_ADDRESS
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/THIS_INT_Code
add wave -noupdate -expand -group Interrupt /sim_system/UUT/Scheduler_Unit/Interrupt_handler_Unit/THIS_INT_Load
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {20205 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 196
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {19928 ns} {21011 ns}
