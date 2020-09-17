#  mp3-cp1.s version 3.0
.align 4
.section .text
.globl _start
_start: #PC = 60
    lw x1, %lo(COUNT)(x0)	# x1 = 0x0000000a PC=64
    beq x0, x0, LOAD_VALS	# go to LOAD VALS PC=68
LOAD_VALS:			#PC = 6c
    lw x2, %lo(ONE)(x0)		#PC = 70
    lw x3, %lo(TWO)(x0)		#PC = 74
    lw x4, %lo(THREE)(x0)
    lw x5, %lo(FOUR)(x0)
    jal x20, CLEAR_VALS		# Go to LOOP. store pc+4 in x20. x20 = 7c. pc = 0x78
.section .rodata
.balign 256
ONE:    .word 0x00000001
TWO:	.word 0xF00FF00F
THREE:	.word 0x0FF0F0F0
FOUR:  	.word 0xFFFF0000
GOOD:   .word 0x600D600D
BAD:    .word 0xBADDBADD
SIX:    .word 0x123456AB
SEVEN:  .word 0x1234ABCD
FIVE:   .word 0x80000000 	# ADDED BY MATTHEW
COUNT:  .word 0x0000000a

.section .text
.align 4
LOOP:
	jalr x21, %lo(JUMP_ONE)(x0)	# we done
BRANCH_TWO:
    	addi x1, x1, -1 # Decrement x1 (Initially 10)
	bne x1, x0, LOOP # If x1 is NOT 0 then we loop
	jal x2, DONEa # If x1 is zero, we're done
	#beq x1, x0, DONEa
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
JUMP_ONE:
	beq x0, x1, BRANCH_ONE
	bne x0, x1, BRANCH_ONE
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
BRANCH_ONE:
	addi x10, x10, 1 #increment
	bge x1, x0, BRANCH_TWO #Go to branch two when x1 >= 0
HALT:
    beq x0, x0, HALT
    nop
    nop
    nop
    nop
    nop
    nop
    nop

DONEa:
    lw x1, %lo(GOOD)(x0)
DONEb:
    beq x0, x0, DONEb
    nop
    nop
    nop
    nop
    nop
    nop
    nop
CLEAR_VALS:
	add x10, x0, x0
	add x11, x0, x0
	add x12, x0, x0
	add x13, x0, x0
	blt x10, x1, LOOP #If x1 > 0, go to LOOP
