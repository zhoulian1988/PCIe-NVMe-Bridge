-makelib xcelium_lib/xil_defaultlib -sv \
  "/home/vavido/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "/home/vavido/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "/home/vavido/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../../../../ips_690t/top_ep_ila_1/sim/top_ep_ila.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

