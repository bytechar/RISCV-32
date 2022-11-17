# RISCV-32I-AHD
Advanced Hardware Design Project



ALU
1. Design(alu.v)
- I designed an ALU which performs all the operations mentioned in the supplementary material. The ALU has 2 32 bit inputs, a 4 bit alu_select input and a 32 bit output
that stores the result of the operarion. The alu_select opcodes have been defined in a sepearte header file that hold all the opcodes for different components of the 
processor. For, example ADD instruction has the word ADD at the alu_select case instead of the actual binary number. This makes the code very legible and easy to 
understand. 

2. Testbench(alu_tb.v)
- The testbench for the ALU is pretty straightforward. It has registers that store the inputs and wire that holds the output. I chose to read a alu_test.txt file that
will consist of all my testcases. This way instead of writing each and every testcases, there will be a single file which will hold the testcases. I also added 2 counters,
a pass count and a fail count. These counters will keep track of all the testcases whether they have passed or failed. 
