`timescale 1ns / 1ps
//program counter register, updates on clk

module REG_PC(NPC,PC, en,clr,clk);
    input [31:0] NPC;
    input en, clr, clk;
    output reg [31:0] PC;
    
    always@(posedge clk or posedge clr) begin
        if(clr) PC<=32'h00000000;
        else if(en) PC<=NPC;
        end
        
endmodule
