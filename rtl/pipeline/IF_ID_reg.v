`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/08/2026 11:52:46 PM
// Design Name: 
// Module Name: IF_ID_reg
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


module reg_IF_ID( clk, IR, PC, en, reset, flush, IR_ID, PC_ID);
    input clk;
    input en;       //active high
    input reset;    //active high 
    input flush;    //active high
    
    input [31:0] IR;
    input [31:0] PC;
    output reg [31:0] PC_ID;
    output reg [31:0]IR_ID;
    
    
    always @(posedge clk or posedge reset)
        begin
            if( reset || flush)
                begin
                 PC_ID <= 32'b0;
                 IR_ID <= 32'b0;
                end
            else begin
                    IR_ID <= IR;
                    PC_ID<= PC;
                 end
        end
endmodule 

