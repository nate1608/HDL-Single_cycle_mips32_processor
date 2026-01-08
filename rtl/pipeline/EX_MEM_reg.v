`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/08/2026 11:52:46 PM
// Design Name: 
// Module Name: EX_MEM_reg
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


module reg_EX_MEM( clk, z, B_EX, sel4_EX, rd_EX, mem_wr_EX, mem_rd_EX, reg_wr_EX, en, reset, flush, 
z_MEM, B_MEM, sel4_MEM, rd_MEM, mem_wr_MEM, mem_rd_MEM, reg_wr_MEM );
    input clk;
    input en;       //active high
    input reset;    //active high 
    input flush;    //active high
    
    //datapath signals
    input [31:0] z;
    input [31:0] B_EX;
    output reg [31:0] z_MEM;
    output reg [31:0] B_MEM;
    
    //control signals
    input sel4_EX, mem_wr_EX, mem_rd_EX, reg_wr_EX;
    input [4:0] rd_EX;
    output reg sel4_MEM, mem_wr_MEM, mem_rd_MEM, reg_wr_MEM;
    output reg [4:0] rd_MEM;
    
    always @(posedge clk or posedge reset)
        begin
            if( reset || flush)
                begin
                 z_MEM <= 32'b0;
                 B_MEM <= 32'b0;
                 sel4_MEM<= 1'b0; mem_wr_MEM<= 1'b0; mem_rd_MEM<= 1'b0; reg_wr_MEM<= 1'b0;
                 rd_MEM<=5'b0;
                end
            else begin
                    z_MEM <= z;
                    B_MEM<= B_EX;
                    sel4_MEM<= sel4_EX; mem_wr_MEM<=mem_wr_EX; mem_rd_MEM<= mem_rd_EX; reg_wr_MEM<=reg_wr_EX;
                    rd_MEM<=rd_EX;
                 end
        end
endmodule 
