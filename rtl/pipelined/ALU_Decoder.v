`timescale 1ns / 1ps

//Role: Determines the specific operation the ALU should perform.

//currently alu directly takes 6 bit opcode , but if we want to change it to standard MIPS where opcode
//opcode + funct bits are also used for instructions , we just need to change this module

module ALU_Decoder(
    input [5:0] opcode,
    output reg [5:0] alu_ctrl // Sending Opcode directly to ALU for now
);
    always @(*) begin
        // In your current ISA, the ALU Control signal IS the opcode.
        // This makes the design modular.
        alu_ctrl = opcode; 
    end
endmodule

