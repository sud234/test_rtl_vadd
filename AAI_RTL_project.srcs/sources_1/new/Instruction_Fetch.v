`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: Adrian  
// Engineer: Sudarshan
// 
// Create Date: 05.10.2019 16:33:52
// Design Name: Instruction_Fetch
// Module Name: Instruction_Fetch
// Project Name: AAI
// Target Devices: 
// Tool Versions: 
// Description: This module contains instruction memory, Program Counter.
//              This module has storage for instructions and gives out instructions
//              to the Decode module.
// Dependencies: None
// 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//////////////////////////////////////////////////////////////////////////////////

module Instruction_Fetch( i_sys_clk, i_sys_rst, i_inst_mem_data, i_inst_mem_wr_en, 
                          i_freeze, o_PC, o_instruction);
                          
input                           i_sys_clk;
input                           i_sys_rst;

input                           i_freeze;

input    [`INST_LEN - 1 : 0]    i_inst_mem_data;
input                           i_inst_mem_wr_en;

output   [`INST_LEN - 1 : 0]    o_PC,o_instruction;

reg     [`INST_LEN - 1 : 0]     r_Program_Counter;

wire    [`INST_LEN - 1 : 0]     w_PC_mux_out;
wire    [`INST_LEN - 1 : 0]     w_PC_next;

//Program Counter Register
always @ (posedge i_sys_clk)
begin
  if(i_sys_rst == 1'b1)
    r_Program_Counter <= {`WORD_LEN{1'b0}};
  else if(~i_freeze)
    r_Program_Counter <= w_PC_next;
end

//Next value of Program Counter
assign  w_PC_next =  r_Program_Counter + 32'd4;
assign  o_PC      =  r_Program_Counter;

Instruction_Mem Instruction_Mem_inst(
.i_sys_clk          (i_sys_clk),
.i_sys_rst          (i_sys_rst),

.i_inst_mem_data    (i_inst_mem_data),
.i_inst_mem_wr_en   (i_inst_mem_wr_en),

.i_PC               (r_Program_Counter),

.o_intruction       (o_instruction)
);


endmodule
