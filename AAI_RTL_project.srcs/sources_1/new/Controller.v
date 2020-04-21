`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: Adrian  
// Engineer: Sudarshan
// 
// Create Date: 08.10.2019 16:33:52
// Design Name: Controller
// Module Name: Controller
// Project Name: AAI
// Target Devices: 
// Tool Versions: 
// Description: This module gets the instruction and controls the execution.              
// Dependencies: None
// 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//////////////////////////////////////////////////////////////////////////////////


module Controller( i_opcode, i_R_type, o_writeback_en, o_is_immediate, o_Execute_cmd, o_switch, o_MEM_Rd_EN, o_MEM_Wr_EN);

input    [`OP_CODE_LEN-1:0]     i_opcode;
input                           i_R_type;

output                          o_writeback_en, o_switch, o_MEM_Rd_EN, o_MEM_Wr_EN;
output                          o_is_immediate;

output   [`EXE_CMD_LEN-1:0]     o_Execute_cmd;

reg     r_write_back_en, r_switch, r_MEM_Rd_EN,r_MEM_Wr_EN;
reg     r_is_immediate;
reg     [`EXE_CMD_LEN-1:0]     r_Execute_cmd;

always @ ( * )
begin
  //Initialising to 0.
  r_Execute_cmd <= {`EXE_CMD_LEN{1'b0}};
  r_write_back_en <= 1'b0;
  r_is_immediate  <= 1'b0;
  r_switch        <= 1'b0;
  r_MEM_Rd_EN     <= 1'b0;
  r_MEM_Wr_EN     <= 1'b0;
  case({i_R_type,i_opcode})
    //R-type operations
    {1'b1,`OP_ADD} : begin r_Execute_cmd <=  `EXE_ADD; r_write_back_en <= 1'b1; end
    {1'b1,`OP_ADDU}: begin r_Execute_cmd <=  `EXE_ADD; r_write_back_en <= 1'b1; end
    {1'b1,`OP_SUB} : begin r_Execute_cmd <=  `EXE_SUB; r_write_back_en <= 1'b1; end
    {1'b1,`OP_SUBU}: begin r_Execute_cmd <=  `EXE_SUB; r_write_back_en <= 1'b1; end
    {1'b1,`OP_AND} : begin r_Execute_cmd <=  `EXE_AND; r_write_back_en <= 1'b1; end
    {1'b1,`OP_OR}  : begin r_Execute_cmd <=  `EXE_OR;  r_write_back_en <= 1'b1; end
    {1'b1,`OP_XOR} : begin r_Execute_cmd <=  `EXE_XOR; r_write_back_en <= 1'b1; end
    {1'b1,`OP_NOR} : begin r_Execute_cmd <=  `EXE_NOR; r_write_back_en <= 1'b1; end
    
    // I-type operations
    {1'b0,`OP_ADDI} : begin r_Execute_cmd <= `EXE_ADD; r_write_back_en <= 1'b1; r_is_immediate <= 1; end
    {1'b0,`OP_ADDIU}: begin r_Execute_cmd <= `EXE_ADD; r_write_back_en <= 1'b1; r_is_immediate <= 1; end
    {1'b0,`OP_SUBI} : begin r_Execute_cmd <= `EXE_SUB; r_write_back_en <= 1'b1; r_is_immediate <= 1; end
    {1'b0,`OP_ANDI} : begin r_Execute_cmd <= `EXE_AND; r_write_back_en <= 1'b1; r_is_immediate <= 1; end
    {1'b0,`OP_ORI } : begin r_Execute_cmd <= `EXE_OR;  r_write_back_en <= 1'b1; r_is_immediate <= 1; end
    {1'b0,`OP_XORI} : begin r_Execute_cmd <= `EXE_XOR; r_write_back_en <= 1'b1; r_is_immediate <= 1; end
    
    // Memory operations
    {1'b0,`OP_LW}   : begin r_Execute_cmd <= `EXE_ADD; r_write_back_en <= 1'b1; r_is_immediate <= 1; r_switch <= 1'b1; r_MEM_Rd_EN <= 1'b1; end
    {1'b0,`OP_SW}   : begin r_Execute_cmd <= `EXE_ADD; r_is_immediate <= 1; r_switch <= 1'b1; r_MEM_Wr_EN <= 1'b1; end
    
  default: {r_Execute_cmd,r_write_back_en,r_is_immediate,r_switch,r_MEM_Wr_EN,r_MEM_Rd_EN} <= 0;
  endcase
end

assign o_Execute_cmd = r_Execute_cmd;
assign o_writeback_en = r_write_back_en;
assign o_is_immediate = r_is_immediate;
assign o_switch       = r_switch;
assign o_MEM_Rd_EN    = r_MEM_Rd_EN;
assign o_MEM_Wr_EN    = r_MEM_Wr_EN;

endmodule
