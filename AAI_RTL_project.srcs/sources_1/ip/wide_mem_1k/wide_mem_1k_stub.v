// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
// Date        : Thu Feb  6 22:07:20 2020
// Host        : sud_shenoy running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               D:/Freelance/AAI_RTL_project/AAI_RTL_project.srcs/sources_1/ip/wide_mem_1k/wide_mem_1k_stub.v
// Design      : wide_mem_1k
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k160tfbg676-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_1,Vivado 2018.2" *)
module wide_mem_1k(clka, wea, addra, dina, douta, clkb, enb, web, addrb, dinb, 
  doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[9:0],dina[4095:0],douta[4095:0],clkb,enb,web[0:0],addrb[9:0],dinb[4095:0],doutb[4095:0]" */;
  input clka;
  input [0:0]wea;
  input [9:0]addra;
  input [4095:0]dina;
  output [4095:0]douta;
  input clkb;
  input enb;
  input [0:0]web;
  input [9:0]addrb;
  input [4095:0]dinb;
  output [4095:0]doutb;
endmodule
