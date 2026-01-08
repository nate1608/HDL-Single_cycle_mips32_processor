`timescale 1ns / 1ps
//decodes the entire instruction in opcode, rs,rt,rd 
//decides input of ALU based on MUX select lines
//read and write signals along with addresses in reg_bank and memory
//program counter

module control_path2( sel1, sel2, sel3,sel4, opcode, rs1, rs2, rd, mem_wr,mem_rd, reg_wr, IR, EQZ);
    input [31:0] IR;
    input EQZ;
    
    output [5:0] opcode;
    output [4:0] rs1, rs2;
    output reg [4:0] rd;
    output reg sel1,sel2,sel3,sel4, mem_wr,reg_wr,mem_rd;
    
    //naming opcodes 
    parameter add=6'b000000 ,sub=6'b000001 ,AND=6'b000010 ,OR=6'b000011 ,SLT=6'b000100 ,MUL=6'b000101, HLT = 6'b111111,
              LW=6'b001000, SW=6'b001001 ,addi=6'b001010 ,subi=6'b001011 ,SLTi=6'b001100 ,BNEQZ=6'b001101 , BEQZ=6'b001110
              ,jump=6'b001111;
    
    
    assign opcode = IR[31:26];
    assign rs1 = IR[25:21];
    assign rs2 = IR[20:16];
    
    always @(*)
        if(opcode != HLT)
            begin 
                sel1=1'b1; sel2=1'b0; sel3=1'b0; sel4=1'b1; mem_wr=1'b0; mem_rd=1'b0; reg_wr=1'b0;
                case(opcode)
                    //reg-reg
                    add,sub,AND,OR,SLT,MUL: begin   
                                                sel1=1'b1; sel2=1'b0; rd=IR[15:11]; sel4=1'b1; reg_wr=1'b1;
                                            end   
                    //reg-imm 
                    addi,subi,SLTi: begin           
                                        sel1=1'b1; sel2=1'b1; rd=IR[20:16];sel4=1'b1; reg_wr=1'b1; 
                                    end           
                    //branch
                    BNEQZ: begin 
                               sel1=1'b0; sel2=1'b1; reg_wr=1'b0;
                               if(EQZ) sel3=1'b0;
                               else sel3=1'b1;
                           end 
                    BEQZ: begin             
                              sel1=1'b0; sel2=1'b1; reg_wr=1'b0;
                              if(EQZ) sel3=1'b1;
                              else sel3=1'b0;
                          end  
                          
                    //Memorry reference           
                    LW: begin 
                            sel1=1'b1; sel2=1'b1; sel3=1'b0; mem_wr=1'b0; mem_rd=1'b1; 
                            rd=IR[20:16]; sel4=1'b0; reg_wr=1'b1; 
                        end
                    SW: begin 
                            sel1=1'b1; sel2=1'b1; sel3=1'b0; mem_wr=1'b1; mem_rd=1'b0;
                            reg_wr=1'b0; 
                        end   
                    
                    //jump indefinitely
                    jump: begin
                              sel1=1'b1; sel2=1'b1; sel3=1'b1; sel4=1'bx;
                              mem_wr=1'b0; mem_rd=1'b0; reg_wr=1'b0;
                          end
                        
                    //default -> reg-reg                   
                    default: begin 
                                sel1=1'b1; sel2=1'b0; sel3=1'b0; mem_wr=0; mem_rd=1'b0; reg_wr=1'b0;
                             end 
                endcase
           end
    
    //When opcode==HLT, no further read or write in reg_bank and data_mem.
        else begin 
                sel1=1'b1; sel2=1'b0; sel3=1'b0; sel4=1'b1; mem_wr=1'b0; mem_rd=1'b0; reg_wr=1'b0;
             end
    
endmodule
