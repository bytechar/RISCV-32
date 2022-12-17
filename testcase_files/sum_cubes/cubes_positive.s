
/*
 * Standalone assembly language program for NYU-6463-RV32I processor
 * The label 'reset handler' will be called upon startup.
*/

.global reset_handler
.type reset_handler,@function


reset_handler:
add x7, x7, x0 		# Output x7 = 0
addi x5, x0 , 1
addi x6, x0, 8
add x18, x0, x5 	# x18 = x5
blt x5, x6, continue 	# We want to store lower value in x18 and higher in x6
add x18, x0, x6 	# If x5 >= x6, x18 = x6
add x6, x0, x5 		# x6 = x5

continue:
andi x9, x18, 1 	# If N1 is even x9 = 0, else if odd x9 = 1
bne x9, x0, oddn1 
addi x18, x18, 1 	# If N is even, x18 (N1) = N+1 (First odd number) 

oddn1:
andi x10, x6, 1 	# If N2 is even x10 = 0, else if odd x10 = 1
bne x10, x0, oddn2 
addi x6, x6, -1 	# If N2 is even, x6 (N2) = N-1 (Last odd number)

oddn2:
addi x6, x6, 1 		# x6 = x6 + 1 to have iterator (i) max = N

loopi: 			# Loop to iterate from N1 to N2
addi x20, x0, 1 	# x20 = 1
add x21, x18, x0 	# Temporary register to store i 
bge x18, x0, pos 	# If i is positive, skip to next steps
sub x21, x0, x21 	# If i is negative, x21 = -i
addi x20, x0, -1 	# x20 = -1 if i is negative

pos:
addi x31, x0, 3 	# Iterator j = 3
add x30, x0, x0 	# x30 = 0, to have iterator (j) min = 1

loopj: 			# Loop to calculate i^3
andi x29, x29, 0 	# Iterator k = 0
andi x28, x28, 0 	# Temporary register to store sum x28 = 0

loopk: 			# Loop to add i iteratively to perform multiplication
add x28, x28, x20 	# If i is positive, we iteratively add 1, else add -1
addi x29, x29, 1 	# k = k + 1
blt x29, x21, loopk 	# If k < i, run loop again
addi x20, x28, 0 	# x20 = i^(4 - j)
addi x31, x31, -1 	# j = j - 1
bne x31, x30, loopj 	# If j != 0, run loop again
add x7, x7, x20 	# output x7 = (-N1)^3 + (-(N1+1))^3 + .. + i^3 
addi x18, x18, 2 	# i = i + 2, increment iterator to next odd number
blt x18, x6, loopi 	# If iterator i <= N2, run loop i again

endi: 			# end loopi
lui x2, 0x00100
sw x5, 20(x2)		# show x5 on leds
sw x6, 20(x2)		# show x6 on leds
sw x7, 20(x2)		# show x7 on leds
ecall
