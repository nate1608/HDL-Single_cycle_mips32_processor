`timescale 1ns / 1ps

module Hazard_Unit(
    // control hazard
    input [1:0] sel_PC,         // 00:Next, 01:Jump, 10:JR, 11:Branch
    output reg flush_ID,        // Flush IF/ID (Fetch Stage)
    
    // stalls (Load-Use Hazard) 
    input lw_EX,                // Is the instruction in EX a Load?
    input [4:0] rs1_ID,         // Source Reg 1 in Decode
    input [4:0] rs2_ID,         // Source Reg 2 in Decode
    input [4:0] rd_EX,          // Dest Reg in Execute
    output reg stall,           // Stall the pipeline
    output reg flush_EX,        // Flush ID/EX (Execute Stage)
    
    // Forwarding Signals (Data Hazard) 
    input [4:0] rs1_EX,         // Source Reg 1 in Execute
    input [4:0] rs2_EX,         // Source Reg 2 in Execute
    input [4:0] rd_MEM,         // Dest Reg in Memory Stage
    input [4:0] rd_WB,          // Dest Reg in Writeback Stage
    input reg_wr_MEM,           // Write Enable in Memory Stage
    input reg_wr_WB,            // Write Enable in Writeback Stage
    
    output reg [1:0] sel_A,     // Forward A (00:Reg, 01:MEM, 10:WB)
    output reg [1:0] sel_B      // Forward B (00:Reg, 01:MEM, 10:WB)
);

    // PC Source Constants) ---
    parameter PC_NEXT   = 2'b00;
    parameter PC_JUMP   = 2'b01;
    parameter PC_JR     = 2'b10;
    parameter PC_BRANCH = 2'b11;

    always @(*) begin
        // 1. Stall Logic (Load-Use Hazard)
        // If the instruction in EX is a Load (lw) AND
        // it writes to a register that the ID instruction needs to read (rs1 or rs2)
        // -> STALL.
        stall = ((rs1_ID == rd_EX) || (rs2_ID == rd_EX)) && lw_EX && (rd_EX != 5'b0);

        // 2. Flush Logic (Control Hazard)
        
        // Flush EX: 
        // 1. If we Stall, we must insert a Bubble into EX (Flush it).
        // 2. If a Branch/JR is taken (sel_PC[1] is high), the instruction in ID is wrong.
        flush_EX = stall || (sel_PC[1] == 1'b1); 
        
        // Flush ID:
        // If ANY jump/branch happens (sel_PC != 0), the instruction being Fetched is wrong.
        flush_ID = |sel_PC;
        // 3. Forwarding Logic (RAW Hazard)
        
        // Forwarding for Source A (rs1) 
       
        if ((rs1_EX == rd_MEM) && reg_wr_MEM && (rs1_EX != 0)) 
            sel_A = 2'b01;
        else if ((rs1_EX == rd_WB) && reg_wr_WB && (rs1_EX != 0)) 
            sel_A = 2'b10;
        else 
            sel_A = 2'b00;

        //Forwarding for Source B (rs2) 
       
        if ((rs2_EX == rd_MEM) && reg_wr_MEM && (rs2_EX != 0)) 
            sel_B = 2'b01;
        else if ((rs2_EX == rd_WB) && reg_wr_WB && (rs2_EX != 0)) 
            sel_B = 2'b10;
        else 
            sel_B = 2'b00;
            
    end
endmodule