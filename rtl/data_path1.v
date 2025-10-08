`timescale 1ns / 1ps
//connect all the components together and consider any input as controls coming from control_path

module data_path1(IR, EQZ, sel1, sel2, sel3, sel4, opcode, rs1, rs2, rd, mem_wr, mem_rd, reg_wr,clr_PC, clk );
    input [4:0] rs1,rs2,rd;
    input [5:0] opcode;
    input mem_rd, mem_wr,reg_wr,clk,clr_PC, sel1,sel2,sel3,sel4; 
    
    output [31:0] IR;
    output EQZ;
    
    //wires (interconnection between modules)
    wire [31:0] NPC,A,B,Imm,z,x,y;
    wire [31:0] PC,d_in;
    wire [31:0] LMD;
    
    
    assign Imm = {{16{IR[15]}},IR[15:0]};
    assign EQZ = (A==32'h00000000);
    
    
    REG_PC pc_reg(PC,NPC,clr_PC,clk);                   //Loads the previous cycles's NPC to PC at clock edge
    INS_MEM ins_set1(PC,IR);                            //Fetches instruction
    REG_BANK reg_bank1(reg_wr,rs1,rs2,rd,d_in,A,B,clk); //For Fetching A=reg[rs1] and B=reg[rs2] and writing back reg[rd]=d_in
    MUX2x1 mux1(sel1,PC+1'b1,A,x);                      //selects input of ALU (x and y)
    MUX2x1 mux2(sel2,B,Imm,y);
    ALU alu1(opcode,x,y,z);                             //ALU (contains both ALU decoder as well ALU functions)
    DATA_MEM data_mem(mem_rd,mem_wr,z,B,LMD, clk);      //read(load) or write(store) 
    MUX2x1 mux3(sel3,PC+1'b1,z,NPC);                    // updates NPC based on branch and it's condition
    MUX2x1 mux4(sel4,LMD,z,d_in);                       //selects between mem[z] (load) and z (RR/RI type)
    
 
endmodule
