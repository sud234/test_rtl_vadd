`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: Adrian
// Engineer: Sudarshan
// 
// Create Date: 09.10.2019 06:47:56
// Design Name: 
// Module Name: IF_to_ID_pipereg
// Project Name: IF_to_ID_pipereg
// Target Devices: AAI
// Tool Versions: 
// Description: These contain registers required for the next stage of the cycles.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module IF_to_ID_pipereg( i_sys_clk, i_sys_rst, i_freeze, i_PC_in, i_instruction_in,
                         o_PC_out, o_instruction_out, o_R_type);

input           i_sys_clk,i_sys_rst,i_freeze;
input   [`INST_LEN-1:0] i_PC_in,i_instruction_in;
output  [`INST_LEN-1:0] o_PC_out,o_instruction_out;
output                  o_R_type;

reg     [`INST_LEN-1:0] r_PC_out,r_instruction_out;
reg                     r_R_type;

always @ (posedge i_sys_clk)
begin
  if(i_sys_rst)
  begin
    r_PC_out <= {`WORD_LEN{1'b0}};
    r_instruction_out <= {`WORD_LEN{1'b0}};
    r_R_type          <= 1'b0;
  end
  else if(~i_freeze)
  begin
    r_PC_out <= i_PC_in;
    r_instruction_out <= i_instruction_in;
    if(i_instruction_in[31:26] == `OP_ROP)
      r_R_type <= 1'b1;
    else
      r_R_type <= 1'b0;
  end
end

assign  o_PC_out = r_PC_out;
assign  o_instruction_out = r_instruction_out;
assign  o_R_type          = r_R_type;

endmodule
