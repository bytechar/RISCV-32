`timescale 1ns / 1ps
`include "defines.vh"
`default_nettype none

module branch_comp(
    input wire [2:0] branch_op,
    input wire [31:0] data_in1,
    input wire [31:0] data_in2,
    output reg branch_out
    );
    
    always@(*) begin
        case(branch_op)
            `BEQ: // Branch if equal
                branch_out = (data_in1==data_in2) ? 1:0;
            `BNE: // Branch if not equal
                branch_out = (data_in1==data_in2) ? 0:1;
            `BLT: // Branch if less than (signed)
                branch_out = ($signed(data_in1) < $signed(data_in2)) ? 1:0;
            `BGE: // branch if greater than or equal (signed)
                branch_out = ($signed(data_in1) < $signed(data_in2)) ? 0:1;
            `BLTU: // branch if less than (unsigned)
                branch_out = (data_in1 < data_in2)? 1:0;
            `BGEU: // branch if greater than or equal (unsigned)
                branch_out = (data_in1 < data_in2)? 0:1;
        endcase
    end
    
endmodule
