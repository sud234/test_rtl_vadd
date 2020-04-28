`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Adrian  
// Engineer: Sudarshan
// 
// Create Date: 05.10.2019 16:33:52
// Design Name: MIPS_top
// Module Name: MIPS_top
// Project Name: AAI
// Target Devices: 
// Tool Versions: 
// Description: This module contains all the modules necessary for MIPS 
//              processor to work. We are getting input instructions from a TB.
//              As soon as reset is removed, this processor starts working. 
// Dependencies: None
// 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: In this first version only limite functionalities are used
//                      of MIPS thus only ALU operations are supported.
//////////////////////////////////////////////////////////////////////////////////


module MIPS_top( i_sys_clk, i_sys_rst, i_inst_mem_data, i_inst_mem_wr_en,
                //Host side port details
               i_host_mem_wr_en,i_host_mem_rd_en,
               i_host_addr, i_host_din, o_host_dout,o_krnl_done );

input                           i_sys_clk;
input                           i_sys_rst;

input    [`INST_LEN - 1 : 0]    i_inst_mem_data;
input                           i_inst_mem_wr_en;

//Host side port details
input                           i_host_mem_wr_en,i_host_mem_rd_en;
input     [9:0]                 i_host_addr;
input   [`WORD_LEN-1:0]         i_host_din;
output  [`WORD_LEN-1:0]         o_host_dout;
output                          o_krnl_done;

wire                            w_writeback_en_ID,w_writeback_en_EXE,
                                w_writeback_en_MEM,w_writeback_en_WB;
wire                            w_R_type_ID, w_switch_ID;
wire    [`INST_LEN - 1 : 0]     w_PC_IF,w_PC_ID,w_PC_EXE,w_PC_MEM;
wire    [`INST_LEN - 1 : 0]     w_instruction_IF,w_instruction_ID;
wire    [`REG_32_ADDR_LEN-1:0]  w_dest_addr_EXE,w_dest_addr_MEM,w_dest_addr_WB;
wire    [`EXE_CMD_LEN-1:0]      w_execute_cmd_ID,w_execute_cmd_EXE;
wire                            w_is_immediate;
wire    [`WORD_LEN - 1 : 0]     w_value_1_ID,w_value_1_EXE;
wire    [`WORD_LEN - 1 : 0]     w_value_2_ID,w_value_2_EXE;
wire    [`REG_32_ADDR_LEN-1:0]  w_source_addr1_ID,w_source_addr1_EXE;
wire    [`REG_32_ADDR_LEN-1:0]  w_source_addr2_ID,w_source_addr2_EXE;
wire    [`WORD_LEN - 1 : 0]     w_ALU_result_EXE,w_ALU_result_MEM,w_ALU_result_WB;
wire    [`WORD_LEN - 1 : 0]     w_datamem_EXE,w_datamem_MEM,w_datamem_WB;    
wire    [`WORD_LEN - 1 : 0]     w_writeback_res;
    
wire    [`WORD_LEN - 1 : 0]     w_reg_val_1,w_reg_val_2;
wire    [`WORD_LEN - 1 : 0]     w_ST_value_in,w_ST_value_EXE,w_ST_value_MEM;
wire                            w_MEM_Rd_en_WB,w_MEM_Rd_en_MEM,w_MEM_Rd_en_EXE,w_MEM_Rd_en_ID;
wire                            w_MEM_Wr_en_MEM,w_MEM_Wr_en_EXE,w_MEM_Wr_en_ID;

wire                            w_hazard_detected;
reg                             r_krnl_done,r_krnl_done_d1;

hazard_detection    hazard_detection_unit(
.i_sys_clk          (i_sys_clk),

.i_src1_ID          (w_source_addr1_ID),
.i_src2_ID          (w_source_addr2_ID),

.i_dest_EXE         (w_dest_addr_EXE),
.i_dest_MEM         (w_dest_addr_MEM),

.i_switch           (w_switch_ID),

.i_WB_EN_EXE        (w_writeback_en_EXE),
.i_WB_EN_MEM        (w_writeback_en_MEM),

.i_is_imm           (w_is_immediate),

.o_hazard_detected  (w_hazard_detected)


);

Instruction_Fetch   Instruction_Fetch_inst(
.i_sys_clk          (i_sys_clk),
.i_sys_rst          (i_sys_rst),

.i_freeze           (w_hazard_detected),

.i_inst_mem_data    (i_inst_mem_data),
.i_inst_mem_wr_en   (i_inst_mem_wr_en),

.o_PC               (w_PC_IF),
.o_instruction      (w_instruction_IF)  
); 

Instruction_Decode   Instruction_decode_inst(
.i_sys_clk          (i_sys_clk),
.i_sys_rst          (i_sys_rst),

.i_intruction       (w_instruction_ID),
.i_R_type           (w_R_type_ID),

.i_reg_1            (w_reg_val_1),
.i_reg_2            (w_reg_val_2),

.o_writeback_en     (w_writeback_en_ID),
.o_is_immediate     (w_is_immediate),
.o_switch           (w_switch_ID),
.o_MEM_Rd_EN        (w_MEM_Rd_en_ID),
.o_MEM_Wr_EN        (w_MEM_Wr_en_ID),

.o_Execute_cmd      (w_execute_cmd_ID),
.o_value1           (w_value_1_ID),
.o_value2           (w_value_2_ID),

.o_src_addr1        (w_source_addr1_ID),
.o_src_addr2        (w_source_addr2_ID)
);

Execute_inst    Execute_inst(

.i_sys_clk          (i_sys_clk),

.i_Execute_cmd      (w_execute_cmd_EXE),

.i_value_1          (w_value_1_EXE),
.i_value_2          (w_value_2_EXE),
.i_ST_value_in      (w_ST_value_in),

.o_ALU_result       (w_ALU_result_EXE),
.o_ST_value_out     (w_ST_value_EXE)
);

Memory_access   Memory_acc(

.i_sys_clk          (i_sys_clk),
.i_sys_rst          (i_sys_rst),

.i_Mem_wr_en        (w_MEM_Wr_en_MEM),
.i_Mem_rd_en        (w_MEM_Rd_en_MEM),
.i_ALU_res          (w_ALU_result_MEM),

.i_ST_value         (w_ST_value_MEM),
.o_datamem_out      (w_datamem_MEM),

.i_host_mem_wr_en   (i_host_mem_wr_en),
.i_host_mem_rd_en   (i_host_mem_rd_en),

.i_host_addr        (i_host_addr),
.i_host_din         (i_host_din),

.o_host_dout        (o_host_dout)
);

Write_Back      Write_back(

.i_mem_rd_en        (w_MEM_Rd_en_WB),
.i_mem_data         (w_datamem_WB),
.i_alu_result       (w_ALU_result_WB),

.o_writeback_res    (w_writeback_res)   
);

//Pipeline Register Stages
IF_to_ID_pipereg    IF_to_ID_pipereg(
.i_sys_clk          (i_sys_clk),
.i_sys_rst          (i_sys_rst),

.i_freeze           (w_hazard_detected),

.i_PC_in            (w_PC_IF),
.i_instruction_in   (w_instruction_IF),

.o_PC_out           (w_PC_ID),
.o_instruction_out  (w_instruction_ID),
.o_R_type           (w_R_type_ID)        
);

ID_to_EXE_pipereg    ID_to_EXE_pipereg(
.i_sys_clk          (i_sys_clk),
.i_sys_rst          (i_sys_rst),

.i_writeback_en_in  (w_writeback_en_ID),
.i_dest_in          (w_instruction_ID[25:21]),
.i_source1_in       (w_source_addr1_ID),
.i_source2_in       (w_source_addr2_ID),
.i_value1_in        (w_value_1_ID),
.i_value2_in        (w_value_2_ID),
.i_PC_in            (w_PC_ID),
.i_Execute_cmd_in   (w_execute_cmd_ID),      
.i_reg_2_val        (w_reg_val_2),
.i_MEM_Rd_en        (w_MEM_Rd_en_ID),
.i_MEM_Wr_en        (w_MEM_Wr_en_ID),

.o_MEM_Rd_en        (w_MEM_Rd_en_EXE),
.o_MEM_Wr_en        (w_MEM_Wr_en_EXE),
.o_writeback_en_out (w_writeback_en_EXE),
.o_dest_out         (w_dest_addr_EXE),
.o_source1_out      (w_source_addr1_EXE),
.o_source2_out      (w_source_addr2_EXE),
.o_value1_out       (w_value_1_EXE),
.o_value2_out       (w_value_2_EXE),
.o_PC_out           (w_PC_EXE),
.o_Execute_cmd_out  (w_execute_cmd_EXE),
.o_ST_value         (w_ST_value_EXE)
);

EXE_to_MEM_pipereg    EXE_to_MEM_pipereg(
.i_sys_clk          (i_sys_clk),
.i_sys_rst          (i_sys_rst),

.i_writeback_en_in  (w_writeback_en_EXE),
.i_dest_in          (w_dest_addr_EXE),
.i_PC_in            (w_PC_EXE),
.i_ALU_result_in    (w_ALU_result_EXE),
.i_STvalue_in       (w_ST_value_EXE),
.i_MEM_Rd_en        (w_MEM_Rd_en_EXE),
.i_MEM_Wr_en        (w_MEM_Wr_en_EXE),

.o_MEM_Rd_en        (w_MEM_Rd_en_MEM),
.o_MEM_Wr_en        (w_MEM_Wr_en_MEM),
.o_writeback_en_out (w_writeback_en_MEM),
.o_dest_out         (w_dest_addr_MEM),
.o_PC_out           (w_PC_MEM),
.o_ALU_result_out   (w_ALU_result_MEM),
.o_STvalue_out      (w_ST_value_MEM)

);

MEM_to_WB_pipereg    MEM_to_WB_pipereg(
.i_sys_clk          (i_sys_clk),
.i_sys_rst          (i_sys_rst),

.i_writeback_en_in  (w_writeback_en_MEM),
.i_dest_in          (w_dest_addr_MEM),
.i_ALU_result_in    (w_ALU_result_MEM),
.i_memread_in       (w_datamem_MEM),
.i_MEM_Rd_en        (w_MEM_Rd_en_MEM),

.o_writebck_en_out  (w_writeback_en_WB),
.o_dest_out         (w_dest_addr_WB),
.o_MEM_Rd_en        (w_MEM_Rd_en_WB),
.o_ALU_result_out   (w_ALU_result_WB),
.o_memread_out      (w_datamem_WB)

);

reg_32_memory       reg_32_memory(
.i_sys_clk          (i_sys_clk),
.i_sys_rst          (i_sys_rst),

.i_src_addr_1       (w_source_addr1_ID),
.i_src_addr_2       (w_source_addr2_ID),
.i_dest_addr        (w_dest_addr_WB),
.i_dest_write_val   (w_writeback_res),
.i_dest_write_en    (w_writeback_en_WB),

.o_register_value_1 (w_reg_val_1),
.o_register_value_2 (w_reg_val_2)
);

always @ (posedge i_sys_clk)
begin
  if(i_sys_rst)
    r_krnl_done <= 1'b0;
  else if(w_PC_MEM > 32'd100)
    r_krnl_done <= 1'b1;
  r_krnl_done_d1 <= r_krnl_done;
end
assign o_krnl_done = r_krnl_done & ~r_krnl_done_d1;

endmodule
