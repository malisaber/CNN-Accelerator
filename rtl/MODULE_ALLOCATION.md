# Module Allocation Plan

This is a placement plan for the RTL tree under `SYSTEM`.
I kept the existing project structure and mapped files to the module that instantiates or owns them.

## Top
- `SYSTEM.vhd` -> top-level wrapper
- `sim/SIM_SYSTEM.vhd` -> simulation wrapper for `SYSTEM`

## Accelerator
- `system/accelerator/Accelerator.vhd` -> accelerator top
- `system/accelerator/pe-plane/PE_Plane.vhd` -> plane wrapper used by `Accelerator`
- `system/accelerator/pe-plane/pe-sys/P_sys.vhd` -> plane subsystem core
- `system/accelerator/pe-plane/ua/UA.vhd` -> update-agent wrapper
- `system/accelerator/pe-plane/ua/UA_controller.vhd` -> UA control path
- `system/accelerator/pe-plane/ua/UA_datapath.vhd` -> UA datapath
- `system/accelerator/pe-plane/sa/SA.vhd` -> store-agent wrapper
- `system/accelerator/pe-plane/sa/SA_CU.vhd` -> SA control unit
- `system/accelerator/pe-plane/sa/SA_DP.vhd` -> SA datapath
- `system/accelerator/pe-plane/sa/SA_Add_gen.vhd` -> SA address generator
- `system/accelerator/pe-plane/sa/Activation.vhd` -> activation block used by SA
- `system/accelerator/pe-plane/pe-sys/data-provider/Data_provider_v2.vhd` -> bank/provider top
- `system/accelerator/pe-plane/pe-sys/data-provider/Controller_v5.vhd` -> provider controller
- `system/accelerator/pe-plane/pe-sys/data-provider/Cont_add_unit_v3.vhd` -> provider address counter
- `system/accelerator/pe-plane/pe-sys/data-provider/address_gen_v3.vhd` -> provider address generation
- `system/accelerator/pe-plane/pe-sys/data-provider/BM_selector_v2.vhd` -> bank selector
- `system/accelerator/pe-plane/pe-sys/data-provider/CNT_FSM_0.vhd` -> provider FSM leaf
- `system/accelerator/pe-plane/pe-sys/data-provider/CNT_FSM_1.vhd` -> provider FSM leaf
- `system/accelerator/pe-plane/pe-sys/data-provider/Memory_Bank.vhd` -> memory bank primitive wrapper
- `system/accelerator/pe-plane/pe-sys/data-provider/Memory_Bank_Group.vhd` -> memory-bank group
- `system/accelerator/pe-plane/pe-sys/pe-arraay/PEs_v2.vhd` -> PE array top
- `system/accelerator/pe-plane/pe-sys/pe-arraay/PE_slice.vhd` -> PE slice
- `system/accelerator/pe-plane/pe-sys/pe-arraay/dataPath_v3.vhd` -> PE slice datapath
- `system/accelerator/pe-plane/pe-sys/pe-arraay/MUL_v4.vhd` -> multiplier leaf
- `system/accelerator/pe-plane/pe-sys/pe-arraay/Barrel_Shifter.vhd` -> shifter leaf
- `system/accelerator/pe-plane/pe-sys/pe-arraay/Reg.vhd` -> register leaf
- `system/accelerator/pe-plane/pe-sys/pe-arraay/MultiOpAdder.vhd` -> multi-operand adder
- `system/accelerator/pe-plane/pe-sys/pe-arraay/MOP_ACC.vhd` -> adder accumulator
- `system/accelerator/pe-plane/pe-sys/pe-arraay/MOA_slice.vhd` -> adder slice
- `system/accelerator/pe-plane/pe-sys/pe-arraay/Full_Adder.vhd` -> full-adder leaf
- `system/accelerator/pe-plane/pe-sys/pe-arraay/MY_Adder.vhd` -> local adder helper
- `system/accelerator/mem-hierarch/LMN.vhd` -> local memory node top
- `system/accelerator/mem-hierarch/LMN_Master.vhd` -> LMN bus master
- `system/accelerator/mem-hierarch/LMN_Mem_IF.vhd` -> LMN memory interface
- `system/accelerator/mem-hierarch/LMN_memory_2_P.vhd` -> shared 2-port memory wrapper
- `system/accelerator/mem-hierarch/LMN_Gate.vhd` -> LMN gate
- `system/accelerator/mem-hierarch/GMN.vhd` -> global memory node top
- `system/accelerator/mem-hierarch/GMN_pass_DAM.vhd` -> GMN DMA pass-through
- `system/accelerator/mem-hierarch/Connector_complete.vhd` -> arbiter connector
- `system/accelerator/mem-hierarch/Connector_double_mem_map_address.vhd` -> double-address connector
- `system/accelerator/mem-hierarch/LMN_Arbiter_Fixed_way_complete.vhd` -> LMN arbiter
- `system/accelerator/mem-hierarch/LMN_Arbiter_Fixed_way_double_address.vhd` -> GMN arbiter
- `system/accelerator/mpdr/MPDR.vhd` -> MPDR top
- `system/accelerator/mpdr/MPDR_Controller.vhd` -> MPDR control logic
- `system/accelerator/mpdr/MPDR_Datapath.vhd` -> MPDR datapath

## Scheduler
- `system/scheduler/peripheral/Scheduler.vhd` -> scheduler top
- `system/scheduler/peripheral/Scheduler_Main_Memory.vhd` -> scheduler memory wrapper for AFTAB-style CPU
- `system/scheduler/peripheral/Scheduler_Main_Memory_64x.vhd` -> scheduler memory wrapper for BIRISC-style CPU
- `system/scheduler/peripheral/Scheduler_mem_core.vhd` -> generic memory core wrapper
- `system/scheduler/peripheral/DMA_Control_Box_V2.vhd` -> DMA control registers
- `system/scheduler/peripheral/Timer_Box.vhd` -> timer peripheral
- `system/scheduler/peripheral/Singular_Event_Box.vhd` -> event collector
- `system/scheduler/peripheral/Plane_Event_Box.vhd` -> plane event collector
- `system/scheduler/peripheral/Event_cntr.vhd` -> per-event counter leaf
- `system/scheduler/peripheral/Control_Status_Box.vhd` -> accelerator control/status registers
- `system/scheduler/peripheral/Initiator_Box.vhd` -> plane initiation registers
- `system/scheduler/peripheral/PEs_Control_Box.vhd` -> plane control register block
- `system/scheduler/peripheral/Planar_CSR_Box.vhd` -> plane CSR block
- `system/scheduler/peripheral/TRx_Box.vhd` -> serial interface top
- `system/scheduler/peripheral/TRx.vhd` -> combined RX/TX serial block
- `system/scheduler/peripheral/RX.vhd` -> receive path top
- `system/scheduler/peripheral/RXCU.vhd` -> receive control unit
- `system/scheduler/peripheral/RXDP.vhd` -> receive datapath
- `system/scheduler/peripheral/TX.vhd` -> transmit path top
- `system/scheduler/peripheral/TXCU.vhd` -> transmit control unit
- `system/scheduler/peripheral/TXDP.vhd` -> transmit datapath
- `system/scheduler/peripheral/MPDR_Control_Box.vhd` -> MPDR register block used by `Scheduler`
- `system/scheduler/peripheral/Interrupt_handler.vhd` -> interrupt routing
- `system/scheduler/biriscv/BIRISC_Wrapper.vhd` -> BIRISC-V wrapper
- `system/scheduler/aftab/AFTAB_Wrapper.vhd` -> AFTAB wrapper

## Shared Support
- `packages/MEM_MAPS.vhd` -> memory map constants
- `packages/MY_Pack_v2.vhd` -> common project types and helpers
- `packages/Port_Adapter_Pack.vhd` -> port adapter types
- `shared/address_gen_reduced.vhd` -> shared address generator
- `shared/Incrementer.vhd` -> shared incrementer
- `shared/inc_dec_v2.vhd` -> shared increment/decrement helper
- `shared/CH_buffer.vhd` -> shared channel buffer
- `shared/OCH_buffer.vhd` -> shared output-channel buffer
- `shared/fifo/FIFO_v2.vhd` -> shared FIFO
- `shared/fifo/FIFO_Controller_V2.vhd` -> FIFO controller
- `shared/fifo/FIFO_DataPath_V2.vhd` -> FIFO datapath
- `shared/fifo/FIFO_RAM.vhd` -> FIFO RAM wrapper
- `shared/sram/Scheduler_mem_core_verilog.v` -> scheduler memory primitive
- `shared/sram/Scheduler_mem_core_verilog_64x.v` -> 64x scheduler memory primitive
- `shared/sram/Simple_2P_RegFile.v` -> simple 2-port register file
- `shared/sram/sram_*.v` -> raw SRAM macros

## Legacy
- `old/*` -> legacy tree, not part of the current `SYSTEM` instantiation path

## Simulation
- `sim/SIM_FIFO_V2.vhd` -> FIFO testbench
- `sim/SIM_MY_ADDER.vhd` -> adder testbench
- `sim/SIM_FILE_IO_Handler.v` -> file I/O testbench
- `sim/FILE_IO_Handler.v` -> simulation file I/O helper
- `sim/Semi_serializer.vhd` -> serializer used by `SIM_SYSTEM`
- `system/scheduler/aftab/Main_Port_Tracker.v` -> AFTAB tracker helper
- `system/scheduler/biriscv/uPROC_Port_Tracker.v` -> BIRISC tracker helper
- `sim/SIM_TEMP.vhd` -> temporary simulation wrapper
