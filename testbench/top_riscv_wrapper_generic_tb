`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/13/2022 05:11:01 PM
// Design Name: 
// Module Name: top_riscv_wrapper_tb
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


module top_riscv_wrapper_tb();

reg clk,rst;
reg [15:0] sw;
wire [15:0] led;
wire [6:0] seg;
wire [3:0] an;

top_riscv_wrapper DUT(.clk(clk), .btnU(rst), .sw(sw), .led(led), .seg(seg), .an(an));

parameter clock_period=15;
always #(clock_period/2) clk=~clk;

initial begin: GENERIC_TESTS
    
    clk = 0;
    rst = 1;
    sw = 16'h070a;
    #(clock_period*10);    

    rst = 0;
    #(clock_period*200);
    
    $finish;

end

endmodule
