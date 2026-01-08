`timescale 1ns / 1ps

module MUX2x1(
    input sel,
    input [31:0] A,B,
    output [31:0] out
    );
    
    assign out = sel?B:A;
    
endmodule
