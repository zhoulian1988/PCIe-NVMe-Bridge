vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib
vlib modelsim_lib/msim/xpm

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib
vmap xpm modelsim_lib/msim/xpm

vlog -work xil_defaultlib -64 -incr -sv \
"/home/vavido/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"/home/vavido/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"/home/vavido/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib -64 -incr \
"../../../../../../../ips_690t/rp_690t_1/source/rp_690t_pcie_7vx.v" \
"../../../../../../../ips_690t/rp_690t_1/source/rp_690t_pcie_bram_7vx.v" \
"../../../../../../../ips_690t/rp_690t_1/source/rp_690t_pcie_bram_7vx_8k.v" \
"../../../../../../../ips_690t/rp_690t_1/source/rp_690t_pcie_bram_7vx_16k.v" \
"../../../../../../../ips_690t/rp_690t_1/source/rp_690t_pcie_bram_7vx_cpl.v" \
"../../../../../../../ips_690t/rp_690t_1/source/rp_690t_pcie_bram_7vx_rep.v" \
"../../../../../../../ips_690t/rp_690t_1/source/rp_690t_pcie_bram_7vx_rep_8k.v" \
"../../../../../../../ips_690t/rp_690t_1/source/rp_690t_pcie_bram_7vx_req.v" \
"../../../../../../../ips_690t/rp_690t_1/source/rp_690t_pcie_init_ctrl_7vx.v" \
"../../../../../../../ips_690t/rp_690t_1/source/rp_690t_pcie_pipe_lane.v" \
"../../../../../../../ips_690t/rp_690t_1/source/rp_690t_pcie_pipe_misc.v" \
"../../../../../../../ips_690t/rp_690t_1/source/rp_690t_pcie_pipe_pipeline.v" \
"../../../../../../../ips_690t/rp_690t_1/source/rp_690t_pcie_top.v" \
"../../../../../../../ips_690t/rp_690t_1/source/rp_690t_pcie_force_adapt.v" \
"../../../../../../../ips_690t/rp_690t_1/source/rp_690t_pipe_clock.v" \
"../../../../../../../ips_690t/rp_690t_1/source/rp_690t_pipe_drp.v" \
"../../../../../../../ips_690t/rp_690t_1/source/rp_690t_pipe_eq.v" \
"../../../../../../../ips_690t/rp_690t_1/source/rp_690t_pipe_rate.v" \
"../../../../../../../ips_690t/rp_690t_1/source/rp_690t_pipe_reset.v" \
"../../../../../../../ips_690t/rp_690t_1/source/rp_690t_pipe_sync.v" \
"../../../../../../../ips_690t/rp_690t_1/source/rp_690t_pipe_user.v" \
"../../../../../../../ips_690t/rp_690t_1/source/rp_690t_pipe_wrapper.v" \
"../../../../../../../ips_690t/rp_690t_1/source/rp_690t_qpll_drp.v" \
"../../../../../../../ips_690t/rp_690t_1/source/rp_690t_qpll_reset.v" \
"../../../../../../../ips_690t/rp_690t_1/source/rp_690t_qpll_wrapper.v" \
"../../../../../../../ips_690t/rp_690t_1/source/rp_690t_rxeq_scan.v" \
"../../../../../../../ips_690t/rp_690t_1/source/rp_690t_gt_wrapper.v" \
"../../../../../../../ips_690t/rp_690t_1/source/rp_690t_gt_top.v" \
"../../../../../../../ips_690t/rp_690t_1/source/rp_690t_gt_common.v" \
"../../../../../../../ips_690t/rp_690t_1/source/rp_690t_gtx_cpllpd_ovrd.v" \
"../../../../../../../ips_690t/rp_690t_1/source/rp_690t_pcie_tlp_tph_tbl_7vx.v" \
"../../../../../../../ips_690t/rp_690t_1/source/rp_690t_pcie_3_0_7vx.v" \
"../../../../../../../ips_690t/rp_690t_1/sim/rp_690t.v" \

vlog -work xil_defaultlib \
"glbl.v"

