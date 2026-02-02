`timescale 1ns / 1ps


module test_bench();
    reg clk;
    reg clr_PC;
    wire [5:0] opcode;
    wire [31:0] IR;
    wire [4:0] rs1,rs2,rd;
    integer i,k;
    
    control_path2 CP( sel1, sel2, sel3,sel4, opcode, rs1, rs2, rd, mem_wr,mem_rd, reg_wr, IR, EQZ);
    data_path1 DP( IR, EQZ, sel1, sel2, sel3,sel4, opcode, rs1, rs2, rd, mem_wr,mem_rd, reg_wr,clr_PC, clk );
    
    initial clk=1'b0;
    
    always #5 clk = ~clk;
    
    initial
        begin
            for(i=0; i<1024; i=i+1)
                begin
                    DP.ins_set1.mem[i] = 32'bx;
                    //DP.data_mem.mem[i] = 32'dx; //to clear data memory
                end
            DP.data_mem.mem[200] = 32'd5;
        end
    
    initial
        begin
             //initializing program counter to 0
             #2 clr_PC=1'b1; #7 clr_PC=1'b0;  

//program for finding factorial of value stored at mem[200] and store the result at mem[198] (for without script test)
//            DP.ins_set1.mem[6'd0] = 32'h200100c8;
//            DP.ins_set1.mem[6'd1] = 32'h28020001;
//            DP.ins_set1.mem[6'd2] = 32'h14411000;
//            DP.ins_set1.mem[6'd3] = 32'h2c210001;
//            DP.ins_set1.mem[6'd4] = 32'h3420fffd;
//            DP.ins_set1.mem[6'd5] = 32'h240200c6;
//            DP.ins_set1.mem[6'd6] = 32'hfc000000;

            //Reads program from the hex file generates from python script (assembly to machine code)
            $readmemh( "verification/program.hex ",  DP.ins_set1.mem );

            //uncomment to check registers value (apply suffient delay first) 
            //for(k=0; k<3; k=k+1) begin #15
            //    $display( $time, "R[k] = %d ",  DP.reg_bank1.reg_bank[k]); 
            //end
            
            $monitor( $time, "R[1] = %d /nR[2] = %d",  DP.reg_bank1.reg_bank[1] ,DP.reg_bank1.reg_bank[2] );   
            #195 $monitor($time, "Data_mem[200] = %d /nData_mem[198] = %d", DP.data_mem.mem[32'd200] , DP.data_mem.mem[32'd198] );
        end
endmodule
