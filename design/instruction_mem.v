`timescale 1ns / 1ps
`include "defines.vh"
`default_nettype none

module instruction_mem(
    input wire clk,rd,
    input wire [31:0] instr_addr,
    output wire [31:0] instr
    );
    
    reg [31:0] instr_temp;
    
    //define instruction memory from 0x01000000 to 0x01000FFF (4KByte memory)
    (*rom_style = "block" *) reg [31:0] imem [10'h000/4:10'hFFC/4];
    
    //load instruction memory
    initial $readmemh("imem_int.mem", imem);
        
    always@(posedge clk)
    begin
        //memory is byte addressed, however only entire word can be accessed at a time
        if(rd) instr_temp <= imem[instr_addr[11:2]];
    end
    
    //send ECALL HALT instruction if address is out of bounds
    assign instr = (instr_addr[31:12]==20'h01000) ? instr_temp : { {25{1'b0}} , `SYSTEM };
    
endmodule
