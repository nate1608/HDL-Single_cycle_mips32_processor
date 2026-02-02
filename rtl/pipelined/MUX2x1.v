`timescale 1ns / 1ps

module MUX2x1(
    input sel,
    input [31:0] i1,i0,
    output [31:0] y
    );
    
    assign y = sel?i1:i0;
    
endmodule
