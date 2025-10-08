`timescale 1ns / 1ps
//decodes the entire instruction in opcode, rs,rt,rd 
//decides input of ALU based on MUX select lines
//read and write signals along with addresses in reg_bank and memory
//program counter

module control_path1( sel1, sel2, sel3,sel4, opcode, rs1, rs2, rd, mem_wr, reg_wr, IR, EQZ,clr_PC, clk);
    input [31:0] IR;
    input EQZ,clk;
    output reg sel1,sel2,sel3,sel4, mem_wr,reg_wr,clr_PC;
    output [4:0] rs1, rs2;
    output reg [4:0] rd;
    output [5:0] opcode;
    parameter add=6'b000000 ,sub=6'b000001 ,AND=6'b000010 ,OR=6'b000011 ,SLT=6'b000100 ,MUL=6'b000101, 
              LW=6'b001000, SW=6'b001001 ,addi=6'b001010 ,subi=6'b001011 ,SLTi=6'b001100 ,BNEQZ=6'b001101 , BEQZ=6'b001110 ;
    
    //IF
    assign opcode = IR[31:26];
    assign rs1 = IR[25:21];
    assign rs2 = IR[20:16];
    
    
    //ID: read A and B
//    always @(*)
//        begin
//            rs1 <= IR[25:21]; rs2 <= IR[20:16];
//            reg_wr <= 0;   
//        end
        
    //EX: select inputs of ALU based on type of Instruction/opcode
    
    always @(*)
        begin
            case(opcode)
                add,sub,AND,OR,SLT,MUL: begin sel1=1'b1; sel2=1'b0; end   //reg-reg
                addi,subi,SLTi: begin sel1=1'b1; sel2=1'b1; end           //reg-imm 
                BNEQZ, BEQZ: begin sel1=1'b0; sel2=1'b1; end              //branch
                LW,SW: begin sel1=1'b1; sel2=1'b1; end                      //memory ref
                default: begin sel1=1'b1; sel2=1'b0; end //default -> reg-reg
            endcase
        end
    always @(*)
    begin
        reg_wr=1'b0; mem_wr=1'b0;
        case(opcode)
            add,sub,AND,OR,SLT,MUL: begin sel1=1'b1; sel2=1'b0; rd=IR[15:11]; sel4=1'b1; reg_wr=1'b1;end   //reg-reg
            addi,subi,SLTi: begin sel1=1'b1; sel2=1'b1; rd=IR[20:16];sel4=1'b1; reg_wr=1'b1; end           //reg-imm 
            BEQZ: begin 
                    sel1=1'b0; sel2=1'b1; reg_wr=1'b0;
                    if(EQZ) sel3=1'b0;
                    else sel3=1'b1;
                  end 
            BEQZ: begin 
                    sel1=1'b0; sel2=1'b1; reg_wr=1'b0;
                    if(EQZ) sel3=1'b1;
                    else sel3=1'b0;
                  end               //branch
            LW: begin sel1=1'b1; sel2=1'b1; sel3=1'b0; mem_wr=1'b0; rd=IR[20:16]; sel4=1'b0; reg_wr=1'b1; end
            SW: begin sel1=1'b1; sel2=1'b1; sel3=1'b0; mem_wr=1'b1; reg_wr=1'b0; end                      //memory ref
            default: begin sel1=1'b1; sel2=1'b0; sel3=1'b0; mem_wr=0; reg_wr=1'b0;end //default -> reg-reg
        endcase
    end
        
    //MEM
    always @(*)
        case(opcode)
            LW: begin 
                    sel3=1'b0; 
                    mem_wr=1'b0; 
                end
            SW: begin
                    sel3=1'b0; 
                    mem_wr=1'b1; 
                end
            BNEQZ: if(EQZ) sel3=1'b0;
                   else sel3=1'b1;
            BEQZ:  if(EQZ) sel3=1'b1;
                   else sel3=1'b0;
            default: begin sel3=1'b0; mem_wr=0; end
        endcase
     
    //WB (if not bracnh instruction than write back is done in the next clk edge, therefore the write back regs of previous instruction
    // cannot be used in the just next instruction
    always @(*)
    begin
        reg_wr=0;
        case(opcode)
            add,sub,AND,OR,SLT,MUL: begin rd=IR[15:11]; sel4=1'b1; reg_wr=1'b1; end   //reg-reg
            addi,subi,SLTi: begin rd=IR[20:16];sel4=1'b1; reg_wr=1'b1;end           //reg-imm 
            LW: begin rd=IR[20:16]; sel4=1'b0; reg_wr=1'b1; end          //memory ref
            SW,BEQZ,BNEQZ: begin reg_wr=1'b0; end
            default: begin rd=IR[15:11]; sel4=1'b1; reg_wr=1'b1; end
        
        endcase
    end
endmodule
