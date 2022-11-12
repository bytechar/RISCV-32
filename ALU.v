`timescale 1ns / 1ps
`include "defines.vh"
`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/07/2022 02:56:38 PM
// Design Name: 
// Module Name: ALU
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


module ALU(
    input wire [31:0] in_a,
    input wire [31:0] in_b,
    input wire [3:0] alu_select,
    output reg [31:0] result
    );
    
    always @(*) begin
    case(alu_select)
        `ADD: result = in_a + in_b; //ADD
        `SUB: result = in_a - in_b; //SUB
        `SLL: result = in_a << in_b[4:0]; //Shift Left Logical
        `SLT: result = $signed(in_a) < $signed(in_b); //Set Less than Signed
        `SLTU: result = $unsigned(in_a) < $unsigned(in_b); //Set Less than Unsigned
        `XOR: result = in_a ^ in_b; //XOR
        `SRL: result = in_a >> in_b[4:0]; //Shift Right Logical
        `SRA: result = $signed(in_a) >>> in_b[4:0]; //Shift Right Arithmatic
        `OR: result = in_a | in_b; //OR
        `AND: result = in_a & in_b; //AND
        default: result = result; //added default
    endcase
end
endmodule
