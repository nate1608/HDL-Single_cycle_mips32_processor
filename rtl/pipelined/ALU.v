`timescale 1ns / 1ps
module ALU(opcode, A,B, out);
    input [31:0] A,B;
    input [5:0] opcode;
    output reg [31:0] out;
    
    parameter add=6'b000000 ,sub=6'b000001 ,AND=6'b000010 ,OR=6'b000011 ,SLT=6'b000100 ,MUL=6'b000101 
              ,LW=6'b001000, SW=6'b001001,addi=6'b001010 ,subi=6'b001011 ,SLTi=6'b001100 ,BNEQZ=6'b001101 , BEQZ=6'b001110,
              jump=6'b001111;
              
    always @(*)
        case(opcode)
            add,addi,BNEQZ,BEQZ, LW,SW: out=A+B;
            sub,subi: out=A-B;
            AND: out=A&B;
            OR: out=A|B;
            SLT,SLTi: out=A<B?1:0;
            MUL: out=A*B;
            jump: out=B; //equals to immediate value which shows address
        endcase
    
endmodule
