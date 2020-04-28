`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Adrian
// Engineer: Sudarshan
// 
// Create Date: 09.10.2019 07:53:03
// Design Name: MEM_to_WB_pipereg
// Module Name: MEM_to_WB_pipereg
// Project Name: AAI project
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MEM_to_WB_pipereg( i_sys_clk, i_sys_rst, i_writeback_en_in, i_dest_in, i_MEM_Rd_en,
                          i_ALU_result_in, i_memread_in, o_writebck_en_out, o_MEM_Rd_en,
                          o_dest_out, o_ALU_result_out, o_memread_out);

input       i_sys_clk,i_sys_rst,i_writeback_en_in,i_MEM_Rd_en;
input   [`REG_32_ADDR_LEN-1:0] i_dest_in;
input   [`WORD_LEN-1:0] i_ALU_result_in, i_memread_in;

output      o_writebck_en_out,o_MEM_Rd_en;
output  [`REG_32_ADDR_LEN-1:0] o_dest_out;
output  [`WORD_LEN-1:0] o_ALU_result_out, o_memread_out;

reg      r_writebck_en_out,r_MEM_Rd_en;
reg  [`REG_32_ADDR_LEN-1:0] r_dest_out;
reg  [`WORD_LEN-1:0] r_ALU_result_out, r_memread_out;

always @ (posedge i_sys_clk)
begin
  if(i_sys_rst)
  begin
    r_writebck_en_out   <= 1'b0;
    r_dest_out          <= {`REG_32_ADDR_LEN{1'b0}};
    r_ALU_result_out    <= {`WORD_LEN{1'b0}};
    r_memread_out       <= {`WORD_LEN{1'b0}};
    r_MEM_Rd_en         <= 1'b0;
  end
  else
  begin
    r_writebck_en_out   <= i_writeback_en_in;
    r_dest_out          <= i_dest_in;
    r_ALU_result_out    <= i_ALU_result_in;
    r_memread_out       <= i_memread_in;  
    r_MEM_Rd_en         <= i_MEM_Rd_en;
  end
end

assign o_writebck_en_out = r_writebck_en_out;
assign o_dest_out        = r_dest_out;
assign o_ALU_result_out  = r_ALU_result_out;
assign o_memread_out     = r_memread_out;
assign o_MEM_Rd_en       = r_MEM_Rd_en;

endmodule
