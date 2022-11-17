`timescale 1ns / 1ps
`include "defines.vh"
`default_nettype none

module imm_extend(
    input wire [31:0] instr,
    output reg signed [31:0] immediate
    );
        
    wire [6:0] opcode;
    assign opcode = instr[6:0];
    
    always @(*) begin
        case(opcode)
            `AUIPC:  immediate = { instr[31:12]    , {12{1'b0}} };                                          //U-type
            `JAL:    immediate = { {12{instr[31]}} , instr[19:12] , instr[20]    , instr[30:21] , 1'b0 };   //J-type
            `JALR:   immediate = { {12{instr[31]}} , instr[19:12] , instr[20]    , instr[30:21] , 1'b0 };   //J-type
            `BRANCH: immediate = { {20{instr[31]}} , instr[7]     , instr[30:25] , instr[11:8]  , 1'b0 };   //B-type
            `STORE:  immediate = { {21{instr[31]}} , instr[30:25] , instr[11:7] };                          //S-type
            `LOAD:   immediate = { {21{instr[31]}} , instr[30:20] };                                        //I-type
            `IMM:    immediate = { {21{instr[31]}} , instr[30:20] };                                        //I-type
            default: immediate = { 32{1'b0} };
        endcase
    end

endmodule
