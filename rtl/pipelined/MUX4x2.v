`timescale 1ns / 1ps

module MUX4x2(
    input [31:0] i0,i1,i2,i3,
    input [1:0] sel,
    
    output reg [31:0] y
    );
    
    always @(*)
        case(sel)
            2'b00: y = i0;
            2'b01: y = i1;
            2'b10: y = i2;
            2'b11: y = i3;
            default: y = i0;
        endcase
            
endmodule
