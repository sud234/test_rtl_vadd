`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: Adrian  
// Engineer: Sudarshan
// 
// Create Date: 05.10.2019 16:33:52
// Design Name: Instruction_Mem 
// Module Name: Instruction_Mem
// Project Name: AAI
// Target Devices: 
// Tool Versions: 
// Description: This module contains instructions and gives out Instructions based 
//              based on PC.
// Dependencies: None
// 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//////////////////////////////////////////////////////////////////////////////////


module Instruction_Mem( i_sys_clk, i_sys_rst, i_inst_mem_data, i_inst_mem_wr_en,
                        i_PC, o_intruction);

input                           i_sys_clk;
input                           i_sys_rst;

input    [`INST_LEN - 1 : 0]    i_inst_mem_data;
input                           i_inst_mem_wr_en;

input    [`INST_LEN - 1 : 0]    i_PC;

output   [`INST_LEN - 1 : 0]    o_intruction;

reg     [15 : 0]                r_inst_mem_wr_add = 16'd0;
reg                             r_sys_rst;

wire    [15 : 0]                w_inst_mem_rd_add;
wire                            w_sys_rst;

//wire    [31:0]                  w_intruction_2;

assign      w_inst_mem_rd_add   = i_PC[17:2];   //Divided by 4

//inst_mem inst_mem_inst (
//  .a(r_inst_mem_wr_add),        // input wire [15 : 0] a
//  .d(i_inst_mem_data),        // input wire [31 : 0] d
//  .dpra(w_inst_mem_rd_add),  // input wire [15 : 0] dpra
//  .clk(i_sys_clk),    // input wire clk
//  .we(i_inst_mem_wr_en),      // input wire we
//  .dpo(o_intruction)    // output wire [31 : 0] dpo
//);

  xpm_memory_sdpram #(
      .ADDR_WIDTH_A(16),               // DECIMAL
      .ADDR_WIDTH_B(16),               // DECIMAL
      .AUTO_SLEEP_TIME(0),            // DECIMAL
      .BYTE_WRITE_WIDTH_A(32),        // DECIMAL
      .CLOCKING_MODE("common_clock"), // String
      .ECC_MODE("no_ecc"),            // String
      .MEMORY_INIT_FILE("none"),      // String
      .MEMORY_INIT_PARAM("0"),        // String
      .MEMORY_OPTIMIZATION("true"),   // String
      .MEMORY_PRIMITIVE("auto"),      // String
      .MEMORY_SIZE(2097152),          // DECIMAL
      .MESSAGE_CONTROL(0),            // DECIMAL
      .READ_DATA_WIDTH_B(32),         // DECIMAL
      .READ_LATENCY_B(0),             // DECIMAL
      .READ_RESET_VALUE_B("0"),       // String
      .USE_EMBEDDED_CONSTRAINT(0),    // DECIMAL
      .USE_MEM_INIT(1),               // DECIMAL
      .WAKEUP_TIME("disable_sleep"),  // String
      .WRITE_DATA_WIDTH_A(32),        // DECIMAL
      .WRITE_MODE_B("no_change")      // String
   )
   xpm_memory_sdpram_inst (
      .dbiterrb(),             // 1-bit output: Status signal to indicate double bit error occurrence
                                       // on the data output of port B.

      .doutb(o_intruction),  // READ_DATA_WIDTH_B-bit output: Data output for port B read operations.
      .sbiterrb(),             // 1-bit output: Status signal to indicate single bit error occurrence
                                       // on the data output of port B.

      .addra(r_inst_mem_wr_add),                   // ADDR_WIDTH_A-bit input: Address for port A write operations.
      .addrb(w_inst_mem_rd_add),                   // ADDR_WIDTH_B-bit input: Address for port B read operations.
      .clka(i_sys_clk),                     // 1-bit input: Clock signal for port A. Also clocks port B when
                                       // parameter CLOCKING_MODE is "common_clock".

      .clkb(i_sys_clk),                     // 1-bit input: Clock signal for port B when parameter CLOCKING_MODE is
                                       // "independent_clock". Unused when parameter CLOCKING_MODE is
                                       // "common_clock".

      .dina(i_inst_mem_data),                     // WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
      .ena(1'b1),                       // 1-bit input: Memory enable signal for port A. Must be high on clock
                                       // cycles when write operations are initiated. Pipelined internally.

      .enb(1'b1),                       // 1-bit input: Memory enable signal for port B. Must be high on clock
                                       // cycles when read operations are initiated. Pipelined internally.

      .injectdbiterra(1'b0), // 1-bit input: Controls double bit error injection on input data when
                                       // ECC enabled (Error injection capability is not available in
                                       // "decode_only" mode).

      .injectsbiterra(1'b0), // 1-bit input: Controls single bit error injection on input data when
                                       // ECC enabled (Error injection capability is not available in
                                       // "decode_only" mode).

      .regceb(1'b1),                 // 1-bit input: Clock Enable for the last register stage on the output
                                       // data path.

      .rstb(1'b0),                     // 1-bit input: Reset signal for the final port B output register stage.
                                       // Synchronously resets output port doutb to the value specified by
                                       // parameter READ_RESET_VALUE_B.

      .sleep(1'b0),                   // 1-bit input: sleep signal to enable the dynamic power saving feature.
      .wea({4{i_inst_mem_wr_en}})      // WRITE_DATA_WIDTH_A-bit input: Write enable vector for port A input
                                       // data port dina. 1 bit wide when word-wide writes are used. In
                                       // byte-wide write configurations, each bit controls the writing one
                                       // byte of dina to address addra. For example, to synchronously write
                                       // only bits [15-8] of dina when WRITE_DATA_WIDTH_A is 32, wea would be
                                       // 4'b0010.
   );

always @ (posedge i_sys_clk)
begin
  r_sys_rst<=   i_sys_rst;
end

assign  w_sys_rst = i_sys_rst & ~r_sys_rst;

always @ (posedge i_sys_clk)
begin
  if(w_sys_rst)
    r_inst_mem_wr_add <= 16'd0;
  else if(i_inst_mem_wr_en)
    r_inst_mem_wr_add <= r_inst_mem_wr_add + 16'd1;
end

endmodule
