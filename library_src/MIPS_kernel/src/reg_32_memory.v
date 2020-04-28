`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Adrian
// Engineer: Sudarshan
// 
// Create Date: 10.10.2019 20:37:51
// Design Name: reg_32_memory
// Module Name: reg_32_memory
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


module reg_32_memory( i_sys_clk, i_sys_rst, i_src_addr_1, i_src_addr_2, 
                      i_dest_addr, i_dest_write_val, i_dest_write_en, 
                      o_register_value_1, o_register_value_2);

input           i_sys_clk,i_sys_rst;
input   [`REG_32_ADDR_LEN-1:0] i_src_addr_1,i_src_addr_2,i_dest_addr;
input           i_dest_write_en;
input   [`WORD_LEN-1:0] i_dest_write_val;
output  [`WORD_LEN-1:0] o_register_value_1,o_register_value_2;

reg [`WORD_LEN-1:0] r_register_value[0:`REG_32_TOTALSIZE-1];

genvar i;

generate
for(i=0;i<`REG_32_TOTALSIZE;i=i+1)
begin
    always @ (posedge i_sys_clk)
    begin
        if(i_sys_rst)
            r_register_value[i]<= {`WORD_LEN{1'b0}};
        else if(i_dest_write_en)
            r_register_value[i_dest_addr] <= i_dest_write_val;
    end
end
endgenerate

assign  o_register_value_1  =  r_register_value[i_src_addr_1];
assign  o_register_value_2  =  r_register_value[i_src_addr_2];


endmodule
