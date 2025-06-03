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
// File       : xilinx_pcie_3_0_7vx_rp.v
// Version    : 4.2
//-----------------------------------------------------------------------------
//--
//-- Description:  PCI Express Endpoint example FPGA design
//--
//------------------------------------------------------------------------------

`timescale 1ps / 1ps
(* DowngradeIPIdentifiedWarnings = "yes" *)
module rp # (
 // parameter PL_SIM_FAST_LINK_TRAINING                  = "TRUE",         // Simulation Speedup
  parameter          EXT_PIPE_SIM                        = "FALSE",  // This Parameter has effect on selecting Enable External PIPE Interface in GUI.
  parameter PCIE_EXT_CLK                               = "FALSE", // Use External Clocking Module
  parameter C_DATA_WIDTH                               = 128,             // RX/TX interface data width
  parameter [2:0] PL_LINK_CAP_MAX_LINK_SPEED                 = 3'h2,               // 1- GEN1, 2 - GEN2, 4 - GEN3
  parameter [3:0] PL_LINK_CAP_MAX_LINK_WIDTH                 = 4'h4,               // 1- X1, 2 - X2, 4 - X4, 8 - X8
  parameter PL_DISABLE_EI_INFER_IN_L0           = "TRUE",
  parameter ROM_FILE = "cgator_cfg_rom.data",
  parameter ROM_SIZE = 32,
  parameter [15:0] REQUESTER_ID        = 16'h01A0,
  parameter [7:0]  BUSNUMBER           = 8'h01,
  //  USER_CLK[1/2]_FREQ        : 0 = Disable user clock
  //                                : 1 =  31.25 MHz
  //                                : 2 =  62.50 MHz (default)
  //                                : 3 = 125.00 MHz
  //                                : 4 = 250.00 MHz
  //                                : 5 = 500.00 MHz
  parameter PL_DISABLE_UPCONFIG_CAPABLE                = "FALSE",
  parameter  integer USER_CLK2_FREQ                    = 3,
  parameter          REF_CLK_FREQ                      = 0,                 // 0 - 100 MHz, 1 - 125 MHz,  2 - 250 MHz
//  parameter USER_CLK2_DIV2                             = "FALSE",         // "FALSE" => user_clk2 = user_clk
  parameter        AXISTEN_IF_RQ_ALIGNMENT_MODE   = "FALSE",
  parameter        AXISTEN_IF_CC_ALIGNMENT_MODE   = "FALSE",
  parameter        AXISTEN_IF_CQ_ALIGNMENT_MODE   = "FALSE",
  parameter        AXISTEN_IF_RC_ALIGNMENT_MODE   = "FALSE",
  parameter        AXISTEN_IF_ENABLE_CLIENT_TAG   = "TRUE",
  parameter        AXISTEN_IF_RQ_PARITY_CHECK     = "FALSE",
  parameter        AXISTEN_IF_CC_PARITY_CHECK     = "FALSE",
  parameter        AXISTEN_IF_MC_RX_STRADDLE      = "FALSE",
  parameter        AXISTEN_IF_ENABLE_RX_MSG_INTFC = "FALSE",
  parameter [17:0] AXISTEN_IF_ENABLE_MSG_ROUTE    = 18'h2FFFF,
  parameter KEEP_WIDTH                                 = C_DATA_WIDTH / 32,
  
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
(
  output  [(PL_LINK_CAP_MAX_LINK_WIDTH - 1) : 0]  pci_exp_txp,
  output  [(PL_LINK_CAP_MAX_LINK_WIDTH - 1) : 0]  pci_exp_txn,
  input   [(PL_LINK_CAP_MAX_LINK_WIDTH - 1) : 0]  pci_exp_rxp,
  input   [(PL_LINK_CAP_MAX_LINK_WIDTH - 1) : 0]  pci_exp_rxn,

  input                                        sys_clk_p,
  input                                        sys_clk_n,
  input                                        sys_rst_n,
  
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

  output                                    user_clk,
  output                                    user_reset,
  output                                    user_lnk_up,
  output                                    cfg_err_cor_out,
  output                                    cfg_err_nonfatal_out,
  output                                    cfg_err_fatal_out,
  output                                    finished_config,
  output                                    failed_config,
  input                                     dna_ok_flag
  
);


  localparam        TCQ = 1;
  localparam integer USER_CLK_FREQ         = ((PL_LINK_CAP_MAX_LINK_SPEED == 3'h4) ? 5 : 4);

  wire					       pipe_mmcm_rst_n;
  wire                                         sys_rst_n_c;

//-------------------------------------------------------
  // 0. Configurator Control/Status Interface
  //-------------------------------------------------------
   
  wire [15:0]               cfg_subsys_vend_id = 16'h10EE;      
//  reg                       start_config;    
  wire                      finished_config; 
  wire                      failed_config;  
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

  //-------------------------------------------------------
  // 2. Transaction (AXIS) Interface
  //-------------------------------------------------------
  wire                      user_clk;           // out
  wire                      user_reset;         // out
  wire                      user_lnk_up;        // out
  
    //-------------------------------------------------------
    // 2. Transaction (AXIS) Interface
    //-------------------------------------------------------
  wire                                       s_axis_rq_tlast;
  wire                 [C_DATA_WIDTH-1:0]    s_axis_rq_tdata;
  wire          [AXI4_RQ_TUSER_WIDTH-1:0]    s_axis_rq_tuser;
  wire                   [KEEP_WIDTH-1:0]    s_axis_rq_tkeep;
  wire                              [3:0]    s_axis_rq_tready;
  wire                                       s_axis_rq_tvalid;

  wire                 [C_DATA_WIDTH-1:0]    m_axis_rc_tdata;
  wire          [AXI4_RC_TUSER_WIDTH-1:0]    m_axis_rc_tuser;
  wire                                       m_axis_rc_tlast;
  wire                   [KEEP_WIDTH-1:0]    m_axis_rc_tkeep;
  wire                                       m_axis_rc_tvalid;
  wire                                       m_axis_rc_tready;

  wire                 [C_DATA_WIDTH-1:0]    m_axis_cq_tdata;
  wire          [AXI4_CQ_TUSER_WIDTH-1:0]    m_axis_cq_tuser;
  wire                                       m_axis_cq_tlast;
  wire                   [KEEP_WIDTH-1:0]    m_axis_cq_tkeep;
  wire                                       m_axis_cq_tvalid;
  wire                                       m_axis_cq_tready;

  wire                 [C_DATA_WIDTH-1:0]    s_axis_cc_tdata;
  wire          [AXI4_CC_TUSER_WIDTH-1:0]    s_axis_cc_tuser;
  wire                                       s_axis_cc_tlast;
  wire                   [KEEP_WIDTH-1:0]    s_axis_cc_tkeep;
  wire                                       s_axis_cc_tvalid;
  wire                              [3:0]    s_axis_cc_tready;

  //-------------------------------------------------------
  // 3. Configuration (CFG) Interface - EP and RP
  //-------------------------------------------------------
  wire                      cfg_phy_link_down;
  wire  [1:0]               cfg_phy_link_status;
  wire  [3:0]               cfg_negotiated_width;
  wire  [2:0]               cfg_current_speed;
  wire  [2:0]               cfg_max_payload;
  wire  [2:0]               cfg_max_read_req;
  wire  [7:0]               cfg_function_status;
  wire  [5:0]               cfg_function_power_state;
  wire  [11:0]              cfg_vf_status;
  wire  [17:0]              cfg_vf_power_state;
  wire  [1:0]               cfg_link_power_state;

  //-------------------------------------------------------
  // Error Reporting Interface
  //-------------------------------------------------------
  wire                      cfg_err_cor_out;
  wire                      cfg_err_nonfatal_out;
  wire                      cfg_err_fatal_out;
  //wire                    cfg_local_error;

  wire                      cfg_ltr_enable;
  wire   [5:0]              cfg_ltssm_state;
  wire   [1:0]              cfg_rcb_status;
  wire   [1:0]              cfg_dpa_substate_change;
  wire   [1:0]              cfg_obff_enable;
  wire                      cfg_pl_status_change;

  wire   [1:0]              cfg_tph_requester_enable;
  wire   [5:0]              cfg_tph_st_mode;
  wire   [5:0]              cfg_vf_tph_requester_enable;
  wire   [17:0]             cfg_vf_tph_st_mode;
  //-------------------------------------------------------
  // Management Interface
  //-------------------------------------------------------
  reg    [18:0]    cfg_mgmt_addr;
  reg              cfg_mgmt_write;
  reg    [31:0]    cfg_mgmt_write_data;
  reg    [3:0]     cfg_mgmt_byte_enable;
  reg              cfg_mgmt_read;
  wire   [31:0]    cfg_mgmt_read_data;
  wire             cfg_mgmt_read_write_done;
  reg              cfg_mgmt_type1_cfg_reg_access;
  wire             cfg_msg_received;
  wire   [7:0]     cfg_msg_received_data;
  wire   [4:0]     cfg_msg_received_type;
  reg              cfg_msg_transmit;
  reg    [2:0]     cfg_msg_transmit_type;
  reg    [31:0]    cfg_msg_transmit_data;
  wire             cfg_msg_transmit_done;
  wire   [7:0]     cfg_fc_ph;
  wire   [11:0]    cfg_fc_pd;
  wire   [7:0]     cfg_fc_nph;
  wire   [11:0]    cfg_fc_npd;
  wire   [7:0]     cfg_fc_cplh;
  wire   [11:0]    cfg_fc_cpld;
  reg    [2:0]     cfg_fc_sel;
  reg    [2:0]     cfg_per_func_status_control;
  wire   [15:0]    cfg_per_func_status_data;
  reg    [2:0]     cfg_per_function_number;
  reg              cfg_per_function_output_request;
  wire             cfg_per_function_update_done;

  reg     [63:0]   cfg_dsn;
  reg              cfg_power_state_change_ack;
  wire             cfg_power_state_change_interrupt;
  reg              cfg_err_cor_in;
  reg              cfg_err_uncor_in;

  wire    [1:0]    cfg_flr_in_process;
  reg     [1:0]    cfg_flr_done;
  wire    [5:0]    cfg_vf_flr_in_process;
  reg     [5:0]    cfg_vf_flr_done;
  wire             cfg_hot_reset_out;

  reg              cfg_link_training_enable;
  reg              cfg_config_space_enable;
  reg              cfg_req_pm_transition_l23_ready;
  reg              cfg_hot_reset_in;
  reg     [7:0]    cfg_ds_port_number;
  reg     [7:0]    cfg_ds_bus_number;
  reg     [4:0]    cfg_ds_device_number;
  reg     [2:0]    cfg_ds_function_number;

  //----------------------------------------------------------------------------------------------------------------//
  // EP Only   -    Interrupt Interface Signals                                                                     //
  //----------------------------------------------------------------------------------------------------------------//
  reg     [3:0]    cfg_interrupt_int;
  reg     [1:0]    cfg_interrupt_pending;
  wire             cfg_interrupt_sent;
  wire    [1:0]    cfg_interrupt_msi_enable;
  wire    [5:0]    cfg_interrupt_msi_vf_enable;
  wire    [5:0]    cfg_interrupt_msi_mmenable;
  wire             cfg_interrupt_msi_mask_update;
  wire    [31:0]   cfg_interrupt_msi_data;
  reg     [3:0]    cfg_interrupt_msi_select;
  reg     [31:0]   cfg_interrupt_msi_int;
  reg     [63:0]   cfg_interrupt_msi_pending_status;
  wire             cfg_interrupt_msi_sent;
  wire             cfg_interrupt_msi_fail;
  reg     [2:0]    cfg_interrupt_msi_attr;
  reg              cfg_interrupt_msi_tph_present;
  reg     [1:0]    cfg_interrupt_msi_tph_type;
  reg     [8:0]    cfg_interrupt_msi_tph_st_tag;
  reg     [2:0]    cfg_interrupt_msi_function_number;
  
  //-------------------------------------------------------
  // Button sampling
  //-------------------------------------------------------
  reg               pio_test_restart    = 1'b0;
  wire              pio_test_finished;
  wire              pio_test_failed;

  wire              sys_clk;


  //IBUF   sys_reset_n_ibuf (.O(sys_rst_n_c), .I(sys_rst_n));
 assign  sys_rst_n_c = sys_rst_n;

    IBUFDS_GTE2 refclk_ibuf (.O(sys_clk), .ODIV2(), .I(sys_clk_p), .CEB(1'b0), .IB(sys_clk_n));




  localparam X8_GEN3 = ((PL_LINK_CAP_MAX_LINK_WIDTH == 8) && (PL_LINK_CAP_MAX_LINK_SPEED == 4)) ? 1'b1 : 1'b0;

  cgator_wrapper #(
    .TCQ                            (TCQ),
    .AXISTEN_IF_RQ_ALIGNMENT_MODE   (AXISTEN_IF_RQ_ALIGNMENT_MODE),
    .EXTRA_PIPELINE                 (0),
    .ROM_FILE                       (ROM_FILE),
    .ROM_SIZE                       (ROM_SIZE),
    .REQUESTER_ID                   (REQUESTER_ID), 
    .BUSNUMBER                      (BUSNUMBER), 
    .PCIE_EXT_CLK                   (PCIE_EXT_CLK),          
    .PL_LINK_CAP_MAX_LINK_SPEED     (PL_LINK_CAP_MAX_LINK_SPEED),          
    .PL_LINK_CAP_MAX_LINK_WIDTH     (PL_LINK_CAP_MAX_LINK_WIDTH),          
    .PL_DISABLE_EI_INFER_IN_L0      (PL_DISABLE_EI_INFER_IN_L0), 
    .PL_DISABLE_UPCONFIG_CAPABLE    (PL_DISABLE_UPCONFIG_CAPABLE), 
    .USER_CLK2_FREQ                 (USER_CLK2_FREQ), 
    .REF_CLK_FREQ                   (REF_CLK_FREQ),          
    .AXISTEN_IF_RQ_PARITY_CHECK     (AXISTEN_IF_RQ_PARITY_CHECK), 
    .C_DATA_WIDTH                   (C_DATA_WIDTH),
    .KEEP_WIDTH                     (KEEP_WIDTH),
    .DNA_EN                         (DNA_EN)
  ) cgator_wrapper_i
  (
      .pipe_mmcm_rst_n  (pipe_mmcm_rst_n), 

    //-------------------------------------------------------
    // 0. Configurator I/Os
    //-------------------------------------------------------
   // .start_config                   (start_config),
    .finished_config                (finished_config),
    .failed_config                  (failed_config),
    //-------------------------------------------------------
    // 1. PCI Express (pci_exp) Interface
    //-------------------------------------------------------
    .pci_exp_txp                    (pci_exp_txp[PL_LINK_CAP_MAX_LINK_WIDTH-1:0]),
    .pci_exp_txn                    (pci_exp_txn[PL_LINK_CAP_MAX_LINK_WIDTH-1:0]),
    .pci_exp_rxp                    (pci_exp_rxp[PL_LINK_CAP_MAX_LINK_WIDTH-1:0]),
    .pci_exp_rxn                    (pci_exp_rxn[PL_LINK_CAP_MAX_LINK_WIDTH-1:0]),
    //-------------------------------------------------------
    // 2. Transaction (AXIS) Interface
    //-------------------------------------------------------
    .user_clk                       (user_clk),
    .user_reset                     (user_reset),
    .user_lnk_up                    (user_lnk_up),
    //-------------------------------------------------------

      .s_axis_cc_tdata                                ( s_axis_cc_tdata ),
      .s_axis_cc_tkeep                                ( s_axis_cc_tkeep ),
      .s_axis_cc_tlast                                ( s_axis_cc_tlast ),
      .s_axis_cc_tvalid                               ( s_axis_cc_tvalid ),
      .s_axis_cc_tuser                                ( s_axis_cc_tuser ),
      .s_axis_cc_tready                               ( s_axis_cc_tready ),
    
      .s_axis_rq_tdata                                ( s_axis_rq_tdata ),
      .s_axis_rq_tkeep                                ( s_axis_rq_tkeep ),
      .s_axis_rq_tlast                                ( s_axis_rq_tlast ),
      .s_axis_rq_tvalid                               ( s_axis_rq_tvalid ),
      .s_axis_rq_tuser                                ( s_axis_rq_tuser ),
      .s_axis_rq_tready                               ( s_axis_rq_tready ),
    
      .m_axis_cq_tdata                                ( m_axis_cq_tdata ),
      .m_axis_cq_tlast                                ( m_axis_cq_tlast ),
      .m_axis_cq_tvalid                               ( m_axis_cq_tvalid ),
      .m_axis_cq_tuser                                ( m_axis_cq_tuser ),
      .m_axis_cq_tkeep                                ( m_axis_cq_tkeep ),
      .m_axis_cq_tready                               ( m_axis_cq_tready ),
    
      .m_axis_rc_tdata                                ( m_axis_rc_tdata ),
      .m_axis_rc_tlast                                ( m_axis_rc_tlast ),
      .m_axis_rc_tvalid                               ( m_axis_rc_tvalid ),
      .m_axis_rc_tuser                                ( m_axis_rc_tuser ),
      .m_axis_rc_tkeep                                ( m_axis_rc_tkeep ),
      .m_axis_rc_tready                               ( m_axis_rc_tready ),
    //-------------------------------------------------------
    // 4. Configuration (CFG) Interface    - EP and RP                                                       
    //-------------------------------------------------------
   .cfg_phy_link_down                         (cfg_phy_link_down),
   .cfg_phy_link_status                       (cfg_phy_link_status),
   .cfg_negotiated_width                      (cfg_negotiated_width),
   .cfg_current_speed                         (cfg_current_speed),
   .cfg_max_payload                           (cfg_max_payload),
   .cfg_max_read_req                          (cfg_max_read_req),
   .cfg_function_status                       (cfg_function_status),
   .cfg_function_power_state                  (cfg_function_power_state),
   .cfg_vf_status                             (cfg_vf_status),
   .cfg_vf_power_state                        (cfg_vf_power_state),
   .cfg_link_power_state                      (cfg_link_power_state),

    //-------------------------------------------------------
    // Error Reporting Interface
    //-------------------------------------------------------
   .cfg_err_cor_out                           (cfg_err_cor_out),
   .cfg_err_nonfatal_out                      (cfg_err_nonfatal_out),
   .cfg_err_fatal_out                         (cfg_err_fatal_out),
  
   .cfg_ltr_enable                            (cfg_ltr_enable),
   .cfg_ltssm_state                           (cfg_ltssm_state),
   .cfg_rcb_status                            (cfg_rcb_status),
   .cfg_dpa_substate_change                   (cfg_dpa_substate_change),
   .cfg_obff_enable                           (cfg_obff_enable),
   .cfg_pl_status_change                      (cfg_pl_status_change),
  
   .cfg_tph_requester_enable                  (cfg_tph_requester_enable),
   .cfg_tph_st_mode                           (cfg_tph_st_mode),
   .cfg_vf_tph_requester_enable               (cfg_vf_tph_requester_enable),
   .cfg_vf_tph_st_mode                        (cfg_vf_tph_st_mode),
    //-------------------------------------------------------
    // Management Interface
    //-------------------------------------------------------
   .cfg_mgmt_addr                             (cfg_mgmt_addr),
   .cfg_mgmt_write                            (cfg_mgmt_write),
   .cfg_mgmt_write_data                       (cfg_mgmt_write_data),
   .cfg_mgmt_byte_enable                      (cfg_mgmt_byte_enable),
  
   .cfg_mgmt_read                             (cfg_mgmt_read),
   .cfg_mgmt_read_data                        (cfg_mgmt_read_data),
   .cfg_mgmt_read_write_done                  (cfg_mgmt_read_write_done),
   .cfg_mgmt_type1_cfg_reg_access             (cfg_mgmt_type1_cfg_reg_access),
  
   .cfg_msg_received                          (cfg_msg_received),
   .cfg_msg_received_data                     (cfg_msg_received_data),
   .cfg_msg_received_type                     (cfg_msg_received_type),
   .cfg_msg_transmit                          (cfg_msg_transmit),
   .cfg_msg_transmit_type                     (cfg_msg_transmit_type),
   .cfg_msg_transmit_data                     (cfg_msg_transmit_data),
   .cfg_msg_transmit_done                     (cfg_msg_transmit_done),
   .cfg_fc_ph                                 (cfg_fc_ph),
   .cfg_fc_pd                                 (cfg_fc_pd),
   .cfg_fc_nph                                (cfg_fc_nph),
   .cfg_fc_npd                                (cfg_fc_npd),
   .cfg_fc_cplh                               (cfg_fc_cplh),
   .cfg_fc_cpld                               (cfg_fc_cpld),
   .cfg_fc_sel                                (cfg_fc_sel),
   .cfg_per_func_status_control               (cfg_per_func_status_control),
   .cfg_per_func_status_data                  (cfg_per_func_status_data),
   .cfg_subsys_vend_id                        (cfg_subsys_vend_id),
   .cfg_hot_reset_out                         (cfg_hot_reset_out),
   .cfg_config_space_enable                   (cfg_config_space_enable),
   .cfg_req_pm_transition_l23_ready           (cfg_req_pm_transition_l23_ready),

   .cfg_hot_reset_in                          (cfg_hot_reset_in),
   .cfg_ds_bus_number                         (cfg_ds_bus_number),
   .cfg_ds_device_number                      (cfg_ds_device_number),
   .cfg_ds_function_number                    (cfg_ds_function_number),
   .cfg_ds_port_number                        (cfg_ds_port_number),
  
   .cfg_per_function_number                   (cfg_per_function_number),
   .cfg_per_function_output_request           (cfg_per_function_output_request),
   .cfg_per_function_update_done              (cfg_per_function_update_done),
  
   .cfg_dsn                                   (cfg_dsn),
   .cfg_power_state_change_ack                (cfg_power_state_change_ack),
   .cfg_power_state_change_interrupt          (cfg_power_state_change_interrupt),
   .cfg_err_cor_in                            (cfg_err_cor_in),
   .cfg_err_uncor_in                          (cfg_err_uncor_in),
  
   .cfg_flr_in_process                        (cfg_flr_in_process),
   .cfg_flr_done                              (cfg_flr_done),
   .cfg_vf_flr_in_process                     (cfg_vf_flr_in_process),
   .cfg_vf_flr_done                           (cfg_vf_flr_done),

   .cfg_link_training_enable                  (cfg_link_training_enable),

    //-------------------------------------------------------
    // Interrupt Interface Signals
    //-------------------------------------------------------
   .cfg_interrupt_int                         (cfg_interrupt_int),
   .cfg_interrupt_pending                     (cfg_interrupt_pending),
   .cfg_interrupt_sent                        (cfg_interrupt_sent),
   .cfg_interrupt_msi_enable                  (cfg_interrupt_msi_enable),
   .cfg_interrupt_msi_vf_enable               (cfg_interrupt_msi_vf_enable),
   .cfg_interrupt_msi_mmenable                (cfg_interrupt_msi_mmenable),
   .cfg_interrupt_msi_mask_update             (cfg_interrupt_msi_mask_update),
   .cfg_interrupt_msi_data                    (cfg_interrupt_msi_data),
   .cfg_interrupt_msi_select                  (cfg_interrupt_msi_select),
   .cfg_interrupt_msi_int                     (cfg_interrupt_msi_int),
   .cfg_interrupt_msi_pending_status          (cfg_interrupt_msi_pending_status),
   .cfg_interrupt_msi_sent                    (cfg_interrupt_msi_sent),
   .cfg_interrupt_msi_fail                    (cfg_interrupt_msi_fail),
   .cfg_interrupt_msi_attr                    (cfg_interrupt_msi_attr),
   .cfg_interrupt_msi_tph_present             (cfg_interrupt_msi_tph_present),
   .cfg_interrupt_msi_tph_type                (cfg_interrupt_msi_tph_type),
   .cfg_interrupt_msi_tph_st_tag              (cfg_interrupt_msi_tph_st_tag),
   .cfg_interrupt_msi_function_number         ( cfg_interrupt_msi_function_number ),

   //-------------------------------------------------------
   // 5. System  (SYS) Interface
   //-------------------------------------------------------
   .sys_clk                        (sys_clk),
   .sys_reset_n                    (sys_rst_n_c),
   .dna_ok_flag                    (dna_ok_flag)
  );

  assign 	     pipe_mmcm_rst_n=1'b1;
 
  
  //--------------------------------------------------------------------------------------------------------------------//
  // CFG_WRITE : Description : Write Configuration Space MI decode error, Disabling LFSR update from SKP. CR# 
  //--------------------------------------------------------------------------------------------------------------------//
    reg write_cfg_done_1;
      always @(posedge user_clk) begin : cfg_write_skp_nolfsr
        if (user_reset) begin
            cfg_mgmt_addr        <= #TCQ 32'b0;
            cfg_mgmt_write_data  <= #TCQ 32'b0;
            cfg_mgmt_byte_enable <= #TCQ 4'b0;
            cfg_mgmt_write       <= #TCQ 1'b0;
            cfg_mgmt_read        <= #TCQ 1'b0;
            write_cfg_done_1     <= #TCQ 1'b0; end
        else begin
          if (cfg_mgmt_read_write_done == 1'b1 && write_cfg_done_1 == 1'b1) begin
              cfg_mgmt_addr        <= #TCQ 0;
              cfg_mgmt_write_data  <= #TCQ 0;
              cfg_mgmt_byte_enable <= #TCQ 0;
              cfg_mgmt_write       <= #TCQ 0;
              cfg_mgmt_read        <= #TCQ 0;  end
          else if (cfg_mgmt_read_write_done == 1'b1 && write_cfg_done_1 == 1'b0) begin
              cfg_mgmt_addr        <= #TCQ 32'h40082;
              cfg_mgmt_write_data[31:28] <= #TCQ cfg_mgmt_read_data[31:28];
              cfg_mgmt_write_data[27]    <= #TCQ 1'b1; 
              cfg_mgmt_write_data[26:0]  <= #TCQ cfg_mgmt_read_data[26:0];
              cfg_mgmt_byte_enable <= #TCQ 4'hF;
              cfg_mgmt_write       <= #TCQ 1'b1;
              cfg_mgmt_read        <= #TCQ 1'b0;  
              write_cfg_done_1     <= #TCQ 1'b1; end
          else if (write_cfg_done_1 == 1'b0) begin
              cfg_mgmt_addr        <= #TCQ 32'h40082;
              cfg_mgmt_write_data  <= #TCQ 32'b0;
              cfg_mgmt_byte_enable <= #TCQ 4'hF;
              cfg_mgmt_write       <= #TCQ 1'b0;
              cfg_mgmt_read        <= #TCQ 1'b1;  end
          end
      end
  //--------------------------------------------------------------------------------------------------------------------//
  // Configuration signals which are unused
  //--------------------------------------------------------------------------------------------------------------------//
   initial begin
   
     cfg_mgmt_type1_cfg_reg_access    <= 0 ;//  
     
     cfg_msg_transmit                 <= 0 ;// 
     cfg_msg_transmit_type            <= 0 ;//[2:0]
     cfg_msg_transmit_data            <= 0 ;//[31:0]  
     
  
     cfg_fc_sel                       <= 0 ;//[2:0]     
  
     cfg_per_func_status_control      <= 0 ;//[2:0] 
 
   
     cfg_config_space_enable          <= 1'b1 ;//    
     cfg_req_pm_transition_l23_ready  <= 0 ;//                                   
     cfg_hot_reset_in                 <= 0 ;//        
     cfg_ds_bus_number                <= 8'h45 ;//[7:0]
     cfg_ds_device_number             <= 4'b0001 ;//[4:0]        
     cfg_ds_function_number           <= 3'b011 ;//[2:0]   
     cfg_ds_port_number               <= 8'h9F ;//[7:0]           
     cfg_per_function_number          <= 0 ;//[2:0]     
     cfg_per_function_output_request  <= 0 ;//      
     cfg_dsn                          <= 64'h78EE32BAD28F906B ;//[63:0]       
     cfg_power_state_change_ack       <= 0 ;//    
     cfg_err_cor_in                   <= 0 ;
     cfg_err_uncor_in                 <= 0 ;//     
     cfg_flr_done                     <= 0 ;//[1:0]
     cfg_vf_flr_done                  <= 0 ;//[5:0]    
     cfg_link_training_enable         <= 1 ;// 
   
      
     // Interrupt Interface Signals
     cfg_interrupt_int                <= 0 ;//[3:0]  
     cfg_interrupt_pending            <= 0 ;//[1:0]      
   
     cfg_interrupt_msi_select         <= 0 ;//[3:0]        
     cfg_interrupt_msi_int            <= 0 ;//[31:0]  
     cfg_interrupt_msi_pending_status <= 0 ;//[63:0]  
     cfg_interrupt_msi_attr           <= 0 ;//[2:0] 
     cfg_interrupt_msi_tph_present    <= 0 ;//        
     cfg_interrupt_msi_tph_type       <= 0 ;//[1:0]       
     cfg_interrupt_msi_tph_st_tag     <= 0 ;//[8:0]        
     cfg_interrupt_msi_function_number<= 0 ;//[2:0]            
 
   end
  //--------------------------------------------------------------------------------------------------------------------//

ep_ila rp_ila_i (
	.clk(user_clk),
	
	.probe0(user_lnk_up),		    // 1
	.probe1(cfg_negotiated_width),  // 3
	.probe2(cfg_current_speed),     // 2 
	.probe3(cfg_ltssm_state)        // 6
	);

endmodule
