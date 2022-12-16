`timescale 1ns / 1ps

module program_counter_tb();

reg clk,rstn,imm,we;
reg [31:0] imm_addr;
wire [31:0] instr_addr;
wire halt;

program_counter PC (
        .clk(clk),
        .rstn(rstn),
        .imm(imm),
        .we(we),
        .imm_addr(imm_addr),
        .instr_addr(instr_addr),
        .halt(halt)
);

reg rstn_f,imm_f,we_f,halt_f;
reg [31:0] imm_addr_f, instr_addr_f;
integer file_test_cases;

parameter clock_period=15;
always #(clock_period/2) clk=~clk;

initial begin: PROGRAM_COUNTER

   file_test_cases = $fopen("program_counter.csv","r");
    if (file_test_cases == 0) begin
        $display("Could not open test cases file.");
        $stop;
    end
    $display("Opened test cases file.");
    
    clk = 0;  

    while( !$feof(file_test_cases)) begin
        
        if ((instr_addr !== instr_addr_f) && (instr_addr_f !== 32'bx)) begin
            $display("Instruction address does not match expected value.");
            $stop;
        end  
        
        if ((halt !== halt_f) && (halt_f !== 1'bx)) begin
            $display("Halt signal does not match expected value.");
            $stop;
        end   
        
        #(clock_period/4);    
 
        $fscanf(file_test_cases,"%b,%b,%b,%h,%h,%b",rstn_f,we_f,imm_f,imm_addr_f,instr_addr_f,halt_f);
 
        rstn = rstn_f;   
        imm = imm_f; 
        we = we_f;    
        imm_addr = imm_addr_f;     

        #(clock_period*3/4);          
             
    end
    
    $fclose(file_test_cases);
    $display("All testcases passed!");

    $finish;
end

endmodule
