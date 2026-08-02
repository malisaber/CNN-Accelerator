onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/clk_w
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/rst_w
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/P_S
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/Update_IFM
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/Update_WFM
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/LL_data_rdy
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/LL_data_in
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CNT_UPA_PAUSE
add wave -noupdate -expand /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/MB_status
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/LL_ack
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/Colm_inc
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/Kern_inc
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/init
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/Phys_val
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/Phys_inc
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/Base_Step_en
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/BCI_add
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/Phys_eq
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/Chan_eq
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/Colm_eq
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/Kern_eq
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/MB_set
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/WB_wen
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/Chan_inc
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/MB_wen
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/MB_set_flag
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/WB_low_lvl_sig
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/WB_low_lvl_wen
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/MB_low_lvl_sig
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/MB_low_lvl_wen
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/LL_data_wen
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/LL_cnt
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/LL_add
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/LL_write
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/LL_read
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/LL_push
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/done
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/status
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/LL_data_out
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Kern_val
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Colm_val
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Chan_val
add wave -noupdate /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Phys_vls
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {167365 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 774
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ns} {131246 ns}
