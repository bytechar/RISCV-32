`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/07/2022 05:31:00 PM
// Design Name: 
// Module Name: program_counter
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
module program_counter(
    input wire clk,rst,branch,
    input wire [31:0] imm_addr,
    output reg [31:0] instr_addr
    );
    
    always@(posedge clk or posedge rst)
begin
    if(rst==1) instr_addr <= 32'h01000000;
    else
    begin
        if(branch==1) instr_addr <= instr_addr + imm_addr;
        else instr_addr <= instr_addr + 4;
    end
end
    
endmodule
