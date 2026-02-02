`timescale 1ns / 1ps

module test_bench();

    reg clk;
    reg clr_PC;
    reg reset;
    // Debug outputs from Top Module
    wire [31:0] ALU_Result_WB;
    wire [31:0] WriteData_WB;
    
    
    wire [1:0] PCsrc = CPU.PCsrc;
    wire [31:0] PC = CPU.PC_ID;
    wire [31:0] IR = CPU.Instr_ID;
    
    wire [4:0] rs1 = CPU.rs1_ID;
    wire [4:0] rs2 = CPU.rs2_ID;
    wire [4:0] rd = CPU.rd_ID;
    wire [31:0] R1 = CPU.ID.rf.reg_bank[5'd1];
    wire [31:0] R2 = CPU.ID.rf.reg_bank[5'd2];
    wire [31:0] R3 = CPU.ID.rf.reg_bank[5'd3];
    wire [1:0] branch_type = CPU.branch_type_ID;
    wire stall = CPU.stall_IF;
    wire flush_ID = CPU.flush_ID;
    wire flush_EX  = CPU.flush_EX;
    wire [1:0] sel_Aforward = CPU.sel_A_fwd;
    wire [1:0] sel_Bforward = CPU.sel_B_fwd;
    
    integer i;

    // Instantiate the Top Level Processor
    MIPS_Processor CPU( 
        .clk(clk), 
        .reset(reset),
        .clr_PC(clr_PC),
        .ALU_Result_WB(ALU_Result_WB),
        .WriteData_WB(WriteData_WB)
    );
    
    // Simulation Duration
    initial #1000 $finish;
    
    // Clock Generation
    initial clk = 1'b0;
    always #5 clk = ~clk;
    
    // Memory Initialization
    initial begin
        // Initialize Instruction Memory (inside IF Stage)
        for(i=0; i<1024; i=i+1) begin
            CPU.stage_IF.imem.mem[i] = 32'bx;
        end

        // Initialize Data Memory (inside MEM Stage)
        // Setting specific values for testing
        CPU.MEM.dmem.mem[200] = 32'd5;
        CPU.MEM.dmem.mem[201] = 32'd67;
    end
    
    // Reset & Program Load
    initial begin
        #2 clr_PC = 1'b1; reset = 1'b1;
        
        // Load the Hex program
        // Update this path if you move the file!
        $readmemh("C:/Users/ASUS/visual code/Assembler/temp.hex", CPU.stage_IF.imem.mem);
        
        #1 clr_PC = 1'b0; reset = 1'b0;

        // Monitor Register Values (inside ID Stage -> Register File)
        $monitor($time, " R[1]=%d, R[2]=%d, R[3]=%d, R[4]=%d",  
            $signed(CPU.ID.rf.reg_bank[1]), 
            $signed(CPU.ID.rf.reg_bank[2]),
            $signed(CPU.ID.rf.reg_bank[3]), 
            $signed(CPU.ID.rf.reg_bank[4]),
            $signed(CPU.ID.rf.reg_bank[31])
        );
        
        // Monitor Memory Output (inside MEM Stage)
        $monitor($time, " Data_mem[200]=%d, Data_mem[198]=%d", 
            CPU.MEM.dmem.mem[32'd200], 
            CPU.MEM.dmem.mem[32'd198] 
        );
    end
        
endmodule
