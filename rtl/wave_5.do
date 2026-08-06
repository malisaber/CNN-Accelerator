onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sim_system/UUT/clk
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/clk_w
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/rst_w
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Phys_val
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Phys_eq
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Chan_eq
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/MB_status
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Update_IFM
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Update_WFM
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Colm_eq
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Kern_eq
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/CNT_UPA_PAUSE
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/LL_data_rdy
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/LL_ack
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/MB_st
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/WB_wen
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/MB_wen
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/UM_B_Full
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/UW_A_clct
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/UM_A_clct
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/p_edge
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/N_S
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/P_S
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/MB_set
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Colm_inc
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Chan_inc
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Kern_inc
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Base_Step_en
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Phys_max
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/BCI_add
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/init
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/MB_low_lvl_wen
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/WB_low_lvl_wen
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/MB_set_flag
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/status
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/done
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/LL_data_wen
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/LL_push
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/LL_write
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Phys_inc
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/LL_read
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Addresses
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Base_Step_en
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Base_Wen
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/BCI_add
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Chan_inc
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Chan_max
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/clk_w
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Colm_inc
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Colm_max
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Count_Wen
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/init
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/IntVal_Wen
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Kern_inc
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Kern_max
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/LL_data_in
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Phys_inc
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Phys_max
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/rst_w
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Target_add
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Chan_eq
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Colm_eq
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Kern_eq
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/LL_add
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/LL_cnt
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/MB_low_lvl_sig
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Phys_eq
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Phys_val
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/WB_low_lvl_sig
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/BAdd_val
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/BAdd_vli
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/CAdd_val
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Chan_val
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Colm_val
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/IAdd_val
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Kern_val
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Phys_vls
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/tmp
add wave -noupdate -group UPAs -group UPA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/zeros
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/clk_w
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/rst_w
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Phys_val
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Phys_eq
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Chan_eq
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/MB_status
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Update_IFM
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Update_WFM
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Colm_eq
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Kern_eq
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/CNT_UPA_PAUSE
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/LL_data_rdy
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/LL_ack
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/MB_st
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/WB_wen
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/MB_wen
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/UM_B_Full
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/UW_A_clct
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/UM_A_clct
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/p_edge
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/N_S
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/P_S
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/MB_set
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Colm_inc
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Chan_inc
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Kern_inc
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Base_Step_en
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Phys_max
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/BCI_add
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/init
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/MB_low_lvl_wen
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/WB_low_lvl_wen
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/MB_set_flag
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/status
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/done
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/LL_data_wen
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/LL_push
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/LL_write
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Phys_inc
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/LL_read
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Addresses
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Base_Step_en
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Base_Wen
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/BCI_add
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Chan_inc
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Chan_max
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/clk_w
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Colm_inc
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Colm_max
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Count_Wen
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/init
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/IntVal_Wen
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Kern_inc
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Kern_max
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/LL_data_in
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Phys_inc
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Phys_max
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/rst_w
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Target_add
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Chan_eq
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Colm_eq
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Kern_eq
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/LL_add
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/LL_cnt
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/MB_low_lvl_sig
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Phys_eq
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Phys_val
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/WB_low_lvl_sig
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/BAdd_val
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/BAdd_vli
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/CAdd_val
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Chan_val
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Colm_val
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/IAdd_val
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Kern_val
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Phys_vls
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/tmp
add wave -noupdate -group UPAs -group UPA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/zeros
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/clk_w
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/rst_w
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Phys_val
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Phys_eq
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Chan_eq
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/MB_status
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Update_IFM
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Update_WFM
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Colm_eq
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Kern_eq
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/CNT_UPA_PAUSE
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/LL_data_rdy
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/LL_ack
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/MB_st
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/WB_wen
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/MB_wen
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/UM_B_Full
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/UW_A_clct
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/UM_A_clct
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/p_edge
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/N_S
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/P_S
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/MB_set
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Colm_inc
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Chan_inc
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Kern_inc
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Base_Step_en
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Phys_max
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/BCI_add
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/init
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/MB_low_lvl_wen
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/WB_low_lvl_wen
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/MB_set_flag
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/status
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/done
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/LL_data_wen
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/LL_push
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/LL_write
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Phys_inc
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/LL_read
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Addresses
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Base_Step_en
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Base_Wen
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/BCI_add
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Chan_inc
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Chan_max
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/clk_w
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Colm_inc
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Colm_max
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Count_Wen
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/init
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/IntVal_Wen
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Kern_inc
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Kern_max
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/LL_data_in
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Phys_inc
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Phys_max
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/rst_w
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Target_add
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Chan_eq
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Colm_eq
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Kern_eq
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/LL_add
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/LL_cnt
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/MB_low_lvl_sig
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Phys_eq
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Phys_val
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/WB_low_lvl_sig
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/BAdd_val
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/BAdd_vli
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/CAdd_val
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Chan_val
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Colm_val
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/IAdd_val
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Kern_val
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Phys_vls
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/tmp
add wave -noupdate -group UPAs -group UPA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/zeros
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/clk_w
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/rst_w
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Phys_val
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Phys_eq
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Chan_eq
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/MB_status
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Update_IFM
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Update_WFM
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Colm_eq
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Kern_eq
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/CNT_UPA_PAUSE
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/LL_data_rdy
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/LL_ack
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/MB_st
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/WB_wen
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/MB_wen
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/UM_B_Full
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/UW_A_clct
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/UM_A_clct
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/p_edge
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/N_S
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/P_S
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/MB_set
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Colm_inc
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Chan_inc
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Kern_inc
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Base_Step_en
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Phys_max
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/BCI_add
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/init
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/MB_low_lvl_wen
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/WB_low_lvl_wen
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/MB_set_flag
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/status
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/done
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/LL_data_wen
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/LL_push
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/LL_write
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/Phys_inc
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/CU/LL_read
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Addresses
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Base_Step_en
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Base_Wen
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/BCI_add
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Chan_inc
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Chan_max
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/clk_w
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Colm_inc
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Colm_max
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Count_Wen
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/init
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/IntVal_Wen
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Kern_inc
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Kern_max
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/LL_data_in
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Phys_inc
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Phys_max
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/rst_w
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Target_add
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Chan_eq
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Colm_eq
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Kern_eq
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/LL_add
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/LL_cnt
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/MB_low_lvl_sig
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Phys_eq
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Phys_val
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/WB_low_lvl_sig
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/BAdd_val
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/BAdd_vli
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/CAdd_val
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Chan_val
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Colm_val
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/IAdd_val
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Kern_val
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/Phys_vls
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/tmp
add wave -noupdate -group UPAs -group UPA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/UA_unit/DP/zeros
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/clk_w
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_ACK
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_active
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_BIS_en
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_load
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_load_UA
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_MEM_en
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_OBM_en
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_save
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_start
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_stor_UA
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_store
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNF_MAX_Colm
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNF_MAX_Kern
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNF_MAX_mode
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNT_STA_PAUSE
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_ack
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_data_in
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_data_rdy
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_wait
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/OBM_DATA
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/rst_w
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/TOP_Addresses
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/TOP_Base_Wen
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/TOP_Bias_Add
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/TOP_Bias_val
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/TOP_Bias_Wen
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/TOP_Count_Wen
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/TOP_IntVal_Wen
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/TOP_Target_add
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_done
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_add
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_cnt
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_data_out
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_data_wen
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_push
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_read
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_write
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/OBM_ADD
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_ACT_en
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_BIS_en
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_Colm_eq
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_Colm_inc
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_init
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_Kern_eq
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_Kern_inc
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_Load_UA_en
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_LSbar
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_MEM_en
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_OFM_en
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_Stat_Wen
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_Stor_UA_en
add wave -noupdate -group STAs -group STA_0 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(0)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CU/P_S
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/clk_w
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_ACK
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_active
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_BIS_en
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_load
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_load_UA
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_MEM_en
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_OBM_en
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_save
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_start
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_stor_UA
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_store
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNF_MAX_Colm
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNF_MAX_Kern
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNF_MAX_mode
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNT_STA_PAUSE
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_ack
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_data_in
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_data_rdy
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_wait
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/OBM_DATA
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/rst_w
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/TOP_Addresses
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/TOP_Base_Wen
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/TOP_Bias_Add
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/TOP_Bias_val
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/TOP_Bias_Wen
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/TOP_Count_Wen
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/TOP_IntVal_Wen
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/TOP_Target_add
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_done
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_add
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_cnt
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_data_out
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_data_wen
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_push
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_read
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_write
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/OBM_ADD
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_ACT_en
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_BIS_en
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_Colm_eq
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_Colm_inc
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_init
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_Kern_eq
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_Kern_inc
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_Load_UA_en
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_LSbar
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_MEM_en
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_OFM_en
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_Stat_Wen
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_Stor_UA_en
add wave -noupdate -group STAs -group STA_1 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(1)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CU/P_S
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/clk_w
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_ACK
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_active
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_BIS_en
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_load
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_load_UA
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_MEM_en
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_OBM_en
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_save
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_start
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_stor_UA
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_store
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNF_MAX_Colm
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNF_MAX_Kern
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNF_MAX_mode
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNT_STA_PAUSE
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_ack
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_data_in
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_data_rdy
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_wait
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/OBM_DATA
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/rst_w
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/TOP_Addresses
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/TOP_Base_Wen
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/TOP_Bias_Add
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/TOP_Bias_val
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/TOP_Bias_Wen
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/TOP_Count_Wen
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/TOP_IntVal_Wen
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/TOP_Target_add
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_done
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_add
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_cnt
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_data_out
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_data_wen
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_push
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_read
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_write
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/OBM_ADD
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_ACT_en
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_BIS_en
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_Colm_eq
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_Colm_inc
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_init
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_Kern_eq
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_Kern_inc
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_Load_UA_en
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_LSbar
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_MEM_en
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_OFM_en
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_Stat_Wen
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_Stor_UA_en
add wave -noupdate -group STAs -group STA_2 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(2)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CU/P_S
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/clk_w
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_ACK
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_active
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_BIS_en
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_load
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_load_UA
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_MEM_en
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_OBM_en
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_save
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_start
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_stor_UA
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_store
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNF_MAX_Colm
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNF_MAX_Kern
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNF_MAX_mode
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNT_STA_PAUSE
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_ack
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_data_in
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_data_rdy
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_wait
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/OBM_DATA
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/rst_w
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/TOP_Addresses
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/TOP_Base_Wen
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/TOP_Bias_Add
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/TOP_Bias_val
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/TOP_Bias_Wen
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/TOP_Count_Wen
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/TOP_IntVal_Wen
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/TOP_Target_add
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CMD_done
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_add
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_cnt
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_data_out
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_data_wen
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_push
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_read
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/LMN_write
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/OBM_ADD
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_ACT_en
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_BIS_en
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_Colm_eq
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_Colm_inc
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_init
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_Kern_eq
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_Kern_inc
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_Load_UA_en
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_LSbar
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_MEM_en
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_OFM_en
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_Stat_Wen
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CNU_Stor_UA_en
add wave -noupdate -group STAs -group STA_3 /sim_system/UUT/Accelerator_Unit/PLANE_GEN(3)/Processing_Plane/ROW_GEN(1)/COL_GEN(1)/SA_unit/CU/P_S
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/BUS_done
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/BUS_grant
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/BUS_MD_in
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/BUS_MD_in_rdy
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/BUS_wait
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/clk
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/NAT_Add
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/NAT_Cnt
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/NAT_data_in
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/NAT_data_wen
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/NAT_push
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/NAT_read
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/NAT_write
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/rst
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/BUS_Add
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/BUS_cnt
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/BUS_MD_out
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/BUS_MD_out_rdy
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/BUS_read
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/BUS_req
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/BUS_write
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/NAT_ack
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/NAT_data_out
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/NAT_data_rdy
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/NAT_ready
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/NAT_wait
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/clar_CD
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/load_cmd
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/load_Data
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/N_S
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/P_S
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/REG_Add
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/REG_Cnt
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/REG_read
add wave -noupdate -group BNU /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/REG_write
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/BUS_done
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/BUS_grant
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/BUS_MD_in
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/BUS_MD_in_rdy
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/BUS_wait
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/clk
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/NAT_Add
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/NAT_Cnt
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/NAT_data_in
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/NAT_data_wen
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/NAT_push
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/NAT_read
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/NAT_write
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/rst
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/BUS_Add
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/BUS_cnt
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/BUS_MD_out
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/BUS_MD_out_rdy
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/BUS_read
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/BUS_req
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/BUS_write
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/NAT_ack
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/NAT_data_out
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/NAT_data_rdy
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/NAT_ready
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/NAT_wait
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/clar_CD
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/load_cmd
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/load_Data
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/N_S
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/P_S
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/REG_Add
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/REG_Cnt
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/REG_read
add wave -noupdate -group BNS /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/REG_write
add wave -noupdate -group Bus_Nat_STA -group BNS_0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/BUS_req
add wave -noupdate -group Bus_Nat_STA -group BNS_0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/BUS_Add
add wave -noupdate -group Bus_Nat_STA -group BNS_0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/BUS_read
add wave -noupdate -group Bus_Nat_STA -group BNS_0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/BUS_write
add wave -noupdate -group Bus_Nat_STA -group BNS_0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/BUS_grant
add wave -noupdate -group Bus_Nat_STA -group BNS_0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/BUS_wait
add wave -noupdate -group Bus_Nat_STA -group BNS_0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/BUS_done
add wave -noupdate -group Bus_Nat_STA -group BNS_0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_STA_Master/P_S
add wave -noupdate -group Bus_Nat_STA -group BNS_1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(1)/NAT_STA_Master/BUS_req
add wave -noupdate -group Bus_Nat_STA -group BNS_1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(1)/NAT_STA_Master/BUS_Add
add wave -noupdate -group Bus_Nat_STA -group BNS_1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(1)/NAT_STA_Master/BUS_read
add wave -noupdate -group Bus_Nat_STA -group BNS_1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(1)/NAT_STA_Master/BUS_write
add wave -noupdate -group Bus_Nat_STA -group BNS_1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(1)/NAT_STA_Master/BUS_grant
add wave -noupdate -group Bus_Nat_STA -group BNS_1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(1)/NAT_STA_Master/BUS_wait
add wave -noupdate -group Bus_Nat_STA -group BNS_1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(1)/NAT_STA_Master/BUS_done
add wave -noupdate -group Bus_Nat_STA -group BNS_1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(1)/NAT_STA_Master/P_S
add wave -noupdate -group Bus_Nat_STA -group BNS_2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(2)/NAT_STA_Master/BUS_req
add wave -noupdate -group Bus_Nat_STA -group BNS_2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(2)/NAT_STA_Master/BUS_Add
add wave -noupdate -group Bus_Nat_STA -group BNS_2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(2)/NAT_STA_Master/BUS_read
add wave -noupdate -group Bus_Nat_STA -group BNS_2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(2)/NAT_STA_Master/BUS_write
add wave -noupdate -group Bus_Nat_STA -group BNS_2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(2)/NAT_STA_Master/BUS_grant
add wave -noupdate -group Bus_Nat_STA -group BNS_2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(2)/NAT_STA_Master/BUS_wait
add wave -noupdate -group Bus_Nat_STA -group BNS_2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(2)/NAT_STA_Master/BUS_done
add wave -noupdate -group Bus_Nat_STA -group BNS_2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(2)/NAT_STA_Master/P_S
add wave -noupdate -group Bus_Nat_STA -group BNS_3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(3)/NAT_STA_Master/BUS_req
add wave -noupdate -group Bus_Nat_STA -group BNS_3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(3)/NAT_STA_Master/BUS_Add
add wave -noupdate -group Bus_Nat_STA -group BNS_3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(3)/NAT_STA_Master/BUS_read
add wave -noupdate -group Bus_Nat_STA -group BNS_3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(3)/NAT_STA_Master/BUS_write
add wave -noupdate -group Bus_Nat_STA -group BNS_3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(3)/NAT_STA_Master/BUS_grant
add wave -noupdate -group Bus_Nat_STA -group BNS_3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(3)/NAT_STA_Master/BUS_wait
add wave -noupdate -group Bus_Nat_STA -group BNS_3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(3)/NAT_STA_Master/BUS_done
add wave -noupdate -group Bus_Nat_STA -group BNS_3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(3)/NAT_STA_Master/P_S
add wave -noupdate -group Bus_Nat_UPA -group BNS_0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/BUS_req
add wave -noupdate -group Bus_Nat_UPA -group BNS_0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/BUS_Add
add wave -noupdate -group Bus_Nat_UPA -group BNS_0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/BUS_read
add wave -noupdate -group Bus_Nat_UPA -group BNS_0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/BUS_write
add wave -noupdate -group Bus_Nat_UPA -group BNS_0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/BUS_grant
add wave -noupdate -group Bus_Nat_UPA -group BNS_0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/BUS_wait
add wave -noupdate -group Bus_Nat_UPA -group BNS_0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/BUS_done
add wave -noupdate -group Bus_Nat_UPA -group BNS_0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(0)/NAT_UPA_Master/P_S
add wave -noupdate -group Bus_Nat_UPA -group BNS_1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(1)/NAT_UPA_Master/BUS_req
add wave -noupdate -group Bus_Nat_UPA -group BNS_1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(1)/NAT_UPA_Master/BUS_Add
add wave -noupdate -group Bus_Nat_UPA -group BNS_1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(1)/NAT_UPA_Master/BUS_read
add wave -noupdate -group Bus_Nat_UPA -group BNS_1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(1)/NAT_UPA_Master/BUS_write
add wave -noupdate -group Bus_Nat_UPA -group BNS_1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(1)/NAT_UPA_Master/BUS_grant
add wave -noupdate -group Bus_Nat_UPA -group BNS_1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(1)/NAT_UPA_Master/BUS_wait
add wave -noupdate -group Bus_Nat_UPA -group BNS_1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(1)/NAT_UPA_Master/BUS_done
add wave -noupdate -group Bus_Nat_UPA -group BNS_1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(1)/NAT_UPA_Master/P_S
add wave -noupdate -group Bus_Nat_UPA -group BNS_2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(2)/NAT_UPA_Master/BUS_req
add wave -noupdate -group Bus_Nat_UPA -group BNS_2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(2)/NAT_UPA_Master/BUS_Add
add wave -noupdate -group Bus_Nat_UPA -group BNS_2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(2)/NAT_UPA_Master/BUS_read
add wave -noupdate -group Bus_Nat_UPA -group BNS_2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(2)/NAT_UPA_Master/BUS_write
add wave -noupdate -group Bus_Nat_UPA -group BNS_2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(2)/NAT_UPA_Master/BUS_grant
add wave -noupdate -group Bus_Nat_UPA -group BNS_2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(2)/NAT_UPA_Master/BUS_wait
add wave -noupdate -group Bus_Nat_UPA -group BNS_2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(2)/NAT_UPA_Master/BUS_done
add wave -noupdate -group Bus_Nat_UPA -group BNS_2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(2)/NAT_UPA_Master/P_S
add wave -noupdate -group Bus_Nat_UPA -group BNS_3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(3)/NAT_UPA_Master/BUS_req
add wave -noupdate -group Bus_Nat_UPA -group BNS_3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(3)/NAT_UPA_Master/BUS_Add
add wave -noupdate -group Bus_Nat_UPA -group BNS_3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(3)/NAT_UPA_Master/BUS_read
add wave -noupdate -group Bus_Nat_UPA -group BNS_3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(3)/NAT_UPA_Master/BUS_write
add wave -noupdate -group Bus_Nat_UPA -group BNS_3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(3)/NAT_UPA_Master/BUS_grant
add wave -noupdate -group Bus_Nat_UPA -group BNS_3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(3)/NAT_UPA_Master/BUS_wait
add wave -noupdate -group Bus_Nat_UPA -group BNS_3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(3)/NAT_UPA_Master/BUS_done
add wave -noupdate -group Bus_Nat_UPA -group BNS_3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NATIVE_UPA_PLANE_GEN(3)/NAT_UPA_Master/P_S
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/clk
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/IGM_2GMN_Add
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/IGM_2GMN_Cnt
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/IGM_2GMN_CS
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/IGM_2GMN_read
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/IGM_2GMN_SD_in
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/IGM_2GMN_SD_in_rdy
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/IGM_2GMN_write
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/LMN_COL_POS
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/LMN_ROW_POS
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_MPEU_Add
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_MPEU_Cnt
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_MPEU_data_in
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_MPEU_data_wen
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_MPEU_push
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_MPEU_read
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_MPEU_write
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_STA_Add
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_STA_Cnt
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_STA_data_in
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_STA_data_wen
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_STA_push
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_STA_read
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_STA_write
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_UPA_Add
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_UPA_Cnt
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_UPA_data_in
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_UPA_data_wen
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_UPA_push
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_UPA_read
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_UPA_write
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2GMN_done
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2GMN_grant
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2GMN_MD_in
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2GMN_MD_in_rdy
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2GMN_wait
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU_done
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU_grant
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU_MD_in
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU_MD_in_rdy
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU_wait
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/rst
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/TR_R_Add
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/TR_R_Cnt
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/TR_start
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/TR_W_Add
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/TR_W_Cnt
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/IGM_2GMN_done
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/IGM_2GMN_SD_out
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/IGM_2GMN_SD_out_rdy
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/IGM_2GMN_wait
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_MPEU_ack
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_MPEU_data_out
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_MPEU_data_rdy
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_MPEU_ready
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_MPEU_wait
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_STA_ack
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_STA_data_out
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_STA_data_rdy
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_STA_ready
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_STA_wait
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_UPA_ack
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_UPA_data_out
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_UPA_data_rdy
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_UPA_ready
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NAT_UPA_wait
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2GMN_Add
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2GMN_Cnt
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2GMN_MD_out
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2GMN_MD_out_rdy
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2GMN_read
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2GMN_req
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2GMN_write
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU_Add
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU_Cnt
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU_MD_out
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU_MD_out_rdy
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU_read
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU_req
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU_write
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/TR_ready
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arb_M_MSM
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arb_S_SSM
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/MEM_P0_Add
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/MEM_P0_Din
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/MEM_P0_Dout
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/MEM_P0_wen
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/MEM_P1_Add
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/MEM_P1_Din
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/MEM_P1_Dout
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/MEM_P1_wen
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/MSB_Add
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/MSB_Cnt
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/MSB_Din
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/MSB_Din_rdy
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/MSB_done
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/MSB_Dout
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/MSB_Dout_rdy
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/MSB_grant
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/MSB_MSM
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/MSB_read
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/MSB_req
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/MSB_wait
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/MSB_write
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NOM
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/NOS
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/SM_size
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/SSB_Add
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/SSB_Cnt
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/SSB_CS
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/SSB_Din
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/SSB_Din_rdy
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/SSB_done
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/SSB_Dout
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/SSB_Dout_rdy
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/SSB_read
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/SSB_SSM
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/SSB_wait
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/SSB_write
add wave -noupdate -group LMN /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/clk
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/MBUS_done
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/MBUS_grant
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/MBUS_MD_in
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/MBUS_MD_in_rdy
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/MBUS_wait
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/rst
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/SBUS_Add
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/SBUS_Cnt
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/SBUS_CS
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/SBUS_read
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/SBUS_SD_in
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/SBUS_SD_in_rdy
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/SBUS_write
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/MBUS_Add
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/MBUS_Cnt
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/MBUS_MD_out
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/MBUS_MD_out_rdy
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/MBUS_read
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/MBUS_req
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/MBUS_write
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/SBUS_done
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/SBUS_SD_out
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/SBUS_SD_out_rdy
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/SBUS_wait
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/load_MS
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/load_SS
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/MReg_add
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/MReg_Cnt
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/MReg_read
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/MReg_write
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/N_S
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/P_S
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/SReg_add
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/SReg_cnt
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/SReg_read
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/SReg_write
add wave -noupdate -group OGV /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/OGM_2VCU/trans_data
add wave -noupdate -group ARB /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/clk
add wave -noupdate -group ARB /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/Master_Address
add wave -noupdate -group ARB /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/MASTER_CNT
add wave -noupdate -group ARB /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/Master_req
add wave -noupdate -group ARB /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/Name
add wave -noupdate -group ARB /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/rst
add wave -noupdate -group ARB /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/SLAVE_CNT
add wave -noupdate -group ARB /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/Slave_max_add
add wave -noupdate -group ARB /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/Slave_min_add
add wave -noupdate -group ARB /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/SM_size
add wave -noupdate -group ARB /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/ways
add wave -noupdate -group ARB /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/Master_grant
add wave -noupdate -group ARB /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/Master_MSM
add wave -noupdate -group ARB /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/Slave_CS
add wave -noupdate -group ARB /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/Slave_SSM
add wave -noupdate -group ARB /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/aswering
add wave -noupdate -group ARB /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/bussy
add wave -noupdate -group ARB /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/con_cs
add wave -noupdate -group ARB /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/con_grant
add wave -noupdate -group ARB /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/con_MSM
add wave -noupdate -group ARB /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/con_SSM
add wave -noupdate -group ARB /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/G_stop
add wave -noupdate -group ARB /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/L_stop
add wave -noupdate -group ARB /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/starter
add wave -noupdate -group ARB /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/taken
add wave -noupdate -group ARB /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/this_bussy
add wave -noupdate -group ARB /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/this_done
add wave -noupdate -group CN0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(0)/Connector_i/aswering
add wave -noupdate -group CN0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(0)/Connector_i/clk
add wave -noupdate -group CN0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(0)/Connector_i/Master_Address
add wave -noupdate -group CN0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(0)/Connector_i/MASTER_CNT
add wave -noupdate -group CN0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(0)/Connector_i/Master_req
add wave -noupdate -group CN0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(0)/Connector_i/Name
add wave -noupdate -group CN0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(0)/Connector_i/prev_bussy
add wave -noupdate -group CN0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(0)/Connector_i/rst
add wave -noupdate -group CN0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(0)/Connector_i/SLAVE_CNT
add wave -noupdate -group CN0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(0)/Connector_i/Slave_max_add
add wave -noupdate -group CN0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(0)/Connector_i/Slave_min_add
add wave -noupdate -group CN0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(0)/Connector_i/SM_size
add wave -noupdate -group CN0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(0)/Connector_i/stop_in
add wave -noupdate -group CN0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(0)/Connector_i/taken
add wave -noupdate -group CN0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(0)/Connector_i/Master_grant
add wave -noupdate -group CN0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(0)/Connector_i/Master_MSM
add wave -noupdate -group CN0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(0)/Connector_i/Slave_CS
add wave -noupdate -group CN0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(0)/Connector_i/Slave_SSM
add wave -noupdate -group CN0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(0)/Connector_i/stop_out
add wave -noupdate -group CN0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(0)/Connector_i/this_bussy
add wave -noupdate -group CN0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(0)/Connector_i/this_done
add wave -noupdate -group CN0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(0)/Connector_i/Adds
add wave -noupdate -group CN0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(0)/Connector_i/all_reqs
add wave -noupdate -group CN0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(0)/Connector_i/all_zero
add wave -noupdate -group CN0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(0)/Connector_i/fre_reqs
add wave -noupdate -group CN0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(0)/Connector_i/Maxs
add wave -noupdate -group CN0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(0)/Connector_i/Mins
add wave -noupdate -group CN0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(0)/Connector_i/MSM
add wave -noupdate -group CN0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(0)/Connector_i/SSM
add wave -noupdate -group CN0 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(0)/Connector_i/state
add wave -noupdate -group CN1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(1)/Connector_i/aswering
add wave -noupdate -group CN1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(1)/Connector_i/clk
add wave -noupdate -group CN1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(1)/Connector_i/Master_Address
add wave -noupdate -group CN1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(1)/Connector_i/MASTER_CNT
add wave -noupdate -group CN1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(1)/Connector_i/Master_req
add wave -noupdate -group CN1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(1)/Connector_i/Name
add wave -noupdate -group CN1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(1)/Connector_i/prev_bussy
add wave -noupdate -group CN1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(1)/Connector_i/rst
add wave -noupdate -group CN1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(1)/Connector_i/SLAVE_CNT
add wave -noupdate -group CN1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(1)/Connector_i/Slave_max_add
add wave -noupdate -group CN1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(1)/Connector_i/Slave_min_add
add wave -noupdate -group CN1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(1)/Connector_i/SM_size
add wave -noupdate -group CN1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(1)/Connector_i/stop_in
add wave -noupdate -group CN1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(1)/Connector_i/taken
add wave -noupdate -group CN1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(1)/Connector_i/Master_grant
add wave -noupdate -group CN1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(1)/Connector_i/Master_MSM
add wave -noupdate -group CN1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(1)/Connector_i/Slave_CS
add wave -noupdate -group CN1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(1)/Connector_i/Slave_SSM
add wave -noupdate -group CN1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(1)/Connector_i/stop_out
add wave -noupdate -group CN1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(1)/Connector_i/this_bussy
add wave -noupdate -group CN1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(1)/Connector_i/this_done
add wave -noupdate -group CN1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(1)/Connector_i/Adds
add wave -noupdate -group CN1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(1)/Connector_i/all_reqs
add wave -noupdate -group CN1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(1)/Connector_i/all_zero
add wave -noupdate -group CN1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(1)/Connector_i/fre_reqs
add wave -noupdate -group CN1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(1)/Connector_i/Maxs
add wave -noupdate -group CN1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(1)/Connector_i/Mins
add wave -noupdate -group CN1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(1)/Connector_i/MSM
add wave -noupdate -group CN1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(1)/Connector_i/SSM
add wave -noupdate -group CN1 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(1)/Connector_i/state
add wave -noupdate -group CN2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(2)/Connector_i/aswering
add wave -noupdate -group CN2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(2)/Connector_i/clk
add wave -noupdate -group CN2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(2)/Connector_i/Master_Address
add wave -noupdate -group CN2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(2)/Connector_i/MASTER_CNT
add wave -noupdate -group CN2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(2)/Connector_i/Master_req
add wave -noupdate -group CN2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(2)/Connector_i/Name
add wave -noupdate -group CN2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(2)/Connector_i/prev_bussy
add wave -noupdate -group CN2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(2)/Connector_i/rst
add wave -noupdate -group CN2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(2)/Connector_i/SLAVE_CNT
add wave -noupdate -group CN2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(2)/Connector_i/Slave_max_add
add wave -noupdate -group CN2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(2)/Connector_i/Slave_min_add
add wave -noupdate -group CN2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(2)/Connector_i/SM_size
add wave -noupdate -group CN2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(2)/Connector_i/stop_in
add wave -noupdate -group CN2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(2)/Connector_i/taken
add wave -noupdate -group CN2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(2)/Connector_i/Master_grant
add wave -noupdate -group CN2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(2)/Connector_i/Master_MSM
add wave -noupdate -group CN2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(2)/Connector_i/Slave_CS
add wave -noupdate -group CN2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(2)/Connector_i/Slave_SSM
add wave -noupdate -group CN2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(2)/Connector_i/stop_out
add wave -noupdate -group CN2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(2)/Connector_i/this_bussy
add wave -noupdate -group CN2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(2)/Connector_i/this_done
add wave -noupdate -group CN2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(2)/Connector_i/Adds
add wave -noupdate -group CN2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(2)/Connector_i/all_reqs
add wave -noupdate -group CN2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(2)/Connector_i/all_zero
add wave -noupdate -group CN2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(2)/Connector_i/fre_reqs
add wave -noupdate -group CN2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(2)/Connector_i/Maxs
add wave -noupdate -group CN2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(2)/Connector_i/Mins
add wave -noupdate -group CN2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(2)/Connector_i/MSM
add wave -noupdate -group CN2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(2)/Connector_i/SSM
add wave -noupdate -group CN2 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(2)/Connector_i/state
add wave -noupdate -group CN3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(3)/Connector_i/aswering
add wave -noupdate -group CN3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(3)/Connector_i/clk
add wave -noupdate -group CN3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(3)/Connector_i/Master_Address
add wave -noupdate -group CN3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(3)/Connector_i/MASTER_CNT
add wave -noupdate -group CN3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(3)/Connector_i/Master_req
add wave -noupdate -group CN3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(3)/Connector_i/Name
add wave -noupdate -group CN3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(3)/Connector_i/prev_bussy
add wave -noupdate -group CN3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(3)/Connector_i/rst
add wave -noupdate -group CN3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(3)/Connector_i/SLAVE_CNT
add wave -noupdate -group CN3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(3)/Connector_i/Slave_max_add
add wave -noupdate -group CN3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(3)/Connector_i/Slave_min_add
add wave -noupdate -group CN3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(3)/Connector_i/SM_size
add wave -noupdate -group CN3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(3)/Connector_i/stop_in
add wave -noupdate -group CN3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(3)/Connector_i/taken
add wave -noupdate -group CN3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(3)/Connector_i/Master_grant
add wave -noupdate -group CN3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(3)/Connector_i/Master_MSM
add wave -noupdate -group CN3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(3)/Connector_i/Slave_CS
add wave -noupdate -group CN3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(3)/Connector_i/Slave_SSM
add wave -noupdate -group CN3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(3)/Connector_i/stop_out
add wave -noupdate -group CN3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(3)/Connector_i/this_bussy
add wave -noupdate -group CN3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(3)/Connector_i/this_done
add wave -noupdate -group CN3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(3)/Connector_i/Adds
add wave -noupdate -group CN3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(3)/Connector_i/all_reqs
add wave -noupdate -group CN3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(3)/Connector_i/all_zero
add wave -noupdate -group CN3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(3)/Connector_i/fre_reqs
add wave -noupdate -group CN3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(3)/Connector_i/Maxs
add wave -noupdate -group CN3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(3)/Connector_i/Mins
add wave -noupdate -group CN3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(3)/Connector_i/MSM
add wave -noupdate -group CN3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(3)/Connector_i/SSM
add wave -noupdate -group CN3 /sim_system/UUT/Accelerator_Unit/LMN_ROW_GEN(0)/LMN_COL_GEN(0)/Local_Memory_Node/Arbiter/connector_gen(3)/Connector_i/state
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/ACCELERATOR_P0_NORMAL
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/ACCELERATOR_P1_NORMAL
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/ACCELERATOR_P2_NORMAL
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/ACCELERATOR_P3_NORMAL
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/clk
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/clk_w
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_DMA_R_Add
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_DMA_R_Cnt
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_DMA_start
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_DMA_W_Add
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_DMA_W_Cnt
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_MPDR_Addresses
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_MPDR_Base_Wen
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_MPDR_Cont_Wen
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_MPDR_IVal_Wen
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_MPDR_load
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_MPDR_MAX_Chn
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_MPDR_MAX_Col
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_MPDR_start
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_MPDR_Target
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_PEs_init_inc_Rows
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_PEs_start
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_STA_ACK
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_STA_active
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_STA_BIS_en
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_STA_load
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_STA_load_UA
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_STA_MEM_en
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_STA_OBM_en
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_STA_save
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_STA_stor_UA
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_STA_store
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_UPA_Up_IFM
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_UPA_Up_WFM
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CNF_ALL_Configurations
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CNT_PEs_PAUSE
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CNT_STA_PAUSE
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CNT_UPA_PAUSE
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/INI_Addresses
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/INI_Base_Wen
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/INI_Bias_Add
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/INI_Bias_val
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/INI_Bias_Wen
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/INI_Count_Wen
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/INI_IntVal_Wen
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/INI_SA_UAbar
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/INI_SLU_unit_add
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/INI_Target_add
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/OGM_2VCU_done
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/OGM_2VCU_grant
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/OGM_2VCU_MD_in
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/OGM_2VCU_MD_in_rdy
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/OGM_2VCU_wait
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/rst_in
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/rst_w
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_DMA_ready
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_MPDR_Done
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_PEs_done
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_STA_done
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_UPA_done
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/CMD_UPA_status
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/OGM_2VCU_Add
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/OGM_2VCU_Cnt
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/OGM_2VCU_MD_out
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/OGM_2VCU_MD_out_rdy
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/OGM_2VCU_read
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/OGM_2VCU_req
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/OGM_2VCU_write
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/rst
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_GMN_M_Add
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_GMN_M_Cnt
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_GMN_M_Din
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_GMN_M_Din_rdy
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_GMN_M_done
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_GMN_M_Dout
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_GMN_M_Dout_rdy
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_GMN_M_grant
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_GMN_M_read
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_GMN_M_req
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_GMN_M_wait
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_GMN_M_write
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_GMN_S_Add
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_GMN_S_Cnt
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_GMN_S_CS
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_GMN_S_Din
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_GMN_S_Din_rdy
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_GMN_S_done
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_GMN_S_Dout
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_GMN_S_Dout_rdy
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_GMN_S_read
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_GMN_S_wait
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_GMN_S_write
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_MPDR_ack
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_MPDR_Add
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_MPDR_Cnt
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_MPDR_data_in
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_MPDR_data_out
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_MPDR_data_rdy
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_MPDR_data_wen
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_MPDR_push
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_MPDR_read
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_MPDR_ready
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_MPDR_wait
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_MPDR_write
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_STA_ack
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_STA_add
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_STA_cnt
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_STA_data_in
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_STA_data_out
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_STA_data_rdy
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_STA_data_wen
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_STA_push
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_STA_read
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_STA_wait
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_STA_write
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_UPA_ack
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_UPA_add
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_UPA_cnt
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_UPA_data_in
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_UPA_data_out
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_UPA_data_rdy
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_UPA_data_wen
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_UPA_push
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_UPA_read
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_LMN_UPA_write
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_PEP_STA_ack
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_PEP_STA_add
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_PEP_STA_cnt
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_PEP_STA_data_in
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_PEP_STA_data_out
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_PEP_STA_data_rdy
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_PEP_STA_data_wen
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_PEP_STA_push
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_PEP_STA_read
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_PEP_STA_wait
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_PEP_STA_write
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_PEP_UPA_ack
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_PEP_UPA_add
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_PEP_UPA_cnt
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_PEP_UPA_data_in
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_PEP_UPA_data_out
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_PEP_UPA_data_rdy
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_PEP_UPA_data_wen
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_PEP_UPA_push
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_PEP_UPA_read
add wave -noupdate -group ACC /sim_system/UUT/Accelerator_Unit/SIG_PEP_UPA_write
add wave -noupdate -group SYS /sim_system/UUT/clk
add wave -noupdate -group SYS /sim_system/UUT/DNoC_BASE_ADDRESS
add wave -noupdate -group SYS /sim_system/UUT/DNoC_PORT_Address
add wave -noupdate -group SYS /sim_system/UUT/DNoC_PORT_clk
add wave -noupdate -group SYS /sim_system/UUT/DNoC_PORT_Data_in
add wave -noupdate -group SYS /sim_system/UUT/DNoC_PORT_OEN
add wave -noupdate -group SYS /sim_system/UUT/DNoC_PORT_WEN
add wave -noupdate -group SYS /sim_system/UUT/INT_REQ_SYS_PC
add wave -noupdate -group SYS /sim_system/UUT/OGM_2VCU_done
add wave -noupdate -group SYS /sim_system/UUT/OGM_2VCU_grant
add wave -noupdate -group SYS /sim_system/UUT/OGM_2VCU_MD_in
add wave -noupdate -group SYS /sim_system/UUT/OGM_2VCU_MD_in_rdy
add wave -noupdate -group SYS /sim_system/UUT/OGM_2VCU_wait
add wave -noupdate -group SYS /sim_system/UUT/rst
add wave -noupdate -group SYS /sim_system/UUT/RUN_SYS_ALLOW
add wave -noupdate -group SYS /sim_system/UUT/Rx_Rx
add wave -noupdate -group SYS /sim_system/UUT/ACCELERATOR_CONNECT
add wave -noupdate -group SYS /sim_system/UUT/DNoC_PORT_Data_out
add wave -noupdate -group SYS /sim_system/UUT/DNoC_PORT_Dot_Rdy
add wave -noupdate -group SYS /sim_system/UUT/DNoC_PORT_SEL_This
add wave -noupdate -group SYS /sim_system/UUT/INT_ACK_SYS_PC
add wave -noupdate -group SYS /sim_system/UUT/OGM_2VCU_Add
add wave -noupdate -group SYS /sim_system/UUT/OGM_2VCU_Cnt
add wave -noupdate -group SYS /sim_system/UUT/OGM_2VCU_MD_out
add wave -noupdate -group SYS /sim_system/UUT/OGM_2VCU_MD_out_rdy
add wave -noupdate -group SYS /sim_system/UUT/OGM_2VCU_read
add wave -noupdate -group SYS /sim_system/UUT/OGM_2VCU_req
add wave -noupdate -group SYS /sim_system/UUT/OGM_2VCU_write
add wave -noupdate -group SYS /sim_system/UUT/Tx_Tx
add wave -noupdate -group SYS /sim_system/UUT/ACCELERATOR_clk
add wave -noupdate -group SYS /sim_system/UUT/ACCELERATOR_P0_NORMAL
add wave -noupdate -group SYS /sim_system/UUT/ACCELERATOR_P1_NORMAL
add wave -noupdate -group SYS /sim_system/UUT/ACCELERATOR_P2_NORMAL
add wave -noupdate -group SYS /sim_system/UUT/ACCELERATOR_P3_NORMAL
add wave -noupdate -group SYS /sim_system/UUT/ACCELERATOR_rst
add wave -noupdate -group SYS /sim_system/UUT/CMD_DMA_R_Add
add wave -noupdate -group SYS /sim_system/UUT/CMD_DMA_R_Cnt
add wave -noupdate -group SYS /sim_system/UUT/CMD_DMA_ready
add wave -noupdate -group SYS /sim_system/UUT/CMD_DMA_start
add wave -noupdate -group SYS /sim_system/UUT/CMD_DMA_W_Add
add wave -noupdate -group SYS /sim_system/UUT/CMD_DMA_W_Cnt
add wave -noupdate -group SYS /sim_system/UUT/CMD_MPDR_Addresses
add wave -noupdate -group SYS /sim_system/UUT/CMD_MPDR_Base_Wen
add wave -noupdate -group SYS /sim_system/UUT/CMD_MPDR_Cont_Wen
add wave -noupdate -group SYS /sim_system/UUT/CMD_MPDR_Done
add wave -noupdate -group SYS /sim_system/UUT/CMD_MPDR_IVal_Wen
add wave -noupdate -group SYS /sim_system/UUT/CMD_MPDR_load
add wave -noupdate -group SYS /sim_system/UUT/CMD_MPDR_MAX_Chn
add wave -noupdate -group SYS /sim_system/UUT/CMD_MPDR_MAX_Col
add wave -noupdate -group SYS /sim_system/UUT/CMD_MPDR_start
add wave -noupdate -group SYS /sim_system/UUT/CMD_MPDR_Target
add wave -noupdate -group SYS /sim_system/UUT/CMD_PEs_done
add wave -noupdate -group SYS /sim_system/UUT/CMD_PEs_init_inc_Rows
add wave -noupdate -group SYS /sim_system/UUT/CMD_PEs_start
add wave -noupdate -group SYS /sim_system/UUT/CMD_STA_ACK
add wave -noupdate -group SYS /sim_system/UUT/CMD_STA_active
add wave -noupdate -group SYS /sim_system/UUT/CMD_STA_BIS_en
add wave -noupdate -group SYS /sim_system/UUT/CMD_STA_done
add wave -noupdate -group SYS /sim_system/UUT/CMD_STA_load
add wave -noupdate -group SYS /sim_system/UUT/CMD_STA_load_UA
add wave -noupdate -group SYS /sim_system/UUT/CMD_STA_MEM_en
add wave -noupdate -group SYS /sim_system/UUT/CMD_STA_OBM_en
add wave -noupdate -group SYS /sim_system/UUT/CMD_STA_save
add wave -noupdate -group SYS /sim_system/UUT/CMD_STA_stor_UA
add wave -noupdate -group SYS /sim_system/UUT/CMD_STA_store
add wave -noupdate -group SYS /sim_system/UUT/CMD_UPA_done
add wave -noupdate -group SYS /sim_system/UUT/CMD_UPA_status
add wave -noupdate -group SYS /sim_system/UUT/CMD_UPA_Up_IFM
add wave -noupdate -group SYS /sim_system/UUT/CMD_UPA_Up_WFM
add wave -noupdate -group SYS /sim_system/UUT/CNF_ALL_Configurations
add wave -noupdate -group SYS /sim_system/UUT/CNT_PEs_PAUSE
add wave -noupdate -group SYS /sim_system/UUT/CNT_STA_PAUSE
add wave -noupdate -group SYS /sim_system/UUT/CNT_UPA_PAUSE
add wave -noupdate -group SYS /sim_system/UUT/INI_Addresses
add wave -noupdate -group SYS /sim_system/UUT/INI_Base_Wen
add wave -noupdate -group SYS /sim_system/UUT/INI_Bias_Add
add wave -noupdate -group SYS /sim_system/UUT/INI_Bias_val
add wave -noupdate -group SYS /sim_system/UUT/INI_Bias_Wen
add wave -noupdate -group SYS /sim_system/UUT/INI_Count_Wen
add wave -noupdate -group SYS /sim_system/UUT/INI_IntVal_Wen
add wave -noupdate -group SYS /sim_system/UUT/INI_SA_UAbar
add wave -noupdate -group SYS /sim_system/UUT/INI_SLU_unit_add
add wave -noupdate -group SYS /sim_system/UUT/INI_Target_add
add wave -noupdate -group SYS /sim_system/UUT/SCHEDULER_clk
add wave -noupdate -group SYS /sim_system/UUT/SCHEDULER_rst
add wave -noupdate -group SER /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/BASE_ADDRESS
add wave -noupdate -group SER /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/clk
add wave -noupdate -group SER /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/ENDx_ADDRESS
add wave -noupdate -group SER /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/handler_id
add wave -noupdate -group SER /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/OGM_2VCU_Add
add wave -noupdate -group SER /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/OGM_2VCU_Cnt
add wave -noupdate -group SER /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/OGM_2VCU_MD_in
add wave -noupdate -group SER /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/OGM_2VCU_MD_in_rdy
add wave -noupdate -group SER /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/OGM_2VCU_read
add wave -noupdate -group SER /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/OGM_2VCU_req
add wave -noupdate -group SER /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/OGM_2VCU_write
add wave -noupdate -group SER /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/rst
add wave -noupdate -group SER /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/OGM_2VCU_done
add wave -noupdate -group SER /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/OGM_2VCU_grant
add wave -noupdate -group SER /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/OGM_2VCU_MD_out
add wave -noupdate -group SER /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/OGM_2VCU_MD_out_rdy
add wave -noupdate -group SER /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/OGM_2VCU_wait
add wave -noupdate -group SER /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/MEM_Add
add wave -noupdate -group SER /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/MEM_Din
add wave -noupdate -group SER /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/MEM_Dout
add wave -noupdate -group SER /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/MEM_wen
add wave -noupdate -group SER /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/OGM_2VCU_MD_out_rdy_tmp
add wave -noupdate -group SER /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/OGM_2VCU_MD_out_temp
add wave -noupdate -group MIF /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/mem_if/BUS_Add
add wave -noupdate -group MIF /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/mem_if/BUS_Cnt
add wave -noupdate -group MIF /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/mem_if/BUS_CS
add wave -noupdate -group MIF /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/mem_if/BUS_read
add wave -noupdate -group MIF /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/mem_if/BUS_SD_in
add wave -noupdate -group MIF /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/mem_if/BUS_SD_in_rdy
add wave -noupdate -group MIF /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/mem_if/BUS_write
add wave -noupdate -group MIF /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/mem_if/clk
add wave -noupdate -group MIF /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/mem_if/MEM_Din
add wave -noupdate -group MIF /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/mem_if/rst
add wave -noupdate -group MIF /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/mem_if/BUS_done
add wave -noupdate -group MIF /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/mem_if/BUS_SD_out
add wave -noupdate -group MIF /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/mem_if/BUS_SD_out_rdy
add wave -noupdate -group MIF /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/mem_if/BUS_wait
add wave -noupdate -group MIF /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/mem_if/MEM_Add
add wave -noupdate -group MIF /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/mem_if/MEM_Dout
add wave -noupdate -group MIF /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/mem_if/MEM_wen
add wave -noupdate -group MIF /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/mem_if/Addr
add wave -noupdate -group MIF /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/mem_if/cnt
add wave -noupdate -group MIF /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/mem_if/Cntr
add wave -noupdate -group MIF /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/mem_if/eq
add wave -noupdate -group MIF /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/mem_if/load
add wave -noupdate -group MIF /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/mem_if/N_S
add wave -noupdate -group MIF /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/mem_if/P_S
add wave -noupdate -group MIF /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/mem_if/SDout_rdy
add wave -noupdate -group FIO /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/FILE_HANDLER/clk
add wave -noupdate -group FIO /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/FILE_HANDLER/cs
add wave -noupdate -group FIO /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/FILE_HANDLER/MEM_Add
add wave -noupdate -group FIO /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/FILE_HANDLER/MEM_Din
add wave -noupdate -group FIO /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/FILE_HANDLER/MEM_wen
add wave -noupdate -group FIO /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/FILE_HANDLER/MEM_Dout
add wave -noupdate -group FIO /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/FILE_HANDLER/chk_fid
add wave -noupdate -group FIO /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/FILE_HANDLER/err_fid
add wave -noupdate -group FIO /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/FILE_HANDLER/file_name
add wave -noupdate -group FIO /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/FILE_HANDLER/handler_id
add wave -noupdate -group FIO /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/FILE_HANDLER/log_fid
add wave -noupdate -group FIO /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/FILE_HANDLER/mem
add wave -noupdate -group FIO /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/FILE_HANDLER/per_file_width
add wave -noupdate -group FIO /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/FILE_HANDLER/prev_file
add wave -noupdate -group FIO /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/FILE_HANDLER/this_file
add wave -noupdate -group FIO /sim_system/SEMI_SERIALIZER_GEN_ROW(0)/SEMI_SERIALIZER_GEN_COL(0)/semi_ser/FILE_HANDLER/wrote_on_this
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {40446 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 212
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
WaveRestoreZoom {0 ns} {420 us}
