`timescale 1ns / 1ps
`include "defines.vh"
`default_nettype none

`define NUM_STATES 5

module Control_Unit(
    input wire clk, 
    input wire rstn,
    
    // DECODER generated signals
    //input wire is_LUI, is_AUIPC, is_JAL, is_JALR, is_IMM, is_ALU,

    input wire is_LOAD,
    input wire is_STORE,
    input wire is_BRANCH,
    input wire is_FENCE,
    input wire is_SYSTEM,
    input wire [3:0] decoder_dmem_we,
    
     // pc
    output reg pc_we,                     // PC write enable
    // IMem
    output reg imem_rd,                   // IMem read enable
    // regfile
    output reg rf_we,                     // reg file write enable
    // Dmem
    output reg dmem_rd,                   // dmem read enable
    output reg [3:0] dmem_we              // dmem write enable
    );
    
    // STATES
    localparam IF = 3'd0;     // Instruction Fetch
    localparam ID_EX = 3'd1;     // Instruction Decode and Execute (ALU)
    localparam MEM = 3'd2;     // Data Memory
    localparam WB = 3'd3;     // Write back and Update PC
    localparam HALT = 3'd4;     // HALT state
    
    // state machine registers
    reg[2:0] state, next_state;
    
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
                if(is_SYSTEM) next_state = HALT;
                else if (is_LOAD | is_STORE)          //only push to memory if if load or store
                    next_state = MEM;
                else    
                    next_state = WB;
            end      
            // Memory Read Write
            MEM: begin                         // WB and update PC after MEM
                dmem_rd = 1;
                if (is_STORE) dmem_we = decoder_dmem_we;
                next_state = WB;
            end         
            // Write Back
            WB: begin                  // Always fetch instruction after PC is updated
                pc_we = 1;
                if (!(is_STORE | is_BRANCH | is_FENCE))  begin
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
