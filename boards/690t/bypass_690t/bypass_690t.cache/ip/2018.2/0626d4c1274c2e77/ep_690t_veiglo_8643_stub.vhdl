-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.2 (lin64) Build 2258646 Thu Jun 14 20:02:38 MDT 2018
-- Date        : Mon May 29 15:09:01 2023
-- Host        : 192.168.2.204 running 64-bit unknown
-- Command     : write_vhdl -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
--               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ ep_690t_veiglo_8643_stub.vhdl
-- Design      : ep_690t_veiglo_8643
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7vx690tffg1761-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  Port ( 
    pci_exp_txn : out STD_LOGIC_VECTOR ( 3 downto 0 );
    pci_exp_txp : out STD_LOGIC_VECTOR ( 3 downto 0 );
    pci_exp_rxn : in STD_LOGIC_VECTOR ( 3 downto 0 );
    pci_exp_rxp : in STD_LOGIC_VECTOR ( 3 downto 0 );
    mmcm_lock : out STD_LOGIC;
    user_clk : out STD_LOGIC;
    user_reset : out STD_LOGIC;
    user_lnk_up : out STD_LOGIC;
    user_app_rdy : out STD_LOGIC;
    s_axis_rq_tlast : in STD_LOGIC;
    s_axis_rq_tdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    s_axis_rq_tuser : in STD_LOGIC_VECTOR ( 59 downto 0 );
    s_axis_rq_tkeep : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axis_rq_tready : out STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axis_rq_tvalid : in STD_LOGIC;
    m_axis_rc_tdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    m_axis_rc_tuser : out STD_LOGIC_VECTOR ( 74 downto 0 );
    m_axis_rc_tlast : out STD_LOGIC;
    m_axis_rc_tkeep : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axis_rc_tvalid : out STD_LOGIC;
    m_axis_rc_tready : in STD_LOGIC;
    m_axis_cq_tdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    m_axis_cq_tuser : out STD_LOGIC_VECTOR ( 84 downto 0 );
    m_axis_cq_tlast : out STD_LOGIC;
    m_axis_cq_tkeep : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axis_cq_tvalid : out STD_LOGIC;
    m_axis_cq_tready : in STD_LOGIC;
    s_axis_cc_tdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    s_axis_cc_tuser : in STD_LOGIC_VECTOR ( 32 downto 0 );
    s_axis_cc_tlast : in STD_LOGIC;
    s_axis_cc_tkeep : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axis_cc_tvalid : in STD_LOGIC;
    s_axis_cc_tready : out STD_LOGIC_VECTOR ( 3 downto 0 );
    pcie_rq_seq_num : out STD_LOGIC_VECTOR ( 3 downto 0 );
    pcie_rq_seq_num_vld : out STD_LOGIC;
    pcie_rq_tag : out STD_LOGIC_VECTOR ( 5 downto 0 );
    pcie_rq_tag_vld : out STD_LOGIC;
    pcie_tfc_nph_av : out STD_LOGIC_VECTOR ( 1 downto 0 );
    pcie_tfc_npd_av : out STD_LOGIC_VECTOR ( 1 downto 0 );
    pcie_cq_np_req : in STD_LOGIC;
    pcie_cq_np_req_count : out STD_LOGIC_VECTOR ( 5 downto 0 );
    cfg_phy_link_down : out STD_LOGIC;
    cfg_phy_link_status : out STD_LOGIC_VECTOR ( 1 downto 0 );
    cfg_negotiated_width : out STD_LOGIC_VECTOR ( 3 downto 0 );
    cfg_current_speed : out STD_LOGIC_VECTOR ( 2 downto 0 );
    cfg_max_payload : out STD_LOGIC_VECTOR ( 2 downto 0 );
    cfg_max_read_req : out STD_LOGIC_VECTOR ( 2 downto 0 );
    cfg_function_status : out STD_LOGIC_VECTOR ( 7 downto 0 );
    cfg_function_power_state : out STD_LOGIC_VECTOR ( 5 downto 0 );
    cfg_vf_status : out STD_LOGIC_VECTOR ( 11 downto 0 );
    cfg_vf_power_state : out STD_LOGIC_VECTOR ( 17 downto 0 );
    cfg_link_power_state : out STD_LOGIC_VECTOR ( 1 downto 0 );
    cfg_mgmt_addr : in STD_LOGIC_VECTOR ( 18 downto 0 );
    cfg_mgmt_write : in STD_LOGIC;
    cfg_mgmt_write_data : in STD_LOGIC_VECTOR ( 31 downto 0 );
    cfg_mgmt_byte_enable : in STD_LOGIC_VECTOR ( 3 downto 0 );
    cfg_mgmt_read : in STD_LOGIC;
    cfg_mgmt_read_data : out STD_LOGIC_VECTOR ( 31 downto 0 );
    cfg_mgmt_read_write_done : out STD_LOGIC;
    cfg_mgmt_type1_cfg_reg_access : in STD_LOGIC;
    cfg_err_cor_out : out STD_LOGIC;
    cfg_err_nonfatal_out : out STD_LOGIC;
    cfg_err_fatal_out : out STD_LOGIC;
    cfg_ltr_enable : out STD_LOGIC;
    cfg_ltssm_state : out STD_LOGIC_VECTOR ( 5 downto 0 );
    cfg_rcb_status : out STD_LOGIC_VECTOR ( 1 downto 0 );
    cfg_dpa_substate_change : out STD_LOGIC_VECTOR ( 1 downto 0 );
    cfg_obff_enable : out STD_LOGIC_VECTOR ( 1 downto 0 );
    cfg_pl_status_change : out STD_LOGIC;
    cfg_tph_requester_enable : out STD_LOGIC_VECTOR ( 1 downto 0 );
    cfg_tph_st_mode : out STD_LOGIC_VECTOR ( 5 downto 0 );
    cfg_vf_tph_requester_enable : out STD_LOGIC_VECTOR ( 5 downto 0 );
    cfg_vf_tph_st_mode : out STD_LOGIC_VECTOR ( 17 downto 0 );
    cfg_msg_received : out STD_LOGIC;
    cfg_msg_received_data : out STD_LOGIC_VECTOR ( 7 downto 0 );
    cfg_msg_received_type : out STD_LOGIC_VECTOR ( 4 downto 0 );
    cfg_msg_transmit : in STD_LOGIC;
    cfg_msg_transmit_type : in STD_LOGIC_VECTOR ( 2 downto 0 );
    cfg_msg_transmit_data : in STD_LOGIC_VECTOR ( 31 downto 0 );
    cfg_msg_transmit_done : out STD_LOGIC;
    cfg_fc_ph : out STD_LOGIC_VECTOR ( 7 downto 0 );
    cfg_fc_pd : out STD_LOGIC_VECTOR ( 11 downto 0 );
    cfg_fc_nph : out STD_LOGIC_VECTOR ( 7 downto 0 );
    cfg_fc_npd : out STD_LOGIC_VECTOR ( 11 downto 0 );
    cfg_fc_cplh : out STD_LOGIC_VECTOR ( 7 downto 0 );
    cfg_fc_cpld : out STD_LOGIC_VECTOR ( 11 downto 0 );
    cfg_fc_sel : in STD_LOGIC_VECTOR ( 2 downto 0 );
    cfg_per_func_status_control : in STD_LOGIC_VECTOR ( 2 downto 0 );
    cfg_per_func_status_data : out STD_LOGIC_VECTOR ( 15 downto 0 );
    cfg_per_function_number : in STD_LOGIC_VECTOR ( 2 downto 0 );
    cfg_per_function_output_request : in STD_LOGIC;
    cfg_per_function_update_done : out STD_LOGIC;
    cfg_subsys_vend_id : in STD_LOGIC_VECTOR ( 15 downto 0 );
    cfg_dsn : in STD_LOGIC_VECTOR ( 63 downto 0 );
    cfg_power_state_change_ack : in STD_LOGIC;
    cfg_power_state_change_interrupt : out STD_LOGIC;
    cfg_err_cor_in : in STD_LOGIC;
    cfg_err_uncor_in : in STD_LOGIC;
    cfg_flr_in_process : out STD_LOGIC_VECTOR ( 1 downto 0 );
    cfg_flr_done : in STD_LOGIC_VECTOR ( 1 downto 0 );
    cfg_vf_flr_in_process : out STD_LOGIC_VECTOR ( 5 downto 0 );
    cfg_vf_flr_done : in STD_LOGIC_VECTOR ( 5 downto 0 );
    cfg_link_training_enable : in STD_LOGIC;
    cfg_interrupt_int : in STD_LOGIC_VECTOR ( 3 downto 0 );
    cfg_interrupt_pending : in STD_LOGIC_VECTOR ( 1 downto 0 );
    cfg_interrupt_sent : out STD_LOGIC;
    cfg_interrupt_msix_enable : out STD_LOGIC_VECTOR ( 1 downto 0 );
    cfg_interrupt_msix_mask : out STD_LOGIC_VECTOR ( 1 downto 0 );
    cfg_interrupt_msix_vf_enable : out STD_LOGIC_VECTOR ( 5 downto 0 );
    cfg_interrupt_msix_vf_mask : out STD_LOGIC_VECTOR ( 5 downto 0 );
    cfg_interrupt_msix_data : in STD_LOGIC_VECTOR ( 31 downto 0 );
    cfg_interrupt_msix_address : in STD_LOGIC_VECTOR ( 63 downto 0 );
    cfg_interrupt_msix_int : in STD_LOGIC;
    cfg_interrupt_msix_sent : out STD_LOGIC;
    cfg_interrupt_msix_fail : out STD_LOGIC;
    cfg_interrupt_msi_function_number : in STD_LOGIC_VECTOR ( 2 downto 0 );
    cfg_hot_reset_out : out STD_LOGIC;
    cfg_config_space_enable : in STD_LOGIC;
    cfg_req_pm_transition_l23_ready : in STD_LOGIC;
    cfg_hot_reset_in : in STD_LOGIC;
    cfg_ds_port_number : in STD_LOGIC_VECTOR ( 7 downto 0 );
    cfg_ds_bus_number : in STD_LOGIC_VECTOR ( 7 downto 0 );
    cfg_ds_device_number : in STD_LOGIC_VECTOR ( 4 downto 0 );
    cfg_ds_function_number : in STD_LOGIC_VECTOR ( 2 downto 0 );
    sys_clk : in STD_LOGIC;
    sys_reset : in STD_LOGIC
  );

end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture stub of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "pci_exp_txn[3:0],pci_exp_txp[3:0],pci_exp_rxn[3:0],pci_exp_rxp[3:0],mmcm_lock,user_clk,user_reset,user_lnk_up,user_app_rdy,s_axis_rq_tlast,s_axis_rq_tdata[127:0],s_axis_rq_tuser[59:0],s_axis_rq_tkeep[3:0],s_axis_rq_tready[3:0],s_axis_rq_tvalid,m_axis_rc_tdata[127:0],m_axis_rc_tuser[74:0],m_axis_rc_tlast,m_axis_rc_tkeep[3:0],m_axis_rc_tvalid,m_axis_rc_tready,m_axis_cq_tdata[127:0],m_axis_cq_tuser[84:0],m_axis_cq_tlast,m_axis_cq_tkeep[3:0],m_axis_cq_tvalid,m_axis_cq_tready,s_axis_cc_tdata[127:0],s_axis_cc_tuser[32:0],s_axis_cc_tlast,s_axis_cc_tkeep[3:0],s_axis_cc_tvalid,s_axis_cc_tready[3:0],pcie_rq_seq_num[3:0],pcie_rq_seq_num_vld,pcie_rq_tag[5:0],pcie_rq_tag_vld,pcie_tfc_nph_av[1:0],pcie_tfc_npd_av[1:0],pcie_cq_np_req,pcie_cq_np_req_count[5:0],cfg_phy_link_down,cfg_phy_link_status[1:0],cfg_negotiated_width[3:0],cfg_current_speed[2:0],cfg_max_payload[2:0],cfg_max_read_req[2:0],cfg_function_status[7:0],cfg_function_power_state[5:0],cfg_vf_status[11:0],cfg_vf_power_state[17:0],cfg_link_power_state[1:0],cfg_mgmt_addr[18:0],cfg_mgmt_write,cfg_mgmt_write_data[31:0],cfg_mgmt_byte_enable[3:0],cfg_mgmt_read,cfg_mgmt_read_data[31:0],cfg_mgmt_read_write_done,cfg_mgmt_type1_cfg_reg_access,cfg_err_cor_out,cfg_err_nonfatal_out,cfg_err_fatal_out,cfg_ltr_enable,cfg_ltssm_state[5:0],cfg_rcb_status[1:0],cfg_dpa_substate_change[1:0],cfg_obff_enable[1:0],cfg_pl_status_change,cfg_tph_requester_enable[1:0],cfg_tph_st_mode[5:0],cfg_vf_tph_requester_enable[5:0],cfg_vf_tph_st_mode[17:0],cfg_msg_received,cfg_msg_received_data[7:0],cfg_msg_received_type[4:0],cfg_msg_transmit,cfg_msg_transmit_type[2:0],cfg_msg_transmit_data[31:0],cfg_msg_transmit_done,cfg_fc_ph[7:0],cfg_fc_pd[11:0],cfg_fc_nph[7:0],cfg_fc_npd[11:0],cfg_fc_cplh[7:0],cfg_fc_cpld[11:0],cfg_fc_sel[2:0],cfg_per_func_status_control[2:0],cfg_per_func_status_data[15:0],cfg_per_function_number[2:0],cfg_per_function_output_request,cfg_per_function_update_done,cfg_subsys_vend_id[15:0],cfg_dsn[63:0],cfg_power_state_change_ack,cfg_power_state_change_interrupt,cfg_err_cor_in,cfg_err_uncor_in,cfg_flr_in_process[1:0],cfg_flr_done[1:0],cfg_vf_flr_in_process[5:0],cfg_vf_flr_done[5:0],cfg_link_training_enable,cfg_interrupt_int[3:0],cfg_interrupt_pending[1:0],cfg_interrupt_sent,cfg_interrupt_msix_enable[1:0],cfg_interrupt_msix_mask[1:0],cfg_interrupt_msix_vf_enable[5:0],cfg_interrupt_msix_vf_mask[5:0],cfg_interrupt_msix_data[31:0],cfg_interrupt_msix_address[63:0],cfg_interrupt_msix_int,cfg_interrupt_msix_sent,cfg_interrupt_msix_fail,cfg_interrupt_msi_function_number[2:0],cfg_hot_reset_out,cfg_config_space_enable,cfg_req_pm_transition_l23_ready,cfg_hot_reset_in,cfg_ds_port_number[7:0],cfg_ds_bus_number[7:0],cfg_ds_device_number[4:0],cfg_ds_function_number[2:0],sys_clk,sys_reset";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "ep_690t_veiglo_8643_pcie_3_0_7vx,Vivado 2018.2";
begin
end;
