`timescale 1ns / 1ps
`include "defines.vh"
`default_nettype none

module branch_comp(
    input wire [2:0] branch_op,
    input wire [31:0] data_in1,
    input wire [31:0] data_in2,
    output wire branch_out
    );
    
    reg branch_output;
    
    always@(*) begin
        case(branch_op)
            `BEQ: // Branch if equal
                branch_output = (data_in1==data_in2) ? 1:0;
            `BNE: // Branch if not equal
                branch_output = (data_in1!=data_in2) ? 1:0;
            `BLT: // Branch if less than (signed)
                branch_output = ($signed(data_in1) < $signed(data_in2)) ? 1:0;
            `BGE: // branch if greater than or equal (signed)
                branch_output = ($signed(data_in1) > $signed(data_in2)) ? 1:0;
            `BLTU: // branch if less than (unsigned)
                branch_output = (data_in1 < data_in2)? 1:0;
            `BGEU: // branch if greater than or equal (unsigned)
                branch_output = (data_in1 > data_in2)? 1:0;
             default: branch_output = 1'b0; 
        endcase
    end
    
    assign branch_out = branch_output;
    
endmodule
