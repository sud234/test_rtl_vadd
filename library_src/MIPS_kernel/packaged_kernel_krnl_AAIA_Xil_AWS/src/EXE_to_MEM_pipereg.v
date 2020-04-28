`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: Adrian
// Engineer: Sudarshan
// 
// Create Date: 09.10.2019 07:34:14
// Design Name: 
// Module Name: EXE_to_MEM_pipereg
// Project Name: EXE_to_MEM_pipereg
// Target Devices: 
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


module EXE_to_MEM_pipereg( i_sys_clk, i_sys_rst, i_writeback_en_in, i_dest_in,
                           i_PC_in, i_ALU_result_in, i_STvalue_in, o_writeback_en_out,
                           o_dest_out, o_PC_out, o_ALU_result_out, o_STvalue_out,
                           i_MEM_Rd_en, i_MEM_Wr_en, o_MEM_Rd_en, o_MEM_Wr_en );

input           i_sys_clk, i_sys_rst, i_writeback_en_in,i_MEM_Rd_en, i_MEM_Wr_en;
input   [`REG_32_ADDR_LEN-1:0] i_dest_in;
input   [`WORD_LEN-1:0]    i_ALU_result_in,i_STvalue_in;
input   [`INST_LEN-1:0]    i_PC_in;

output  o_writeback_en_out,o_MEM_Rd_en, o_MEM_Wr_en;
output  [`REG_32_ADDR_LEN-1:0] o_dest_out;
output  [`WORD_LEN-1:0]    o_ALU_result_out,o_STvalue_out;
output  [`INST_LEN-1:0]    o_PC_out;

reg  r_writeback_en_out;
reg  [`REG_32_ADDR_LEN-1:0] r_dest_out;
reg  [`WORD_LEN-1:0]    r_ALU_result_out,r_STvalue_out;
reg  [`INST_LEN-1:0]    r_PC_out;
reg                     r_MEM_Rd_en , r_MEM_Wr_en;

always @ (posedge i_sys_clk)
begin
  if(i_sys_rst)
  begin
    r_writeback_en_out  <= 1'b0;
    r_dest_out          <= {`REG_32_ADDR_LEN{1'b0}};
    r_PC_out            <= {`INST_LEN{1'b0}};
    r_ALU_result_out    <= {`WORD_LEN{1'b0}};
    r_STvalue_out       <= {`WORD_LEN{1'b0}};
    r_MEM_Rd_en         <= 1'b0;
    r_MEM_Wr_en         <= 1'b0;
        
  end
  else
  begin
    r_writeback_en_out  <= i_writeback_en_in;
    r_dest_out          <= i_dest_in;
    r_PC_out            <= i_PC_in;
    r_ALU_result_out    <= i_ALU_result_in;
    r_STvalue_out       <= i_STvalue_in;   
    r_MEM_Rd_en         <= i_MEM_Rd_en;
    r_MEM_Wr_en         <= i_MEM_Wr_en;
     
  end
end

assign  o_writeback_en_out  = r_writeback_en_out;
assign  o_dest_out          = r_dest_out;
assign  o_PC_out            = r_PC_out;
assign  o_ALU_result_out    = r_ALU_result_out;
assign  o_STvalue_out       = r_STvalue_out; 
assign  o_MEM_Rd_en         = r_MEM_Rd_en;
assign  o_MEM_Wr_en         = r_MEM_Wr_en;

endmodule
