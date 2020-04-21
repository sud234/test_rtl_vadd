`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: Adrian  
// Engineer: Sudarshan
// 
// Create Date: 05.10.2019 16:33:52
// Design Name: Instruction_Mem 
// Module Name: Instruction_Mem
// Project Name: AAI
// Target Devices: 
// Tool Versions: 
// Description: This module contains instructions and gives out Instructions based 
//              based on PC.
// Dependencies: None
// 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//////////////////////////////////////////////////////////////////////////////////


module Instruction_Mem( i_sys_clk, i_sys_rst, i_inst_mem_data, i_inst_mem_wr_en,
                        i_PC, o_intruction);

input                           i_sys_clk;
input                           i_sys_rst;

input    [`INST_LEN - 1 : 0]    i_inst_mem_data;
input                           i_inst_mem_wr_en;

input    [`INST_LEN - 1 : 0]    i_PC;

output   [`INST_LEN - 1 : 0]    o_intruction;

reg     [15 : 0]                r_inst_mem_wr_add = 16'd0;
reg                             r_sys_rst;

wire    [15 : 0]                w_inst_mem_rd_add;
wire                            w_sys_rst;

assign      w_inst_mem_rd_add   = i_PC[17:2];   //Divided by 4

inst_mem inst_mem_inst (
  .a(r_inst_mem_wr_add),        // input wire [15 : 0] a
  .d(i_inst_mem_data),        // input wire [31 : 0] d
  .dpra(w_inst_mem_rd_add),  // input wire [15 : 0] dpra
  .clk(i_sys_clk),    // input wire clk
  .we(i_inst_mem_wr_en),      // input wire we
  .dpo(o_intruction)    // output wire [31 : 0] dpo
);

always @ (posedge i_sys_clk)
begin
  r_sys_rst<=   i_sys_rst;
end

assign  w_sys_rst = i_sys_rst & ~r_sys_rst;

always @ (posedge i_sys_clk)
begin
  if(w_sys_rst)
    r_inst_mem_wr_add <= 16'd0;
  else if(i_inst_mem_wr_en)
    r_inst_mem_wr_add <= r_inst_mem_wr_add + 16'd1;
end

endmodule
