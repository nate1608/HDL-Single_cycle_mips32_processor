`timescale 1ns / 1ps

//Final buffer before Writeback.
module MEM_WB_Reg(
    input clk,
    input reset,
    input en,
    input flush, // Usually 0, but kept for consistency
    
    // Data Inputs
    input [31:0] ReadData_MEM,
    input [31:0] ALU_Result_MEM,
    input [4:0]  rd_MEM,
    
    // Control Inputs
    input reg_wr_MEM,
    input sel4_MEM,
    input hlt_MEM,
    
    // Outputs
    output reg [31:0] ReadData_WB,
    output reg [31:0] ALU_Result_WB,
    output reg [4:0]  rd_WB,
    
    output reg reg_wr_WB,
    output reg sel4_WB,
    output reg hlt_WB
);

    always @(posedge clk or posedge reset) begin
        if (reset || flush) begin
            ReadData_WB <= 0; ALU_Result_WB <= 0; rd_WB <= 0;
            reg_wr_WB <= 0; sel4_WB <= 0; hlt_WB <= 0;
        end
        else if (en) begin
            ReadData_WB   <= ReadData_MEM;
            ALU_Result_WB <= ALU_Result_MEM;
            rd_WB         <= rd_MEM;
            
            reg_wr_WB <= reg_wr_MEM;
            sel4_WB   <= sel4_MEM;
            hlt_WB    <= hlt_MEM;
        end
    end

endmodule