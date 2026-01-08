`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/08/2026 11:52:46 PM
// Design Name: 
// Module Name: ID_EX_reg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module reg_ID_EX( clk, A, B, Imm, PC_ID, sel2,jump, branch, sel4, opcode, rd, mem_wr, mem_rd, reg_wr, en, reset, 
flush, A_EX, B_EX, Imm_EX, PC_EX, sel2_EX,jump_EX, branch_EX, sel4_EX, opcode_EX, rd_EX, mem_wr_EX, mem_rd_EX, reg_wr_EX);
    input clk;
    input en;       //active high
    input reset;    //active high 
    input flush;    //active high
    
    input [31:0] A,B,Imm;
    input [31:0] PC_ID;
    input sel2, jump, sel4, mem_wr, mem_rd, reg_wr;
    input [1:0] branch;
    input [5:0] opcode;
    input [4:0] rd;
    
    output reg sel2_EX, jump_EX, sel4_EX, mem_wr_EX, mem_rd_EX, reg_wr_EX;
    output reg [1:0] branch_EX;
    output reg [5:0] opcode_EX;
    output reg [4:0] rd_EX;
    output reg [31:0] A_EX, B_EX, Imm_EX;
    output reg [31:0]PC_EX;
    
    
    always @(posedge clk or posedge reset)
        begin
            if( reset || flush)
                begin
                 A_EX <= 32'b0;
                 B_EX <= 32'b0;
                 Imm_EX <= 32'b0;
                 PC_EX <= 32'b0;
                 sel2_EX<=1'b0; jump_EX<=1'b0; sel4_EX<=1'b0; mem_wr_EX<=1'b0; mem_rd_EX<=1'b0; reg_wr_EX<=1'b0;
                 branch_EX<=2'b0; opcode_EX<=6'b0; rd_EX<=5'b0;
                end
            else begin
                 A_EX <= A;
                 B_EX <= B;
                 Imm_EX <= Imm;
                 PC_EX <= PC_ID;
                 sel2_EX<=sel2; jump_EX<=jump; sel4_EX<=sel4; mem_wr_EX<=mem_wr;
                 mem_rd_EX<=mem_rd; reg_wr_EX<=reg_wr;
                 branch_EX<=branch; opcode_EX<=opcode; rd_EX<=rd;
                 end
        end
endmodule 

