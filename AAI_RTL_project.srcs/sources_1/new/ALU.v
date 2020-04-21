`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: Adrian  
// Engineer: Sudarshan
// 
// Create Date: 08.10.2019 16:33:52
// Design Name: ALU
// Module Name: ALU
// Project Name: AAI
// Target Devices: 
// Tool Versions: 
// Description: This module performs arithmetic operations depending
//              on the input command.
// Dependencies: None
// 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//////////////////////////////////////////////////////////////////////////////////

module ALU (i_val1, i_val2, i_Execute_cmd, o_aluout);
input [`WORD_LEN-1:0] i_val1, i_val2;
input [`EXE_CMD_LEN-1:0] i_Execute_cmd;
output [`WORD_LEN-1:0] o_aluout;
reg    [`WORD_LEN-1:0] r_aluout;
  always @ ( * ) 
  begin
    case (i_Execute_cmd)
      `EXE_ADD: r_aluout <= i_val1 + i_val2;
      `EXE_SUB: r_aluout <= i_val1 - i_val2;
      `EXE_AND: r_aluout <= i_val1 & i_val2;
      `EXE_OR: r_aluout <= i_val1 | i_val2;
      `EXE_NOR: r_aluout <= ~(i_val1 | i_val2);
      `EXE_XOR: r_aluout <= i_val1 ^ i_val2;
      default: r_aluout <= 0;
    endcase
  end
  assign o_aluout = r_aluout;
  
endmodule
