-makelib ies_lib/xil_defaultlib -sv \
  "/home/vavido/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "/home/vavido/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "/home/vavido/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../../../../ips_690t/top_ep_ila_2/sim/top_ep_ila.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

