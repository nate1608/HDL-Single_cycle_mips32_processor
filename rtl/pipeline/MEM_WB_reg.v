`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/08/2026 11:52:46 PM
// Design Name: 
// Module Name: MEM_WB_reg
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


module reg_MEM_WB( clk, LMD, sel4_MEM, reg_wr_MEM, rd_MEM, z_MEM, en, reset, flush, 
LMD_WB, z_WB, sel4_WB, reg_wr_WB, rd_WB);
    input clk;
    input en;       //active high
    input reset;    //active high 
    input flush;    //active high
    
    //data path signals
    input [31:0] z_MEM;
    input [31:0] LMD;
    output reg [31:0] z_WB;
    output reg [31:0] LMD_WB;
    
    //control signals
    input sel4_MEM, reg_wr_MEM;
    input [4:0] rd_MEM;
    output reg sel4_WB, reg_wr_WB;
    output reg [4:0] rd_WB;
    
    
    
    always @(posedge clk or posedge reset)
        begin
            if( reset || flush)
                begin
                 z_WB <= 32'b0;
                 LMD_WB <= 32'b0;
                 sel4_WB<=1'b0; reg_wr_WB<=1'b0;
                 rd_WB <=5'b0;
                end
            else begin
                    z_WB <= z_MEM;
                    LMD_WB <= LMD;
                    sel4_WB<=sel4_MEM; reg_wr_WB<=reg_wr_MEM;
                    rd_WB <=rd_MEM;
                 end
        end
endmodule 

