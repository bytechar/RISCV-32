`timescale 1ns / 1ps
`include "defines.vh"
`default_nettype none

module program_counter(
    input wire clk,rst,imm,
    input wire signed [31:0] imm_addr,
    output reg [31:0] instr_addr
    );
    
reg [31:2] instr_addr_temp;

always@(posedge clk or posedge rst)
begin
    
    //reset to start of instruction memory 0x01000000
    if(rst==1) instr_addr <= 32'h01000000;
    
    else
    begin
    
        //add sign extended immediate if control signal imm is asserted
        if(imm==1) instr_addr_temp = instr_addr[31:2] + imm_addr[31:2];
        
        //regular counter increment (4 bytes)
        else instr_addr_temp = instr_addr[31:2] + 1;
        
        //reset program counter if out-of-bounds value is reached (outside of defined instruction memory addresses)
        if (instr_addr_temp > 30'h010007FC/4 | instr_addr_temp < 30'h01000000/4) instr_addr <= 32'h01000000;
        
        //else update PC value and send out to instruction memory
        else instr_addr <= {instr_addr_temp,2'b00};
        
    end
end
    
endmodule
