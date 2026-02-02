`timescale 1ns / 1ps

//Top Level Module (MIPS_Processor.v) to act as the "Motherboard" 
//that wires all these separate cards (stages) together.

module MIPS_Processor(
    input clk,
    input reset,
    input clr_PC,
    output [31:0] ALU_Result_WB, // For verification visibility
    output [31:0] WriteData_WB   // For verification visibility
);

    // 1. Wires & Interconnects

    // IF Stage Signals
    wire [31:0] PC_IF, Instr_IF, PC_plus4_IF;
    wire [1:0]  PCsrc; // Master PC Mux Control
    
    // --- IF/ID Register Signals ---
    wire [31:0] PC_ID, Instr_ID;
    
    // --- ID Stage Signals ---
    wire [31:0] rd1_ID, rd2_ID, Imm_ID, PC_target_j_ID;
    wire [4:0]  rs1_ID, rs2_ID, rd_ID;
    
    // --- Control Unit Signals (ID) ---
    wire sel2_ID, is_jr_ID, mem_wr_ID, mem_rd_ID, reg_wr_ID, sel4_ID, hlt_ID, rs2_use_ID;
    wire [1:0] branch_type_ID;
    wire [5:0] alu_ctrl_ID;
    wire jump_ID; // Raw jump signal from Control Unit

    // --- ID/EX Register Signals ---
    wire [31:0] PC_EX, rd1_EX, rd2_EX, Imm_EX;
    wire [4:0]  rs1_EX, rs2_EX, rd_EX;
    wire sel2_EX, is_jr_EX, mem_wr_EX, mem_rd_EX, reg_wr_EX, sel4_EX, hlt_EX;
    wire [1:0] branch_type_EX;
    wire [5:0] alu_ctrl_EX;
    
    // --- EX Stage Signals ---
    wire [31:0] ALU_Result_EX, WriteData_EX, PC_target_branch_EX, PC_target_jr_EX;
    wire branch_taken_EX;
    
    // --- EX/MEM Register Signals ---
    wire [31:0] ALU_Result_MEM, WriteData_MEM;
    wire [4:0]  rd_MEM;
    wire mem_wr_MEM, mem_rd_MEM, reg_wr_MEM, sel4_MEM, hlt_MEM;
    
    // --- MEM Stage Signals ---
    wire [31:0] ReadData_MEM;
    
    // --- MEM/WB Register Signals ---
    wire [31:0] ReadData_WB;
    wire [4:0]  rd_WB;
    wire reg_wr_WB, sel4_WB, hlt_WB;
    // ALU_Result_WB defined in port list
    
    // --- Hazard Unit Signals ---
    wire stall_IF, flush_ID, flush_EX;
    wire [1:0] sel_A_fwd, sel_B_fwd;


    // 2. Logic & Arbitration

    // --- Master PC Control Logic (The "Brain") ---
    // Priority: Branch(EX) > JR(EX) > Jump(ID) > Next(IF)
    assign PCsrc = (branch_taken_EX) ? 2'b11 :
                   (is_jr_EX)        ? 2'b10 :
                   (jump_ID)         ? 2'b01 : 
                                       2'b00;

    // --- Stall Logic ---
    // If we stall, we freeze PC and IF/ID, and flush ID/EX (insert bubble)
    //Halt is added cause we dont want any new instruction to fetched after it
    wire en_PC    = ~(stall_IF | hlt_ID); 
    wire en_IF_ID = ~(stall_IF | hlt_ID);

    // 3. Module Instantiations

    // --- Hazard Unit ---
    Hazard_Unit hu (
        .sel_PC(PCsrc),         // The Master Control Signal
        .lw_EX(mem_rd_EX),      // Is EX instruction a Load?
        .rs1_ID(rs1_ID), 
        .rs2_ID(rs2_ID),
        .rd_EX(rd_EX),
        .rs1_EX(rs1_EX), 
        .rs2_EX(rs2_EX),
        .rd_MEM(rd_MEM), 
        .rd_WB(rd_WB),
        .reg_wr_MEM(reg_wr_MEM), 
        .reg_wr_WB(reg_wr_WB),
        
        // Outputs
        .stall(stall_IF),
        .flush_ID(flush_ID),
        .flush_EX(flush_EX),
        .sel_A(sel_A_fwd),
        .sel_B(sel_B_fwd)
    );

    // --- FETCH STAGE ---
    IF stage_IF(
        .clk(clk),
        .clr_PC(clr_PC),
        .en_IF(en_PC),
        .PCsrc(PCsrc),
        .PC_target_j(PC_target_j_ID),      // Fed back from ID
        .PC_target_jr(PC_target_jr_EX),    // Fed back from EX
        .PC_target_branch(PC_target_branch_EX), // Fed back from EX
        
        .PC(PC_IF),
        .Instr(Instr_IF)
    );

    // --- IF/ID REGISTER ---
    IF_ID_Reg pipe_IF_ID (
        .clk(clk),
        .reset(reset),
        .en(en_IF_ID),
        .flush(flush_ID),
        .PC_IF(PC_IF),
        .Instr_IF(Instr_IF),
        
        .PC_ID(PC_ID),
        .Instr_ID(Instr_ID)
    );

    // --- DECODE STAGE ---
    ID_Stage ID (
        .clk(clk),
        .reg_wr_WB(reg_wr_WB),
        .Instr(Instr_ID),
        .PC_ID(PC_ID),
        .WriteReg_WB(rd_WB),
        .WriteData_WB(WriteData_WB), // Final Result from WB stage
        .rs2_use(rs2_use_ID),
        
        .rd1(rd1_ID),
        .rd2(rd2_ID),
        .Imm(Imm_ID),
        .PC_target_j(PC_target_j_ID),
        .rs1(rs1_ID),
        .rs2(rs2_ID),
        .rd(rd_ID)
    );

    // --- CONTROL UNIT (Decodes in ID Stage) ---
    Control_Unit cu (
        .opcode(Instr_ID[31:26]),
        
        .sel2(sel2_ID),
        .jump(jump_ID),
        .is_jr(is_jr_ID),
        .mem_wr(mem_wr_ID),
        .mem_rd(mem_rd_ID),
        .reg_wr(reg_wr_ID),
        .sel4(sel4_ID),
        .branch_type(branch_type_ID),
        .rs2_use(rs2_use_ID), // used for advanced hazard/stall logic (prevents unwanted data stall while I type instructions)
        .hlt(hlt_ID),
        .alu_ctrl(alu_ctrl_ID)
    );

    
    // --- ID/EX REGISTER ---
    ID_EX_Reg pipe_ID_EX (
        .clk(clk),
        .reset(reset),
        .en(1'b1),        // Always enabled unless we want advanced freezing
        .flush(flush_EX), // Flush signals bubble here
        
        // Data
        .PC_ID(PC_ID), .rd1_ID(rd1_ID), .rd2_ID(rd2_ID), .Imm_ID(Imm_ID),
        .rs1_ID(rs1_ID), .rs2_ID(rs2_ID), .rd_ID(rd_ID),
        
        // Control
        .sel2_ID(sel2_ID), .is_jr_ID(is_jr_ID), .mem_wr_ID(mem_wr_ID), .mem_rd_ID(mem_rd_ID),
        .reg_wr_ID(reg_wr_ID), .sel4_ID(sel4_ID), .branch_type_ID(branch_type_ID),
        .alu_ctrl_ID(alu_ctrl_ID), .hlt_ID(hlt_ID),
        
        // Outputs
        .PC_EX(PC_EX), .rd1_EX(rd1_EX), .rd2_EX(rd2_EX), .Imm_EX(Imm_EX),
        .rs1_EX(rs1_EX), .rs2_EX(rs2_EX), .rd_EX(rd_EX),
        .sel2_EX(sel2_EX), .is_jr_EX(is_jr_EX), .mem_wr_EX(mem_wr_EX), .mem_rd_EX(mem_rd_EX),
        .reg_wr_EX(reg_wr_EX), .sel4_EX(sel4_EX), .branch_type_EX(branch_type_EX),
        .alu_ctrl_EX(alu_ctrl_EX), .hlt_EX(hlt_EX)
    );

    // --- EXECUTE STAGE ---
    EX_Stage EX (
        .PC_EX(PC_EX),
        .A_EX(rd1_EX),
        .B_EX(rd2_EX),
        .Imm_EX(Imm_EX),
        
        // Forwarding
        .sel_A(sel_A_fwd),
        .sel_B(sel_B_fwd),
        .Result_MEM(ALU_Result_MEM), // Forward from MEM stage
        .Result_WB(WriteData_WB),    // Forward from WB stage
        
        // Control
        .sel2(sel2_EX),
        .alu_ctrl(alu_ctrl_EX),
        .branch_type(branch_type_EX),
        
        // Outputs
        .ALU_Result(ALU_Result_EX),
        .WriteData_EX(WriteData_EX),
        .PC_target_branch(PC_target_branch_EX),
        .PC_target_jr(PC_target_jr_EX),
        .branch_taken(branch_taken_EX)
    );

    // --- EX/MEM REGISTER ---
    EX_MEM_Reg pipe_EX_MEM (
        .clk(clk),
        .reset(reset),
        .en(1'b1),
        .flush(1'b0), // Usually no flush needed here
        
        .ALU_Result_EX(ALU_Result_EX),
        .WriteData_EX(WriteData_EX),
        .rd_EX(rd_EX),
        
        .mem_wr_EX(mem_wr_EX), .mem_rd_EX(mem_rd_EX),
        .reg_wr_EX(reg_wr_EX), .sel4_EX(sel4_EX), .hlt_EX(hlt_EX),
        
        .ALU_Result_MEM(ALU_Result_MEM),
        .WriteData_MEM(WriteData_MEM),
        .rd_MEM(rd_MEM),
        .mem_wr_MEM(mem_wr_MEM), .mem_rd_MEM(mem_rd_MEM),
        .reg_wr_MEM(reg_wr_MEM), .sel4_MEM(sel4_MEM), .hlt_MEM(hlt_MEM)
    );

    // --- MEMORY STAGE ---
    MEM_Stage MEM (
        .clk(clk),
        .mem_wr(mem_wr_MEM),
        .mem_rd(mem_rd_MEM),
        .ALU_Result(ALU_Result_MEM),
        .WriteData(WriteData_MEM),
        
        .ReadData(ReadData_MEM)
    );

    // --- MEM/WB REGISTER ---
    MEM_WB_Reg pipe_MEM_WB (
        .clk(clk),
        .reset(reset),
        .en(1'b1),
        .flush(1'b0),
        
        .ReadData_MEM(ReadData_MEM),
        .ALU_Result_MEM(ALU_Result_MEM),
        .rd_MEM(rd_MEM),
        
        .reg_wr_MEM(reg_wr_MEM), .sel4_MEM(sel4_MEM), .hlt_MEM(hlt_MEM),
        
        .ReadData_WB(ReadData_WB),
        .ALU_Result_WB(ALU_Result_WB),
        .rd_WB(rd_WB),
        .reg_wr_WB(reg_wr_WB), .sel4_WB(sel4_WB), .hlt_WB(hlt_WB)
    );

    // --- WRITEBACK STAGE ---
    WB_Stage WB (
        .sel4(sel4_WB),
        .ALU_Result(ALU_Result_WB),
        .ReadData(ReadData_WB),
        
        .Result(WriteData_WB) // Loop back to ID Stage
    );

endmodule