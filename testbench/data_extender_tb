`timescale 1ns / 1ps
`include "defines.vh"
`default_nettype none

module data_ext_TB();
    
    reg [2:0] opcode;
    reg [31:0] d_in;
    wire [31:0] d_out;
    
    data_ext dut (.opcode(opcode), .d_in(d_in), .d_out(d_out));
    
    reg error_count = 0;
    
    initial begin
        #5;
        d_in <= 32'h98A48DB7;
        opcode <= `LB;
        #10;
        if(d_out!=32'hffffffb7) begin
            $error("Expected output not received");
            error_count = error_count + 1;
            end
        #10;
        opcode <= `LH;
        #10;
        if(d_out!=32'hffff8db7) begin
            $error("Expected output not received");
            error_count = error_count + 1;
            end
        #10;
        opcode <= `LW;
        #10;
        if(d_out!=32'h98a48db7) begin
            $error("Expected output not received");
            error_count = error_count + 1;
            end
        #10;
        opcode <= `LBU;
        #10;
        if(d_out !=32'h000000b7) begin
            $error("Expected output not received");
            error_count = error_count + 1;
            end
        #10;
        opcode <= `LHU;
        #10;
        if(d_out!=32'h00008db7) begin
            $error("Expected output not received");
            error_count = error_count + 1;
            end
        #10;
        if(error_count == 0) $display("All tests passed");
        $finish;
    end
    
endmodule
