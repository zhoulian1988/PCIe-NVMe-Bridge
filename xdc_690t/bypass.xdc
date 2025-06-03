
set_property CFGBVS GND [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS true [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE Yes [current_design]

#-------------------------- 690T ------------------------------------------
#
###############################################################################
# User Time Names / User Time Groups / Time Specs
###############################################################################
#gold finger clock
set_property PACKAGE_PIN AB6 [get_ports ep_sys_clk_p]
set_property PACKAGE_PIN AB5 [get_ports ep_sys_clk_n]


set_property PACKAGE_PIN AC3  [get_ports {ep_pci_exp_rxn[0]}]
set_property PACKAGE_PIN AC4  [get_ports {ep_pci_exp_rxp[0]}]

set_property PACKAGE_PIN AE3  [get_ports {ep_pci_exp_rxn[1]}]
set_property PACKAGE_PIN AE4  [get_ports {ep_pci_exp_rxp[1]}]

set_property PACKAGE_PIN AF5  [get_ports {ep_pci_exp_rxn[2]}]
set_property PACKAGE_PIN AF6  [get_ports {ep_pci_exp_rxp[2]}]

set_property PACKAGE_PIN AG3  [get_ports {ep_pci_exp_rxn[3]}]
set_property PACKAGE_PIN AG4  [get_ports {ep_pci_exp_rxp[3]}]


set_property PACKAGE_PIN AB1  [get_ports {ep_pci_exp_txn[0]}]
set_property PACKAGE_PIN AB2  [get_ports {ep_pci_exp_txp[0]}]

set_property PACKAGE_PIN AD1  [get_ports {ep_pci_exp_txn[1]}]
set_property PACKAGE_PIN AD2  [get_ports {ep_pci_exp_txp[1]}]

set_property PACKAGE_PIN AF1  [get_ports {ep_pci_exp_txn[2]}]
set_property PACKAGE_PIN AF2  [get_ports {ep_pci_exp_txp[2]}]

set_property PACKAGE_PIN AH1  [get_ports {ep_pci_exp_txn[3]}]
set_property PACKAGE_PIN AH2  [get_ports {ep_pci_exp_txp[3]}]


set_property PACKAGE_PIN AN30 [get_ports ep_sys_rst_n]


create_clock -name ep_sys_clk -period 10 [get_ports ep_sys_clk_p]

#
set_false_path -from [get_ports ep_sys_rst_n]
set_property PULLUP true [get_ports ep_sys_rst_n]
set_property IOSTANDARD LVCMOS18 [get_ports ep_sys_rst_n]



#SLOT1 clock
set_property PACKAGE_PIN F6  [get_ports rp_sys_clk_p]
set_property PACKAGE_PIN F5  [get_ports rp_sys_clk_n]


set_property PACKAGE_PIN B5  [get_ports {rp_pci_exp_rxn[0]}]
set_property PACKAGE_PIN B6  [get_ports {rp_pci_exp_rxp[0]}]

set_property PACKAGE_PIN D5 [get_ports {rp_pci_exp_rxn[1]}]
set_property PACKAGE_PIN D6 [get_ports {rp_pci_exp_rxp[1]}]

set_property PACKAGE_PIN E3 [get_ports {rp_pci_exp_rxn[2]}]
set_property PACKAGE_PIN E4 [get_ports {rp_pci_exp_rxp[2]}]

set_property PACKAGE_PIN G3 [get_ports {rp_pci_exp_rxn[3]}]
set_property PACKAGE_PIN G4 [get_ports {rp_pci_exp_rxp[3]}]


set_property PACKAGE_PIN A3  [get_ports {rp_pci_exp_txn[0]}]
set_property PACKAGE_PIN A4  [get_ports {rp_pci_exp_txp[0]}]

set_property PACKAGE_PIN B1 [get_ports {rp_pci_exp_txn[1]}]
set_property PACKAGE_PIN B2 [get_ports {rp_pci_exp_txp[1]}]

set_property PACKAGE_PIN C3 [get_ports {rp_pci_exp_txn[2]}]
set_property PACKAGE_PIN C4 [get_ports {rp_pci_exp_txp[2]}]

set_property PACKAGE_PIN D1 [get_ports {rp_pci_exp_txn[3]}]
set_property PACKAGE_PIN D2 [get_ports {rp_pci_exp_txp[3]}]





# to SLOT1 NVMe SSD
#set_property PACKAGE_PIN AK32 [get_ports rp_to_J8_sys_rst_n]
#set_property PULLUP true [get_ports rp_to_J8_sys_rst_n]
#set_property IOSTANDARD LVCMOS18 [get_ports rp_to_J8_sys_rst_n]


set_property PACKAGE_PIN AK28 [get_ports clk100_p]
set_property PACKAGE_PIN AL28 [get_ports clk100_n]

set_property IOSTANDARD DIFF_SSTL18_I [get_ports clk100_p]
set_property IOSTANDARD DIFF_SSTL18_I [get_ports clk100_n]
create_clock -period 10.000 [get_ports clk100_p]


create_clock -name rp_sys_clk -period 10 [get_ports rp_sys_clk_p]

set_property PACKAGE_PIN AL26 [get_ports led[0]]
set_property IOSTANDARD LVCMOS18 [get_ports led[0]]

set_property PACKAGE_PIN AK27 [get_ports led[1]]
set_property IOSTANDARD LVCMOS18 [get_ports led[1]]



set_false_path -from [get_ports ep_sys_rst_n]

create_clock -name ep_user_clk -period 8 [get_pins ep_i/user_clk]

create_clock -name rp_user_clk -period 8 [get_pins rp_i/user_clk]

set_max_delay 1.5 -from [get_clocks ep_user_clk] -to [get_clocks rp_user_clk] -datapath_only
set_max_delay 1.5 -from [get_clocks rp_user_clk] -to [get_clocks ep_user_clk] -datapath_only