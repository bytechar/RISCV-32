`timescale 1ns / 1ps
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
    input [31:0] in_a,
    input [31:0] in_b,
    input [3:0] alu_select,
    output reg [31:0] result
    );
    
    always @(*) begin
    case(alu_select)
        4'b0000: result = in_a + in_b; //ADD
        4'b0001: result = in_a - in_b; //SUB
        4'b0010: result = in_a << in_b[4:0]; //Shift Left Logical
        4'b0011: result = $signed(in_a) < $signed(in_b); //Set Less than Signed
        4'b0100: result = $unsigned(in_a) < $unsigned(in_b); //Set Less than Unsigned
        4'b0101: result = in_a ^ in_b; //XOR
        4'b0110: result = in_a >> in_b[4:0]; //Shift Right Logical
        4'b0111: result = $signed(in_a) >>> in_b[4:0]; //Shift Right Arithmatic
        4'b1000: result = in_a | in_b; //OR
        4'b1001: result = in_a & in_b; //AND
    endcase
end
endmodule
