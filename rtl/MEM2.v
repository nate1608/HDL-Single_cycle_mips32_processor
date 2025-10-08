`timescale 1ns / 1ps

module DATA_MEM(rd, wr, addr, data_in,data_out, clk);
    input rd, wr, clk;
    output [31:0] data_out;
    input [31:0] data_in;
    input [31:0] addr;
    
    reg [31:0] mem [1023:0];
    
    assign data_out = rd?mem[addr]:32'hzzzzzzzz; //asynchronous read
    
    always@(posedge clk)    if(wr) mem[addr] <= data_in;
        
           
endmodule
