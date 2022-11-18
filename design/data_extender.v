`timescale 1ns / 1ps
`include "defines.vh"
`default_nettype none

module data_ext(
input wire [2:0] opcode,
input wire [31:0] d_in,
output wire [31:0] d_out
    );
    
    reg [31:0] data_out;
    
    always@(*) begin
        case(opcode)
            `LB: data_out <= {{24{d_in[7]}}, d_in[7:0]};
            `LH: data_out <= {{16{d_in[15]}}, d_in[15:0]};
            `LBU: data_out <= {{24{1'b0}}, d_in[7:0]};
            `LHU: data_out <= {{16{1'b0}}, d_in[15:0]};
            `LW: data_out <= d_in;
            default: data_out <= 32'd0;
        endcase
    end
    
    assign d_out = data_out;
    
endmodule


