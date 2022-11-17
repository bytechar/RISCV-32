`timescale 1ps / 0.1ps

module instruction_mem_tb();

reg clk;
reg [31:0] instr_addr;
wire [31:0] instr;

instruction_mem imem1 (
        .clk(clk),
        .instr_addr(instr_addr),
        .instr(instr)
);

reg [31:0] instr_addr_f;
reg [31:0] instr_f;

integer file_test_cases;

initial begin: INSTRUCTION_MEMORY

   file_test_cases = $fopen("imem_testcases.csv","r");
    if (file_test_cases == 0) begin
        $display("Could not open test cases file.");
        $stop;
    end
    $display("Opened test cases file.");
    
    clk = 0;    

    while( !$feof(file_test_cases)) begin
        
        if (instr !== instr_f) begin
            $display("Output does not match expected value.");
            $stop;
        end     
        
        #5;    
 
        $fscanf(file_test_cases,"%h,%h",instr_addr_f,instr_f);
        instr_addr = instr_addr_f;     

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
