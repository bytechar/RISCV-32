`timescale 1ns / 1ps

`define ANVAY 13874751
`define NAMAN 18700095
`define VIDYUT 18313324
`define RAM_LENGTH_WORDS 1024

module DMem_TB();

reg [31:0] addr_in;
reg [31:0] data_in;
reg [3:0] we;
reg clk;
reg rd;
reg rst;//active low reset
wire [31:0] data_out;
integer i;
reg [31:0] rand_wdata;

DMem DUT (.addr_in(addr_in), .data_in(data_in), .we(we), .clk(clk), .rd(rd), .rst(rst), .data_out(data_out));

// clk generator 
initial clk = 0;
always #10 clk = !clk;  // clk with 20 clk cycle period

initial begin

// drive rst for 100 clk cycles
rst <= 0;
#100;

// remove rst
rst <= 1; 
#20; // wait for 20 clk cycles
data_in <= 32'hFEDCBA98;
we <= 4'b0000;
rd <= 1;

// read N numbers and match
addr_in <= 32'h00100000;
#20;
if(data_out == 32'h`ANVAY) $display("TEST PASS for first N number"); else $fatal("TEST FAILED at time %0t", $time);
#20;

// read N numbers and match
addr_in <= 32'h00100004;
#20;
if(data_out == 32'h`NAMAN) $display("TEST PASS for second N number"); else $fatal("TEST FAILED at time %0t", $time);
#20;
// read N numbers and match
addr_in <= 32'h00100008;
#20;
if(data_out == 32'h`VIDYUT) $display("TEST PASS for third N number"); else $fatal("TEST FAILED at time %0t", $time);
#20;

// read only switch
addr_in <= 32'h00100010;
#20;
if(data_out == 32'h0) $display("TEST PASS for switch"); else $fatal("TEST FAILED at time %0t", $time);
#20;

// read only switch
addr_in <= 32'h00100014;
#20;
if(data_out == 32'h0) $display("TEST PASS for LED read"); else $fatal("TEST FAILED at time %0t", $time);
#20;

//write to LED
addr_in <= 32'h00100014;
we <= 1;
#40;
if(data_out == 32'hFEDCBA98) $display("TEST PASS for LED write"); else $fatal("TEST FAILED at time %0t", $time);
#20;

we <= 4'b1111;

// store test at random all addresses
for (i=0; i<`RAM_LENGTH_WORDS; i=i+1) begin
addr_in = 32'h80000000 + i;
rand_wdata = $random;
data_in = rand_wdata;
#40;
if(data_out == rand_wdata) $display("Expected value matches value at ram[%0d]", i); else $fatal("TEST FAILED for ram[%d] at time %0t", i, $time);
#20;
end

$display("All test cases passed");
$finish;

end

endmodule
