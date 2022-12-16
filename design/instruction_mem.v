`timescale 1ns / 1ps
`include "defines.vh"
`default_nettype none

// Instruction Memory Size (4KB or 1024 Words)
`define MEM_LENGTH_WORDS 1024

module instruction_mem(
    input wire clk,rd,
    input wire [31:0] instr_addr,
    output reg [31:0] instr
    );
        
    //define instruction memory (4KByte memory)
    (*rom_style = "block" *) reg [31:0] imem [0:`MEM_LENGTH_WORDS-1];
    
    //load instruction memory
    initial $readmemh("imem_int.mem", imem);
        
    always@(posedge clk)
    begin
        //memory is byte addressed, however only entire word can be accessed at a time
        if(rd) instr <= imem[instr_addr[11:2]];
    end
    
endmodule
