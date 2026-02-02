`timescale 1ns / 1ps

//Contains: PC Register, Master PC Mux, PC Adder, Instruction Memory.

module IF(
    input clk,
    input clr_PC,            // Used as clr_PC in your REG_PC
    input en_IF,            // Stall Signal
    input [1:0] PCsrc,      // Master Mux Control
    input [31:0] PC_target_j,      // From ID
    input [31:0] PC_target_jr,     // From EX
    input [31:0] PC_target_branch, // From EX
    
    output [31:0] PC,
//output [31:0] PC_plus4,
    output [31:0] Instr
);
    wire [31:0] PC_plus4;
    wire [31:0] npc;

    // 1. PC Adder (+4)
    // Assuming you updated your adder module to add 4
    PC_plus4 adder_pc (
        .PC(PC), 
        .PC_Next(PC_plus4)
    );

    // 2. Master PC Mux (4x2 Mux)
    // Inputs: 00:Next, 01:Jump, 10:JR, 11:Branch
    MUX4x2 pc_mux (
        .i0(PC_plus4), 
        .i1(PC_target_j), 
        .i2(PC_target_jr), 
        .i3(PC_target_branch), 
        .sel(PCsrc), 
        .y(npc)
    );

    // 3. PC Register
    REG_PC pc_reg_inst (
        npc,
        PC,
        en_IF,
        clr_PC,
        clk
    );

    // 4. Instruction Memory
    INS_MEM imem (
        .addr(PC), 
        .instruction(Instr)
    );

endmodule