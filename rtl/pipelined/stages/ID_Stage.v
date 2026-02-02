`timescale 1ns / 1ps

module ID_Stage(
    input clk,
    input reg_wr_WB,        
    input [31:0] Instr,
    input [31:0] PC_ID,     
    input [4:0] WriteReg_WB,
    input [31:0] WriteData_WB,
    input rs2_use,
    
    output [31:0] rd1,   //A    
    output [31:0] rd2,     //B 
    output [31:0] Imm,      
    output [31:0] PC_target_j, 
    output [4:0] rs1,
    output [4:0] rs2,
    output [4:0] rd
);

    assign rs1 = Instr[25:21];
    assign rs2 = rs2_use ? Instr[20:16]: 5'b0;
    assign rd = rs2_use? Instr[15:11] : Instr[20:16];

    // 1. Register File
    REG_BANK rf (
        .wr(reg_wr_WB),
        .rs1(rs1),
        .rs2(rs2),
        .rd(WriteReg_WB), // Matched your port name
        .rd_in(WriteData_WB),
        .r1_out(rd1),
        .r2_out(rd2),
        .clk(clk)
    );

    // 2. Sign Extension & Jump Target (Wire logic)
    assign Imm = {{16{Instr[15]}}, Instr[15:0]};
    assign PC_target_j = {PC_ID[31:28], Instr[25:0], 2'b00};

endmodule