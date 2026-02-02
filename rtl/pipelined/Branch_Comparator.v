`timescale 1ns / 1ps

//Role: Resolves whether a branch should be taken.
//Scalability: I added support for standard beq (A==B) so you can easily add it later by just connecting input B.

module Branch_Comparator(
    input [1:0] branch_type, // 00:None, 01:BEQZ, 10:BNEQZ
    input [31:0] A,          // Operand 1 (Forwarded)
    input [31:0] B,          // Operand 2 (Forwarded - Optional for future)
    output reg branch_taken
);

    always @(*) begin
        case(branch_type)
            2'b00: branch_taken = 1'b0; // No Branch
            
            // BEQZ: Branch if A == 0
            2'b01: branch_taken = (A == 32'd0);
            
            // BNEQZ: Branch if A != 0
            2'b10: branch_taken = (A != 32'd0);
            
            // FUTURE SUPPORT (e.g., BEQ R1, R2)
            // 2'b11: branch_taken = (A == B);
            
            default: branch_taken = 1'b0;
        endcase
    end
endmodule