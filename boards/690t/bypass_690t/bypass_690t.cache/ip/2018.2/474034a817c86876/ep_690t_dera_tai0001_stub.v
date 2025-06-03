// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (lin64) Build 2258646 Thu Jun 14 20:02:38 MDT 2018
// Date        : Thu Nov 24 12:02:26 2022
// Host        : 192.168.2.203 running 64-bit unknown
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ ep_690t_dera_tai0001_stub.v
// Design      : ep_690t_dera_tai0001
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7vx690tffg1761-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ep_690t_dera_tai0001_pcie_3_0_7vx,Vivado 2018.2" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(pci_exp_txn, pci_exp_txp, pci_exp_rxn, 
  pci_exp_rxp, mmcm_lock, user_clk, user_reset, user_lnk_up, user_app_rdy, s_axis_rq_tlast, 
  s_axis_rq_tdata, s_axis_rq_tuser, s_axis_rq_tkeep, s_axis_rq_tready, s_axis_rq_tvalid, 
  m_axis_rc_tdata, m_axis_rc_tuser, m_axis_rc_tlast, m_axis_rc_tkeep, m_axis_rc_tvalid, 
  m_axis_rc_tready, m_axis_cq_tdata, m_axis_cq_tuser, m_axis_cq_tlast, m_axis_cq_tkeep, 
  m_axis_cq_tvalid, m_axis_cq_tready, s_axis_cc_tdata, s_axis_cc_tuser, s_axis_cc_tlast, 
  s_axis_cc_tkeep, s_axis_cc_tvalid, s_axis_cc_tready, pcie_rq_seq_num, 
  pcie_rq_seq_num_vld, pcie_rq_tag, pcie_rq_tag_vld, pcie_tfc_nph_av, pcie_tfc_npd_av, 
  pcie_cq_np_req, pcie_cq_np_req_count, cfg_phy_link_down, cfg_phy_link_status, 
  cfg_negotiated_width, cfg_current_speed, cfg_max_payload, cfg_max_read_req, 
  cfg_function_status, cfg_function_power_state, cfg_vf_status, cfg_vf_power_state, 
  cfg_link_power_state, cfg_mgmt_addr, cfg_mgmt_write, cfg_mgmt_write_data, 
  cfg_mgmt_byte_enable, cfg_mgmt_read, cfg_mgmt_read_data, cfg_mgmt_read_write_done, 
  cfg_mgmt_type1_cfg_reg_access, cfg_err_cor_out, cfg_err_nonfatal_out, 
  cfg_err_fatal_out, cfg_ltr_enable, cfg_ltssm_state, cfg_rcb_status, 
  cfg_dpa_substate_change, cfg_obff_enable, cfg_pl_status_change, 
  cfg_tph_requester_enable, cfg_tph_st_mode, cfg_vf_tph_requester_enable, 
  cfg_vf_tph_st_mode, cfg_msg_received, cfg_msg_received_data, cfg_msg_received_type, 
  cfg_msg_transmit, cfg_msg_transmit_type, cfg_msg_transmit_data, cfg_msg_transmit_done, 
  cfg_fc_ph, cfg_fc_pd, cfg_fc_nph, cfg_fc_npd, cfg_fc_cplh, cfg_fc_cpld, cfg_fc_sel, 
  cfg_per_func_status_control, cfg_per_func_status_data, cfg_per_function_number, 
  cfg_per_function_output_request, cfg_per_function_update_done, cfg_subsys_vend_id, 
  cfg_dsn, cfg_power_state_change_ack, cfg_power_state_change_interrupt, cfg_err_cor_in, 
  cfg_err_uncor_in, cfg_flr_in_process, cfg_flr_done, cfg_vf_flr_in_process, 
  cfg_vf_flr_done, cfg_link_training_enable, cfg_interrupt_int, cfg_interrupt_pending, 
  cfg_interrupt_sent, cfg_interrupt_msi_enable, cfg_interrupt_msi_vf_enable, 
  cfg_interrupt_msi_mmenable, cfg_interrupt_msi_mask_update, cfg_interrupt_msi_data, 
  cfg_interrupt_msi_select, cfg_interrupt_msi_int, cfg_interrupt_msi_pending_status, 
  cfg_interrupt_msi_sent, cfg_interrupt_msi_fail, cfg_interrupt_msix_enable, 
  cfg_interrupt_msix_mask, cfg_interrupt_msix_vf_enable, cfg_interrupt_msix_vf_mask, 
  cfg_interrupt_msix_data, cfg_interrupt_msix_address, cfg_interrupt_msix_int, 
  cfg_interrupt_msix_sent, cfg_interrupt_msix_fail, cfg_interrupt_msi_attr, 
  cfg_interrupt_msi_tph_present, cfg_interrupt_msi_tph_type, 
  cfg_interrupt_msi_tph_st_tag, cfg_interrupt_msi_function_number, cfg_hot_reset_out, 
  cfg_config_space_enable, cfg_req_pm_transition_l23_ready, cfg_hot_reset_in, 
  cfg_ds_port_number, cfg_ds_bus_number, cfg_ds_device_number, cfg_ds_function_number, 
  sys_clk, sys_reset)
/* synthesis syn_black_box black_box_pad_pin="pci_exp_txn[3:0],pci_exp_txp[3:0],pci_exp_rxn[3:0],pci_exp_rxp[3:0],mmcm_lock,user_clk,user_reset,user_lnk_up,user_app_rdy,s_axis_rq_tlast,s_axis_rq_tdata[127:0],s_axis_rq_tuser[59:0],s_axis_rq_tkeep[3:0],s_axis_rq_tready[3:0],s_axis_rq_tvalid,m_axis_rc_tdata[127:0],m_axis_rc_tuser[74:0],m_axis_rc_tlast,m_axis_rc_tkeep[3:0],m_axis_rc_tvalid,m_axis_rc_tready,m_axis_cq_tdata[127:0],m_axis_cq_tuser[84:0],m_axis_cq_tlast,m_axis_cq_tkeep[3:0],m_axis_cq_tvalid,m_axis_cq_tready,s_axis_cc_tdata[127:0],s_axis_cc_tuser[32:0],s_axis_cc_tlast,s_axis_cc_tkeep[3:0],s_axis_cc_tvalid,s_axis_cc_tready[3:0],pcie_rq_seq_num[3:0],pcie_rq_seq_num_vld,pcie_rq_tag[5:0],pcie_rq_tag_vld,pcie_tfc_nph_av[1:0],pcie_tfc_npd_av[1:0],pcie_cq_np_req,pcie_cq_np_req_count[5:0],cfg_phy_link_down,cfg_phy_link_status[1:0],cfg_negotiated_width[3:0],cfg_current_speed[2:0],cfg_max_payload[2:0],cfg_max_read_req[2:0],cfg_function_status[7:0],cfg_function_power_state[5:0],cfg_vf_status[11:0],cfg_vf_power_state[17:0],cfg_link_power_state[1:0],cfg_mgmt_addr[18:0],cfg_mgmt_write,cfg_mgmt_write_data[31:0],cfg_mgmt_byte_enable[3:0],cfg_mgmt_read,cfg_mgmt_read_data[31:0],cfg_mgmt_read_write_done,cfg_mgmt_type1_cfg_reg_access,cfg_err_cor_out,cfg_err_nonfatal_out,cfg_err_fatal_out,cfg_ltr_enable,cfg_ltssm_state[5:0],cfg_rcb_status[1:0],cfg_dpa_substate_change[1:0],cfg_obff_enable[1:0],cfg_pl_status_change,cfg_tph_requester_enable[1:0],cfg_tph_st_mode[5:0],cfg_vf_tph_requester_enable[5:0],cfg_vf_tph_st_mode[17:0],cfg_msg_received,cfg_msg_received_data[7:0],cfg_msg_received_type[4:0],cfg_msg_transmit,cfg_msg_transmit_type[2:0],cfg_msg_transmit_data[31:0],cfg_msg_transmit_done,cfg_fc_ph[7:0],cfg_fc_pd[11:0],cfg_fc_nph[7:0],cfg_fc_npd[11:0],cfg_fc_cplh[7:0],cfg_fc_cpld[11:0],cfg_fc_sel[2:0],cfg_per_func_status_control[2:0],cfg_per_func_status_data[15:0],cfg_per_function_number[2:0],cfg_per_function_output_request,cfg_per_function_update_done,cfg_subsys_vend_id[15:0],cfg_dsn[63:0],cfg_power_state_change_ack,cfg_power_state_change_interrupt,cfg_err_cor_in,cfg_err_uncor_in,cfg_flr_in_process[1:0],cfg_flr_done[1:0],cfg_vf_flr_in_process[5:0],cfg_vf_flr_done[5:0],cfg_link_training_enable,cfg_interrupt_int[3:0],cfg_interrupt_pending[1:0],cfg_interrupt_sent,cfg_interrupt_msi_enable[1:0],cfg_interrupt_msi_vf_enable[5:0],cfg_interrupt_msi_mmenable[5:0],cfg_interrupt_msi_mask_update,cfg_interrupt_msi_data[31:0],cfg_interrupt_msi_select[3:0],cfg_interrupt_msi_int[31:0],cfg_interrupt_msi_pending_status[63:0],cfg_interrupt_msi_sent,cfg_interrupt_msi_fail,cfg_interrupt_msix_enable[1:0],cfg_interrupt_msix_mask[1:0],cfg_interrupt_msix_vf_enable[5:0],cfg_interrupt_msix_vf_mask[5:0],cfg_interrupt_msix_data[31:0],cfg_interrupt_msix_address[63:0],cfg_interrupt_msix_int,cfg_interrupt_msix_sent,cfg_interrupt_msix_fail,cfg_interrupt_msi_attr[2:0],cfg_interrupt_msi_tph_present,cfg_interrupt_msi_tph_type[1:0],cfg_interrupt_msi_tph_st_tag[8:0],cfg_interrupt_msi_function_number[2:0],cfg_hot_reset_out,cfg_config_space_enable,cfg_req_pm_transition_l23_ready,cfg_hot_reset_in,cfg_ds_port_number[7:0],cfg_ds_bus_number[7:0],cfg_ds_device_number[4:0],cfg_ds_function_number[2:0],sys_clk,sys_reset" */;
  output [3:0]pci_exp_txn;
  output [3:0]pci_exp_txp;
  input [3:0]pci_exp_rxn;
  input [3:0]pci_exp_rxp;
  output mmcm_lock;
  output user_clk;
  output user_reset;
  output user_lnk_up;
  output user_app_rdy;
  input s_axis_rq_tlast;
  input [127:0]s_axis_rq_tdata;
  input [59:0]s_axis_rq_tuser;
  input [3:0]s_axis_rq_tkeep;
  output [3:0]s_axis_rq_tready;
  input s_axis_rq_tvalid;
  output [127:0]m_axis_rc_tdata;
  output [74:0]m_axis_rc_tuser;
  output m_axis_rc_tlast;
  output [3:0]m_axis_rc_tkeep;
  output m_axis_rc_tvalid;
  input m_axis_rc_tready;
  output [127:0]m_axis_cq_tdata;
  output [84:0]m_axis_cq_tuser;
  output m_axis_cq_tlast;
  output [3:0]m_axis_cq_tkeep;
  output m_axis_cq_tvalid;
  input m_axis_cq_tready;
  input [127:0]s_axis_cc_tdata;
  input [32:0]s_axis_cc_tuser;
  input s_axis_cc_tlast;
  input [3:0]s_axis_cc_tkeep;
  input s_axis_cc_tvalid;
  output [3:0]s_axis_cc_tready;
  output [3:0]pcie_rq_seq_num;
  output pcie_rq_seq_num_vld;
  output [5:0]pcie_rq_tag;
  output pcie_rq_tag_vld;
  output [1:0]pcie_tfc_nph_av;
  output [1:0]pcie_tfc_npd_av;
  input pcie_cq_np_req;
  output [5:0]pcie_cq_np_req_count;
  output cfg_phy_link_down;
  output [1:0]cfg_phy_link_status;
  output [3:0]cfg_negotiated_width;
  output [2:0]cfg_current_speed;
  output [2:0]cfg_max_payload;
  output [2:0]cfg_max_read_req;
  output [7:0]cfg_function_status;
  output [5:0]cfg_function_power_state;
  output [11:0]cfg_vf_status;
  output [17:0]cfg_vf_power_state;
  output [1:0]cfg_link_power_state;
  input [18:0]cfg_mgmt_addr;
  input cfg_mgmt_write;
  input [31:0]cfg_mgmt_write_data;
  input [3:0]cfg_mgmt_byte_enable;
  input cfg_mgmt_read;
  output [31:0]cfg_mgmt_read_data;
  output cfg_mgmt_read_write_done;
  input cfg_mgmt_type1_cfg_reg_access;
  output cfg_err_cor_out;
  output cfg_err_nonfatal_out;
  output cfg_err_fatal_out;
  output cfg_ltr_enable;
  output [5:0]cfg_ltssm_state;
  output [1:0]cfg_rcb_status;
  output [1:0]cfg_dpa_substate_change;
  output [1:0]cfg_obff_enable;
  output cfg_pl_status_change;
  output [1:0]cfg_tph_requester_enable;
  output [5:0]cfg_tph_st_mode;
  output [5:0]cfg_vf_tph_requester_enable;
  output [17:0]cfg_vf_tph_st_mode;
  output cfg_msg_received;
  output [7:0]cfg_msg_received_data;
  output [4:0]cfg_msg_received_type;
  input cfg_msg_transmit;
  input [2:0]cfg_msg_transmit_type;
  input [31:0]cfg_msg_transmit_data;
  output cfg_msg_transmit_done;
  output [7:0]cfg_fc_ph;
  output [11:0]cfg_fc_pd;
  output [7:0]cfg_fc_nph;
  output [11:0]cfg_fc_npd;
  output [7:0]cfg_fc_cplh;
  output [11:0]cfg_fc_cpld;
  input [2:0]cfg_fc_sel;
  input [2:0]cfg_per_func_status_control;
  output [15:0]cfg_per_func_status_data;
  input [2:0]cfg_per_function_number;
  input cfg_per_function_output_request;
  output cfg_per_function_update_done;
  input [15:0]cfg_subsys_vend_id;
  input [63:0]cfg_dsn;
  input cfg_power_state_change_ack;
  output cfg_power_state_change_interrupt;
  input cfg_err_cor_in;
  input cfg_err_uncor_in;
  output [1:0]cfg_flr_in_process;
  input [1:0]cfg_flr_done;
  output [5:0]cfg_vf_flr_in_process;
  input [5:0]cfg_vf_flr_done;
  input cfg_link_training_enable;
  input [3:0]cfg_interrupt_int;
  input [1:0]cfg_interrupt_pending;
  output cfg_interrupt_sent;
  output [1:0]cfg_interrupt_msi_enable;
  output [5:0]cfg_interrupt_msi_vf_enable;
  output [5:0]cfg_interrupt_msi_mmenable;
  output cfg_interrupt_msi_mask_update;
  output [31:0]cfg_interrupt_msi_data;
  input [3:0]cfg_interrupt_msi_select;
  input [31:0]cfg_interrupt_msi_int;
  input [63:0]cfg_interrupt_msi_pending_status;
  output cfg_interrupt_msi_sent;
  output cfg_interrupt_msi_fail;
  output [1:0]cfg_interrupt_msix_enable;
  output [1:0]cfg_interrupt_msix_mask;
  output [5:0]cfg_interrupt_msix_vf_enable;
  output [5:0]cfg_interrupt_msix_vf_mask;
  input [31:0]cfg_interrupt_msix_data;
  input [63:0]cfg_interrupt_msix_address;
  input cfg_interrupt_msix_int;
  output cfg_interrupt_msix_sent;
  output cfg_interrupt_msix_fail;
  input [2:0]cfg_interrupt_msi_attr;
  input cfg_interrupt_msi_tph_present;
  input [1:0]cfg_interrupt_msi_tph_type;
  input [8:0]cfg_interrupt_msi_tph_st_tag;
  input [2:0]cfg_interrupt_msi_function_number;
  output cfg_hot_reset_out;
  input cfg_config_space_enable;
  input cfg_req_pm_transition_l23_ready;
  input cfg_hot_reset_in;
  input [7:0]cfg_ds_port_number;
  input [7:0]cfg_ds_bus_number;
  input [4:0]cfg_ds_device_number;
  input [2:0]cfg_ds_function_number;
  input sys_clk;
  input sys_reset;
endmodule
