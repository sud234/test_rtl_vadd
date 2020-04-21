`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: Adrian  
// Engineer: Sudarshan
// 
// Create Date: 08.10.2019 16:33:52
// Design Name: Memory_access
// Module Name: Memory_access
// Project Name: AAI
// Target Devices: 
// Tool Versions: 
// Description: This module contains data memory which stores and gives out the 
//              resultant data.
// Dependencies: None
// 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//////////////////////////////////////////////////////////////////////////////////

module Memory_access ( i_sys_clk, i_sys_rst, i_Mem_wr_en, i_Mem_rd_en,
                       i_ALU_res, i_ST_value, o_datamem_out);
  input i_sys_clk, i_sys_rst, i_Mem_wr_en, i_Mem_rd_en;
  input [`WORD_LEN-1:0] i_ALU_res, i_ST_value;
  output [`WORD_LEN-1:0] o_datamem_out;
wire   [`WORD_LEN-1:0] doutb;

//d_mem_1k d_mem (
//  .a(i_ALU_res[9:0]),      // input wire [9 : 0] a
//  .d(i_ST_value),      // input wire [31 : 0] d
//  .clk(i_sys_clk),  // input wire clk
//  .we(i_Mem_wr_en),    // input wire we
//  .spo(o_datamem_out)  // output wire [31 : 0] spo
//);

wide_mem_1k w_mem (
  .clka(i_sys_clk),    // input wire clka
  .wea(i_Mem_wr_en),      // input wire [0 : 0] wea
  .addra(i_ALU_res[9:0]),  // input wire [9 : 0] addra
  .dina(i_ST_value),    // input wire [4095 : 0] dina
  .douta(o_datamem_out),  // output wire [4095 : 0] douta
  .clkb(i_sys_clk),    // input wire clkb
  .enb(1'b1),      // input wire enb
  .web(1'b0),      // input wire [0 : 0] web
  .addrb(10'd0),  // input wire [9 : 0] addrb
  .dinb(4096'd0),    // input wire [4095 : 0] dinb
  .doutb(doutb)  // output wire [4095 : 0] doutb
);

endmodule