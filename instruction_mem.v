`timescale 1ns / 1ps
`include "defines.vh"
`default_nettype none

module instruction_mem(
    input wire clk,
    input wire [31:0] instr_addr,
    output wire [31:0] instr
    );
    
    //define instruction memory from 0x01000000 to 0x010007FF
    reg [31:0] imem ['h01000000/4:'h010007FC/4];
    
    //load instruction memory
    initial $readmemh("imem.mem", imem);
    
    reg [31:2] instr_addr_reg;
    
    always@(posedge clk)
    begin
        instr_addr_reg <= instr_addr[31:2];
    end
    
    //memory is byte addressed, however only entire word can be accessed at a time
    assign instr = imem[instr_addr_reg];
    
endmodule
