/*
 * Standalone assembly language program for NYU-6463-RV32I processor
 * The label 'reset handler' will be called upon startup.
 */
.global reset_handler
.type reset_handler,@function

reset_handler:
lui x5, 0x00010
addi x5, x5, 2
add x4, x5, x0
sub x3, x0, x4
spot1:
bne x0, x4, spot2
addi x4, x3, 1
spot4:
bltu x4, x3, spot5
spot3:
addi x4, x4, -1
blt x3, x4, spot4
spot2: 
beq x4, x5, spot3
spot6: 
bgeu x6, x4, spot7
spot5: 
add x4, x4, x5
sub x6, x0, x4
bge x4, x5, spot6
jalr x9, x1, 0			//goes to end
spot7: 
and x4, x4, x0
jal x1, spot1
end: 
ori x9, x0, 0x001
slti x5, x9, -2
sltiu x6, x9, -2
xori x3, x0, -1
sll x2, x9, x3			//data memory base address
srli x3, x2, 11			//memory mapped I/O base address
ori x10, x0, 0x70a
sw x10, 16(x2)			//write to memory
lw x11, 16(x2)			//read memory
sb x11, 20(x3)			//write to LEDs
sw x11, 20(x3)
sh x11, 20(x2)			//write to memory
lw x19, 20(x2)
lhu x24, 20(x2)
lbu x31, 20(x2)
xor x12, x24, x31
slli x31, x31, 2
srl x31, x31, x9
lh x21, 20(x2)
lb x27, 20(x2)
sra x22, x21, x9
or x22, x22, x9
slt x1, x19, x21
sltu x2, x21, x27
sub x9, x0, x9
andi x9, x9, 0x00f
srai x9, x9, 1
lw x11, 16(x3)			//read switches
sw x11, 20(x3)			//write to LEDs
auipc x1, 0x000f4
beq x11, x10, pc_update		//x11 = 0x70a
bne x11, x9, halt		//x11 != 0x7
fence
ecall
halt: 
ebreak
pc_update: 
jalr x9, x1, 0			//goes over PC
