`timescale 1ns / 1ps
`include "defines.vh"
`default_nettype none

module program_counter(
    input wire clk,rstn,imm,we,
    input wire [31:0] imm_addr,
    output wire [31:0] instr_addr
    );
    
reg [31:2] instr_addr_temp;

always@(posedge clk or negedge rstn)
begin
    
    //reset to start of instruction memory 0x01000000
    if(rstn==0) instr_addr_temp <= 30'h01000000/4;
    
    //update PC only when we is enabled by control unit (IF stage)
    else begin
        if(we==1) begin
    
            //use immediate address generated outside PC if control signal imm is asserted
            if(imm==1) instr_addr_temp <= imm_addr[31:2];
            //regular counter increment (4 bytes)
            else instr_addr_temp <= instr_addr[31:2] + 1;
        
        end
    end
end

assign instr_addr = {instr_addr_temp,2'b00};
    
endmodule
