`timescale 1ns / 1ps

//Role: Connects the Main Decoder and 
//ALU Decoder into a single block that sits in the ID Stage.

module Control_Unit(
    input [5:0] opcode,
    
    // Datapath Controls
    output sel2,      // ALUSrc
    output jump,
    output is_jr,
    output mem_wr,
    output mem_rd,
    output reg_wr,
    output sel4,      // MemToReg
    output [1:0] branch_type,
    output rs2_use,
    output hlt,
    
    // ALU Controls
    output [5:0] alu_ctrl
);

    Main_Decoder md (
        .opcode(opcode),
        .sel2(sel2),
        .jump(jump),
        .is_jr(is_jr),
        .mem_wr(mem_wr),
        .mem_rd(mem_rd),
        .reg_wr(reg_wr),
        .sel4(sel4),
        .branch_type(branch_type),
        .rs2_use(rs2_use),
        .hlt(hlt)
    );

    ALU_Decoder ad (
        .opcode(opcode),
        .alu_ctrl(alu_ctrl)
    );

endmodule