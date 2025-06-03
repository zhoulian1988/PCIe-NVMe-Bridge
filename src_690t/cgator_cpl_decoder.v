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
// File       : cgator_cpl_decoder.v
// Version    : 4.2
// Description : Configurator Completion Decoder module - receives incoming
//               TLPs and checks completion status. When in config mode, all
//               received TLPs are consumed by this module. When not in config
//               mode, all TLPs are passed to user logic
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

module cgator_cpl_decoder
  #(
    parameter           TCQ            = 1,
    parameter           EXTRA_PIPELINE = 1,
    parameter [15:0]    REQUESTER_ID   = 16'h10EE,
    parameter           C_DATA_WIDTH   = 64,
    parameter           KEEP_WIDTH     = C_DATA_WIDTH / 32,
    
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
    input wire          user_clk,

    input wire          reset,

    // Root Port Wrapper Rx interface

    // Rx
    input  [C_DATA_WIDTH-1:0]     rport_m_axis_rc_tdata,
    input  [KEEP_WIDTH-1:0]       rport_m_axis_rc_tkeep,
    input                         rport_m_axis_rc_tlast,
    input                         rport_m_axis_rc_tvalid,
    output                        rport_m_axis_rc_tready,
    input    [74:0]               rport_m_axis_rc_tuser,



    // User Rx interface
    input                                   usr_m_axis_rc_tready, //2022.11.03 jzhang add flow controller signal.
/*    
    output reg [C_DATA_WIDTH-1:0]           usr_m_axis_rc_tdata,
    output reg [KEEP_WIDTH-1:0]             usr_m_axis_rc_tkeep,
    output reg                              usr_m_axis_rc_tlast,
    output reg                              usr_m_axis_rc_tvalid,
    output reg [AXI4_RC_TUSER_WIDTH-1:0]    usr_m_axis_rc_tuser,
*/
    
    output [C_DATA_WIDTH-1:0]           usr_m_axis_rc_tdata,   //2023.03.06 jzhang delete the pipeline
    output [KEEP_WIDTH-1:0]             usr_m_axis_rc_tkeep,
    output                              usr_m_axis_rc_tlast,
    output                              usr_m_axis_rc_tvalid,
    output [AXI4_RC_TUSER_WIDTH-1:0]    usr_m_axis_rc_tuser,
    

    // Controller interface
    input wire          config_mode,
    output reg          cpl_sc,
    output reg          cpl_ur,
    output reg          cpl_crs,
    output reg          cpl_ca,
    output reg [31:0]   cpl_data,
    output reg          cpl_mismatch
  );

  // Bit-slicing positions for decoding header fields
  localparam FMT_TYPE_HI   = 30;
  localparam FMT_TYPE_LO   = 24;
  localparam CPL_STAT_HI   = 47;
  localparam CPL_STAT_LO   = 45;
  localparam CPL_DATA_HI   = 63;
  localparam CPL_DATA_LO   = 32;
  localparam REQ_ID_HI     = 31;
  localparam REQ_ID_LO     = 16;

  localparam CPL_DATA_HI_128 = 127;
  localparam CPL_DATA_LO_128 = 96;
  localparam REQ_ID_HI_128   = 95;
  localparam REQ_ID_LO_128   = 80;

  // Static field values for comparison
  localparam FMT_TYPE_CPLX = 6'b001010;
  localparam SC_STATUS     = 3'b000;
  localparam UR_STATUS     = 3'b001;
  localparam CRS_STATUS    = 3'b010;
  localparam CA_STATUS     = 3'b100;

  // Local variables
  reg    [C_DATA_WIDTH-1:0]     pipe_m_axis_rc_tdata;
  reg    [KEEP_WIDTH-1:0]       pipe_m_axis_rc_tkeep;
  reg                           pipe_m_axis_rc_tlast;
  reg                           pipe_m_axis_rc_tvalid;
  reg [AXI4_RC_TUSER_WIDTH-1:0] pipe_m_axis_rc_tuser;
  reg                           pipe_rx_np_ok;
  reg                           pipe_rsop;

  reg [C_DATA_WIDTH-1:0]  check_rd;
  reg         check_rsop;
  reg         check_rsrc_rdy;
  reg [2:0]   cpl_status;
  reg         cpl_detect;

  wire        sop;                   // Start of packet
  wire        check_cpl_cpld;
 
  // Dst rdy and rNP OK are always asserted to Root Port wrapper
  //assign rport_m_axis_rc_tready = 1'b1;
  assign rport_m_axis_rc_tready = usr_m_axis_rc_tready;  //2022.11.03 jzhang add flow controller signal.


  // start of packet generation
  assign sop = (rport_m_axis_rc_tuser[32] && rport_m_axis_rc_tvalid);

  // Data-path with one or two pipeline stages
  always @(posedge user_clk) begin
    if (reset) begin
      pipe_m_axis_rc_tdata   <= #TCQ {C_DATA_WIDTH{1'b0}};
      pipe_m_axis_rc_tkeep   <= #TCQ {KEEP_WIDTH{1'b0}};
      pipe_m_axis_rc_tlast   <= #TCQ 1'b0;
      pipe_m_axis_rc_tvalid  <= #TCQ 1'b0;
      pipe_m_axis_rc_tuser   <= #TCQ {AXI4_RC_TUSER_WIDTH{1'b0}};
      pipe_rx_np_ok          <= #TCQ 1'b0;
      pipe_rsop              <= #TCQ 1'b0;

/*
      usr_m_axis_rc_tdata    <= #TCQ {C_DATA_WIDTH{1'b0}};
      usr_m_axis_rc_tkeep    <= #TCQ {KEEP_WIDTH{1'b0}};
      usr_m_axis_rc_tlast    <= #TCQ 1'b0;
      usr_m_axis_rc_tvalid   <= #TCQ 1'b0;
      usr_m_axis_rc_tuser    <= #TCQ {AXI4_RC_TUSER_WIDTH{1'b0}};
*/      

    end else begin

      pipe_m_axis_rc_tdata   <= #TCQ rport_m_axis_rc_tdata;
      pipe_m_axis_rc_tkeep   <= #TCQ rport_m_axis_rc_tkeep;
      pipe_m_axis_rc_tlast   <= #TCQ rport_m_axis_rc_tlast;
      pipe_m_axis_rc_tvalid  <= #TCQ rport_m_axis_rc_tvalid;
      pipe_m_axis_rc_tuser   <= #TCQ rport_m_axis_rc_tuser;
      pipe_rsop              <= #TCQ sop;
/*
      usr_m_axis_rc_tdata    <= #TCQ (EXTRA_PIPELINE == 1) ? pipe_m_axis_rc_tdata     : rport_m_axis_rc_tdata;
      usr_m_axis_rc_tkeep    <= #TCQ (EXTRA_PIPELINE == 1) ? pipe_m_axis_rc_tkeep     : rport_m_axis_rc_tkeep;
      usr_m_axis_rc_tlast    <= #TCQ (EXTRA_PIPELINE == 1) ? pipe_m_axis_rc_tlast     : rport_m_axis_rc_tlast;
      usr_m_axis_rc_tvalid   <= #TCQ (EXTRA_PIPELINE == 1) ? (pipe_m_axis_rc_tvalid && !config_mode) :
                                                            (rport_m_axis_rc_tvalid && !config_mode);
      usr_m_axis_rc_tuser    <= #TCQ (EXTRA_PIPELINE == 1) ? pipe_m_axis_rc_tuser     : rport_m_axis_rc_tuser;
*/      
    end
  end

assign usr_m_axis_rc_tdata   = rport_m_axis_rc_tdata;
assign usr_m_axis_rc_tkeep   = rport_m_axis_rc_tkeep;
assign usr_m_axis_rc_tlast   = rport_m_axis_rc_tlast;
assign usr_m_axis_rc_tvalid  = rport_m_axis_rc_tvalid && !config_mode;
assign usr_m_axis_rc_tuser   = rport_m_axis_rc_tuser;

  //
  // Completion processing
  //

  // Select input to completion decoder depending on whether extra pipeline
  // stage is selected
  always @* begin
    check_rd         = EXTRA_PIPELINE ? pipe_m_axis_rc_tdata    : rport_m_axis_rc_tdata;
    check_rsop       = EXTRA_PIPELINE ? pipe_rsop               : sop;
    check_rsrc_rdy   = EXTRA_PIPELINE ? pipe_m_axis_rc_tvalid   : rport_m_axis_rc_tvalid;
  end

  generate
    if (C_DATA_WIDTH == 64) begin : width_64
    assign check_cpl_cpld = EXTRA_PIPELINE ? (pipe_m_axis_rc_tkeep[1] && pipe_m_axis_rc_tuser[7]) : (rport_m_axis_rc_tkeep[1] && rport_m_axis_rc_tuser[7]);

      // Process first QW of received TLP - Check for Cpl or CplD type and capture
      // completion status
      always @(posedge user_clk) begin : beat_1_64
        if (reset) begin
          cpl_status     <= #TCQ 3'b000;
          cpl_detect     <= #TCQ 1'b0;
        end else begin

          if (check_rsop && check_rsrc_rdy) begin
            // Check for Start of Frame

            if (check_rd[30]) begin
              // Check Format and Type fields to see whether this is a Cpl or
              // CplD. If so, set the cpl_detect bit for the next pipeline stage.
              cpl_detect   <= #TCQ 1'b1;

              // Capture Completion Status header field
              cpl_status   <= #TCQ check_rd[45:43];

            end else begin
              // Not a Cpl or CplD TLP
              cpl_detect   <= #TCQ 1'b0;
            end

          end else begin
            cpl_detect     <= #TCQ 1'b0;
          end
        end
      end

      // Process second QW of received TLP - check Requester ID and output
      // status bits and data Dword
      always @(posedge user_clk) begin : beat_2_64
        if (reset) begin
          cpl_sc         <= #TCQ 1'b0;
          cpl_ur         <= #TCQ 1'b0;
          cpl_crs        <= #TCQ 1'b0;
          cpl_ca         <= #TCQ 1'b0;
          cpl_mismatch   <= #TCQ 1'b0;
          cpl_data       <= #TCQ 32'd0;
        end else begin
          if (cpl_detect) begin
            // a Cpl or CplD TLP
            // Capture data
             if (check_cpl_cpld) begin
                 cpl_data       <= #TCQ check_rd[CPL_DATA_HI:CPL_DATA_LO];
             end
            if (check_rd[23:8] == REQUESTER_ID) begin
              // If requester ID matches, check Completion Status field
              cpl_sc       <= #TCQ (cpl_status == SC_STATUS);
              cpl_ur       <= #TCQ (cpl_status == UR_STATUS);
              cpl_crs      <= #TCQ (cpl_status == CRS_STATUS);
              cpl_ca       <= #TCQ (cpl_status == CA_STATUS);
              cpl_mismatch <= #TCQ 1'b0;

            end else begin
              // If Requester ID doesn't match, set mismatch indicator
              cpl_sc       <= #TCQ 1'b0;
              cpl_ur       <= #TCQ 1'b0;
              cpl_crs      <= #TCQ 1'b0;
              cpl_ca       <= #TCQ 1'b0;
              cpl_mismatch <= #TCQ 1'b1;
            end

          end else begin
            // Not start-of-frame
            cpl_sc         <= #TCQ 1'b0;
            cpl_ur         <= #TCQ 1'b0;
            cpl_crs        <= #TCQ 1'b0;
            cpl_ca         <= #TCQ 1'b0;
            cpl_mismatch   <= #TCQ 1'b0;
          end

        end
      end
    end else if (C_DATA_WIDTH == 128) begin : width_128
    assign check_cpl_cpld = EXTRA_PIPELINE ? (pipe_m_axis_rc_tkeep[3] && pipe_m_axis_rc_tuser[15]) : (rport_m_axis_rc_tkeep[3] && rport_m_axis_rc_tuser[15]);

      // Process first 2 QW's of received TLP - Check for Cpl or CplD type and capture
      // completion status
      always @(posedge user_clk) begin
        if (reset) begin
          cpl_status     <= #TCQ 3'b000;
          cpl_detect     <= #TCQ 1'b0;
          cpl_sc         <= #TCQ 1'b0;
          cpl_ur         <= #TCQ 1'b0;
          cpl_crs        <= #TCQ 1'b0;
          cpl_ca         <= #TCQ 1'b0;
          cpl_data       <= #TCQ 32'd0;
          cpl_mismatch   <= #TCQ 1'b0;
        end else begin
          if (check_rsop && check_rsrc_rdy) begin
            // Check for Start of Frame

            if (check_rd[30]) begin
                cpl_detect     <= #TCQ 1'b1;  

              //if (check_rd[87:72] == REQUESTER_ID) begin  //jzhang 2022.11.24  here is a bug of Xilinx
              if (check_rd[63:48] == REQUESTER_ID) begin    //jzhang 2022.11.24
                // If requester ID matches, check Completion Status field
                cpl_sc       <= #TCQ (check_rd[45:43] == SC_STATUS);
                cpl_ur       <= #TCQ (check_rd[45:43] == UR_STATUS);
                cpl_crs      <= #TCQ (check_rd[45:43] == CRS_STATUS);
                cpl_ca       <= #TCQ (check_rd[45:43] == CA_STATUS);
                cpl_mismatch <= #TCQ 1'b0;
              end else begin
                cpl_sc       <= #TCQ 1'b0;
                cpl_ur       <= #TCQ 1'b0;
                cpl_crs      <= #TCQ 1'b0;
                cpl_ca       <= #TCQ 1'b0;
                cpl_mismatch <= #TCQ 1'b1;
              end

            // Capture data
             if (check_cpl_cpld) begin
                 cpl_data       <= #TCQ check_rd[CPL_DATA_HI_128:CPL_DATA_LO_128];
             end
            
            end else begin
              // Not a Cpl or CplD TLP
              cpl_data     <= #TCQ {C_DATA_WIDTH{1'b0}};
              cpl_sc       <= #TCQ 1'b0;
              cpl_ur       <= #TCQ 1'b0;
              cpl_crs      <= #TCQ 1'b0;
              cpl_ca       <= #TCQ 1'b0;
              cpl_mismatch <= #TCQ 1'b0;
            end

          end else begin
            // Not start-of-frame
            cpl_data     <= #TCQ {C_DATA_WIDTH{1'b0}};
            cpl_sc       <= #TCQ 1'b0;
            cpl_ur       <= #TCQ 1'b0;
            cpl_crs      <= #TCQ 1'b0;
            cpl_ca       <= #TCQ 1'b0;
            cpl_mismatch <= #TCQ 1'b0;
          end
        end   
   end              
 /*     
      rp_ila_2 rp_ila_2_i (
          .clk(user_clk),
          
          .probe0(cpl_detect),     // 1
          .probe1(check_rsop),     // 1
          .probe2(config_mode),    // 1
          .probe3(cpl_mismatch),   // 1
          .probe4(check_rd)        // 128     
          ); */
          
          
    end else begin : width_256
    assign check_cpl_cpld = EXTRA_PIPELINE ? (pipe_m_axis_rc_tkeep[3] && pipe_m_axis_rc_tuser[15]) : (rport_m_axis_rc_tkeep[3] && rport_m_axis_rc_tuser[15]);

      // Process first 2 QW's of received TLP - Check for Cpl or CplD type and capture
      // completion status
      always @(posedge user_clk) begin
        if (reset) begin
          cpl_status     <= #TCQ 3'b000;
          cpl_detect     <= #TCQ 1'b0;
          cpl_sc         <= #TCQ 1'b0;
          cpl_ur         <= #TCQ 1'b0;
          cpl_crs        <= #TCQ 1'b0;
          cpl_ca         <= #TCQ 1'b0;
          cpl_data       <= #TCQ 32'd0;
          cpl_mismatch   <= #TCQ 1'b0;
        end else begin
          if (check_rsop && check_rsrc_rdy) begin
            // Check for Start of Frame

            if (check_rd[30]) begin
                cpl_detect     <= #TCQ 1'b1;  

              if (check_rd[87:72] == REQUESTER_ID) begin
                // If requester ID matches, check Completion Status field
                cpl_sc       <= #TCQ (check_rd[45:43] == SC_STATUS);
                cpl_ur       <= #TCQ (check_rd[45:43] == UR_STATUS);
                cpl_crs      <= #TCQ (check_rd[45:43] == CRS_STATUS);
                cpl_ca       <= #TCQ (check_rd[45:43] == CA_STATUS);
                cpl_mismatch <= #TCQ 1'b0;
              end else begin
                cpl_sc       <= #TCQ 1'b0;
                cpl_ur       <= #TCQ 1'b0;
                cpl_crs      <= #TCQ 1'b0;
                cpl_ca       <= #TCQ 1'b0;
                cpl_mismatch <= #TCQ 1'b1;
              end

            // Capture data
             if (check_cpl_cpld) begin
                 cpl_data       <= #TCQ check_rd[CPL_DATA_HI_128:CPL_DATA_LO_128];
             end

            end else begin
              // Not a Cpl or CplD TLP
              cpl_data     <= #TCQ {C_DATA_WIDTH{1'b0}};
              cpl_sc       <= #TCQ 1'b0;
              cpl_ur       <= #TCQ 1'b0;
              cpl_crs      <= #TCQ 1'b0;
              cpl_ca       <= #TCQ 1'b0;
              cpl_mismatch <= #TCQ 1'b0;
            end

          end else begin
            // Not start-of-frame
            cpl_data     <= #TCQ {C_DATA_WIDTH{1'b0}};
            cpl_sc       <= #TCQ 1'b0;
            cpl_ur       <= #TCQ 1'b0;
            cpl_crs      <= #TCQ 1'b0;
            cpl_ca       <= #TCQ 1'b0;
            cpl_mismatch <= #TCQ 1'b0;
          end
        end
      end
    end
    endgenerate





endmodule // cgator_cpl_decoder

