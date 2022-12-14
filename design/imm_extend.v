`timescale 1ns / 1ps
`include "defines.vh"
`default_nettype none

module imm_extend(
    input wire [31:0] instr,
    output reg signed [31:0] immediate
    );
    
    wire [2:0] funct3;    
    wire [6:0] opcode;
    assign funct3 = instr[14:12];
    assign opcode = instr[6:0];
    
    always @(*) begin
        case(opcode)
            `AUIPC:  immediate = { instr[31:12]    , {12{1'b0}} };                                          //U-type
            `JAL:    immediate = { {12{instr[31]}} , instr[19:12] , instr[20]    , instr[30:21] , 1'b0 };   //J-type
            `JALR:   immediate = { {21{instr[31]}} , instr[30:20] };                                        //I-type
            `BRANCH: immediate = { {20{instr[31]}} , instr[7]     , instr[30:25] , instr[11:8]  , 1'b0 };   //B-type
            `STORE:  immediate = { {19{instr[31]}} , instr[30:25] , instr[11:7]  , {2{1'b0}} };             //S-type
            `LOAD:   immediate = { {19{instr[31]}} , instr[30:20] , {2{1'b0}} };                            //L-type
             //need to pick immediates differently for shift operations
            `IMM:    immediate = (funct3[0] && ~funct3[1]) ? { {27{1'b0}} , instr[24:20] } : { {21{instr[31]}} , instr[30:20] };
            default: immediate = { 32{1'b0} };
        endcase
    end

endmodule
