`timescale 1ns / 1ps

//Role: The massive register that passes everything to Execute.
//Updates: Now carries is_jr and branch_type correctly.

module ID_EX_Reg(
    input clk,
    input reset,
    input en,
    input flush,
    
    // Data Inputs
    input [31:0] PC_ID,
    input [31:0] rd1_ID,
    input [31:0] rd2_ID,
    input [31:0] Imm_ID,
    input [4:0]  rs1_ID,
    input [4:0]  rs2_ID,
    input [4:0]  rd_ID,
    
    // Control Inputs (From Control Unit)
    input sel2_ID,        // ALUSrc
    input is_jr_ID,
    input mem_wr_ID,
    input mem_rd_ID,
    input reg_wr_ID,
    input sel4_ID,        // MemToReg
    input [1:0] branch_type_ID,
    input [5:0] alu_ctrl_ID,
    input hlt_ID,
    
    // Outputs
    output reg [31:0] PC_EX,
    output reg [31:0] rd1_EX,
    output reg [31:0] rd2_EX,
    output reg [31:0] Imm_EX,
    output reg [4:0]  rs1_EX,
    output reg [4:0]  rs2_EX,
    output reg [4:0]  rd_EX,
    
    output reg sel2_EX,
    output reg is_jr_EX,
    output reg mem_wr_EX,
    output reg mem_rd_EX,
    output reg reg_wr_EX,
    output reg sel4_EX,
    output reg [1:0] branch_type_EX,
    output reg [5:0] alu_ctrl_EX,
    output reg hlt_EX
);

    always @(posedge clk or posedge reset) begin
        if (reset || flush) begin
            // Reset all to 0
            PC_EX <= 0; rd1_EX <= 0; rd2_EX <= 0; Imm_EX <= 0;
            rs1_EX <= 0; rs2_EX <= 0; rd_EX <= 0;
            sel2_EX <= 0; is_jr_EX <= 0; mem_wr_EX <= 0; mem_rd_EX <= 0;
            reg_wr_EX <= 0; sel4_EX <= 0; branch_type_EX <= 0; alu_ctrl_EX <= 0;
            hlt_EX <= 0;
        end
        else if (en) begin
            PC_EX <= PC_ID;
            rd1_EX <= rd1_ID;
            rd2_EX <= rd2_ID;
            Imm_EX <= Imm_ID;
            rs1_EX <= rs1_ID;
            rs2_EX <= rs2_ID;
            rd_EX  <= rd_ID;
            
            sel2_EX <= sel2_ID;
            is_jr_EX <= is_jr_ID;
            mem_wr_EX <= mem_wr_ID;
            mem_rd_EX <= mem_rd_ID;
            reg_wr_EX <= reg_wr_ID;
            sel4_EX <= sel4_ID;
            branch_type_EX <= branch_type_ID;
            alu_ctrl_EX <= alu_ctrl_ID;
            hlt_EX <= hlt_ID;
        end
    end

endmodule