`timescale 1ns / 1ps

//Role: Buffers the Instruction and PC between Fetch and Decode.
//Features: Supports Stall (en) and Flush (flush for taken branches/jumps).


module IF_ID_Reg(
    input clk,
    input reset,
    input en,           // Active High Enable (Inverse of Stall)
    input flush,        // Active High Flush (Synchronous or Async)
    input [31:0] PC_IF,
    input [31:0] Instr_IF,
    
    output reg [31:0] PC_ID,
    output reg [31:0] Instr_ID
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC_ID    <= 32'b0;
            Instr_ID <= 32'b0;
        end
        else if (en) begin
            if (flush) begin
                PC_ID    <= 32'b0;
                Instr_ID <= 32'b0; // NOP
            end
            else begin
                PC_ID    <= PC_IF;
                Instr_ID <= Instr_IF;
            end
        end
    end

endmodule