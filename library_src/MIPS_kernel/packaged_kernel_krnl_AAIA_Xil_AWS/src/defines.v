// Wire widths
`define WORD_LEN 32
`define INST_LEN 32
`define REG_32_ADDR_LEN 5
`define EXE_CMD_LEN 4
//`define FORW_SEL_LEN 2
`define OP_CODE_LEN 6

// Memory constants
`define REG_32_TOTALSIZE 32

// To be used inside controller.v
`define OP_ROP 6'd0
//R type operation OP codes
    `define OP_NOP  6'd0
    `define OP_ADD  6'd32
    `define OP_ADDU 6'd33
    `define OP_SUB  6'd34
    `define OP_SUBU 6'd35
    `define OP_AND  6'd36
    `define OP_OR   6'd37
    `define OP_XOR  6'd38
    `define OP_NOR  6'd39
    `define OP_SLT  6'd42
    `define OP_SLTU 6'd43

//I type OP codes
`define OP_ADDI  6'd8
`define OP_ADDIU 6'd9
`define OP_SLTI  6'd10
`define OP_SLTIU 6'd11
`define OP_ANDI  6'd12
`define OP_ORI   6'd13
`define OP_XORI  6'd14
`define OP_LUI   6'd15
`define OP_SUBI  6'd16   /////

`define OP_LW    6'd35
`define OP_SW    6'd43

// To be used in side ALU
`define EXE_ADD 4'b0000
`define EXE_SUB 4'b0010
`define EXE_AND 4'b0100
`define EXE_OR  4'b0101
`define EXE_NOR 4'b0110
`define EXE_XOR 4'b0111
`define EXE_NO_OPERATION 4'b1111 // for NOP, BEZ, BNQ, JMP
