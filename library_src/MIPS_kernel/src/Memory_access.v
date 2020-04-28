`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: Adrian  
// Engineer: Sudarshan
// 
// Create Date: 08.10.2019 16:33:52
// Design Name: Memory_access
// Module Name: Memory_access
// Project Name: AAI
// Target Devices: 
// Tool Versions: 
// Description: This module contains data memory which stores and gives out the 
//              resultant data.
// Dependencies: None
// 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//////////////////////////////////////////////////////////////////////////////////

module Memory_access ( i_sys_clk, i_sys_rst, i_Mem_wr_en, i_Mem_rd_en,
                       i_ALU_res, i_ST_value, o_datamem_out,
                       //Host side port details
                       i_host_mem_wr_en,i_host_mem_rd_en,
                       i_host_addr, i_host_din, o_host_dout
                       );
  input i_sys_clk, i_sys_rst, i_Mem_wr_en, i_Mem_rd_en;
  input [`WORD_LEN-1:0] i_ALU_res, i_ST_value;
  output [`WORD_LEN-1:0] o_datamem_out;
  
  //Host side port details
  input             i_host_mem_wr_en,i_host_mem_rd_en;
  input     [9:0]   i_host_addr;
  input[`WORD_LEN-1:0]  i_host_din;
  output [`WORD_LEN-1:0] o_host_dout;
wire   [`WORD_LEN-1:0] doutb;

//wire   [`WORD_LEN-1:0] w_doutb;

//d_mem_1k d_mem (
//  .a(i_ALU_res[9:0]),      // input wire [9 : 0] a
//  .d(i_ST_value),      // input wire [31 : 0] d
//  .clk(i_sys_clk),  // input wire clk
//  .we(i_Mem_wr_en),    // input wire we
//  .spo(o_datamem_out)  // output wire [31 : 0] spo
//);


   xpm_memory_tdpram #(
      .ADDR_WIDTH_A(10),               // DECIMAL
      .ADDR_WIDTH_B(10),               // DECIMAL
      .AUTO_SLEEP_TIME(0),            // DECIMAL
      .BYTE_WRITE_WIDTH_A(32),        // DECIMAL
      .BYTE_WRITE_WIDTH_B(32),        // DECIMAL
      .CLOCKING_MODE("common_clock"), // String
      .ECC_MODE("no_ecc"),            // String
      .MEMORY_INIT_FILE("none"),      // String
      .MEMORY_INIT_PARAM("0"),        // String
      .MEMORY_OPTIMIZATION("true"),   // String
      .MEMORY_PRIMITIVE("auto"),      // String
      .MEMORY_SIZE(2048),             // DECIMAL
      .MESSAGE_CONTROL(0),            // DECIMAL
      .READ_DATA_WIDTH_A(32),         // DECIMAL
      .READ_DATA_WIDTH_B(32),         // DECIMAL
      .READ_LATENCY_A(0),             // DECIMAL
      .READ_LATENCY_B(0),             // DECIMAL
      .READ_RESET_VALUE_A("0"),       // String
      .READ_RESET_VALUE_B("0"),       // String
      .USE_EMBEDDED_CONSTRAINT(0),    // DECIMAL
      .USE_MEM_INIT(1),               // DECIMAL
      .WAKEUP_TIME("disable_sleep"),  // String
      .WRITE_DATA_WIDTH_A(32),        // DECIMAL
      .WRITE_DATA_WIDTH_B(32),        // DECIMAL
      .WRITE_MODE_A("no_change"),     // String
      .WRITE_MODE_B("no_change")      // String
   )
   xpm_memory_tdpram_inst (
      .dbiterra(),             // 1-bit output: Status signal to indicate double bit error occurrence
                                       // on the data output of port A.

      .dbiterrb(),             // 1-bit output: Status signal to indicate double bit error occurrence
                                       // on the data output of port A.

      .douta(o_datamem_out),       // READ_DATA_WIDTH_A-bit output: Data output for port A read operations.
      .doutb(o_host_dout),         // READ_DATA_WIDTH_B-bit output: Data output for port B read operations.
      .sbiterra(),             // 1-bit output: Status signal to indicate single bit error occurrence
                                       // on the data output of port A.

      .sbiterrb(),             // 1-bit output: Status signal to indicate single bit error occurrence
                                       // on the data output of port B.

      .addra(i_ALU_res[9:0]),          // ADDR_WIDTH_A-bit input: Address for port A write and read operations.
      .addrb(i_host_addr),             // ADDR_WIDTH_B-bit input: Address for port B write and read operations.
      .clka(i_sys_clk),                // 1-bit input: Clock signal for port A. Also clocks port B when
                                       // parameter CLOCKING_MODE is "common_clock".

      .clkb(i_sys_clk),                // 1-bit input: Clock signal for port B when parameter CLOCKING_MODE is
                                       // "independent_clock". Unused when parameter CLOCKING_MODE is
                                       // "common_clock".

      .dina(i_ST_value),               // WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
      .dinb(i_host_din),               // WRITE_DATA_WIDTH_B-bit input: Data input for port B write operations.
      .ena(1'b1),                      // 1-bit input: Memory enable signal for port A. Must be high on clock
                                       // cycles when read or write operations are initiated. Pipelined
                                       // internally.

      .enb(1'b1),                       // 1-bit input: Memory enable signal for port B. Must be high on clock
                                       // cycles when read or write operations are initiated. Pipelined
                                       // internally.

      .injectdbiterra(1'b0), // 1-bit input: Controls double bit error injection on input data when
                                       // ECC enabled (Error injection capability is not available in
                                       // "decode_only" mode).

      .injectdbiterrb(1'b0), // 1-bit input: Controls double bit error injection on input data when
                                       // ECC enabled (Error injection capability is not available in
                                       // "decode_only" mode).

      .injectsbiterra(1'b0), // 1-bit input: Controls single bit error injection on input data when
                                       // ECC enabled (Error injection capability is not available in
                                       // "decode_only" mode).

      .injectsbiterrb(1'b0), // 1-bit input: Controls single bit error injection on input data when
                                       // ECC enabled (Error injection capability is not available in
                                       // "decode_only" mode).

      .regcea(1'b1),                 // 1-bit input: Clock Enable for the last register stage on the output
                                       // data path.

      .regceb(1'b1),                 // 1-bit input: Clock Enable for the last register stage on the output
                                       // data path.

      .rsta(1'b0),                     // 1-bit input: Reset signal for the final port A output register stage.
                                       // Synchronously resets output port douta to the value specified by
                                       // parameter READ_RESET_VALUE_A.

      .rstb(1'b0),                     // 1-bit input: Reset signal for the final port B output register stage.
                                       // Synchronously resets output port doutb to the value specified by
                                       // parameter READ_RESET_VALUE_B.

      .sleep(1'b0),                   // 1-bit input: sleep signal to enable the dynamic power saving feature.
      .wea(i_Mem_wr_en),               // WRITE_DATA_WIDTH_A-bit input: Write enable vector for port A input
                                       // data port dina. 1 bit wide when word-wide writes are used. In
                                       // byte-wide write configurations, each bit controls the writing one
                                       // byte of dina to address addra. For example, to synchronously write
                                       // only bits [15-8] of dina when WRITE_DATA_WIDTH_A is 32, wea would be
                                       // 4'b0010.

      .web(i_host_mem_wr_en)           // WRITE_DATA_WIDTH_B-bit input: Write enable vector for port B input
                                       // data port dinb. 1 bit wide when word-wide writes are used. In
                                       // byte-wide write configurations, each bit controls the writing one
                                       // byte of dinb to address addrb. For example, to synchronously write
                                       // only bits [15-8] of dinb when WRITE_DATA_WIDTH_B is 32, web would be
                                       // 4'b0010.

   );

//wide_mem_1k w_mem (
//  .clka(i_sys_clk),    // input wire clka
//  .wea(i_Mem_wr_en),      // input wire [0 : 0] wea
//  .addra(i_ALU_res[9:0]),  // input wire [9 : 0] addra
//  .dina(i_ST_value),    // input wire [4095 : 0] dina
//  .douta(o_datamem_out),  // output wire [4095 : 0] douta
//  .clkb(i_sys_clk),    // input wire clkb
//  .enb(1'b1),      // input wire enb
//  .web(1'b0),      // input wire [0 : 0] web
//  .addrb(10'd0),  // input wire [9 : 0] addrb
//  .dinb(4096'd0),    // input wire [4095 : 0] dinb
//  .doutb(doutb)  // output wire [4095 : 0] doutb
//);

endmodule