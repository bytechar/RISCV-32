`timescale 1ns / 1ps
`include "defines.vh"
`default_nettype none

module Decoder
    #(parameter data_width = 32)(
    input wire [data_width - 1:0] instruction,
    output wire [4:0] rs1, rs2, rd,
    output reg [3:0] alu_select, we,
    output wire [2:0] bc_select, load_select,
    output wire alu_inb_imm_select, alu_ina_pc_select, rd_din_pc_select,
    output wire signed [31:0] immediate,
    output wire is_LUI, is_AUIPC, is_JAL, is_JALR, is_BRANCH, is_LOAD, is_STORE, is_IMM, is_ALU, is_FENCE, is_SYSTEM
    //to be added
);
    wire [6:0] top_opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
            
    imm_extend IMM_EXT(.instr(instruction), .immediate(immediate));

    assign top_opcode = instruction[6:0];
    assign funct3 = instruction[14:12];
    assign funct7 = instruction[31:25];
    
    assign is_LUI = top_opcode == `LUI;
    assign is_AUIPC = top_opcode == `AUIPC;
    assign is_JAL = top_opcode == `JAL;
    assign is_JALR = top_opcode == `JALR;
    assign is_BRANCH = top_opcode == `BRANCH;
    assign is_LOAD = top_opcode == `LOAD;
    assign is_STORE = top_opcode == `STORE;
    assign is_IMM = top_opcode == `IMM;
    assign is_ALU = top_opcode == `ALU;
    assign is_FENCE = top_opcode == `FENCE;
    assign is_SYSTEM = top_opcode == `SYSTEM;
    
    assign rs1 = (is_LUI || is_FENCE) ? 5'b00000 : instruction[19:15];
    assign rs2 = instruction[24:20];
    assign rd = is_FENCE ? 5'b00000 : instruction[11:7];
    
    assign bc_select = funct3;
    assign load_select = funct3;
    assign alu_inb_imm_select = is_LOAD || is_STORE || is_IMM || is_BRANCH || is_JALR || is_JAL || is_LUI || is_AUIPC;
    assign alu_ina_pc_select = is_JAL || is_AUIPC || is_BRANCH;
    assign rd_din_pc_select = is_JAL || is_JALR;
    
    always@(*) begin
    
        //data memory wr-enable
        case(funct3)
               `SB : we = 4'b0001; 
               `SH : we = 4'b0011;
               `SW : we = 4'b1111;
            default: we = 4'b0000;
        endcase
        
        //ALU op select
        case( is_LOAD || is_STORE || is_BRANCH || is_JALR || is_JAL || is_LUI || is_AUIPC || is_FENCE )
            1'b1 : alu_select = `ADD;
            default: alu_select = {(funct7[5] && ((funct3[0] && ~funct3[1]) || ~is_IMM)),funct3};
                                   //pick funct7[5] ONLY when not IMM type OR SHIFT instruction           
        endcase
        
    end
        
endmodule
