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
// File       : cgator_pkt_generator.v
// Version    : 4.2
// Description : Configurator Packet Generator module - transmits downstream
//               TLPs. Packet type and non-static header and data fields are
//               provided by the Configurator module
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

module cgator_pkt_generator
  #(
    parameter        TCQ          = 1,
    parameter        AXISTEN_IF_RQ_ALIGNMENT_MODE   = "TRUE",
    parameter [15:0] REQUESTER_ID = 16'h10EE,
    parameter [7:0]  BUSNUMBER    = 8'h01,
    parameter C_DATA_WIDTH        = 64,
    parameter KEEP_WIDTH          = C_DATA_WIDTH / 32, 
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
    )
  (
    // globals
    input wire          user_clk,
    input wire          reset,

    // Tx mux interface
    input                          pg_s_axis_rq_tready,
    output reg [C_DATA_WIDTH-1:0]  pg_s_axis_rq_tdata,
    output reg [KEEP_WIDTH-1:0]    pg_s_axis_rq_tkeep,
    output reg [AXI4_RQ_TUSER_WIDTH-1:0]              pg_s_axis_rq_tuser,
    output reg                     pg_s_axis_rq_tlast,
    output reg                     pg_s_axis_rq_tvalid,

    // Controller interface
    input wire [1:0]    pkt_type,  // See TYPE_* below for encodings
    input wire [1:0]    pkt_func_num,
    input wire [9:0]    pkt_reg_num,
    input wire [3:0]    pkt_1dw_be,
    input wire [2:0]    pkt_msg_routing,
    input wire [7:0]    pkt_msg_code,
    input wire [31:0]   pkt_data,
    input wire          pkt_start,
    output reg          pkt_done
  );

  // Encodings for pkt_type
  localparam [1:0] TYPE_CFGRD = 2'b00;
  localparam [1:0] TYPE_CFGWR = 2'b01;
  localparam [1:0] TYPE_MSG   = 2'b10;
  localparam [1:0] TYPE_MSGD  = 2'b11;

  // State encodings
  localparam [2:0] ST_IDLE   = 3'd0;

  localparam [2:0] ST_CFG0   = 3'd1;
  localparam [2:0] ST_CFG1   = 3'd2;
  localparam [2:0] ST_CFG2   = 3'd3;

  localparam [2:0] ST_MSG0   = 3'd4;
  localparam [2:0] ST_MSG1   = 3'd5;
  localparam [2:0] ST_MSG2   = 3'd6;

  // State variable
  reg [2:0]  pkt_state;

  generate
    if (C_DATA_WIDTH == 64) begin : width_64
      // State-machine and controller hand-shake
      always @(posedge user_clk) begin
        if (reset) begin
          pkt_state          <= #TCQ ST_IDLE;
          pkt_done           <= #TCQ 1'b0;
        end else begin
          case (pkt_state)
            ST_IDLE: begin
              // Idle - wait for Controller to request TLP transmission

              pkt_done       <= #TCQ 1'b0;

              if (pkt_start) begin
                if (pkt_type == TYPE_CFGRD || pkt_type == TYPE_CFGWR) begin
                  pkt_state  <= #TCQ ST_CFG0;
                end else begin
                  pkt_state  <= #TCQ ST_CFG0;
                  //pkt_state  <= #TCQ ST_MSG0;
                end
              end
            end // ST_IDLE

            ST_CFG0: begin : beat_1_CFG0
              // First Quad-word (2 dwords) of a CfgRd0 or CfgWr0 TLP
              if (pg_s_axis_rq_tready) begin
                pkt_state    <= #TCQ ST_CFG1;
              end
            end // ST_CFG0

            ST_CFG1: begin : beat_2_CFG0
              // Second QW of a CfgWr0 TLP and last QW of a CfgRd0
              if (pg_s_axis_rq_tready) begin
                 if (pkt_type == TYPE_CFGWR) begin
                     pkt_state    <= #TCQ ST_CFG2;
                 end else begin
                     pkt_state    <= #TCQ ST_IDLE;
                     pkt_done     <= #TCQ 1'b1;
                 end
              end
            end // ST_CFG1

            ST_CFG2: begin : beat_3_CFG0
              // last QW of a CfgWr0 TLP
              if (pg_s_axis_rq_tready) begin
                pkt_state    <= #TCQ ST_IDLE;
                pkt_done     <= #TCQ 1'b1;
              end
            end // ST_CFG2

            ST_MSG0: begin : beat_1_MSG
              // First QW of a Msg or MsgD TLP
              if (pg_s_axis_rq_tready) begin
                pkt_state    <= #TCQ ST_MSG1;
              end
            end // ST_MSG0

            ST_MSG1: begin : beat_2_MSG
              // Second QW of a Msg or MsgD TLP
              if (pg_s_axis_rq_tready) begin
                if (pkt_type == TYPE_MSGD) begin
                  // MsgD TLPs have a third QW
                  pkt_state    <= #TCQ ST_MSG2;
                end else begin
                  // Msg TLPs end after two QWs
                  pkt_state    <= #TCQ ST_IDLE;
                  pkt_done     <= #TCQ 1'b1;
                end
              end
            end // ST_MSG1

            ST_MSG2: begin : beat_3_MSG
              // Third and last QW of a MsgD TLP
              if (pg_s_axis_rq_tready) begin
                pkt_state    <= #TCQ ST_IDLE;
                pkt_done     <= #TCQ 1'b1;
              end
            end // ST_MSG2

            default: begin
              pkt_state      <= #TCQ ST_IDLE;
            end // default case
          endcase
        end
      end

      always @* begin
        case (pkt_state)
          ST_CFG0: begin
            // First QW of a CfgRd0 or CfgWr0 TLP
            pg_s_axis_rq_tlast = 1'b0;
            pg_s_axis_rq_tuser = {32'b0,
                                   4'b1010,      // Seq Number
                                   8'h00,        // TPH Steering Tag
                                   1'b0,         // TPH indirect Tag Enable
                                   2'b0,         // TPH Type
                                   1'b0,         // TPH Present
                                   1'b0,         // Discontinue
                                   3'b000,       // Byte Lane number in case of Address Aligned mode
                                   4'b0,         //last_dw_be_,    // Last BE of the Read Data
                                   pkt_1dw_be};  //first_dw_be_ }; // First BE of the Read Data

            pg_s_axis_rq_tdata = {32'b0,
                                  16'b0,
                                   4'b0,
                                   pkt_reg_num,    // Ext Reg Number, Register Number
                                   2'b00           // Reserved
                                   };
            pg_s_axis_rq_tkeep  = {KEEP_WIDTH{1'b1}};
            pg_s_axis_rq_tvalid = 1'b1;
          end // ST_CFG0

          ST_CFG1: begin
            // Second QW of a CfgWr0 TLP and last QW of a CfgRd0
            pg_s_axis_rq_tlast = (pkt_type == TYPE_CFGWR) ? 1'b0 : 1'b1;
            pg_s_axis_rq_tuser = 60'b0;
            pg_s_axis_rq_tdata = { 1'b0,   // Force ECRC
                                   3'b0,   // Attribute
                                   3'b0,   // TC
                                   1'b0,   // RID

                                   BUSNUMBER,         // Bus #            \
                                   5'b00000,      // Device #         |  Completer ID     //2022.11.03 jzhang
                                   1'b0,          // Function # (Hi)  |
                                   pkt_func_num,  // Function # (Lo)  /
//                                   8'd1,          // Bus #            \
//                                   5'd0,          // Device #         |  Completer ID
//                                   1'b0,          // Function # (Hi)  |
//                                   pkt_func_num, // Function # (Lo)  /
                                   8'b0,   // Tag

                                   REQUESTER_ID, //
                                   1'b0,
                                  (pkt_type == TYPE_CFGRD) ? 4'b1000 : 4'b1010, // Req Type
                                  11'd1 }; 

            pg_s_axis_rq_tkeep  = {KEEP_WIDTH{1'b1}};
            pg_s_axis_rq_tvalid = 1'b1;
          end // ST_CFG1

          ST_CFG2: begin
            // last QW of a CfgWr0 TLP
            pg_s_axis_rq_tlast = 1'b1;
            pg_s_axis_rq_tuser = 60'b0;
            pg_s_axis_rq_tdata = {32'b0,
                                  pkt_data[31:24], 
                                  pkt_data[23:16], 
                                  pkt_data[15: 8], 
                                  pkt_data[ 7: 0] 
                                  };
            pg_s_axis_rq_tkeep  = 2'b1;
            pg_s_axis_rq_tvalid = 1'b1;
          end // ST_CFG2

          ST_MSG0: begin
            // First QW of a Msg or MsgD TLP
            pg_s_axis_rq_tlast = 1'b0;
            pg_s_axis_rq_tuser = {32'b0,
                                   4'b1010,      // Seq Number
                                   8'h00,        // TPH Steering Tag
                                   1'b0,         // TPH indirect Tag Enable
                                   2'b0,         // TPH Type
                                   1'b0,         // TPH Present
                                   1'b0,         // Discontinue
                                   3'b000,       // Byte Lane number in case of Address Aligned mode
                                   4'b0,         //last_dw_be_,    // Last BE of the Read Data
                                   4'b0};        //first_dw_be_ }; // First BE of the Read Data

            pg_s_axis_rq_tdata  = 64'h0000_0000_0000_0000; // Addr[31:2], Reserved, Addr[63:32]

            pg_s_axis_rq_tkeep  = {KEEP_WIDTH{1'b1}};
            pg_s_axis_rq_tvalid = 1'b1;
          end // ST_MSG0

          ST_MSG1: begin
            // Second QW of a Msg or MsgD TLP (last for Msg)
            pg_s_axis_rq_tlast  = (pkt_type == TYPE_MSGD) ? 1'b0 : 1'b1;
            pg_s_axis_rq_tuser = 60'b0;
            pg_s_axis_rq_tdata = { 1'b0,   // Force ECRC
                                   3'b0,   // Attribute
                                   3'b0,   // TC
                                   1'b0,   // RID
                                   5'b0,   // rsvd
                                   pkt_msg_routing,                         // Msg Routing
                                   pkt_msg_code,                            // Message Code
                                   8'b0,   // Tag

                                   REQUESTER_ID, //
                                   1'b0,
                                   4'b1100,   // Req Type
                                  (pkt_type == TYPE_MSGD) ? 11'd1 : 11'd0 }; // Length

            pg_s_axis_rq_tkeep  = {KEEP_WIDTH{1'b1}};
            pg_s_axis_rq_tvalid = 1'b1;
          end // ST_MSG1

          ST_MSG2: begin
            // Third and last QW of a MsgD TLP
            pg_s_axis_rq_tlast  = 1'b1;
            pg_s_axis_rq_tuser = 60'b0;
            pg_s_axis_rq_tdata  = {32'h0000_0000, pkt_data}; // Data, don't-care
            pg_s_axis_rq_tkeep  = 2'h1;
            pg_s_axis_rq_tvalid = 1'b1;
          end // ST_MSG2

          default: begin
            // No TLP active
            pg_s_axis_rq_tlast  = 1'b0;
            pg_s_axis_rq_tuser = 60'b0;
            pg_s_axis_rq_tdata  = 64'h0000_0000_0000_0000;
            pg_s_axis_rq_tkeep  = 8'h00;
            pg_s_axis_rq_tvalid = 1'b0;
          end // default case
        endcase
      end // End 64-bit mode
    end else if (C_DATA_WIDTH == 128) begin : width_128
       // State-machine and controller hand-shake
      always @(posedge user_clk) begin
        if (reset) begin
          pkt_state          <= #TCQ ST_IDLE;
          pkt_done           <= #TCQ 1'b0;
        end else begin
          case (pkt_state)
            ST_IDLE: begin
              // Idle - wait for Controller to request TLP transmission

              pkt_done       <= #TCQ 1'b0;

              if (pkt_start) begin
                if (pkt_type == TYPE_CFGRD || pkt_type == TYPE_CFGWR) begin
                  pkt_state  <= #TCQ ST_CFG0;
                end else begin
                  pkt_state  <= #TCQ ST_MSG0;        //jzhang 2022.11.24 , It is so strange here, why Xilinx engineer comment this line? 
 //                 pkt_state  <= #TCQ ST_CFG0;      //jzhang 2022.11.24 ,  
                end
              end
            end // ST_IDLE

            ST_CFG0: begin : beat_1_CFG0
              // First 2 QW's (4 dwords) of a CfgRd0 or CfgWr0 TLP
              if (pg_s_axis_rq_tready) begin
                 if (pkt_type == TYPE_CFGWR) begin
                     pkt_state    <= #TCQ ST_CFG1;
                 end else begin
                     pkt_state    <= #TCQ ST_IDLE;
                     pkt_done     <= #TCQ 1'b1;
                 end
              end
            end // ST_CFG0

            ST_CFG1: begin : beat_2_CFG0
              // Last 2 QW's (4 dwords) of a CfgWr0 TLP
              if (pg_s_axis_rq_tready) begin
                pkt_state    <= #TCQ ST_IDLE;
                pkt_done     <= #TCQ 1'b1;
              end
            end // ST_CFG1

            ST_MSG0: begin : beat_1_MSG
              // First 2 QW's of a Msg or MsgD TLP
              if (pg_s_axis_rq_tready) begin
                if (pkt_type == TYPE_MSGD) begin
                  pkt_state    <= #TCQ ST_MSG1;
                end else begin
                  pkt_state    <= #TCQ ST_IDLE;
                  pkt_done     <= #TCQ 1'b1;
                end
              end
            end // ST_MSG0

            ST_MSG1: begin : beat_2_MSG
              // Third QW of MsgD TLP
              if (pg_s_axis_rq_tready) begin
                  pkt_state    <= #TCQ ST_IDLE;
                  pkt_done     <= #TCQ 1'b1;
              end
            end // ST_MSG1

            default: begin
              pkt_state      <= #TCQ ST_IDLE;
            end // default case
          endcase
        end
      end

      always @* begin
        case (pkt_state)
          ST_CFG0: begin
            // First 2 QW of a CfgRd0 or CfgWr0 TLP
            pg_s_axis_rq_tlast = (pkt_type == TYPE_CFGWR) ? 1'b0 : 1'b1;
            pg_s_axis_rq_tuser = {32'b0,
                                   4'b1010,      // Seq Number
                                   8'h00,        // TPH Steering Tag
                                   1'b0,         // TPH indirect Tag Enable
                                   2'b0,         // TPH Type
                                   1'b0,         // TPH Present
                                   1'b0,         // Discontinue
                                   3'b000,       // Byte Lane number in case of Address Aligned mode
                                   4'b0,         //last_dw_be_,    // Last BE of the Read Data
                                   pkt_1dw_be};  //first_dw_be_ }; // First BE of the Read Data

            pg_s_axis_rq_tdata = {
                                   1'b0,   // Force ECRC
                                   3'b0,   // Attribute
                                   3'b0,   // TC
                                   1'b1,   // RID  //jzhang 2022.11.24
                                   BUSNUMBER,         // Bus #            \
                                   5'b00000,      // Device #         |  Completer ID     //2022.11.03 jzhang
                                   1'b0,          // Function # (Hi)  |
                                   pkt_func_num,  // Function # (Lo)  /
//                                   8'd1,          // Bus #            \
//                                   5'd0,          // Device #         |  Completer ID
//                                   1'b0,          // Function # (Hi)  |
//                                   pkt_func_num, // Function # (Lo)  /
                                   8'b0,   // Tag

                                   REQUESTER_ID, //
                                   1'b0,
                                  (pkt_type == TYPE_CFGRD) ? 4'b1000 : 4'b1010, // Req Type
                                  11'd1,
                                  32'b0,
                                  16'b0,
                                   4'b0,
                                   pkt_reg_num,    // Ext Reg Number, Register Number
                                   2'b00           // Reserved
                                   };
            pg_s_axis_rq_tkeep  = {KEEP_WIDTH{1'b1}};
            pg_s_axis_rq_tvalid = 1'b1;
          end // ST_CFG0

          ST_CFG1: begin
            pg_s_axis_rq_tdata = {32'b0,
                                  32'b0,
                                  32'b0,
                                  pkt_data[31:24], 
                                  pkt_data[23:16], 
                                  pkt_data[15: 8], 
                                  pkt_data[ 7: 0] 
                                  };
            pg_s_axis_rq_tkeep  = 4'b1;
            pg_s_axis_rq_tvalid = 1'b1;
            pg_s_axis_rq_tlast  = 1'b1;
            pg_s_axis_rq_tuser = 60'b0;
          end // ST_CFG1

          ST_MSG0: begin
            pg_s_axis_rq_tlast  = (pkt_type == TYPE_MSGD) ? 1'b0 : 1'b1;
            pg_s_axis_rq_tuser = {32'b0,
                                   4'b1010,      // Seq Number
                                   8'h00,        // TPH Steering Tag
                                   1'b0,         // TPH indirect Tag Enable
                                   2'b0,         // TPH Type
                                   1'b0,         // TPH Present
                                   1'b0,         // Discontinue
                                   3'b000,       // Byte Lane number in case of Address Aligned mode
                                   4'b0,         //last_dw_be_,    // Last BE of the Read Data
                                   4'b0};        //first_dw_be_ }; // First BE of the Read Data

            pg_s_axis_rq_tdata = { 1'b0,   // Force ECRC
                                   3'b0,   // Attribute
                                   3'b0,   // TC
                                   1'b1,   // RID  //jzhang 2022.11.24
                                   5'b0,   // rsvd
                                   pkt_msg_routing,                         // Msg Routing
                                   pkt_msg_code,                            // Message Code
                                   8'b0,   // Tag

                                   REQUESTER_ID, //
                                   1'b0,
                                   4'b1100,  // Req Type
                                  (pkt_type == TYPE_MSGD) ? 11'd1 : 11'd0,     // Length

                                   64'h0 }; // Addr[31:2], Reserved, Addr[63:32]

            pg_s_axis_rq_tkeep  = {KEEP_WIDTH{1'b1}};
            pg_s_axis_rq_tvalid = 1'b1;
          end // ST_MSG0

          ST_MSG1: begin
            pg_s_axis_rq_tlast  = 1'b1;
            pg_s_axis_rq_tuser = 60'b0;
            pg_s_axis_rq_tdata  = {96'h0000_0000, pkt_data}; // Data, don't-care
            pg_s_axis_rq_tkeep  = 4'b1;
            pg_s_axis_rq_tvalid = 1'b1;
          end // ST_MSG1

          default: begin
            // No TLP active
            pg_s_axis_rq_tlast  = 1'b0;
            pg_s_axis_rq_tuser = 60'b0;
            pg_s_axis_rq_tdata  = {C_DATA_WIDTH{1'b0}};
            pg_s_axis_rq_tkeep  = {KEEP_WIDTH{1'b0}};
            pg_s_axis_rq_tvalid = 1'b0;
          end // default case
        endcase
      end
    end // End 128-bit Mode
    else begin : width_256
       // State-machine and controller hand-shake
      always @(posedge user_clk) begin
        if (reset) begin
          pkt_state          <= #TCQ ST_IDLE;
          pkt_done           <= #TCQ 1'b0;
        end else begin
          case (pkt_state)
            ST_IDLE: begin
              // Idle - wait for Controller to request TLP transmission

              pkt_done       <= #TCQ 1'b0;

              if (pkt_start) begin
                if (pkt_type == TYPE_CFGRD || pkt_type == TYPE_CFGWR) begin
                  pkt_state  <= #TCQ ST_CFG0;
                end else begin
//                  pkt_state  <= #TCQ ST_MSG0;
                  pkt_state  <= #TCQ ST_CFG0;
                end
              end
            end // ST_IDLE

            ST_CFG0: begin : beat_1_CFG0
              // First 2 QW's (4 dwords) of a CfgRd0 or CfgWr0 TLP
              if (pg_s_axis_rq_tready) begin
	        if(AXISTEN_IF_RQ_ALIGNMENT_MODE == "TRUE" && (pkt_type == TYPE_CFGWR || pkt_type == TYPE_MSGD)) begin
                  pkt_state    <= #TCQ ST_CFG1;
                  pkt_done     <= #TCQ 1'b0;
		end
		else begin 
                  pkt_state    <= #TCQ ST_IDLE;
                  pkt_done     <= #TCQ 1'b1;
		end
              end
            end // ST_CFG0
            ST_CFG1: begin : beat_2_CFG0
              // First 2 QW's (4 dwords) of a CfgRd0 or CfgWr0 TLP
              if (pg_s_axis_rq_tready) begin
                pkt_state    <= #TCQ ST_IDLE;
                pkt_done     <= #TCQ 1'b1;
              end
            end // ST_CFG1

            ST_MSG0: begin : beat_0_MSG
              // First 2 QW's of a Msg or MsgD TLP
	        if(AXISTEN_IF_RQ_ALIGNMENT_MODE == "TRUE" && pkt_type == TYPE_MSGD) begin
                  pkt_state    <= #TCQ ST_MSG1;
                  pkt_done     <= #TCQ 1'b0;
		end
		else begin 
                  pkt_state    <= #TCQ ST_IDLE;
                  pkt_done     <= #TCQ 1'b1;
		end
            end // ST_MSG0
            ST_MSG1: begin : beat_1_MSG
              // First 2 QW's of a Msg or MsgD TLP
              if (pg_s_axis_rq_tready) begin
                  pkt_state    <= #TCQ ST_IDLE;
                  pkt_done     <= #TCQ 1'b1;
                end
            end // ST_MSG1

            default: begin
              pkt_state      <= #TCQ ST_IDLE;
            end // default case
          endcase
        end
      end

      always @* begin
        case (pkt_state)
          ST_CFG0: begin
            pg_s_axis_rq_tuser = {32'b0,
                                   4'b1010,      // Seq Number
                                   8'h00,        // TPH Steering Tag
                                   1'b0,         // TPH indirect Tag Enable
                                   2'b0,         // TPH Type
                                   1'b0,         // TPH Present
                                   1'b0,         // Discontinue
                                   3'b000,       // Byte Lane number in case of Address Aligned mode
                                   4'b0,         //last_dw_be_,    // Last BE of the Read Data
                                   pkt_1dw_be};  //first_dw_be_ }; // First BE of the Read Data

            pg_s_axis_rq_tdata = {96'b0,
                                  (pkt_type == TYPE_CFGWR && AXISTEN_IF_RQ_ALIGNMENT_MODE == "FALSE" ) ? pkt_data : 32'b0,  
                                   1'b0,   // Force ECRC
                                   3'b0,   // Attribute
                                   3'b0,   // TC
                                   1'b0,   // RID
                                   BUSNUMBER,         // Bus #            \
                                   5'b00000,      // Device #         |  Completer ID  //2022.11.03 jzhang
                                   1'b0,          // Function # (Hi)  |
                                   pkt_func_num,  // Function # (Lo)  /
//                                   8'd1,          // Bus #            \
//                                   5'd0,          // Device #         |  Completer ID
//                                   1'b0,          // Function # (Hi)  |
//                                   pkt_func_num, // Function # (Lo)  /
                                   8'b0,   // Tag

                                   REQUESTER_ID, //
                                   1'b0,
                                  (pkt_type == TYPE_CFGRD) ? 4'b1000 : 4'b1010, // Req Type
                                  11'd1,
                                  32'b0,
                                  16'b0,
                                   4'b0,
                                   pkt_reg_num,    // Ext Reg Number, Register Number
                                   2'b00           // Reserved
                                   };

            pg_s_axis_rq_tvalid = 1'b1;

	    if(AXISTEN_IF_RQ_ALIGNMENT_MODE == "TRUE" && (pkt_type == TYPE_CFGWR || pkt_type == TYPE_MSGD)) begin
              pg_s_axis_rq_tkeep  =  8'hFF;
              pg_s_axis_rq_tlast = 1'b0;
	    end else begin
              pg_s_axis_rq_tkeep  = (pkt_type == TYPE_CFGWR) ? 8'h1F : 8'h0F;
              pg_s_axis_rq_tlast = 1'b1;
	    end


          end // ST_CFG0
          ST_CFG1: begin
            pg_s_axis_rq_tdata = {224'b0,
                                  pkt_data[31:24], 
                                  pkt_data[23:16], 
                                  pkt_data[15: 8], 
                                  pkt_data[ 7: 0] 
                                  };
            pg_s_axis_rq_tkeep  = 8'b1;
            pg_s_axis_rq_tvalid = 1'b1;
            pg_s_axis_rq_tlast  = 1'b1;
            pg_s_axis_rq_tuser = 60'b0;
          end // ST_CFG1

          ST_MSG0: begin
            pg_s_axis_rq_tuser = {32'b0,
                                   4'b1010,      // Seq Number
                                   8'h00,        // TPH Steering Tag
                                   1'b0,         // TPH indirect Tag Enable
                                   2'b0,         // TPH Type
                                   1'b0,         // TPH Present
                                   1'b0,         // Discontinue
                                   3'b000,       // Byte Lane number in case of Address Aligned mode
                                   4'b0,         //last_dw_be_,    // Last BE of the Read Data
                                   4'b0};        //first_dw_be_ }; // First BE of the Read Data

            pg_s_axis_rq_tdata = { 96'b0,
                                   (pkt_type == TYPE_MSGD && AXISTEN_IF_RQ_ALIGNMENT_MODE == "FALSE" ) ? pkt_data : 32'b0,  
                                   1'b0,   // Force ECRC
                                   3'b0,   // Attribute
                                   3'b0,   // TC
                                   1'b0,   // RID
                                   5'b0,   // rsvd
                                   pkt_msg_routing,                         // Msg Routing
                                   pkt_msg_code,                            // Message Code
                                   8'b0,   // Tag

                                   REQUESTER_ID, //
                                   1'b0,
                                   4'b1100, // Req Type
                                  (pkt_type == TYPE_MSGD) ? 11'd1 : 11'd0,     // Length

                                   64'h0 }; // Addr[31:2], Reserved, Addr[63:32]

            pg_s_axis_rq_tvalid = 1'b0;

	    if(AXISTEN_IF_RQ_ALIGNMENT_MODE == "TRUE" && pkt_type == TYPE_MSGD) begin
              pg_s_axis_rq_tkeep  =  8'hFF;
              pg_s_axis_rq_tlast  = 1'b0;
	    end else begin
              pg_s_axis_rq_tkeep  = (pkt_type == TYPE_MSGD) ? 8'h1F : 8'h0F;
              pg_s_axis_rq_tlast  = 1'b1;
	    end

          end // ST_MSG0
          ST_MSG1: begin
            pg_s_axis_rq_tdata = {224'b0, pkt_data};
            pg_s_axis_rq_tkeep  = 8'b1;
            pg_s_axis_rq_tvalid = 1'b1;
            pg_s_axis_rq_tlast  = 1'b1;
            pg_s_axis_rq_tuser = 60'b0;
          end // ST_MSG1

          default: begin
            // No TLP active
            pg_s_axis_rq_tlast  = 1'b0;
            pg_s_axis_rq_tuser = 60'b0;
            pg_s_axis_rq_tdata  = {C_DATA_WIDTH{1'b0}};
            pg_s_axis_rq_tkeep  = {KEEP_WIDTH{1'b0}};
            pg_s_axis_rq_tvalid = 1'b0;
          end // default case
        endcase
      end
    end // End 256-bit Mode
    endgenerate

endmodule // cgator_pkt_generator