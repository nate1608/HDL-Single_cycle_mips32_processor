`timescale 1ns / 1ps

//Contains: Forwarding Muxes, ALU, Branch Comparator, Branch Adder.
//Key Upgrade: Includes the new Branch_Comparator instantiation.

module EX_Stage(
    input [31:0] PC_EX,
    input [31:0] A_EX,       
    input [31:0] B_EX,       
    input [31:0] Imm_EX,
    
    // Forwarding & Control
    input [1:0] sel_A,       
    input [1:0] sel_B,
    input [31:0] Result_MEM, 
    input [31:0] Result_WB,  
    input sel2,              // ALUSrc
    input [5:0] alu_ctrl,
    input [1:0] branch_type,
    
    // Outputs
    output [31:0] ALU_Result,
    output [31:0] WriteData_EX, 
    output [31:0] PC_target_branch,
    output [31:0] PC_target_jr, 
    output branch_taken
);

    wire [31:0] A_forward, B_forward;
    wire [31:0] alu_operand_b;
    wire [31:0] imm_shifted;

    // 1. Forwarding Muxes (MUX4x2)
    MUX4x2 fwdA_mux (
        .i0(A_EX), .i1(Result_MEM), .i2(Result_WB), .i3(32'b0), 
        .sel(sel_A), 
        .y(A_forward)
    );

    MUX4x2 fwdB_mux (
        .i0(B_EX), .i1(Result_MEM), .i2(Result_WB), .i3(32'b0), 
        .sel(sel_B), 
        .y(B_forward)
    );

    // 2. ALU Source B Mux (MUX2x1)
    MUX2x1 alu_src_mux (
        .sel(sel2), 
        .i0(B_forward), 
        .i1(Imm_EX), 
        .y(alu_operand_b)
    );

    // 3. ALU
    ALU alu_inst (
        .opcode(alu_ctrl),
        .A(A_forward),
        .B(alu_operand_b),
        .out(ALU_Result)
    );

    // 4. Branch Comparator
    Branch_Comparator bc (
        .branch_type(branch_type),
        .A(A_forward),
        .B(B_forward), 
        .branch_taken(branch_taken)
    );

    // 5. Branch Address Adder
    // Shift logic is explicit here, then fed to adder
    assign imm_shifted = Imm_EX << 2; 
    
    PC_Adder branch_adder (
        .in1(PC_EX), 
        .in2(imm_shifted), 
        .out(PC_target_branch)
    );

    // Outputs
    assign WriteData_EX = B_forward; 
    assign PC_target_jr = A_forward; 

endmodule