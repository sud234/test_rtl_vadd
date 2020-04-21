`timescale 1ns / 1ps


module tb_MIPS_top;

reg i_sys_clk,i_sys_rst;
reg [31:0]  i_inst_mem_data;
reg         i_inst_mem_wr_en;
reg [4:0]   cntr;
integer     FILE_PTR;
integer     FILE_PTR_2;
integer     i;

MIPS_top    MIPS_top_inst(
.i_sys_clk          (i_sys_clk),
.i_sys_rst          (i_sys_rst),

.i_inst_mem_data    (i_inst_mem_data),
.i_inst_mem_wr_en   (i_inst_mem_wr_en)
);

initial
begin
i_sys_clk = 1'b0;
i_sys_rst = 1'b0;
i_inst_mem_data = 32'd0;
i_inst_mem_wr_en = 1'b0;
FILE_PTR    = $fopen("D://Reg_output.txt","w"); //Change the location to wherever you want the output file to get created.
FILE_PTR_2  = $fopen("D://Assert_output.txt","w"); //Change the location to wherever you want the output file to get created.
cntr        = 5'd0;
fork
  //Clock
  begin
    forever
    #4 i_sys_clk = ~i_sys_clk;
  end
  
  //Add Stimulus here
  begin
    i_sys_rst = 1'b1;
    #100        //Wait for global reset to get over
    
    repeat(10)@(posedge i_sys_clk);
    
    @(negedge i_sys_clk);
    i_inst_mem_wr_en    = 1'b1;
    //Only this part of the code should be changed
    //Add instructions here
    //Case 3    -- 3 ADDI operations followed by Substraction and XOR operation
    send_instruction({`OP_ADDI,5'd1,5'd0,16'hA});
    send_instruction({`OP_ADDI,5'd2,5'd0,16'h8});
    send_instruction({`OP_ROP,5'd3,5'd1,5'd2,5'd0,`OP_ADD});
    send_instruction({`OP_ROP,5'd4,5'd1,5'd2,5'd0,`OP_OR});
    send_instruction({`OP_ROP,5'd5,5'd1,5'd2,5'd0,`OP_SUB});
    send_instruction({`OP_ROP,5'd6,5'd1,5'd2,5'd0,`OP_NOR});
    send_instruction({`OP_ROP,5'd7,5'd1,5'd2,5'd0,`OP_AND});
    send_instruction({`OP_SW,5'd1,5'd0,16'd0});
    
    send_instruction({`OP_ADDI,5'd10,5'd0,16'd5});
    send_instruction({`OP_SW,5'd10,5'd0,16'd2});
    send_instruction({`OP_LW,5'd11,5'd0,16'd2});

    /////////////////////////////////////////////////////
    i_inst_mem_wr_en    = 1'b0;
    
    @(negedge i_sys_clk);
    i_sys_rst = 1'b0;
    //Assert cycles
    //0th clock cycle of execution
    $fwrite(FILE_PTR_2,"0th cycle \n");
    read_task;
    @(negedge i_sys_clk);

    //1st clock cycle of execution
    $fwrite(FILE_PTR_2,"\n1st cycle \n");
    read_task;
    @(negedge i_sys_clk);
    //2nd clock cycle of execution
    $fwrite(FILE_PTR_2,"\n2nd cycle \n");
    read_task;
    @(negedge i_sys_clk);
    //3rd clock cycle of execution
    $fwrite(FILE_PTR_2,"\n3rd cycle \n");
    read_task;
    @(negedge i_sys_clk);
    //4th clock cycle of execution
    $fwrite(FILE_PTR_2,"\n4th cycle \n");
    read_task; 
    @(negedge i_sys_clk);
   //5th clock cycle of execution
    $fwrite(FILE_PTR_2,"\n5th cycle \n");
    read_task;
    @(negedge i_sys_clk);
    //6th clock cycle of execution
    $fwrite(FILE_PTR_2,"\n6th cycle \n");
    read_task;
    @(negedge i_sys_clk);
    //7th clock cycle of execution
    $fwrite(FILE_PTR_2,"\n7th cycle \n");
    read_task;
    @(negedge i_sys_clk);
    
    //8th clock cycle of execution
    $fwrite(FILE_PTR_2,"\n8th cycle \n");
    read_task;
    @(negedge i_sys_clk);
    
    //9th clock cycle of execution
    $fwrite(FILE_PTR_2,"\n9th cycle \n");
    read_task;
    @(negedge i_sys_clk);
    
    
          
    repeat(100)@(negedge i_sys_clk);
    //////////////////////////////////////////////////////
    $fwrite(FILE_PTR,"Register Address \t Register Value\n");
    for(i=0;i<32;i=i+1)
    begin
        force MIPS_top_inst.IF_to_ID_pipereg.r_instruction_out = {11'd0,cntr,16'd0};
        @(posedge i_sys_clk);
        $fwrite(FILE_PTR,"\t%h \t\t %d\n",cntr,MIPS_top_inst.reg_32_memory.o_register_value_1);
        cntr    = cntr + 5'd1;
    end
    i_sys_rst = 1'b1;
    $fclose(FILE_PTR);
    $fclose(FILE_PTR_2);
  end
join
end

task    send_instruction;
input [31:0]    i_instruction;
begin
    i_inst_mem_data = i_instruction;
    @(negedge i_sys_clk);
end
endtask

task    read_pc_IF;
begin
    $fwrite(FILE_PTR_2,"PC at IF = %0.1d ",MIPS_top_inst.Instruction_Fetch_inst.r_Program_Counter);
end
endtask

task    read_pc_ID;
begin
    $fwrite(FILE_PTR_2,"PC at ID = %0.1d ",MIPS_top_inst.IF_to_ID_pipereg.r_PC_out);
end
endtask

task    read_pc_EXE;
begin
    $fwrite(FILE_PTR_2,"PC at EXE = %0.1d ",MIPS_top_inst.ID_to_EXE_pipereg.r_PC_out);
end
endtask

task    read_pc_MEM;
begin
    $fwrite(FILE_PTR_2,"PC at EXE = %0.1d ",MIPS_top_inst.EXE_to_MEM_pipereg.r_PC_out);
end
endtask

task    read_instruction_IF;
begin
    $fwrite(FILE_PTR_2,"Instruction at IF = 0x%h ",MIPS_top_inst.Instruction_Fetch_inst.o_instruction);
end
endtask

task    read_instruction_ID;
begin
    $fwrite(FILE_PTR_2,"Instruction at ID = 0x%h ",MIPS_top_inst.IF_to_ID_pipereg.r_instruction_out);
end
endtask

task    read_R_type_ID;
begin
    $fwrite(FILE_PTR_2,"R-type operation at ID = %b ",MIPS_top_inst.IF_to_ID_pipereg.r_R_type);
end
endtask

task    read_hazard;
begin
    $fwrite(FILE_PTR_2,"Hazard detected = %b ",MIPS_top_inst.hazard_detection_unit.w_hazard);
end
endtask

task    read_dest_addr_EXE;
begin
    $fwrite(FILE_PTR_2,"Dest addr at EXE = 0x%h ",MIPS_top_inst.ID_to_EXE_pipereg.r_dest_out);
end
endtask

task    read_dest_addr_MEM;
begin
    $fwrite(FILE_PTR_2,"Dest addr at MEM = 0x%h ",MIPS_top_inst.EXE_to_MEM_pipereg.r_dest_out);
end
endtask

task    read_dest_addr_WB;
begin
    $fwrite(FILE_PTR_2,"Dest addr at WB = 0x%h ",MIPS_top_inst.MEM_to_WB_pipereg.r_dest_out);
end
endtask

task    read_src1_addr_EXE;
begin
    $fwrite(FILE_PTR_2,"Src1 addr at EXE = 0x%h ",MIPS_top_inst.ID_to_EXE_pipereg.r_source1_out);
end
endtask

task    read_src2_addr_EXE;
begin
    $fwrite(FILE_PTR_2,"Src2 addr at EXE = 0x%h ",MIPS_top_inst.ID_to_EXE_pipereg.r_source2_out);
end
endtask

task    read_Value_1_EXE;
begin
    $fwrite(FILE_PTR_2,"Value_1 addr at EXE = %0.1d ",MIPS_top_inst.ID_to_EXE_pipereg.r_value1_out);
end
endtask


task    read_Value_2_EXE;
begin
    $fwrite(FILE_PTR_2,"Value_2 addr at EXE = %0.1d ",MIPS_top_inst.ID_to_EXE_pipereg.r_value2_out);
end
endtask

task    read_WB_en_EXE;
begin
    $fwrite(FILE_PTR_2,"Writeback en at EXE = %b ",MIPS_top_inst.ID_to_EXE_pipereg.r_writeback_en_out);
end
endtask

task    read_WB_en_MEM;
begin
    $fwrite(FILE_PTR_2,"Writeback en at MEM = %b ",MIPS_top_inst.EXE_to_MEM_pipereg.r_writeback_en_out);
end
endtask

task    read_WB_en_WB;
begin
    $fwrite(FILE_PTR_2,"Writeback en at WB = %b ",MIPS_top_inst.MEM_to_WB_pipereg.r_writebck_en_out);
end
endtask

task    read_ALU_out_MEM;
begin
    $fwrite(FILE_PTR_2,"ALU result at MEM = %0.1d ",MIPS_top_inst.EXE_to_MEM_pipereg.r_ALU_result_out);
end
endtask

task    read_ALU_out_WB;
begin
    $fwrite(FILE_PTR_2,"ALU result at WB = %0.1d ",MIPS_top_inst.MEM_to_WB_pipereg.r_ALU_result_out);
end
endtask

task    read_task;
begin
read_hazard; 
$fwrite(FILE_PTR_2,"\n");   
read_pc_IF;
read_instruction_IF;
$fwrite(FILE_PTR_2,"\n"); 
read_pc_ID;
read_instruction_ID;
read_R_type_ID;
$fwrite(FILE_PTR_2,"\n"); 
read_dest_addr_EXE;
read_src1_addr_EXE;
read_Value_1_EXE;
read_src2_addr_EXE;
read_Value_2_EXE;
read_WB_en_EXE;
$fwrite(FILE_PTR_2,"\n");    
read_dest_addr_MEM;
read_WB_en_MEM;
read_ALU_out_MEM;
$fwrite(FILE_PTR_2,"\n"); 
read_dest_addr_WB;
read_WB_en_WB;
read_ALU_out_WB;

end
endtask

endmodule
