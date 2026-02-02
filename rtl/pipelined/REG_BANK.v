`timescale 1ns / 1ps
//Negedge write:-
//The register file is written during 
//the first half of the cycle and read during the second half of the cycle, so 
//a register can be written and read back in the same cycle without introducing a hazard.

module REG_BANK(wr, rs1, rs2, rd, rd_in, r1_out, r2_out, clk);
    input [4:0] rs1, rs2, rd;
    input clk,wr;
    output [31:0] r1_out, r2_out;
    input [31:0] rd_in;
    
    reg [31:0] reg_bank [31:0];
    
    assign r1_out = reg_bank[rs1];
    assign r2_out = reg_bank[rs2];
    
    initial reg_bank[32'd0] = 32'd0;
    
    always@(negedge clk)
        if(wr) reg_bank[rd] <= rd_in;
endmodule
