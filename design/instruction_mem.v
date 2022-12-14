`timescale 1ns / 1ps
`include "defines.vh"
`default_nettype none

module instruction_mem(
    input wire clk,rd,
    input wire [31:0] instr_addr,
    output reg [31:0] instr
    );
    
    //define instruction memory from 0x01000000 to 0x010007FF
    reg [31:0] imem [30'h01000000/4:30'h010007FC/4];
    
    //load instruction memory
    initial $readmemh("imem.mem", imem);
        
    always@(posedge clk)
    begin
        //memory is byte addressed, however only entire word can be accessed at a time
        if(rd == 1) instr <= imem[instr_addr[31:2]];
    end
    
endmodule
