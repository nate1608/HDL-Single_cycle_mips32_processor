`timescale 1ns / 1ps

module INS_MEM(addr, instruction);
    input [31:0] addr;
    output [31:0] instruction;
    
    reg [31:0] mem [1023:0];
    
    assign instruction = mem[addr];
endmodule