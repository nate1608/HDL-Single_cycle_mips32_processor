`timescale 1ns / 1ps
//synchronous read and write 

module DATA_MEM(rd, wr, addr, data_in,data_out, clk);
    input rd, wr, clk;
    output [31:0] data_out;
    input [31:0] data_in;
    input [31:0] addr;
    
    reg [31:0] mem [1023:0];
    
    assign data_out = rd?mem[addr]:32'hzzzzzzzz; //asynchronous read
    
    always@(posedge clk)    
        begin
            if(wr) mem[addr] <= data_in;
            //else if (rd) data_out <= mem[addr];
        end
           
endmodule
