// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (lin64) Build 2258646 Thu Jun 14 20:02:38 MDT 2018
// Date        : Tue Mar  7 10:30:09 2023
// Host        : 192.168.2.203 running 64-bit unknown
// Command     : write_verilog -force -mode synth_stub
//               /home/jzhang/bypass/ips_690t/rp_rc_to_ep_cc_fifo/rp_rc_to_ep_cc_fifo_stub.v
// Design      : rp_rc_to_ep_cc_fifo
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7vx690tffg1761-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_2,Vivado 2018.2" *)
module rp_rc_to_ep_cc_fifo(rst, wr_clk, rd_clk, din, wr_en, rd_en, dout, full, 
  empty, valid, prog_full, wr_rst_busy, rd_rst_busy)
/* synthesis syn_black_box black_box_pad_pin="rst,wr_clk,rd_clk,din[208:0],wr_en,rd_en,dout[208:0],full,empty,valid,prog_full,wr_rst_busy,rd_rst_busy" */;
  input rst;
  input wr_clk;
  input rd_clk;
  input [208:0]din;
  input wr_en;
  input rd_en;
  output [208:0]dout;
  output full;
  output empty;
  output valid;
  output prog_full;
  output wr_rst_busy;
  output rd_rst_busy;
endmodule
