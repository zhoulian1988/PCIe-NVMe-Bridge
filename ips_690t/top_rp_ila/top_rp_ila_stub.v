// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (lin64) Build 2258646 Thu Jun 14 20:02:38 MDT 2018
// Date        : Wed Nov 23 11:59:21 2022
// Host        : 192.168.2.203 running 64-bit unknown
// Command     : write_verilog -force -mode synth_stub /home/jzhang/bypass/ips_690t/top_rp_ila/top_rp_ila_stub.v
// Design      : top_rp_ila
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7vx690tffg1761-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ila,Vivado 2018.2" *)
module top_rp_ila(clk, probe0, probe1, probe2, probe3, probe4, probe5, 
  probe6, probe7, probe8, probe9, probe10, probe11, probe12, probe13, probe14, probe15, probe16, probe17, 
  probe18, probe19, probe20, probe21, probe22, probe23, probe24, probe25, probe26, probe27, probe28, 
  probe29)
/* synthesis syn_black_box black_box_pad_pin="clk,probe0[0:0],probe1[0:0],probe2[0:0],probe3[3:0],probe4[127:0],probe5[84:0],probe6[0:0],probe7[0:0],probe8[0:0],probe9[3:0],probe10[127:0],probe11[32:0],probe12[0:0],probe13[0:0],probe14[0:0],probe15[3:0],probe16[127:0],probe17[59:0],probe18[0:0],probe19[0:0],probe20[0:0],probe21[3:0],probe22[127:0],probe23[74:0],probe24[0:0],probe25[5:0],probe26[1:0],probe27[5:0],probe28[3:0],probe29[7:0]" */;
  input clk;
  input [0:0]probe0;
  input [0:0]probe1;
  input [0:0]probe2;
  input [3:0]probe3;
  input [127:0]probe4;
  input [84:0]probe5;
  input [0:0]probe6;
  input [0:0]probe7;
  input [0:0]probe8;
  input [3:0]probe9;
  input [127:0]probe10;
  input [32:0]probe11;
  input [0:0]probe12;
  input [0:0]probe13;
  input [0:0]probe14;
  input [3:0]probe15;
  input [127:0]probe16;
  input [59:0]probe17;
  input [0:0]probe18;
  input [0:0]probe19;
  input [0:0]probe20;
  input [3:0]probe21;
  input [127:0]probe22;
  input [74:0]probe23;
  input [0:0]probe24;
  input [5:0]probe25;
  input [1:0]probe26;
  input [5:0]probe27;
  input [3:0]probe28;
  input [7:0]probe29;
endmodule
