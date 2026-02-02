`timescale 1ns / 1ps

//Role: Decodes the 6-bit Opcode into main control signals (Memory, Register, Branch Type).
//last change: Separated branch into branch_type for the comparator. Added rs2_use logic explicitly.


module Main_Decoder(
    input [5:0] opcode,
    output reg sel2,          // ALUSrc (0: RegB, 1: Imm)
    output reg jump,          // Unconditional Jump (J)
    output reg is_jr,         // Jump Register (JR)
    output reg mem_wr,        // MemWrite
    output reg mem_rd,        // MemRead
    output reg reg_wr,        // RegWrite
    output reg sel4,          // MemToReg (0: ALU, 1: Mem)
    output reg [1:0] branch_type, // 00:None, 01:BEQZ, 10:BNEQZ
    output reg rs2_use,       // 1: Use Rs2 (R-Type/Store), 0: Ignore (Imm/Load)
    output reg hlt            // Halt Signal
);

    //Opcode Parameters  (Custom ISA)
    parameter ADD=6'b000000, SUB=6'b000001, AND=6'b000010, OR=6'b000011, SLT=6'b000100, MUL=6'b000101;
    parameter LW=6'b001000, SW=6'b001001;
    parameter ADDI=6'b001010, SUBI=6'b001011, SLTI=6'b001100;
    parameter BNEQZ=6'b001101, BEQZ=6'b001110;
    parameter J=6'b001111, JR=6'b010000;
    parameter HLT_OP=6'b111111;

    always @(*) begin
        // 1. Default Defaults (Safety First)
        sel2=0; jump=0; is_jr=0; mem_wr=0; mem_rd=0; 
        reg_wr=0; sel4=0; branch_type=2'b00; rs2_use=1; hlt=0;

        case(opcode)
            // --- R-Type Arithmetic ---
            ADD, SUB, AND, OR, SLT, MUL: begin 
                reg_wr = 1;
                rs2_use = 1; 
                // ALU Control handled by ALU_Decoder
            end

            // --- I-Type Arithmetic (Reg-Imm) ---
            ADDI, SUBI, SLTI: begin
                reg_wr = 1;
                sel2 = 1;    // ALU Source B = Immediate
                rs2_use = 0; // Optimization: Don't stall on Rs2
            end

            // --- Memory Access ---
            LW: begin
                reg_wr = 1;
                sel2 = 1;
                mem_rd = 1;
                sel4 = 1;    // Writeback Data = Memory
                rs2_use = 0;
            end
            SW: begin
                mem_wr = 1;
                sel2 = 1;
                rs2_use = 1; // Needs Rs2 to store data
            end

            // --- Branches ---
            BEQZ: begin
                sel2 = 1;    // Standardizes input (even if unused)
                branch_type = 2'b01; 
                rs2_use = 0;
            end
            BNEQZ: begin
                sel2 = 1;
                branch_type = 2'b10;
                rs2_use = 0;
            end

            // --- Jumps ---
            J: begin
                jump = 1;
                rs2_use = 0;
            end
            JR: begin
                is_jr = 1;
                rs2_use = 0;
            end
            
            // --- System ---
            HLT_OP: begin
                hlt = 1;
            end
            
            default: begin
                // Maintain defaults
            end
        endcase
    end
endmodule