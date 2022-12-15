`timescale 1ns / 1ps
`default_nettype none
`include "defines.vh"

// Data Memory Size (4KB or 1024 Words)
`define RAM_LENGTH_WORDS 1024

// Relevant Address bits for 4KB Memory (0 - FFC -> 12 Bits)
`define RAM_ADDR_BITS 12
`define STARTING_ADDR_BIT 32

//Special ROM Values
`define ROM_LENGTH 3
`define ROM_ADDR_BIT 21

`define ANVAY 13874751
`define NAMAN 18700095
`define VIDYUT 18313324

//IO Ports
`define IO_LENGTH 2

module DMem(
    input wire clk,
    input wire rstn,
    input wire rd,
    input wire [3:0] we,
    input wire [2:0] load_select,
    input wire [31:0] addr_in,
    input wire [31:0] data_in,
    output wire [31:0] data_out,
    input wire [15:0] sw,
    output reg [15:0] led
);
                  
    integer i;
    
    // Define Data Memory
    reg [31:0] ram [0:`RAM_LENGTH_WORDS-1];
    
    // intialize Data Memory to 0
    initial $readmemh("dmem_int.mem", ram);
 
    // Define Special Memory and IO Ports 
    reg [31:0] rom [0:`ROM_LENGTH -1];
   
    // Loading Memory with hardcoded values
    initial begin
        // special read only registers for N numbers of group members
        rom[0] <= 32'h`ANVAY;   // when addr_in 0X00100000
        rom[1] <= 32'h`NAMAN;   // when addr_in 0X00100004
        rom[2] <= 32'h`VIDYUT;  // when addr_in 0X00100008
        led <= 16'h0000;
    end
    
    // Transalted address used with Dmem
    wire [11:0] addr;

    // Address Translation divide by 4
    assign addr= {2'b00, addr_in[`RAM_ADDR_BITS-1:2]};
    
    // raw 32-bit data output from DMEM
    reg [31:0] data_out_raw;

    // data extender for raw 32-bit data output
    data_ext DATA_EXT(.opcode(load_select), .d_in(data_out_raw), .d_out(data_out));

    // pick data out from memory or other locations (mapped I/O or ROM)
    reg [31:0] data_out_ram, data_out_rom;
    
    always@(*) begin
        case({addr_in[`ROM_ADDR_BIT-1],addr_in[`STARTING_ADDR_BIT-1]})
            2'b01: data_out_raw = data_out_ram;
            2'b10: data_out_raw = data_out_rom;
            default: data_out_raw = 32'h00000000;
        endcase
    end
    
    // we signals based on address
    wire [3:0] we_ram;
    wire [1:0] we_led;
    
    assign we_ram = addr_in[`STARTING_ADDR_BIT-1] ? we : 4'b0000 ;
    assign we_led = (addr_in[`ROM_ADDR_BIT-1] && addr==12'd5) ? we[1:0] : 2'b00;

    always @(posedge clk) begin  

            if (rd) begin
           	        case(addr)
           	            12'd0,12'd1,12'd2: data_out_rom <= rom[addr];      // read N-Numbers from special read only registers
           	            12'd4: data_out_rom <= sw;                         // IO port read for switches
           	            12'd5: data_out_rom <= led;                        // IO port read for leds
           	            default: data_out_rom <= 32'b0;                    // send out 0 in case addr_in is out of bounda
           	        endcase
           	        if (we_led[0]) led[7:0] <= data_in[7:0];    // IO port write to leds
           	        if (we_led[1]) led[15:8] <= data_in[15:8];
            
           	        data_out_ram <= ram[addr];   
           	        if (we_ram[0]) ram[addr][7:0] <= data_in[7:0];
           	        if (we_ram[1]) ram[addr][15:8] <= data_in[15:8];                    
           	        if (we_ram[2]) ram[addr][23:16] <= data_in[23:16];
           	        if (we_ram[3]) ram[addr][31:24] <= data_in[31:24];
            end
    end

endmodule
