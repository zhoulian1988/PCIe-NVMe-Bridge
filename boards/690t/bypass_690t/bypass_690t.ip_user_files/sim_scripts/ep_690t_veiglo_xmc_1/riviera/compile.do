vlib work
vlib riviera

vlib riviera/xil_defaultlib
vlib riviera/xpm

vmap xil_defaultlib riviera/xil_defaultlib
vmap xpm riviera/xpm

vlog -work xil_defaultlib  -sv2k12 \
"/home/vavido/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"/home/vavido/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"/home/vavido/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/source/ep_690t_veiglo_xmc_pcie_7vx.v" \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/source/ep_690t_veiglo_xmc_pcie_bram_7vx.v" \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/source/ep_690t_veiglo_xmc_pcie_bram_7vx_8k.v" \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/source/ep_690t_veiglo_xmc_pcie_bram_7vx_16k.v" \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/source/ep_690t_veiglo_xmc_pcie_bram_7vx_cpl.v" \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/source/ep_690t_veiglo_xmc_pcie_bram_7vx_rep.v" \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/source/ep_690t_veiglo_xmc_pcie_bram_7vx_rep_8k.v" \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/source/ep_690t_veiglo_xmc_pcie_bram_7vx_req.v" \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/source/ep_690t_veiglo_xmc_pcie_init_ctrl_7vx.v" \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/source/ep_690t_veiglo_xmc_pcie_pipe_lane.v" \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/source/ep_690t_veiglo_xmc_pcie_pipe_misc.v" \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/source/ep_690t_veiglo_xmc_pcie_pipe_pipeline.v" \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/source/ep_690t_veiglo_xmc_pcie_top.v" \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/source/ep_690t_veiglo_xmc_pcie_force_adapt.v" \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/source/ep_690t_veiglo_xmc_pipe_clock.v" \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/source/ep_690t_veiglo_xmc_pipe_drp.v" \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/source/ep_690t_veiglo_xmc_pipe_eq.v" \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/source/ep_690t_veiglo_xmc_pipe_rate.v" \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/source/ep_690t_veiglo_xmc_pipe_reset.v" \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/source/ep_690t_veiglo_xmc_pipe_sync.v" \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/source/ep_690t_veiglo_xmc_pipe_user.v" \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/source/ep_690t_veiglo_xmc_pipe_wrapper.v" \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/source/ep_690t_veiglo_xmc_qpll_drp.v" \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/source/ep_690t_veiglo_xmc_qpll_reset.v" \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/source/ep_690t_veiglo_xmc_qpll_wrapper.v" \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/source/ep_690t_veiglo_xmc_rxeq_scan.v" \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/source/ep_690t_veiglo_xmc_gt_wrapper.v" \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/source/ep_690t_veiglo_xmc_gt_top.v" \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/source/ep_690t_veiglo_xmc_gt_common.v" \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/source/ep_690t_veiglo_xmc_gtx_cpllpd_ovrd.v" \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/source/ep_690t_veiglo_xmc_pcie_tlp_tph_tbl_7vx.v" \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/source/ep_690t_veiglo_xmc_pcie_3_0_7vx.v" \
"../../../../../../../ips_690t/ep_690t_veiglo_xmc_1/sim/ep_690t_veiglo_xmc.v" \

vlog -work xil_defaultlib \
"glbl.v"

