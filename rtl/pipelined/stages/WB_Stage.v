`timescale 1ns / 1ps

module WB_Stage(
    input sel4,              // MemToReg
    input [31:0] ALU_Result,
    input [31:0] ReadData,
    output [31:0] Result
);

    MUX2x1 wb_mux (
        .sel(sel4), 
        .i0(ALU_Result), 
        .i1(ReadData), 
        .y(Result)
    );

endmodule