`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Adrian  
// Engineer: Sudarshan
// 
// Create Date: 05.10.2019 16:33:52
// Design Name: Instruction_Decode
// Module Name: Instruction_Decode
// Project Name: AAI
// Target Devices: 
// Tool Versions: 
// Description: This module contains controller and logic which decodes the instruction
//              and generates the output required for execution stage.              
// Dependencies: None
// 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//////////////////////////////////////////////////////////////////////////////////

module Instruction_Decode( i_sys_clk, i_sys_rst, i_intruction, i_R_type, i_reg_1, o_MEM_Rd_EN,
                           i_reg_2, o_writeback_en, o_is_immediate, o_Execute_cmd, o_MEM_Wr_EN,
                           o_value1, o_value2, o_src_addr1, o_src_addr2, o_switch);
                          
input                           i_sys_clk;
input                           i_sys_rst;

input   [`INST_LEN - 1 : 0]     i_intruction;
input   [`WORD_LEN - 1 : 0]     i_reg_1,i_reg_2;
input                           i_R_type;
output                          o_writeback_en, o_switch;
output                          o_is_immediate, o_MEM_Rd_EN, o_MEM_Wr_EN;

output   [`EXE_CMD_LEN-1:0]     o_Execute_cmd;
output   [`WORD_LEN-1:0]        o_value1, o_value2; 

output [`REG_32_ADDR_LEN-1:0] o_src_addr1, o_src_addr2;

wire    [`WORD_LEN-1:0]         w_sign_extended_immi;
wire    [`OP_CODE_LEN-1:0]      w_opcode;
              
assign  w_sign_extended_immi = { {16{i_intruction[15]}},i_intruction[15:0]};
assign  w_opcode             = (i_R_type == 1'b1)?(i_intruction[5:0]):(i_intruction[31:26]);

Controller Controller_inst(
.i_opcode   (w_opcode),
.i_R_type   (i_R_type),

.o_writeback_en (o_writeback_en),
.o_is_immediate (o_is_immediate),

.o_switch       (o_switch),
.o_MEM_Rd_EN    (o_MEM_Rd_EN),
.o_MEM_Wr_EN    (o_MEM_Wr_EN),

.o_Execute_cmd  (o_Execute_cmd)
);


assign o_value1 = i_reg_1;
//Determines the value 2, whether its from register file or Immediate value
assign o_value2 = (o_is_immediate == 1'b0) ? i_reg_2 : w_sign_extended_immi;

assign o_src_addr1 = i_intruction[20:16];
assign o_src_addr2 = (o_switch == 1'b0) ? i_intruction[15:11] : i_intruction[25:21] ;
 
// Determins the register source 2 for forwarding
//assign src2_forw = (o_is_immediate == 1'b0) ? (i_intruction[15:11]) : 5'd0;
endmodule