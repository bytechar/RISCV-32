`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/07/2022 05:31:00 PM
// Design Name: 
// Module Name: instruction_mem
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

`default_nettype none
module instruction_mem(
    input wire clk,
    input wire [31:2] instr_addr,
    output wire [31:0] instr
    );
    
    reg [31:0] imem ['h01000000/4:'h010007FF/4];
    //initial begin
    //    $readmemh("imem.mem", imem);
    //end  
    
    reg [31:2] instr_addr_reg;
    
    always@(posedge clk)
    begin
        instr_addr_reg <= instr_addr;
    end
    
    assign instr = imem[instr_addr_reg];
    
endmodule
