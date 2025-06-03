//-----------------------------------------------------------------------------
//
// (c) Copyright 2012-2012 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//
//-----------------------------------------------------------------------------
//
// Project    : Virtex-7 FPGA Gen3 Integrated Block for PCI Express
// File       : cgator_wrapper.v
// Version    : 4.2
//
// Description : Wrapper file for Configurator example design. Instantiates
//               Configurator example and 7-Series Root Port Block for PCI
//               Express
//
// Hierarchy   : xilinx_pcie_3_0_rport_7vx
//               |
//               |--cgator_wrapper
//               |  |
//               |  |--pcie_3_0_rport_7vx (in source directory)
//               |  |  |
//               |  |  |--<various>
//               |  |
//               |  |--cgator
//               |     |
//               |     |--cgator_cpl_decoder
//               |     |--cgator_pkt_generator
//               |     |--cgator_tx_mux
//               |     |--cgator_controller
//               |        |--<cgator_cfg_rom.data> (specified by ROM_FILE)
//               |
//               |--pio_master
//                  |
//                  |--pio_master_controller
//                  |--pio_master_checker
//                  |--pio_master_pkt_generator
//
//-----------------------------------------------------------------------------
// Parameters for Configurator
//   TCQ                : clock-to-out delay modeled by all registers in design
//   EXTRA_PIPELINE     : whether to pipeline the received data for timing
//   ROM_FILE           : filename containing configuration steps to perform
//   ROM_SIZE           : number of lines in ROM_FILE containing data (equals
//                        number of TLPs to send / 2)
//   REQUESTER_ID       : value for the Requester ID field in outgoing TLPs
//
//   all other parameters apply directly to Root Port Block for PCI Express
//-----------------------------------------------------------------------------

`timescale 1ns/1ns
(* DowngradeIPIdentifiedWarnings = "yes" *)
module cgator_wrapper
  #(
    // Configurator parameters
     parameter        TCQ                                  = 1,
     parameter        AXISTEN_IF_RQ_ALIGNMENT_MODE   = "TRUE",
     parameter        PIPE_SIM_MODE                             = "FALSE",
     parameter        EXTRA_PIPELINE                       = 1,
     parameter        ROM_FILE                             = "cgator_cfg_rom.data",
     parameter        ROM_SIZE                             = 32,
     parameter [15:0] REQUESTER_ID                         = 16'h10EE,
     parameter [7:0]  BUSNUMBER                            = 8'h01,
   
     parameter       PCIE_EXT_CLK                          = "TRUE",             // Use External Clocking Module
     parameter [2:0] PL_LINK_CAP_MAX_LINK_SPEED            = 3'h4,  // 1- GEN1, 2 - GEN2, 4 - GEN3
     parameter [3:0] PL_LINK_CAP_MAX_LINK_WIDTH            = 4'h8,  // 1- X1, 2 - X2, 4 - X4, 8 - X8
     parameter       PL_DISABLE_EI_INFER_IN_L0             = "TRUE",
     parameter       PL_DISABLE_UPCONFIG_CAPABLE           = "FALSE",
     //  USER_CLK[1/2]_FREQ :[0] = Disable user clock;  [1] =  31.25 MHz;  [2] =  62.50 MHz (default);  [3] = 125.00 MHz;  [4] = 250.00 MHz;  [5] = 500.00 MHz;
     parameter  integer USER_CLK2_FREQ                     = 2,
     parameter       REF_CLK_FREQ                          = 0,           // 0 - 100 MHz, 1 - 125 MHz,  2 - 250 MHz
     parameter       AXISTEN_IF_RQ_PARITY_CHECK            = "FALSE",
     parameter       C_DATA_WIDTH                          = 64,
     parameter       KEEP_WIDTH                            = C_DATA_WIDTH / 32,
       
     // Ultrascale +
     // parameter        AXI4_CQ_TUSER_WIDTH            = 88,
     // parameter        AXI4_CC_TUSER_WIDTH            = 33,
     // parameter        AXI4_RQ_TUSER_WIDTH            = 62,
     // parameter        AXI4_RC_TUSER_WIDTH            = 75,
     
     // V7 690T 
     parameter        AXI4_CQ_TUSER_WIDTH            = 85,
     parameter        AXI4_CC_TUSER_WIDTH            = 33,
     parameter        AXI4_RQ_TUSER_WIDTH            = 60,
     parameter        AXI4_RC_TUSER_WIDTH            = 75,
     parameter         DNA_EN                        =1'b0

  )
  (  input                                       pipe_mmcm_rst_n,
    //-------------------------------------------------------
    // 0. Configurator I/Os
    //-------------------------------------------------------
//  input                                         start_config,
    output                                        finished_config,
    output                                        failed_config,
    //-------------------------------------------------------
    // 1. PCI Express (pci_exp) Interface
    //-------------------------------------------------------
    output  [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]     pci_exp_txp,
    output  [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]     pci_exp_txn,
    input   [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]     pci_exp_rxp,
    input   [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]     pci_exp_rxn,
    //-------------------------------------------------------
    // 2. Transaction (AXIS) Interface
    //-------------------------------------------------------
    output                                        user_clk,
    output                                        user_reset,
    output                                        user_lnk_up,
    //-------------------------------------------------------
    output                                    s_axis_rq_tready,
    input                                     s_axis_rq_tlast,
    input              [C_DATA_WIDTH-1:0]     s_axis_rq_tdata,
    input       [AXI4_RQ_TUSER_WIDTH-1:0]     s_axis_rq_tuser,
    input                [KEEP_WIDTH-1:0]     s_axis_rq_tkeep,
    input                                     s_axis_rq_tvalid,
  
    output               [C_DATA_WIDTH-1:0]   m_axis_rc_tdata,
    output        [AXI4_RC_TUSER_WIDTH-1:0]   m_axis_rc_tuser,
    output                                    m_axis_rc_tlast,
    output                 [KEEP_WIDTH-1:0]   m_axis_rc_tkeep,
    output                                    m_axis_rc_tvalid,
    input                                     m_axis_rc_tready,
  
    output               [C_DATA_WIDTH-1:0]   m_axis_cq_tdata,
    output        [AXI4_CQ_TUSER_WIDTH-1:0]   m_axis_cq_tuser,
    output                                    m_axis_cq_tlast,
    output                 [KEEP_WIDTH-1:0]   m_axis_cq_tkeep,
    output                                    m_axis_cq_tvalid,
    input                                     m_axis_cq_tready,
  
    input              [C_DATA_WIDTH-1:0]     s_axis_cc_tdata,
    input       [AXI4_CC_TUSER_WIDTH-1:0]     s_axis_cc_tuser,
    input                                     s_axis_cc_tlast,
    input                [KEEP_WIDTH-1:0]     s_axis_cc_tkeep,
    input                                     s_axis_cc_tvalid,
    output                                    s_axis_cc_tready,
    //-------------------------------------------------------
    // 3. Configuration (CFG) Interface  -  EP and RP
    //-------------------------------------------------------
    output                                      cfg_phy_link_down,
    output                            [1:0]     cfg_phy_link_status,
    output                            [3:0]     cfg_negotiated_width,
    output                            [2:0]     cfg_current_speed,
    output                            [2:0]     cfg_max_payload,
    output                            [2:0]     cfg_max_read_req,
    output                            [7:0]     cfg_function_status,
    output                            [5:0]     cfg_function_power_state,
    output                           [11:0]     cfg_vf_status,
    output                           [17:0]     cfg_vf_power_state,
    output                            [1:0]     cfg_link_power_state,
    //-------------------------------------------------------
    // Error Reporting Interface
    //-------------------------------------------------------
    output                                      cfg_err_cor_out,
    output                                      cfg_err_nonfatal_out,
    output                                      cfg_err_fatal_out,
    output                                      cfg_ltr_enable,
    output                            [5:0]     cfg_ltssm_state,
    output                            [1:0]     cfg_rcb_status,
    output                            [1:0]     cfg_dpa_substate_change,
    output                            [1:0]     cfg_obff_enable,
    output                                      cfg_pl_status_change,
    output                            [1:0]     cfg_tph_requester_enable,
    output                            [5:0]     cfg_tph_st_mode,
    output                            [5:0]     cfg_vf_tph_requester_enable,
    output                           [17:0]     cfg_vf_tph_st_mode,
    //-------------------------------------------------------
    // Management Interface
    //-------------------------------------------------------
    input                            [18:0]     cfg_mgmt_addr,
    input                                       cfg_mgmt_write,
    input                            [31:0]     cfg_mgmt_write_data,
    input                             [3:0]     cfg_mgmt_byte_enable,
    input                                       cfg_mgmt_read,
    output                           [31:0]     cfg_mgmt_read_data,
    output                                      cfg_mgmt_read_write_done,
    input                                       cfg_mgmt_type1_cfg_reg_access,
    output                                      cfg_msg_received,
    output                            [7:0]     cfg_msg_received_data,
    output                            [4:0]     cfg_msg_received_type,
    input                                       cfg_msg_transmit,
    input                             [2:0]     cfg_msg_transmit_type,
    input                            [31:0]     cfg_msg_transmit_data,
    output                                      cfg_msg_transmit_done,
    output                            [7:0]     cfg_fc_ph,
    output                           [11:0]     cfg_fc_pd,
    output                            [7:0]     cfg_fc_nph,
    output                           [11:0]     cfg_fc_npd,
    output                            [7:0]     cfg_fc_cplh,
    output                           [11:0]     cfg_fc_cpld,
    input                             [2:0]     cfg_fc_sel,
    input                             [2:0]     cfg_per_func_status_control,
    output                           [15:0]     cfg_per_func_status_data,
    input                            [15:0]     cfg_subsys_vend_id,
    output                                      cfg_hot_reset_out,
    input                                       cfg_config_space_enable,
    input                                       cfg_req_pm_transition_l23_ready,
    input                                       cfg_hot_reset_in,
    input                             [7:0]     cfg_ds_port_number,
    input                             [7:0]     cfg_ds_bus_number,
    input                             [4:0]     cfg_ds_device_number,
    input                             [2:0]     cfg_ds_function_number,
    input                             [2:0]     cfg_per_function_number,
    input                                       cfg_per_function_output_request,
    output                                      cfg_per_function_update_done,
    input                            [63:0]     cfg_dsn,
    input                                       cfg_power_state_change_ack,
    output                                      cfg_power_state_change_interrupt,
    input                                       cfg_err_cor_in,
    input                                       cfg_err_uncor_in,
    output                            [1:0]     cfg_flr_in_process,
    input                             [1:0]     cfg_flr_done,
    output                            [5:0]     cfg_vf_flr_in_process,
    input                             [5:0]     cfg_vf_flr_done,
    input                                       cfg_link_training_enable,
    //-------------------------------------------------------
    // Interrupt Interface Signals
    //-------------------------------------------------------
    input                             [3:0]     cfg_interrupt_int,
    input                             [1:0]     cfg_interrupt_pending,
    output                                      cfg_interrupt_sent,
    output                            [1:0]     cfg_interrupt_msi_enable,
    output                            [5:0]     cfg_interrupt_msi_vf_enable,
    output                            [5:0]     cfg_interrupt_msi_mmenable,
    output                                      cfg_interrupt_msi_mask_update,
    output                           [31:0]     cfg_interrupt_msi_data,
    input                             [3:0]     cfg_interrupt_msi_select,
    input                            [31:0]     cfg_interrupt_msi_int,
    input                            [63:0]     cfg_interrupt_msi_pending_status,
    output                                      cfg_interrupt_msi_sent,
    output                                      cfg_interrupt_msi_fail,
    input                             [2:0]     cfg_interrupt_msi_attr,
    input                                       cfg_interrupt_msi_tph_present,
    input                             [1:0]     cfg_interrupt_msi_tph_type,
    input                             [8:0]     cfg_interrupt_msi_tph_st_tag,
    input                             [2:0]     cfg_interrupt_msi_function_number,
  //-------------------------------------------------------
  input                 sys_clk,
  input                 sys_reset_n,
  input                 dna_ok_flag
  //-------------------------------------------------------
);

  reg dna_ok_flag_1,dna_ok_flag_2;

  wire                        mmcm_lock;
  wire                        user_app_rdy;
  //--------------------------------------------------------------------------------------------------------------------//
  // Connections between Root Port and Configurator
  //--------------------------------------------------------------------------------------------------------------------//

  wire [3:0]                  rport_s_axis_rq_tready;
  wire [C_DATA_WIDTH-1:0]     rport_s_axis_rq_tdata;
  wire [KEEP_WIDTH-1:0]       rport_s_axis_rq_tkeep;
  wire [59:0]                 rport_s_axis_rq_tuser;
  wire                        rport_s_axis_rq_tlast;
  wire                        rport_s_axis_rq_tvalid;

  wire [C_DATA_WIDTH-1:0]     rport_m_axis_rc_tdata;
  wire [KEEP_WIDTH-1:0]       rport_m_axis_rc_tkeep;
  wire                        rport_m_axis_rc_tlast;
  wire                        rport_m_axis_rc_tvalid;
  wire                        rport_m_axis_rc_tready;
  wire [74:0]                 rport_m_axis_rc_tuser;
  
  wire                   [C_DATA_WIDTH-1:0]     m_axis_cq_tdata;
  wire            [AXI4_CQ_TUSER_WIDTH-1:0]     m_axis_cq_tuser;
  wire                                          m_axis_cq_tlast;
  wire                     [KEEP_WIDTH-1:0]     m_axis_cq_tkeep;
  wire                                          m_axis_cq_tvalid;
  wire                                          m_axis_cq_tready;

  wire                    [C_DATA_WIDTH-1:0]    s_axis_cc_tdata;
  wire             [AXI4_CC_TUSER_WIDTH-1:0]    s_axis_cc_tuser;
  wire                                          s_axis_cc_tlast;
  wire                      [KEEP_WIDTH-1:0]    s_axis_cc_tkeep;
  wire                                          s_axis_cc_tvalid;
  wire                                          s_axis_cc_tready;


 
         reg        start_config;
      
  //--------------------------------------------------------------------------------------------------------------------//
  // Instantiate Root Port wrapper
  //--------------------------------------------------------------------------------------------------------------------//
  rp_690t  rp_690t_i (
     
    //---------------------------------------------------------------------------------------//
    //  PCI Express (pci_exp) Interface                                                      //
    //---------------------------------------------------------------------------------------//

    // Tx
    .pci_exp_txn                                    ( pci_exp_txn ),
    .pci_exp_txp                                    ( pci_exp_txp ),

    // Rx
    .pci_exp_rxn                                    ( pci_exp_rxn ),
    .pci_exp_rxp                                    ( pci_exp_rxp ),
    //---------------------------------------------------------------------------------------//
    //  AXI Interface                                                                        //
    //---------------------------------------------------------------------------------------//

    .mmcm_lock                                      ( mmcm_lock ),
    .user_clk                                       ( user_clk ),
    .user_reset                                     ( user_reset ),
    .user_lnk_up                                    ( user_lnk_up ),
    .user_app_rdy                                   ( user_app_rdy ),

    .s_axis_rq_tlast                                ( rport_s_axis_rq_tlast ),
    .s_axis_rq_tdata                                ( rport_s_axis_rq_tdata ),
    .s_axis_rq_tuser                                ( rport_s_axis_rq_tuser ),
    .s_axis_rq_tkeep                                ( rport_s_axis_rq_tkeep ),
    .s_axis_rq_tready                               ( rport_s_axis_rq_tready ),
    .s_axis_rq_tvalid                               ( rport_s_axis_rq_tvalid ),

    .m_axis_rc_tdata                                ( rport_m_axis_rc_tdata ),
    .m_axis_rc_tuser                                ( rport_m_axis_rc_tuser ),
    .m_axis_rc_tlast                                ( rport_m_axis_rc_tlast ),
    .m_axis_rc_tkeep                                ( rport_m_axis_rc_tkeep ),
    .m_axis_rc_tvalid                               ( rport_m_axis_rc_tvalid ),
    .m_axis_rc_tready                               ( rport_m_axis_rc_tready ),

    .m_axis_cq_tdata                                ( m_axis_cq_tdata ),
    .m_axis_cq_tuser                                ( m_axis_cq_tuser ),
    .m_axis_cq_tlast                                ( m_axis_cq_tlast ),
    .m_axis_cq_tkeep                                ( m_axis_cq_tkeep ),
    .m_axis_cq_tvalid                               ( m_axis_cq_tvalid ),
    .m_axis_cq_tready                               ( m_axis_cq_tready ),

    .s_axis_cc_tdata                                ( s_axis_cc_tdata ),
    .s_axis_cc_tuser                                ( s_axis_cc_tuser ),
    .s_axis_cc_tlast                                ( s_axis_cc_tlast ),
    .s_axis_cc_tkeep                                ( s_axis_cc_tkeep ),
    .s_axis_cc_tvalid                               ( s_axis_cc_tvalid ),
    .s_axis_cc_tready                               ( s_axis_cc_tready ),

    .pcie_tfc_nph_av                                ( ),
    .pcie_tfc_npd_av                                ( ),

    //---------------------------------------------------------------------------------------//
    //  Configuration (CFG) Interface                                                        //
    //---------------------------------------------------------------------------------------//
    .pcie_rq_seq_num                                ( ),
    .pcie_rq_seq_num_vld                            ( ),
    .pcie_rq_tag                                    ( ),
    .pcie_rq_tag_vld                                ( ),

    .pcie_cq_np_req                                 ( 1'b1),
    .pcie_cq_np_req_count                           ( ),

    .cfg_phy_link_down                              ( cfg_phy_link_down ),
    .cfg_phy_link_status                            ( cfg_phy_link_status ),
    .cfg_negotiated_width                           ( cfg_negotiated_width ),
    .cfg_current_speed                              ( cfg_current_speed ),
    .cfg_max_payload                                ( cfg_max_payload ),
    .cfg_max_read_req                               ( cfg_max_read_req ),
    .cfg_function_status                            ( cfg_function_status ),
    .cfg_function_power_state                       ( cfg_function_power_state ),
    .cfg_vf_status                                  ( cfg_vf_status ),
    .cfg_vf_power_state                             ( cfg_vf_power_state ),
    .cfg_link_power_state                           ( cfg_link_power_state ),

    // Error Reporting Interface
    .cfg_err_cor_out                                ( cfg_err_cor_out ),
    .cfg_err_nonfatal_out                           ( cfg_err_nonfatal_out ),
    .cfg_err_fatal_out                              ( cfg_err_fatal_out ),

    .cfg_ltr_enable                                 ( cfg_ltr_enable ),
    .cfg_ltssm_state                                ( cfg_ltssm_state ),
    .cfg_rcb_status                                 ( cfg_rcb_status ),
    .cfg_dpa_substate_change                        ( cfg_dpa_substate_change ),
    .cfg_obff_enable                                ( cfg_obff_enable ),
    .cfg_pl_status_change                           ( cfg_pl_status_change ),

    .cfg_tph_requester_enable                       ( cfg_tph_requester_enable ),
    .cfg_tph_st_mode                                ( cfg_tph_st_mode ),
    .cfg_vf_tph_requester_enable                    ( cfg_vf_tph_requester_enable ),
    .cfg_vf_tph_st_mode                             ( cfg_vf_tph_st_mode ),
    // Management Interface
    .cfg_mgmt_addr                                  ( cfg_mgmt_addr ),
    .cfg_mgmt_write                                 ( cfg_mgmt_write ),
    .cfg_mgmt_write_data                            ( cfg_mgmt_write_data ),
    .cfg_mgmt_byte_enable                           ( cfg_mgmt_byte_enable ),
    .cfg_mgmt_read                                  ( cfg_mgmt_read ),
    .cfg_mgmt_read_data                             ( cfg_mgmt_read_data ),
    .cfg_mgmt_read_write_done                       ( cfg_mgmt_read_write_done ),
    .cfg_mgmt_type1_cfg_reg_access                  ( cfg_mgmt_type1_cfg_reg_access ),
    .cfg_msg_received                               ( cfg_msg_received ),
    .cfg_msg_received_data                          ( cfg_msg_received_data ),
    .cfg_msg_received_type                          ( cfg_msg_received_type ),
    .cfg_msg_transmit                               ( cfg_msg_transmit ),
    .cfg_msg_transmit_type                          ( cfg_msg_transmit_type ),
    .cfg_msg_transmit_data                          ( cfg_msg_transmit_data ),
    .cfg_msg_transmit_done                          ( cfg_msg_transmit_done ),
    .cfg_fc_ph                                      ( cfg_fc_ph ),
    .cfg_fc_pd                                      ( cfg_fc_pd ),
    .cfg_fc_nph                                     ( cfg_fc_nph ),
    .cfg_fc_npd                                     ( cfg_fc_npd ),
    .cfg_fc_cplh                                    ( cfg_fc_cplh ),
    .cfg_fc_cpld                                    ( cfg_fc_cpld ),
    .cfg_fc_sel                                     ( cfg_fc_sel ),
    .cfg_per_func_status_control                    ( cfg_per_func_status_control ),
    .cfg_per_func_status_data                       ( cfg_per_func_status_data ),
    .cfg_subsys_vend_id                             ( cfg_subsys_vend_id ),
    .cfg_hot_reset_out                              ( cfg_hot_reset_out ),
    .cfg_config_space_enable                        ( cfg_config_space_enable ),
    .cfg_req_pm_transition_l23_ready                ( cfg_req_pm_transition_l23_ready ),


    .cfg_hot_reset_in                               ( cfg_hot_reset_in ),
    .cfg_ds_bus_number                              ( cfg_ds_bus_number ),
    .cfg_ds_device_number                           ( cfg_ds_device_number ),
    .cfg_ds_function_number                         ( cfg_ds_function_number ),
    .cfg_ds_port_number                             ( cfg_ds_port_number ),
    .cfg_per_function_number                        ( cfg_per_function_number ),
    .cfg_per_function_output_request                ( cfg_per_function_output_request ),
    .cfg_per_function_update_done                   ( cfg_per_function_update_done ),

    .cfg_dsn                                        ( cfg_dsn ),
    .cfg_power_state_change_ack                     ( cfg_power_state_change_ack ),
    .cfg_power_state_change_interrupt               ( cfg_power_state_change_interrupt ),
    .cfg_err_cor_in                                 ( cfg_err_cor_in ),
    .cfg_err_uncor_in                               ( cfg_err_uncor_in ),

    .cfg_flr_in_process                             ( cfg_flr_in_process ),
    .cfg_flr_done                                   ( cfg_flr_done ),
    .cfg_vf_flr_in_process                          ( cfg_vf_flr_in_process ),
    .cfg_vf_flr_done                                ( cfg_vf_flr_done ),

    .cfg_link_training_enable                       ( cfg_link_training_enable ),
    //-------------------------------------------------------------------------------//
    // EP Only                                                                       //
    //-------------------------------------------------------------------------------//

    // Interrupt Interface Signals
    .cfg_interrupt_int                              ( cfg_interrupt_int ),
    .cfg_interrupt_pending                          ( cfg_interrupt_pending ),
    .cfg_interrupt_sent                             ( cfg_interrupt_sent ),
    .cfg_interrupt_msi_enable                       ( cfg_interrupt_msi_enable ),
    .cfg_interrupt_msi_vf_enable                    ( cfg_interrupt_msi_vf_enable ),
    .cfg_interrupt_msi_mmenable                     ( cfg_interrupt_msi_mmenable ),
    .cfg_interrupt_msi_mask_update                  ( cfg_interrupt_msi_mask_update ),
    .cfg_interrupt_msi_data                         ( cfg_interrupt_msi_data ),
    .cfg_interrupt_msi_select                       ( cfg_interrupt_msi_select ),
    .cfg_interrupt_msi_int                          ( cfg_interrupt_msi_int ),
    .cfg_interrupt_msi_pending_status               ( cfg_interrupt_msi_pending_status ),
    .cfg_interrupt_msi_sent                         ( cfg_interrupt_msi_sent ),
    .cfg_interrupt_msi_fail                         ( cfg_interrupt_msi_fail ),
    .cfg_interrupt_msi_attr                         ( cfg_interrupt_msi_attr ),
    .cfg_interrupt_msi_tph_present                  ( cfg_interrupt_msi_tph_present ),
    .cfg_interrupt_msi_tph_type                     ( cfg_interrupt_msi_tph_type ),
    .cfg_interrupt_msi_tph_st_tag                   ( cfg_interrupt_msi_tph_st_tag ),
    .cfg_interrupt_msi_function_number              ( cfg_interrupt_msi_function_number ),

    //--------------------------------------------------------------------------------------//
    //  System(SYS) Interface                                                               //
    //--------------------------------------------------------------------------------------//
    .sys_clk                                        ( sys_clk ),
    .sys_reset                                      ( ~sys_reset_n )

  );


  //--------------------------------------------------------------------------------------------------------------------//
  // Instantiate Configurator design
  //--------------------------------------------------------------------------------------------------------------------//
  cgator #(
    .TCQ                   ( TCQ ),
    .AXISTEN_IF_RQ_ALIGNMENT_MODE   (AXISTEN_IF_RQ_ALIGNMENT_MODE),
    .EXTRA_PIPELINE        ( EXTRA_PIPELINE ),
    .ROM_SIZE              ( ROM_SIZE ),
    .ROM_FILE              ( ROM_FILE ),
    .REQUESTER_ID          ( REQUESTER_ID ),
    .BUSNUMBER             (BUSNUMBER),
    .C_DATA_WIDTH          ( C_DATA_WIDTH ),
    .KEEP_WIDTH            ( KEEP_WIDTH )
  ) cgator_i
  (
    // globals
    .user_clk                       ( user_clk ),
    .reset                          ( user_reset ),

    // User interface for configuration
    .start_config                   ( start_config ),
    .finished_config                ( finished_config ),
    .failed_config                  ( failed_config ),

    // Rport AXIS interfaces
    .rport_s_axis_rq_tready         ( rport_s_axis_rq_tready[0] ),
    .rport_s_axis_rq_tdata          ( rport_s_axis_rq_tdata ),
    .rport_s_axis_rq_tkeep          ( rport_s_axis_rq_tkeep ),
    .rport_s_axis_rq_tuser          ( rport_s_axis_rq_tuser ),
    .rport_s_axis_rq_tlast          ( rport_s_axis_rq_tlast ),
    .rport_s_axis_rq_tvalid         ( rport_s_axis_rq_tvalid ),

    .rport_m_axis_rc_tdata          ( rport_m_axis_rc_tdata ),
    .rport_m_axis_rc_tkeep          ( rport_m_axis_rc_tkeep ),
    .rport_m_axis_rc_tlast          ( rport_m_axis_rc_tlast ),
    .rport_m_axis_rc_tvalid         ( rport_m_axis_rc_tvalid ),
    .rport_m_axis_rc_tready         ( rport_m_axis_rc_tready ),
    .rport_m_axis_rc_tuser          ( rport_m_axis_rc_tuser ),

    // User AXIS interfaces

    .usr_s_axis_rq_tready           ( s_axis_rq_tready),
    .usr_s_axis_rq_tdata            ( s_axis_rq_tdata ),
    .usr_s_axis_rq_tkeep            ( s_axis_rq_tkeep ),
    .usr_s_axis_rq_tuser            ( s_axis_rq_tuser ),
    .usr_s_axis_rq_tlast            ( s_axis_rq_tlast ),
    .usr_s_axis_rq_tvalid           ( s_axis_rq_tvalid ),

    .usr_m_axis_rc_tready           ( m_axis_rc_tready ),
    .usr_m_axis_rc_tdata            ( m_axis_rc_tdata ),
    .usr_m_axis_rc_tkeep            ( m_axis_rc_tkeep ),
    .usr_m_axis_rc_tlast            ( m_axis_rc_tlast ),
    .usr_m_axis_rc_tvalid           ( m_axis_rc_tvalid ),
    .usr_m_axis_rc_tuser            ( m_axis_rc_tuser )
  );
  //--------------------------------------------------------------------------------------------------------------------//



         reg [7:0]  user_lnk_up_count;
         reg [7:0]  user_lnk_up_count_q;
          
        always @(posedge user_clk ) begin
           if (user_reset) begin
                user_lnk_up_count  <= 8'h00;
           end else begin
             if ((~user_lnk_up) | (~(cfg_ltssm_state == 6'h10)))
                  user_lnk_up_count <= 8'h00;        
             else if (user_lnk_up & (cfg_ltssm_state == 6'h10) & (~(user_lnk_up_count == 8'hFF)))
                user_lnk_up_count <= user_lnk_up_count + 1;
             else if (user_lnk_up_count == 8'hFF)
               user_lnk_up_count <= 8'hFF;
             else
               user_lnk_up_count <= 8'h00;
           end
         end
         
        always @(posedge user_clk ) begin
            if (user_reset) begin
              user_lnk_up_count_q <= 8'h00;
            end else begin
              user_lnk_up_count_q <= user_lnk_up_count;
            end
          end
             
                 generate
                  if(DNA_EN == 1'b1)     
                   always @(posedge user_clk) begin
                      if (user_reset) begin
                        start_config <= # 1'b0;
                      end else begin
                        //start_config <= # (user_lnk_up_count == 8'hFF) & (user_lnk_up_count_q == 8'hFE);
                        start_config <= # (user_lnk_up_count == 8'hFF) & (user_lnk_up_count_q == 8'hFE) & dna_ok_flag_2;
                      end
                    end
                    
                 else if(DNA_EN == 1'b0)
                  
                   always @(posedge user_clk) begin
                     if (user_reset) begin
                       start_config <= # 1'b0;
                     end else begin
                       start_config <= # (user_lnk_up_count == 8'hFF) & (user_lnk_up_count_q == 8'hFE);
                     end
                   end         
                  
                 endgenerate  
          
          always @(posedge user_clk) begin
             if (user_reset) begin
               dna_ok_flag_1 <=  1'b0;
               dna_ok_flag_2 <=  1'b0;
             end 
             else begin
               dna_ok_flag_1 <=  dna_ok_flag;
               dna_ok_flag_2 <=  dna_ok_flag_1;
             end
           end


 /*
    // Sampling registers
  reg          user_lnk_up_q;
  reg          user_lnk_up_q2;


  // Start Configurator after link comes up
  always @(posedge user_clk) begin
    if (user_reset) begin
      user_lnk_up_q  <= #TCQ 1'b0;
      user_lnk_up_q2 <= #TCQ 1'b0;
      start_config   <= #TCQ 1'b0;
    end else begin
      user_lnk_up_q  <= #TCQ user_lnk_up;
      user_lnk_up_q2 <= #TCQ user_lnk_up_q;
      start_config   <= #TCQ (!user_lnk_up_q2 && user_lnk_up_q) ;
    end
  end
   */
           
 /*       
        rp_ila rp_ila_i (
            .clk(user_clk),
            
            .probe0(user_lnk_up),            // 1
            .probe1({start_config, finished_config, failed_config, mmcm_lock, user_app_rdy, sys_reset_n}),  // 6
            .probe2(cfg_current_speed),     // 2 
            .probe3(cfg_ltssm_state),       // 6
            .probe4(cfg_negotiated_width),  // 4
            .probe5(user_lnk_up_count)     // 8
            );
*/ 
/*  
top_rp_ila top_rp_ila_i (
        .clk(user_clk),
        
        .probe0(m_axis_cq_tready),  // 1
        .probe1(m_axis_cq_tvalid),  // 1
        .probe2(m_axis_cq_tlast),   // 1
        .probe3(m_axis_cq_tkeep),   // 4
        .probe4(m_axis_cq_tdata),   // 128
        .probe5(m_axis_cq_tuser),   // 85    +=  220
    
        .probe6(s_axis_cc_tready),  // 1
        .probe7(s_axis_cc_tvalid),  // 1
        .probe8(s_axis_cc_tlast),   // 1
        .probe9(s_axis_cc_tkeep),   // 4
        .probe10(s_axis_cc_tdata),   // 128
        .probe11(s_axis_cc_tuser),   // 33    +=  168
    
        .probe12(rport_s_axis_rq_tready),  // 1
        .probe13(rport_s_axis_rq_tvalid),  // 1
        .probe14(rport_s_axis_rq_tlast),   // 1
        .probe15(rport_s_axis_rq_tkeep),   // 4
        .probe16(rport_s_axis_rq_tdata),   // 128
        .probe17(rport_s_axis_rq_tuser),   // 60    +=  195
    
        .probe18(rport_m_axis_rc_tready),  // 1
        .probe19(rport_m_axis_rc_tvalid),  // 1
        .probe20(rport_m_axis_rc_tlast),   // 1
        .probe21(rport_m_axis_rc_tkeep),   // 4
        .probe22(rport_m_axis_rc_tdata),   // 128
        .probe23(rport_m_axis_rc_tuser),   // 75    +=  210
        
        .probe24(user_lnk_up),            // 1
        .probe25({start_config, finished_config, failed_config, mmcm_lock, user_app_rdy, sys_reset_n}),  // 6
        .probe26(cfg_current_speed),     // 2 
        .probe27(cfg_ltssm_state),       // 6
        .probe28(cfg_negotiated_width),  // 4
        .probe29(user_lnk_up_count)     // 8
    
        );
 */
                 
endmodule // cgator_wrapper

