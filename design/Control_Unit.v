`timescale 1ns / 1ps
`include "defines.vh"
`default_nettype none
`define NUM_STATES 5
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2022 07:13:27 PM
// Design Name: 
// Module Name: Control_Unit
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


module Control_Unit(
    input wire clk, 
    input wire rstn,
    
    // DECODER generated signals
    input wire load,
    input wire store,
    input wire branch,
    input wire fence,
    input wire [3:0] decoder_dmem_we,
    input wire halt,
    
     // pc
    output reg pc_we,                     // PC write enable
    // IMem
    output reg imem_rd,                   // IMem read enable
    // regfile
    output reg rf_we,                      // reg file write enable
    // Dmem
    output reg [3:0] dmem_we,             // dmem write enable
    output reg dmem_rd                    // dmem read enable
    );
    
    // STATES
    localparam IF = 3'd0;     // Instruction Fetch
    localparam ID_EX = 3'd1;     // Instruction Decode and Execute 
    localparam MEM = 3'd2;     // Data Memory
    localparam WB = 3'd3;     // Write back and Update PC
    localparam HALT = 3'd4;     // HALT state
    
    // state machine registers
    reg[`NUM_STATES-1:0] state, next_state;
    
    // state update logic
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin   // active low
            state <= IF;
        end
        else
            state <= next_state;    
    end
    
    // next state and output update
    always @(*) begin
    
        imem_rd = 0;
        pc_we = 0;
        rf_we = 0;
        dmem_rd = 0;
        dmem_we = 4'd0;
        
        case (state) 
            // Instruction Fetch
            IF: begin                          // Move to instruction decode and execute stage for all instruction types
                imem_rd = 1;
                next_state = ID_EX;
            end  
            // Instruction Decode and Execution
            ID_EX: begin
                if(halt) next_state = HALT;
                else if (load | store)          //only push to memory if if load or store
                    next_state = MEM;
                else    
                    next_state = WB;
            end      
            // Memory Read Write
            MEM: begin                         // WB and update PC after MEM
                if (load)  dmem_rd = 1;
                if (store)  dmem_we = decoder_dmem_we;
                next_state = WB;
            end         
            // Write Back
            WB: begin                  // Always fetch instruction after PC is updated
                pc_we = 1;
                if (!(store | branch | fence))  begin
                    rf_we =1;
                end
                next_state = IF;
            end          
            HALT: begin                // Halt 
                //Does Nothing
            end         
       endcase
    end
endmodule

module Decoder
    #(parameter data_width = 32)(
    input wire [data_width - 1:0] instruction,
    output wire [4:0] rs1, rs2, rd,
    output reg [3:0] alu_select,
    output wire [2:0] bc_select, load_select,
    output wire rd_en, we, alu_inb_imm_select, alu_ina_pc_select, rd_din_pc_select
    //to be added
);
    wire [6:0] top_opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    
    wire is_LUI, is_AUIPC, is_JAL, is_JALR, is_BRANCH, is_LOAD, is_STORE, is_IMM, is_ALU, is_FENCE, is_SYSTEM;
    
    assign top_opcode = instruction[6:0];
    assign funct3 = instruction[14:12];
    assign funct7 = instruction[31:25];
    assign rs2 = instruction[24:20];
    assign rd = instruction[11:7];
    
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
    
    assign rs1 = is_LUI ? 5'b00000 : instruction[19:15];
    
    assign bc_select = instruction[14:12]; //funct3
    assign load_select = instruction[14:12]; //funct3
    assign alu_inb_imm_select = is_LOAD || is_STORE || is_IMM || is_BRANCH || is_JALR || is_JAL || is_LUI || is_AUIPC;
    assign alu_ina_pc_select = is_JAL || is_AUIPC;
    assign rd_din_pc_select = is_JAL || is_JALR;
    
    // rf write enable
    //assign rf_we = !(is_BRANCH || is_STORE || is_SYSTEM);
    
    //data_memory rd-wr-enable
    assign we = is_STORE;
    assign rd_en = is_LOAD;
    
    
    //to be added
    
    always @(*) begin
        case( is_LOAD || is_STORE || is_BRANCH || is_JALR || is_JAL || is_LUI || is_AUIPC )
            1'b0 : alu_select = `ADD;
            default: alu_select = {instruction[30], instruction[14:12]}; //{funct7[5], funct3}
        endcase
    end
endmodule
    
