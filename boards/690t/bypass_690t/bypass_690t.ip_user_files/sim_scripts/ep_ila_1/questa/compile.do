vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/xpm

vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap xpm questa_lib/msim/xpm

vlog -work xil_defaultlib -64 -sv "+incdir+../../../../../../../ips_690t/ep_ila_1/hdl/verilog" "+incdir+../../../../../../../ips_690t/top_ep_ila_2/hdl/verilog" "+incdir+../../../../../../../ips_690t/ep_ila_1/hdl/verilog" "+incdir+../../../../../../../ips_690t/top_ep_ila_2/hdl/verilog" \
"/home/vavido/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"/home/vavido/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"/home/vavido/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib -64 "+incdir+../../../../../../../ips_690t/ep_ila_1/hdl/verilog" "+incdir+../../../../../../../ips_690t/top_ep_ila_2/hdl/verilog" "+incdir+../../../../../../../ips_690t/ep_ila_1/hdl/verilog" "+incdir+../../../../../../../ips_690t/top_ep_ila_2/hdl/verilog" \
"../../../../../../../ips_690t/ep_ila_1/sim/ep_ila.v" \

vlog -work xil_defaultlib \
"glbl.v"

