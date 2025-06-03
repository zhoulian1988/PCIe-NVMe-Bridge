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
// File       : cgator.v
// Version    : 4.2
// Description : Configurator example design - configures a PCI Express
//               Endpoint via the Root Port Block for PCI Express. Endpoint is
//               configured using a pre-determined set of configuration
//               and message transactions. Transactions are specified in the
//               file indicated by the ROM_FILE parameter
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
//-----------------------------------------------------------------------------

`timescale 1ns/1ns

module cgator
  #(
    parameter           TCQ                   = 1,
    parameter        AXISTEN_IF_RQ_ALIGNMENT_MODE   = "TRUE",
    parameter           EXTRA_PIPELINE        = 1,
    parameter           ROM_FILE              = "cgator_cfg_rom.data",
    parameter           ROM_SIZE              = 32,
    parameter [15:0]    REQUESTER_ID          = 16'h10EE,
    parameter [7:0]     BUSNUMBER             = 8'h01,
    parameter           C_DATA_WIDTH          = 64,
    parameter           KEEP_WIDTH            = C_DATA_WIDTH / 32,
    
    // Ultrascale +
    // parameter        AXI4_CQ_TUSER_WIDTH            = 88,
    // parameter        AXI4_CC_TUSER_WIDTH            = 33,
    // parameter        AXI4_RQ_TUSER_WIDTH            = 62,
    // parameter        AXI4_RC_TUSER_WIDTH            = 75,
    
    // V7 690T 
    parameter        AXI4_CQ_TUSER_WIDTH            = 85,
    parameter        AXI4_CC_TUSER_WIDTH            = 33,
    parameter        AXI4_RQ_TUSER_WIDTH            = 60,
    parameter        AXI4_RC_TUSER_WIDTH            = 75
  ) (
    // globals
    input wire                          user_clk,
    input wire                          reset,

    // User interface for configuration
    input wire                          start_config,
    output wire                         finished_config,
    output wire                         failed_config,

    // Rport AXIS interfaces
    input                               rport_s_axis_rq_tready,
    output [C_DATA_WIDTH-1:0]           rport_s_axis_rq_tdata,
    output [KEEP_WIDTH-1:0]             rport_s_axis_rq_tkeep,
    output [AXI4_RQ_TUSER_WIDTH-1:0]    rport_s_axis_rq_tuser,
    output                              rport_s_axis_rq_tlast,
    output                              rport_s_axis_rq_tvalid,

    input  [C_DATA_WIDTH-1:0]           rport_m_axis_rc_tdata,
    input  [KEEP_WIDTH-1:0]             rport_m_axis_rc_tkeep,
    input                               rport_m_axis_rc_tlast,
    input                               rport_m_axis_rc_tvalid,
    output                              rport_m_axis_rc_tready,
    input  [AXI4_RC_TUSER_WIDTH-1:0]    rport_m_axis_rc_tuser,

    // User AXIS interfaces
    output                              usr_s_axis_rq_tready,
    input  [C_DATA_WIDTH-1:0]           usr_s_axis_rq_tdata,
    input  [KEEP_WIDTH-1:0]             usr_s_axis_rq_tkeep,
    input  [AXI4_RQ_TUSER_WIDTH-1:0]    usr_s_axis_rq_tuser,
    input                               usr_s_axis_rq_tlast,
    input                               usr_s_axis_rq_tvalid,

    input 				                usr_m_axis_rc_tready,
    output  [C_DATA_WIDTH-1:0]          usr_m_axis_rc_tdata,
    output  [KEEP_WIDTH-1:0]            usr_m_axis_rc_tkeep,
    output                              usr_m_axis_rc_tlast,
    output                              usr_m_axis_rc_tvalid,
    output  [AXI4_RC_TUSER_WIDTH-1:0]   usr_m_axis_rc_tuser

    // Rport CFG interface

    // User CFG interface

    // Rport PL interface
  );

  //--------------------------------------------------------------------------------------------------------------------//
  // Controller <-> All modules
  wire          config_mode;
  wire          config_mode_active;

 
  wire                            pg_s_axis_rq_tready;
  wire [C_DATA_WIDTH-1:0]         pg_s_axis_rq_tdata;
  wire [KEEP_WIDTH-1:0]           pg_s_axis_rq_tkeep;
  wire [AXI4_RQ_TUSER_WIDTH-1:0]  pg_s_axis_rq_tuser;
  wire                            pg_s_axis_rq_tlast;
  wire                            pg_s_axis_rq_tvalid;
  // Controller <-> Packet Generator
  wire [1:0]    pkt_type;
  wire [1:0]    pkt_func_num;
  wire [9:0]    pkt_reg_num;
  wire [3:0]    pkt_1dw_be;
  wire [2:0]    pkt_msg_routing;
  wire [7:0]    pkt_msg_code;
  wire [31:0]   pkt_data;
  wire          pkt_start;
  wire          pkt_done;

  // Completion Decoder -> Controller
  wire          cpl_sc;
  wire          cpl_ur;
  wire          cpl_crs;
  wire          cpl_ca;
  wire [31:0]   cpl_data;
  wire          cpl_mismatch;

  // These signals are not modified internally, so are just passed through
  // this module to user logic

  //--------------------------------------------------------------------------------------------------------------------//
  // Configurator Controller module - controls the Endpoint configuration
  // process
  //--------------------------------------------------------------------------------------------------------------------//
  cgator_controller #(
    .TCQ                  (TCQ),
    .ROM_FILE             (ROM_FILE),
    .ROM_SIZE             (ROM_SIZE)
  ) cgator_controller_i (
    // globals
    .user_clk           (user_clk),
    .reset              (reset),

    // User interface
    .start_config       (start_config),
    .finished_config    (finished_config),
    .failed_config      (failed_config),

    // Packet generator interface
    .pkt_type           (pkt_type),
    .pkt_func_num       (pkt_func_num),
    .pkt_reg_num        (pkt_reg_num),
    .pkt_1dw_be         (pkt_1dw_be),
    .pkt_msg_routing    (pkt_msg_routing),
    .pkt_msg_code       (pkt_msg_code),
    .pkt_data           (pkt_data),
    .pkt_start          (pkt_start),
    .pkt_done           (pkt_done),

    // Tx mux and completion decoder interface
    .config_mode        (config_mode),
    .config_mode_active (config_mode_active),
    .cpl_sc             (cpl_sc),
    .cpl_ur             (cpl_ur),
    .cpl_crs            (cpl_crs),
    .cpl_ca             (cpl_ca),
    .cpl_data           (cpl_data),
    .cpl_mismatch       (cpl_mismatch)
  );

  //--------------------------------------------------------------------------------------------------------------------//
  // Configurator Packet Generator module - generates downstream TLPs as
  // directed by the Controller module
  //--------------------------------------------------------------------------------------------------------------------//
  cgator_pkt_generator #(
    .TCQ          (TCQ),
    .AXISTEN_IF_RQ_ALIGNMENT_MODE   (AXISTEN_IF_RQ_ALIGNMENT_MODE),
    .REQUESTER_ID (REQUESTER_ID),
    .BUSNUMBER    (BUSNUMBER),
    .C_DATA_WIDTH (C_DATA_WIDTH),
    .KEEP_WIDTH   (KEEP_WIDTH)
  ) cgator_pkt_generator_i (
    // globals
    .user_clk             (user_clk),
    .reset                (reset),

    .pg_s_axis_rq_tready  (pg_s_axis_rq_tready),
    .pg_s_axis_rq_tdata   (pg_s_axis_rq_tdata),
    .pg_s_axis_rq_tkeep   (pg_s_axis_rq_tkeep),
    .pg_s_axis_rq_tuser   (pg_s_axis_rq_tuser),
    .pg_s_axis_rq_tlast   (pg_s_axis_rq_tlast),
    .pg_s_axis_rq_tvalid  (pg_s_axis_rq_tvalid),


    // Controller interface
    .pkt_type             (pkt_type),
    .pkt_func_num         (pkt_func_num),
    .pkt_reg_num          (pkt_reg_num),
    .pkt_1dw_be           (pkt_1dw_be),
    .pkt_msg_routing      (pkt_msg_routing),
    .pkt_msg_code         (pkt_msg_code),
    .pkt_data             (pkt_data),
    .pkt_start            (pkt_start),
    .pkt_done             (pkt_done)
  );

  //--------------------------------------------------------------------------------------------------------------------//
  // Configurator Tx Mux module - multiplexes between internally-generated
  // TLP data and user data
  //--------------------------------------------------------------------------------------------------------------------//
  cgator_tx_mux #(
    .TCQ                  (TCQ),
    .C_DATA_WIDTH         (C_DATA_WIDTH),
    .KEEP_WIDTH           (KEEP_WIDTH)
  ) cgator_tx_mux_i (
    // globals
    .user_clk                   (user_clk),
    .reset                      (reset),

    // User Tx AXIS interface

    .usr_s_axis_rq_tready       (usr_s_axis_rq_tready),
    .usr_s_axis_rq_tdata        (usr_s_axis_rq_tdata),
    .usr_s_axis_rq_tkeep        (usr_s_axis_rq_tkeep),
    .usr_s_axis_rq_tuser        (usr_s_axis_rq_tuser),
    .usr_s_axis_rq_tlast        (usr_s_axis_rq_tlast),
    .usr_s_axis_rq_tvalid       (usr_s_axis_rq_tvalid),

    // Packet Generator Tx interface
    .pg_s_axis_rq_tready        (pg_s_axis_rq_tready),
    .pg_s_axis_rq_tdata         (pg_s_axis_rq_tdata),
    .pg_s_axis_rq_tkeep         (pg_s_axis_rq_tkeep),
    .pg_s_axis_rq_tuser         (pg_s_axis_rq_tuser),
    .pg_s_axis_rq_tlast         (pg_s_axis_rq_tlast),
    .pg_s_axis_rq_tvalid        (pg_s_axis_rq_tvalid),

    // Root Port Wrapper Tx interface
    .rport_s_axis_rq_tready     (rport_s_axis_rq_tready),
    .rport_s_axis_rq_tdata      (rport_s_axis_rq_tdata),
    .rport_s_axis_rq_tkeep      (rport_s_axis_rq_tkeep),
    .rport_s_axis_rq_tuser      (rport_s_axis_rq_tuser),
    .rport_s_axis_rq_tlast      (rport_s_axis_rq_tlast),
    .rport_s_axis_rq_tvalid     (rport_s_axis_rq_tvalid),

    // Controller interface
    .config_mode                (config_mode),
    .config_mode_active         (config_mode_active)
  );

  //--------------------------------------------------------------------------------------------------------------------//
  // Configurator Completion Decoder module - receives upstream TLPs and
  // decodes completion status
  //--------------------------------------------------------------------------------------------------------------------//
  cgator_cpl_decoder #(
    .TCQ            (TCQ),
    .EXTRA_PIPELINE (EXTRA_PIPELINE),
    .REQUESTER_ID   (REQUESTER_ID),
    .C_DATA_WIDTH   (C_DATA_WIDTH),
    .KEEP_WIDTH     (KEEP_WIDTH)
  ) cgator_cpl_decoder_i (
    // globals
    .user_clk                 (user_clk),
    .reset                    (reset),

    // Root Port Wrapper Rx interface
    .rport_m_axis_rc_tdata    (rport_m_axis_rc_tdata),
    .rport_m_axis_rc_tkeep    (rport_m_axis_rc_tkeep),
    .rport_m_axis_rc_tlast    (rport_m_axis_rc_tlast),
    .rport_m_axis_rc_tvalid   (rport_m_axis_rc_tvalid),
    .rport_m_axis_rc_tready   (rport_m_axis_rc_tready),
    .rport_m_axis_rc_tuser    (rport_m_axis_rc_tuser),
    // User Rx AXIS interface
    .usr_m_axis_rc_tready     (usr_m_axis_rc_tready),  //2022.11.03 jzhang add flow controller signal.
    .usr_m_axis_rc_tdata      (usr_m_axis_rc_tdata),
    .usr_m_axis_rc_tkeep      (usr_m_axis_rc_tkeep),
    .usr_m_axis_rc_tlast      (usr_m_axis_rc_tlast),
    .usr_m_axis_rc_tvalid     (usr_m_axis_rc_tvalid),
    .usr_m_axis_rc_tuser      (usr_m_axis_rc_tuser),

    // Controller interface
    .config_mode              (config_mode),
    .cpl_sc                   (cpl_sc),
    .cpl_ur                   (cpl_ur),
    .cpl_crs                  (cpl_crs),
    .cpl_ca                   (cpl_ca),
    .cpl_data                 (cpl_data),
    .cpl_mismatch             (cpl_mismatch)
  );
  //--------------------------------------------------------------------------------------------------------------------//

endmodule // cgator

