`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/24/2020 02:38:03 AM
// Design Name: 
// Module Name: fifo_to_MIPS_IF
// Project Name: 
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


module fifo_to_MIPS_IF(
input            aclk,
input            areset,

//Instruction FIFO IFs
input            i_inst_fifo_empty,
input   [31:0]   i_inst_mem_in,
//input            i_inst_mem_vld,

output           o_inst_mem_rd_en,

//Narrow Data input mem IFs
input            i_data_mem_empty,
input   [31:0]   i_data_mem_in,
//input            i_data_mem_vld,

output           o_data_mem_rd_en,

//Narrow Data output mem IFs
output  [31:0]   o_data_mem_data,
output           o_data_mem_wr_en

    );

reg         r_inst_mem_rd_en,r_data_mem_rd_en;
reg         r_inst_mem_vld,r_data_mem_vld;

reg         r_out_data_mem_rd_en,r_out_data_mem_rd_en_d1;

reg [9:0]   r_addr_wr_rd_data_mem;

wire        w_krnl_done;

reg         r_MIPS_rst;

always @ (posedge aclk)
begin
  if(areset)
    r_inst_mem_rd_en <= 1'b0;
  else if(~i_inst_fifo_empty & ~r_inst_mem_rd_en)
    r_inst_mem_rd_en <= 1'b1;
  else
    r_inst_mem_rd_en <= 1'b0;
end
assign o_inst_mem_rd_en = r_inst_mem_rd_en;

always @ (posedge aclk)
begin
  if(areset)
    r_data_mem_rd_en <= 1'b0;
  else if(~i_data_mem_empty & ~r_data_mem_rd_en)
    r_data_mem_rd_en <= 1'b1;
  else
    r_data_mem_rd_en <= 1'b0;
end
assign o_data_mem_rd_en = r_data_mem_rd_en;

always @ (posedge aclk)
begin
  r_inst_mem_vld <= r_inst_mem_rd_en;
  r_data_mem_vld <= r_data_mem_rd_en;
end

always @ (posedge aclk)
begin
  if(areset | r_addr_wr_rd_data_mem == 10'd256)
    r_addr_wr_rd_data_mem <= 10'd0;
  else if(r_data_mem_vld | r_out_data_mem_rd_en)
    r_addr_wr_rd_data_mem <= r_addr_wr_rd_data_mem + 10'd1;
end

always @ (posedge aclk)
begin
  if(areset)
    r_out_data_mem_rd_en <= 1'b0;
  else if(w_krnl_done)
    r_out_data_mem_rd_en <= 1'b1;
  else if(r_addr_wr_rd_data_mem == 10'd255)
    r_out_data_mem_rd_en <= 1'b0;
  r_out_data_mem_rd_en_d1 <= r_out_data_mem_rd_en;
end

always @ (posedge aclk)
begin
  if(areset)
    r_MIPS_rst <= 1'b1;
  else if(r_addr_wr_rd_data_mem == 10'd254)
    r_MIPS_rst <= 1'b0;
end

MIPS_top MIPS_inst(
.i_sys_clk      (aclk),
.i_sys_rst      (r_MIPS_rst),

.i_inst_mem_data(i_inst_mem_in),
.i_inst_mem_wr_en(r_inst_mem_rd_en),

.i_host_mem_wr_en(r_data_mem_rd_en),

.i_host_mem_rd_en(1'b0),

.i_host_addr        (r_addr_wr_rd_data_mem),

.i_host_din         (i_data_mem_in),

.o_host_dout        (o_data_mem_data),

.o_krnl_done        (w_krnl_done)
);
assign o_data_mem_wr_en = r_out_data_mem_rd_en_d1;

endmodule
