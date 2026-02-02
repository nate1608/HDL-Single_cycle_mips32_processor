`timescale 1ns / 1ps

module MEM_Stage(
    input clk,
    input mem_wr,
    input mem_rd,
    input [31:0] ALU_Result, // Address
    input [31:0] WriteData,  // Data input
    output [31:0] ReadData
);

    DATA_MEM dmem (
        .rd(mem_rd),
        .wr(mem_wr),
        .addr(ALU_Result),   // Address (z in your code)
        .data_in(WriteData), // Data in (B_MEM in your code)
        .data_out(ReadData),   // Data out
        .clk(clk)
    );

endmodule