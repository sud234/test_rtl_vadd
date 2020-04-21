`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Adrian  
// Engineer: Sudarshan
// 
// Create Date: 08.10.2019 16:33:52
// Design Name: Execute_inst
// Module Name: Execute_inst
// Project Name: AAI
// Target Devices: 
// Tool Versions: 
// Description: This module contains ALU and performs arithmetic operations depending
//              on the input. It basically Executes the isntructions
// Dependencies: None
// 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//////////////////////////////////////////////////////////////////////////////////

module Execute_inst( i_sys_clk, i_Execute_cmd, i_value_1, i_value_2,
                     i_ST_value_in, o_ALU_result, o_ST_value_out );

input       i_sys_clk;

input   [`EXE_CMD_LEN-1:0]  i_Execute_cmd;
input   [`WORD_LEN-1:0]     i_value_1,i_value_2,i_ST_value_in;

output  [`WORD_LEN-1:0]     o_ALU_result,o_ST_value_out;

  ALU ALU_inst(
    .i_val1         (i_value_1),
    .i_val2         (i_value_2),
    .i_Execute_cmd  (i_Execute_cmd),
    .o_aluout       (o_ALU_result)
  );

assign  o_ST_value_out = i_ST_value_in;

endmodule