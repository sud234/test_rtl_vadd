`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Adrian
// Engineer: Sudarshan
// 
// Create Date: 09.10.2019 06:56:16
// Design Name: 
// Module Name: ID_to_EXE_pipereg
// Project Name: ID_to_EXE_pipereg
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


module ID_to_EXE_pipereg( i_sys_clk, i_sys_rst, i_writeback_en_in, i_dest_in, 
                          i_source1_in, i_source2_in, i_value1_in, i_value2_in, 
                          i_PC_in, o_writeback_en_out, o_dest_out, o_source1_out,
                          o_source2_out, o_value1_out, o_value2_out, o_PC_out,
                          i_Execute_cmd_in, o_Execute_cmd_out, i_reg_2_val, o_ST_value,
                          i_MEM_Rd_en, i_MEM_Wr_en, o_MEM_Rd_en, o_MEM_Wr_en);

input   i_sys_clk,i_sys_rst,i_writeback_en_in,i_MEM_Rd_en, i_MEM_Wr_en;
input   [`EXE_CMD_LEN-1:0] i_Execute_cmd_in;
input   [`REG_32_ADDR_LEN-1:0] i_dest_in,i_source1_in,i_source2_in;
input   [`WORD_LEN-1:0]    i_value1_in,i_value2_in,i_reg_2_val;
input   [`INST_LEN-1:0]    i_PC_in;

output                     o_writeback_en_out,o_MEM_Rd_en, o_MEM_Wr_en;
output  [`EXE_CMD_LEN-1:0] o_Execute_cmd_out;
output  [`REG_32_ADDR_LEN-1:0] o_dest_out,o_source1_out,o_source2_out;
output  [`WORD_LEN-1:0]    o_value1_out,o_value2_out,o_ST_value;
output  [`INST_LEN-1:0]    o_PC_out;

reg                     r_writeback_en_out;
reg  [`EXE_CMD_LEN-1:0] r_Execute_cmd_out;
reg  [`REG_32_ADDR_LEN-1:0] r_dest_out,r_source1_out,r_source2_out;
reg  [`WORD_LEN-1:0]    r_value1_out,r_value2_out,r_ST_value;
reg  [`INST_LEN-1:0]    r_PC_out;
reg                     r_MEM_Rd_en , r_MEM_Wr_en;

always @ (posedge i_sys_clk)
begin
  if(i_sys_rst)
  begin
    r_writeback_en_out  <= 1'b0;
    r_Execute_cmd_out   <= {`EXE_CMD_LEN{1'b0}};
    r_dest_out          <= {`REG_32_ADDR_LEN{1'b0}};
    r_source1_out       <= {`REG_32_ADDR_LEN{1'b0}};
    r_source2_out       <= {`REG_32_ADDR_LEN{1'b0}};
    r_value1_out        <= {`WORD_LEN{1'b0}};
    r_value2_out        <= {`WORD_LEN{1'b0}};
    r_PC_out            <= {`INST_LEN{1'b0}};
    r_ST_value          <= {`WORD_LEN{1'b0}};
    r_MEM_Rd_en         <= 1'b0;
    r_MEM_Wr_en         <= 1'b0;
  end
  else 
  begin
    r_writeback_en_out  <= i_writeback_en_in;
    r_Execute_cmd_out   <= i_Execute_cmd_in;
    r_dest_out          <= i_dest_in;
    r_source1_out       <= i_source1_in;
    r_source2_out       <= i_source2_in;
    r_value1_out        <= i_value1_in;
    r_value2_out        <= i_value2_in;
    r_PC_out            <= i_PC_in;
    r_ST_value          <= i_reg_2_val;
    r_MEM_Rd_en         <= i_MEM_Rd_en;
    r_MEM_Wr_en         <= i_MEM_Wr_en;

  end
end
assign  o_writeback_en_out  = r_writeback_en_out;
assign  o_Execute_cmd_out   = r_Execute_cmd_out;
assign  o_dest_out          = r_dest_out;
assign  o_source1_out       = r_source1_out;
assign  o_source2_out       = r_source2_out;
assign  o_value1_out        = r_value1_out;
assign  o_value2_out        = r_value2_out;
assign  o_PC_out            = r_PC_out;
assign  o_ST_value          = r_ST_value;
assign  o_MEM_Rd_en         = r_MEM_Rd_en;
assign  o_MEM_Wr_en         = r_MEM_Wr_en;

endmodule
