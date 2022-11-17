`timescale 1ns / 1ps

module program_counter_tb();

reg clk,rst,imm;
reg [31:0] imm_addr;
wire [31:0] instr_addr;

program_counter PC (
        .clk(clk),
        .rst(rst),
        .imm(imm),
        .imm_addr(imm_addr),
        .instr_addr(instr_addr)
);

reg rst_f,imm_f;
reg [31:0] imm_addr_f, instr_addr_f;
integer file_test_cases;

initial begin: PROGRAM_COUNTER

   file_test_cases = $fopen("program_counter.csv","r");
    if (file_test_cases == 0) begin
        $display("Could not open test cases file.");
        $stop;
    end
    $display("Opened test cases file.");
    
    clk = 0;  

    while( !$feof(file_test_cases)) begin
        
        if (instr_addr !== instr_addr_f) begin
            $display("Output does not match expected value.");
            $stop;
        end     
        
        #5;    
 
        $fscanf(file_test_cases,"%b,%b,%h,%h",rst_f,imm_f,imm_addr_f,instr_addr_f);
 
        rst = rst_f;   
        imm = imm_f;     
        imm_addr = imm_addr_f;     

        #5;
        clk = 1;
        #10;
        clk = 0;        
             
    end
    
    $fclose(file_test_cases);
    $display("All testcases passed!");

    $finish;
end

endmodule
