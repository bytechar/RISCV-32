`timescale 1ns / 1ps
`include "defines.vh"
`default_nettype none

module register_file(
    input wire clk,rstn,we,
    input wire [4:0] rs1_addr, rs2_addr, rd_addr,
    input wire [31:0] rd_din,
    output wire [31:0] rs1_dout, rs2_dout
    );
    
    integer i;
    reg [31:0] register_file [0:31];
    
    //hardwire R0 = 0
    initial register_file[0] = 32'h00000000;
    
    reg [4:0] rs1_addr_reg, rs2_addr_reg;
    
    always@(posedge clk or negedge rstn)
    begin
    
        //update source register addresses
        rs1_addr_reg <= rs1_addr;
        rs2_addr_reg <= rs2_addr;
        
        //reset registers R1-R31 to 0, reset to R0 not permitted
        if (rstn==0) for(i=1;i<32;i=i+1) register_file[i] <= 32'h00000000;
        
        //write to registers R1-R31 as per rd signal if write enable (we) is asserted
        //write to R0 is not permitted
        else if (we==1 & rd_addr!=5'h00) register_file[rd_addr] <= rd_din;
        
    end
    
    //update output data lines from source registers
    assign rs1_dout = register_file[rs1_addr_reg];
    assign rs2_dout = register_file[rs2_addr_reg];

endmodule
