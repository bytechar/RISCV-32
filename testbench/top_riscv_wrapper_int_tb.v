`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/14/2022 07:28:08 PM
// Design Name: 
// Module Name: top_riscv_wrapper_int_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_riscv_wrapper_int_tb();
reg clk,rst;
reg [15:0] sw;
wire [15:0] led;
wire [6:0] seg;
wire [3:0] an;

top_riscv_wrapper DUT(.clk(clk), .btnU(rst), .sw(sw), .led(led), .seg(seg), .an(an));

reg rst_f;
reg [15:0] sw_f, led_f;
reg [3:0] an_f;

integer file_test_cases;
integer cycles;

parameter clock_period=15;
always #(clock_period/2) clk=~clk;

initial begin: INTEGRATION_TESTS 
   
    //file_test_cases = $fopen("integration_testcases.csv","r");
    //file_test_cases = $fopen("integration_testcases2.csv","r");
    //file_test_cases = $fopen("binary_search_1.csv","r");
    //file_test_cases = $fopen("cubes_positive.csv","r");
    file_test_cases = $fopen("sum_cubes.csv","r");
    //file_test_cases = $fopen("rc5.csv","r");
    //file_test_cases = $fopen("rc5_complex.csv","r");
   
    if (file_test_cases == 0) begin
        $display("Could not open test cases file.");
        $stop;
    end
    $display("Opened test cases file.");
        
    clk = 0;
    rst = 1;
    #(clock_period*10);
    
    led_f = 16'h0000;
    an_f = 4'h0;

    while( !$feof(file_test_cases)) begin
        
        // MEM related signals
        
        if (led !== led_f) begin
            $display("LED output %h does not match expected value %h at %0t ps.",led,led_f,$time);
            $stop;
        end 

        // HALT related signals
        
        if ((seg !== 7'h00) || (an !== an_f)) begin
            $display("HALT output %h does not match expected value %h at %0t ps.",an,an_f,$time);
            $stop;
        end
                
        $fscanf(file_test_cases,"%b,%h,%h,%h,%d",rst_f,sw_f,led_f,an_f,cycles);
        
        rst = rst_f;
        sw = sw_f;
        
        #(clock_period*cycles);
     
    end
    
    $fclose(file_test_cases);
    $display("All testcases passed!");
 
    $finish;

end

endmodule
