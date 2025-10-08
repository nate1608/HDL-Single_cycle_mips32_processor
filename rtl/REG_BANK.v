`timescale 1ns / 1ps

module REG_BANK(wr,rs1,rs2,rd,rd_in,r1_out,r2_out, clk);
    input [4:0] rs1, rs2, rd;
    input clk,wr;
    output [31:0] r1_out, r2_out;
    input [31:0] rd_in;
    
    reg [31:0] reg_bank [31:0];
    
    assign r1_out = reg_bank[rs1];
    assign r2_out = reg_bank[rs2];
    
    initial reg_bank[32'd0] = 32'd0;
    
    always@(posedge clk)
        if(wr) reg_bank[rd] <= rd_in;
endmodule
