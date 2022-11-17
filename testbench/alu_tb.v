`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2022 03:44:16 PM
// Design Name: 
// Module Name: alu_tb
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


module alu_tb();
    
    parameter width = 32;
    reg [width - 1:0] t_in_a, t_in_b, exp_result;
    reg [3:0] t_alu_select;
    wire [width - 1:0] t_result;
    
    integer test_fp;
    
    ALU dut(
        .in_a(t_in_a),
        .in_b(t_in_b),
        .alu_select(t_alu_select),
        .result(t_result)
        );
    
    integer t_cnt = 0;
    integer cnt_pass = 0;
    integer cnt_fail = 0;
    reg out_display;
    
    initial begin
        test_fp = $fopen("alu_test.txt", "r");
        
        if(test_fp == 0) begin
            $display("Unable to open the test case file.");
            $finish;
        end
    
    while(!$feof(test_fp)) begin
        $fscanf(test_fp, "%h %h %h %h\n", t_in_a, t_in_b, t_alu_select, t_result);
        t_cnt = t_cnt + 1;
        #5
        if(exp_result == t_result) begin
            cnt_pass = cnt_pass + 1;
            out_display = "Passed!";
        end
        else begin
            cnt_fail = cnt_fail + 1;
            out_display = "Failed!";
        end
        $display("Expected: %h, Actual: %h", exp_result, t_result);
     end
     $display("\nResult:");
     if(cnt_pass == t_cnt)
        $display("All Tests Passed!");
     else begin
        $display("%d Tests Passed.", cnt_pass);
        $display("%d Tests Failed.", cnt_pass);
     end
     $finish;
     
end   
endmodule
