`timescale 1ns / 1ps
//program counter register, updates on clk

module REG_PC(d_out,d_in, clr,clk);
    input [31:0] d_in;
    input clr, clk;
    output reg [31:0] d_out;
    
    always@(posedge clk) begin
        if(clr) d_out<=32'h00000000;
        else d_out<=d_in;
        end
        
endmodule
