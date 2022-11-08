`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/07/2022 05:31:00 PM
// Design Name: 
// Module Name: register_file
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
module register_file(
    input wire clk,we,
    input wire [4:0] rs1_addr, rs2_addr, rd_addr,
    input wire [31:0] rd_din,
    output wire [31:0] rs1_dout, rs2_dout
    );
    
    reg [31:0] register_file [0:31];
    initial register_file[0] = 32'h00000000;
    
    reg [4:0] rs1_addr_reg, rs2_addr_reg;
    
    always@(posedge clk)
    begin
        rs1_addr_reg <= rs1_addr;
        rs2_addr_reg <= rs2_addr;        
        if (we==1 & rd_addr!=5'h00) register_file[rd_addr] <= rd_din;
    end
    
    assign rs1_dout = register_file[rs1_addr_reg];
    assign rs2_dout = register_file[rs2_addr_reg];

endmodule
