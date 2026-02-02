`timescale 1ns / 1ps

//Role: buffers ALU results before Memory Access.
//Critical: Carries WriteData (which is the forwarded B value) for sw instructions.

module EX_MEM_Reg(
    input clk,
    input reset,
    input en,
    input flush,
    
    // Data Inputs
    input [31:0] ALU_Result_EX,
    input [31:0] WriteData_EX, // The forwarded 'B' value
    input [4:0]  rd_EX,
    
    // Control Inputs
    input mem_wr_EX,
    input mem_rd_EX,
    input reg_wr_EX,
    input sel4_EX,
    input hlt_EX,
    
    // Outputs
    output reg [31:0] ALU_Result_MEM,
    output reg [31:0] WriteData_MEM,
    output reg [4:0]  rd_MEM,
    
    output reg mem_wr_MEM,
    output reg mem_rd_MEM,
    output reg reg_wr_MEM,
    output reg sel4_MEM,
    output reg hlt_MEM
);

    always @(posedge clk or posedge reset) begin
        if (reset || flush) begin
            ALU_Result_MEM <= 0; WriteData_MEM <= 0; rd_MEM <= 0;
            mem_wr_MEM <= 0; mem_rd_MEM <= 0; reg_wr_MEM <= 0; sel4_MEM <= 0;
            hlt_MEM <= 0;
        end
        else if (en) begin
            ALU_Result_MEM <= ALU_Result_EX;
            WriteData_MEM  <= WriteData_EX;
            rd_MEM         <= rd_EX;
            
            mem_wr_MEM <= mem_wr_EX;
            mem_rd_MEM <= mem_rd_EX;
            reg_wr_MEM <= reg_wr_EX;
            sel4_MEM   <= sel4_EX;
            hlt_MEM    <= hlt_EX;
        end
    end

endmodule