# `SYSTEM` Dependency Tree

```text
SYSTEM
|-- Scheduler
|   |-- Scheduler_Main_Memory / Scheduler_Main_Memory_64x
|   |   |-- Scheduler_mem_core_verilog / Scheduler_mem_core_verilog_64x
|   |   `-- sram_4096X16_freepdk45_2rw
|   |-- DMA_Control_Box_V2
|   |-- MPDR_Control_Box
|   |-- Timer_Box
|   |-- Singular_Event_Box
|   |   `-- Event_cntr
|   |-- Control_Status_Box
|   |-- TRx_Box
|   |   |-- TRx
|   |   |   |-- RX
|   |   |   |   |-- RXDP
|   |   |   |   |   `-- incr
|   |   |   |   `-- RXCU
|   |   |   `-- TX
|   |   |       |-- TXDP
|   |   |       |   `-- incr
|   |   |       `-- TXCU
|   |   `-- FIFO_v2
|   |-- Interrupt_handler
|   |-- Planar_CSR_Box
|   |   |-- config_holder_v2
|   |   |-- Initiator_Box
|   |   |-- PEs_Control_Box
|   |   `-- Plane_Event_Box
|   |       `-- Event_cntr
|   |-- AFTAB_Wrapper
|   |   |-- aftab_core
|   |   |   |-- aftab_controller
|   |   |   `-- aftab_datapath
|   |   |       `-- aftab_iccd
|   |   `-- Main_Port_Tracker
|   `-- BIRISC_Wrapper
|       |-- riscv_core
|       |   |-- biriscv_fetch
|       |   |-- biriscv_decode
|       |   |   `-- fetch_fifo
|       |   |-- biriscv_issue
|       |   |-- biriscv_exec
|       |   |-- biriscv_csr
|       |   |-- biriscv_lsu
|       |   |   `-- biriscv_lsu_fifo
|       |   |-- biriscv_multiplier
|       |   |-- biriscv_regfile
|       |   |-- biriscv_csr_regfile
|       |   |-- biriscv_alu
|       |   |-- biriscv_mmu
|       |   |-- biriscv_divider
|       |   |-- biriscv_npc
|       |   |-- biriscv_pipe_ctrl
|       |   |-- biriscv_frontend
|       |   `-- biriscv_PC_Tracer
|       `-- uPROC_Port_Tracker
`-- Accelerator
    |-- PE_Plane
    |   |-- P_sys
    |   |   |-- Data_provider_v2
    |   |   |   |-- Controller_v5
    |   |   |   |   |-- CNT_FSM_0
    |   |   |   |   `-- CNT_FSM_1
    |   |   |   |-- Cont_add_unit_v3
    |   |   |   |-- address_gen_v3
    |   |   |   |-- BM_selector_v2
    |   |   |   |-- Memory_Bank_Group
    |   |   |   |   `-- Memory_Bank
    |   |   |   `-- Memory_Bank
    |   |   `-- PEs_v2
    |   |       `-- PE_slice
    |   |           `-- dataPath_v3
    |   |               |-- MUL_v4
    |   |               |-- Barrel_Shifter
    |   |               |-- Reg
    |   |               |-- MultiOpAdder
    |   |               |   `-- MOA_slice
    |   |               |       `-- Full_Adder
    |   |               |-- MOP_ACC
    |   |               |   |-- Full_Adder
    |   |               |   `-- MY_Adder
    |   |               `-- MY_Adder
    |   |-- UA
    |   |   |-- UA_controller
    |   |   `-- UA_datapath
    |   |       |-- LMN_memory_2_P
    |   |       `-- address_gen_reduced
    |   `-- SA
    |       |-- SA_CU
    |       |-- SA_DP
    |       |   |-- LMN_memory_2_P
    |       |   |-- SA_Add_gen
    |       |   |   `-- incr
    |       |   |-- MOP_ACC
    |       |   `-- Activation
    |       `-- SA_Add_gen
    |-- LMN
    |   |-- LMN_Master
    |   |-- LMN_Mem_IF
    |   |-- LMN_memory_2_P
    |   |   |-- sram_16X8_freepdk45_2rw
    |   |   |-- sram_16X16_freepdk45_2rw
    |   |   |-- sram_16X12_freepdk45_2rw
    |   |   |-- sram_256X16_freepdk45_2rw
    |   |   |-- sram_1024X16_freepdk45_2rw
    |   |   `-- sram_4096X16_freepdk45_2rw
    |   |-- LMN_Gate
    |   |-- GMN_pass_DAM
    |   `-- LMN_Arbiter_Fixed_way_complete
    |       `-- Connector_complete
    |-- GMN
    |   `-- LMN_Arbiter_Fixed_way_double_address
    |       `-- Connector_double_mem_map_address
    `-- MPDR
        |-- MPDR_Controller
        |-- MPDR_Datapath
        |   |-- LMN_memory_2_P
        |   |-- Simple_2P_RegFile
        |   `-- address_gen_reduced
```

## Notes
- `SYSTEM` is a pure integration wrapper; it does not contain compute logic itself.
- The accelerator side is split into plane logic, memory hierarchy, and MPDR control.
- The scheduler side is split into memory/peripheral control, serial IO, CPU wrapper, and interrupt handling.
- `old/` is legacy RTL and does not feed the current `SYSTEM` hierarchy.
- `sim/` is simulation support, with helper modules that mirror or observe top-level buses.
