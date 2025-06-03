#
#-------------------------- 690T ------------------------------------------
#
###############################################################################
# User Time Names / User Time Groups / Time Specs
###############################################################################
#gold finger clock
set_property PACKAGE_PIN E10 [get_ports ep_sys_clk_p]
set_property PACKAGE_PIN E9  [get_ports ep_sys_clk_n]


set_property PACKAGE_PIN E5  [get_ports {ep_pci_exp_rxn[0]}]
set_property PACKAGE_PIN E6  [get_ports {ep_pci_exp_rxp[0]}]

set_property PACKAGE_PIN F7  [get_ports {ep_pci_exp_rxn[1]}]
set_property PACKAGE_PIN F8  [get_ports {ep_pci_exp_rxp[1]}]

set_property PACKAGE_PIN G5  [get_ports {ep_pci_exp_rxn[2]}]
set_property PACKAGE_PIN G6  [get_ports {ep_pci_exp_rxp[2]}]

set_property PACKAGE_PIN H7  [get_ports {ep_pci_exp_rxn[3]}]
set_property PACKAGE_PIN H8  [get_ports {ep_pci_exp_rxp[3]}]

#############################################################################
set_property PACKAGE_PIN F3  [get_ports {ep_pci_exp_txn[0]}]
set_property PACKAGE_PIN F4  [get_ports {ep_pci_exp_txp[0]}]

set_property PACKAGE_PIN G1  [get_ports {ep_pci_exp_txn[1]}]
set_property PACKAGE_PIN G2  [get_ports {ep_pci_exp_txp[1]}]

set_property PACKAGE_PIN H3  [get_ports {ep_pci_exp_txn[2]}]
set_property PACKAGE_PIN H4  [get_ports {ep_pci_exp_txp[2]}]

set_property PACKAGE_PIN J1  [get_ports {ep_pci_exp_txn[3]}]
set_property PACKAGE_PIN J2  [get_ports {ep_pci_exp_txp[3]}]


set_property PACKAGE_PIN F32 [get_ports ep_sys_rst_n]


create_clock -name ep_sys_clk -period 10 [get_ports ep_sys_clk_p]

#
set_false_path -from [get_ports ep_sys_rst_n]
set_property PULLUP true [get_ports ep_sys_rst_n]
set_property IOSTANDARD LVCMOS18 [get_ports ep_sys_rst_n]
#
##set_property LOC [get_package_pins -of_objects [get_bels [get_sites -filter {NAME =~ *COMMON*} -of_objects [get_iobanks -of_objects [get_sites GTHE4_CHANNEL_X0Y15]]]/REFCLK0P]] [get_ports ep_sys_clk_p]
##set_property LOC [get_package_pins -of_objects [get_bels [get_sites -filter {NAME =~ *COMMON*} -of_objects [get_iobanks -of_objects [get_sites GTHE4_CHANNEL_X0Y15]]]/REFCLK0N]] [get_ports ep_sys_clk_n]
#
#
#
#
#
# CLOCK_ROOT LOCKing to Reduce CLOCK SKEW
# Add/Edit  Clock Routing Option to improve clock path skew
#
# BITFILE/BITSTREAM compress options
# Flash type constraints. These should be modified to match the target board.
#
#
#
# sys_clk vs TXOUTCLK
##set_clock_groups -name ep_async18 -asynchronous -group [get_clocks {ep_sys_clk}] -group [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ *gen_channel_container[*].*gen_gthe4_channel_inst[*].GTHE4_CHANNEL_PRIM_INST/TXOUTCLK}]]
##set_clock_groups -name ep_async19 -asynchronous -group [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ *gen_channel_container[*].*gen_gthe4_channel_inst[*].GTHE4_CHANNEL_PRIM_INST/TXOUTCLK}]] -group [get_clocks {ep_sys_clk}]
#
#
#
#
#
#
# ASYNC CLOCK GROUPINGS
# sys_clk vs user_clk
##set_clock_groups -name ep_async5 -asynchronous -group [get_clocks {ep_sys_clk}] -group [get_clocks -of_objects [get_pins ep_i/ep_J1_i/inst/gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_userclk/O]]
##set_clock_groups -name ep_async6 -asynchronous -group [get_clocks -of_objects [get_pins ep_i/ep_J1_i/inst/gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_userclk/O]] -group [get_clocks {ep_sys_clk}]
#
#
# Timing improvement
# Add/Edit Pblock slice constraints for init_ctr module to improve timing
#create_pblock init_ctr_rst; add_cells_to_pblock [get_pblocks init_ctr_rst] [get_cells ep_J1_i/inst/pcie_4_0_pipe_inst/pcie_4_0_init_ctrl_inst]
# Keep This Logic Left/Right Side Of The PCIe Block (Whichever is near to the FPGA Boundary)
#resize_pblock [get_pblocks init_ctr_rst] -add {SLICE_X90Y160:SLICE_X104Y250}
#
##set_clock_groups -name ep_async7 -asynchronous -group [get_clocks -of_objects [get_pins ep_i/ep_J1_i/inst/gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_intclk/O]] -group [get_clocks {ep_sys_clk}]




###############################################################################
# User Time Names / User Time Groups / Time Specs
###############################################################################
#SLOT clock
#set_property PACKAGE_PIN AT8 [get_ports rp_sys_clk_p]
#set_property PACKAGE_PIN AT7 [get_ports rp_sys_clk_n]


#set_property PACKAGE_PIN AP7 [get_ports {rp_pci_exp_rxn[0]}]
#set_property PACKAGE_PIN AP8 [get_ports {rp_pci_exp_rxp[0]}]

#set_property PACKAGE_PIN AR5 [get_ports {rp_pci_exp_rxn[1]}]
#set_property PACKAGE_PIN AR6 [get_ports {rp_pci_exp_rxp[1]}]

#set_property PACKAGE_PIN AU5 [get_ports {rp_pci_exp_rxn[2]}]
#set_property PACKAGE_PIN AU6 [get_ports {rp_pci_exp_rxp[2]}]

#set_property PACKAGE_PIN AV7 [get_ports {rp_pci_exp_rxn[3]}]
#set_property PACKAGE_PIN AV8 [get_ports {rp_pci_exp_rxp[3]}]

#############################################################################
#set_property PACKAGE_PIN AR1 [get_ports {rp_pci_exp_txn[0]}]
#set_property PACKAGE_PIN AR2 [get_ports {rp_pci_exp_txp[0]}]

#set_property PACKAGE_PIN AT3 [get_ports {rp_pci_exp_txn[1]}]
#set_property PACKAGE_PIN AT4 [get_ports {rp_pci_exp_txp[1]}]

#set_property PACKAGE_PIN AU1 [get_ports {rp_pci_exp_txn[2]}]
#set_property PACKAGE_PIN AU2 [get_ports {rp_pci_exp_txp[2]}]

#set_property PACKAGE_PIN AV3 [get_ports {rp_pci_exp_txn[3]}]
#set_property PACKAGE_PIN AV4 [get_ports {rp_pci_exp_txp[3]}]

#############################################################################
#SLOT1 clock
set_property PACKAGE_PIN Y8  [get_ports rp_sys_clk_p]
set_property PACKAGE_PIN Y7  [get_ports rp_sys_clk_n]


set_property PACKAGE_PIN Y3  [get_ports {rp_pci_exp_rxn[0]}]
set_property PACKAGE_PIN Y4  [get_ports {rp_pci_exp_rxp[0]}]

set_property PACKAGE_PIN AA5 [get_ports {rp_pci_exp_rxn[1]}]
set_property PACKAGE_PIN AA6 [get_ports {rp_pci_exp_rxp[1]}]

set_property PACKAGE_PIN AB3 [get_ports {rp_pci_exp_rxn[2]}]
set_property PACKAGE_PIN AB4 [get_ports {rp_pci_exp_rxp[2]}]

set_property PACKAGE_PIN AC5 [get_ports {rp_pci_exp_rxn[3]}]
set_property PACKAGE_PIN AC6 [get_ports {rp_pci_exp_rxp[3]}]

#############################################################################
set_property PACKAGE_PIN W1  [get_ports {rp_pci_exp_txn[0]}]
set_property PACKAGE_PIN W2  [get_ports {rp_pci_exp_txp[0]}]

set_property PACKAGE_PIN AA1 [get_ports {rp_pci_exp_txn[1]}]
set_property PACKAGE_PIN AA2 [get_ports {rp_pci_exp_txp[1]}]

set_property PACKAGE_PIN AC1 [get_ports {rp_pci_exp_txn[2]}]
set_property PACKAGE_PIN AC2 [get_ports {rp_pci_exp_txp[2]}]

set_property PACKAGE_PIN AE1 [get_ports {rp_pci_exp_txn[3]}]
set_property PACKAGE_PIN AE2 [get_ports {rp_pci_exp_txp[3]}]



# to SLOT NVMe SSD
#set_property PACKAGE_PIN AL23 [get_ports rp_sys_rst_n]
#set_property PACKAGE_PIN AA42 [get_ports rp_to_SLOT_sys_rst_n]
#set_property IOSTANDARD LVCMOS18 [get_ports rp_to_SLOT_sys_rst_n]


# to SLOT1 NVMe SSD
#set_property PACKAGE_PIN AL23 [get_ports rp_sys_rst_n]
set_property PACKAGE_PIN AA37 [get_ports rp_to_J8_sys_rst_n]
set_property IOSTANDARD LVCMOS18 [get_ports rp_to_J8_sys_rst_n]


create_clock -name rp_sys_clk -period 10 [get_ports rp_sys_clk_p]
#
#set_false_path -from [get_ports rp_sys_rst_n]
#set_property PULLUP true [get_ports rp_sys_rst_n]
#set_property IOSTANDARD LVCMOS18 [get_ports rp_sys_rst_n]
#set_property LOC [get_package_pins -filter {PIN_FUNC =~ *_PERSTN0_65}] [get_ports rp_sys_rst_n] 
#
##set_property LOC [get_package_pins -of_objects [get_bels [get_sites -filter {NAME =~ *COMMON*} -of_objects [get_iobanks -of_objects [get_sites GTYE4_CHANNEL_X0Y7]]]/REFCLK0P]] [get_ports rp_sys_clk_p]
##set_property LOC [get_package_pins -of_objects [get_bels [get_sites -filter {NAME =~ *COMMON*} -of_objects [get_iobanks -of_objects [get_sites GTYE4_CHANNEL_X0Y7]]]/REFCLK0N]] [get_ports rp_sys_clk_n]
#
#
#
#
#
# CLOCK_ROOT LOCKing to Reduce CLOCK SKEW
# Add/Edit  Clock Routing Option to improve clock path skew
#
# BITFILE/BITSTREAM compress options
# Flash type constraints. These should be modified to match the target board.
#
#
#
# sys_clk vs TXOUTCLK
##set_clock_groups -name rp_async18 -asynchronous -group [get_clocks {rp_sys_clk}] -group [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ *gen_channel_container[*].*gen_gtye4_channel_inst[*].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]]
##set_clock_groups -name rp_async19 -asynchronous -group [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ *gen_channel_container[*].*gen_gtye4_channel_inst[*].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]] -group [get_clocks {rp_sys_clk}]
#
#
#
#
#
#
# ASYNC CLOCK GROUPINGS
# sys_clk vs user_clk
##set_clock_groups -name rp_async5 -asynchronous -group [get_clocks {rp_sys_clk}] -group [get_clocks -of_objects [get_pins rp_i/cgator_wrapper_i/rp_J110_i/inst/gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_userclk/O]]
##set_clock_groups -name rp_async6 -asynchronous -group [get_clocks -of_objects [get_pins rp_i/cgator_wrapper_i/rp_J110_i/inst/gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_userclk/O]] -group [get_clocks {rp_sys_clk}]
#
#
# Timing improvement
# Add/Edit Pblock slice constraints for init_ctr module to improve timing
#create_pblock init_ctr_rst; add_cells_to_pblock [get_pblocks init_ctr_rst] [get_cells cgator_wrapper_i/rp_J110_i/inst/pcie_4_0_pipe_inst/pcie_4_0_init_ctrl_inst]
# Keep This Logic Left/Right Side Of The PCIe Block (Whichever is near to the FPGA Boundary)
#resize_pblock [get_pblocks init_ctr_rst] -add {SLICE_X0Y240:SLICE_X14Y320}
#
##set_clock_groups -name rp_async24 -asynchronous -group [get_clocks -of_objects [get_pins rp_i/cgator_wrapper_i/rp_J110_i/inst/gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_intclk/O]] -group [get_clocks {rp_sys_clk}]

