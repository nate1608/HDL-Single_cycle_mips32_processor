`timescale 1ns / 1ps

//connect all the components together and consider any input as controls coming from control_path
    
    
module data_path(IR_ID, sel2,jump, branch, sel4, opcode, rs1, rs2, rd, mem_wr, mem_rd, reg_wr,clr_PC,reset, clk );
    input [4:0] rs1,rs2,rd;
    input [5:0] opcode;
    input mem_rd, mem_wr,reg_wr,clk,clr_PC, sel2,jump,sel4; 
    input [1:0] branch;
    input reset;
    
    wire EQZ, sel3;
    wire en = 1'b1;
    wire flush = 1'b0;
    
    
    //wires (interconnection between modules)
    wire [31:0] NPC,A,B,Imm,z,x,y;
    wire [31:0] PC,PC_plus1, PC_target, d_in;
    wire [31:0] LMD;
    wire [31:0] IR;
    
    //wires for different stages
    wire [31:0] PC_ID;
    output wire [31:0] IR_ID;
    
    wire [31:0] A_EX, B_EX, Imm_EX, PC_EX;
    wire sel2_EX, jump_EX, sel4_EX, mem_wr_EX, mem_rd_EX, reg_wr_EX;
    wire [1:0] branch_EX;
    wire [5:0] opcode_EX;
    wire [4:0] rd_EX;
    
    wire [31:0] z_MEM, B_MEM;
    wire sel4_MEM, mem_wr_MEM, mem_rd_MEM, reg_wr_MEM;
    wire [4:0] rd_MEM;
    
    wire [31:0] LMD_WB, z_WB;
    wire sel4_WB, reg_wr_WB;
    wire [4:0] rd_WB;
    
    //Branch instruction
    wire Branch_Taken_EX;
    
    
    //IF stage
    PC_plus1 adder1(PC, PC_plus1);
    MUX2x1 mux3(sel3,PC_plus1,PC_target,NPC);   // updates NPC based on branch and it's condition
    REG_PC pc_reg(PC,NPC,clr_PC,clk);           //Loads the previous cycles's NPC to PC at clock edge

    INS_MEM ins_set1(PC,IR);                    //Fetches instruction            
    
    reg_IF_ID reg_ID( clk, IR, PC, 1'b1, 1'b0, 1'b0, IR_ID, PC_ID);
            
            
    //ID stage                           
    assign Imm = {{16{IR_ID[15]}},IR_ID[15:0]};
    REG_BANK reg_bank1(reg_wr_WB,rs1,rs2,rd_WB,d_in,A,B,clk); //For Fetching A=reg[rs1] and B=reg[rs2] and writing back reg[rd]=d_in
    
    reg_ID_EX reg_EX( clk, A, B, Imm, PC_ID,sel2,jump, branch, sel4, opcode, rd, mem_wr, mem_rd, reg_wr, en, reset, 
    flush, A_EX, B_EX, Imm_EX, PC_EX,sel2_EX,jump_EX, branch_EX, sel4_EX, opcode_EX, rd_EX, mem_wr_EX, mem_rd_EX, reg_wr_EX);
    
    
    //EX stage
    MUX2x1 mux2(sel2_EX,B_EX,Imm_EX,y);
    ALU alu1(opcode_EX,A_EX,y,z);              //ALU (contains both ALU decoder as well ALU functions)
    assign EQZ = (A_EX==32'h00000000);      //Branch taken or not
    assign Branch_Taken_EX = (branch_EX == 2'b01 && EQZ) ||       // BEQZ taken
                             (branch_EX == 2'b10 && !EQZ);        // BNEQZ taken
    assign sel3 = (~branch_EX[1])&branch_EX[0]&EQZ || branch_EX[1]&(~branch_EX[0])&(~EQZ) || jump_EX;
    PC_Adder adder2(PC_EX, Imm_EX, PC_target);
    
    reg_EX_MEM reg_MEM( clk, z, B_EX, sel4_EX, rd_EX, mem_wr_EX, mem_rd_EX, reg_wr_EX, en, reset, flush, 
    z_MEM, B_MEM, sel4_MEM, rd_MEM, mem_wr_MEM, mem_rd_MEM, reg_wr_MEM );
    
    
    //MEM stage 
    DATA_MEM data_mem(mem_rd_MEM,mem_wr_MEM,z_MEM,B_MEM, LMD, clk);      //read(load) or write(store) 
    
    reg_MEM_WB reg_WB( clk, LMD, sel4_MEM, reg_wr_MEM, rd_MEM, z_MEM, en, reset, flush, 
    LMD_WB, z_WB, sel4_WB, reg_wr_WB, rd_WB);
    
    
    //WB stage
    MUX2x1 mux4(sel4_WB,LMD_WB,z_WB,d_in);                       //selects between mem[z] (load) and z (RR/RI type)
    
 
endmodule
