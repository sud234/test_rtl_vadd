`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: Adrian  
// Engineer: Sudarshan
// 
// Create Date: 08.10.2019 16:33:52
// Design Name: Write_back  
// Module Name: Write_back
// Project Name: AAI
// Target Devices: 
// Tool Versions: 
// Description: 
// Dependencies: None
// 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//////////////////////////////////////////////////////////////////////////////////

module Write_Back ( i_mem_rd_en, i_mem_data, i_alu_result, o_writeback_res);

input       i_mem_rd_en;
input   [`WORD_LEN-1:0] i_mem_data, i_alu_result;
output  [`WORD_LEN-1:0] o_writeback_res;

assign  o_writeback_res = (i_mem_rd_en == 1'b1) ? i_mem_data : i_alu_result;

endmodule