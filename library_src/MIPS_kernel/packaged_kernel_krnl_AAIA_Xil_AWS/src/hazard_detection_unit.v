`include "defines.v"

module hazard_detection( i_sys_clk, i_is_imm, i_src1_ID, i_src2_ID, i_dest_EXE, i_WB_EN_EXE, i_dest_MEM, i_WB_EN_MEM, 
                         i_switch, o_hazard_detected);
  input i_sys_clk;
  input [`REG_32_ADDR_LEN-1:0] i_src1_ID, i_src2_ID;
  input [`REG_32_ADDR_LEN-1:0] i_dest_EXE, i_dest_MEM;
  input i_WB_EN_EXE, i_WB_EN_MEM, i_is_imm, i_switch;
  output o_hazard_detected;


wire w_src2_is_valid,w_hazard;
wire w_EXE_hazard,w_MEM_hazard,w_ID_hazard;
reg  r_hazard_delay;

assign w_src2_is_valid = ~(i_is_imm) || i_switch;
assign w_EXE_hazard = i_WB_EN_EXE && (i_src1_ID == i_dest_EXE || (w_src2_is_valid && i_src2_ID == i_dest_EXE));
assign w_MEM_hazard = i_WB_EN_MEM && (i_src1_ID == i_dest_MEM || (w_src2_is_valid && i_src2_ID == i_dest_MEM));

assign w_hazard	=	w_EXE_hazard | w_MEM_hazard;

assign o_hazard_detected = w_hazard | r_hazard_delay;

always @ (posedge i_sys_clk)
begin
  r_hazard_delay <= w_hazard;
end
endmodule