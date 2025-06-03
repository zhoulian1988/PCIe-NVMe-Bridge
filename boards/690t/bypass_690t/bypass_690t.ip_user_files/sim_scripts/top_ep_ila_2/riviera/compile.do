vlib work
vlib riviera

vlib riviera/xil_defaultlib
vlib riviera/xpm

vmap xil_defaultlib riviera/xil_defaultlib
vmap xpm riviera/xpm

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../../../../ips_690t/top_ep_ila_2/hdl/verilog" "+incdir+../../../../../../../ips_690t/top_ep_ila_2/hdl/verilog" \
"/home/vavido/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"/home/vavido/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"/home/vavido/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../../../../ips_690t/top_ep_ila_2/hdl/verilog" "+incdir+../../../../../../../ips_690t/top_ep_ila_2/hdl/verilog" \
"../../../../../../../ips_690t/top_ep_ila_2/sim/top_ep_ila.v" \

vlog -work xil_defaultlib \
"glbl.v"

