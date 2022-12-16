`timescale 1ns / 1ps

module instruction_mem_tb();

reg clk, rd;
reg [31:0] instr_addr;
wire [31:0] instr;

instruction_mem imem1 (
        .clk(clk),
        .rd(rd),
        .instr_addr(instr_addr),
        .instr(instr)
);

reg rd_f;
reg [31:0] instr_addr_f;
reg [31:0] instr_f;

integer file_test_cases;

parameter clock_period=15;
always #(clock_period/2) clk=~clk;

initial begin: INSTRUCTION_MEMORY

   $readmemh("imem_tb.mem", imem1.imem);
   
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
         
        #(clock_period/4);
        
        $fscanf(file_test_cases,"%b,%h,%h",rd_f,instr_addr_f,instr_f);
        
        rd = rd_f;
        instr_addr = instr_addr_f;     

        #(clock_period*3/4);               
             
    end
    
    $fclose(file_test_cases);
    $display("All testcases passed!");

    $finish;
end


endmodule
