`timescale 1ns / 1ps

module PC_plus4(PC, PC_Next);
    input [31:0] PC;
    output [31:0] PC_Next;
    
    assign PC_Next = PC+3'b100;

endmodule
