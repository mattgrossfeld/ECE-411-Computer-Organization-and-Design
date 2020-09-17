#  mp3-cp1.s version 3.0
.align 4
.section .text
.globl _start
_start:
    lw x1, %lo(ONE)(x0)	# x1 = 1 GOOD
    lw x2, %lo(TWO)(x0)	# x2 = 0xF00FF00F GOOD
    lw x3, %lo(THREE)(x0)	# x3 = 0x0FF0F0F0 GOOD
    lw x4, %lo(FOUR)(x0)	# x4 = 0xFFFF0000 GOOD
    lw x5, %lo(FIVE)(x0)	# x5 = 0x80000000 GOOD
    lb x22, %lo(SIX)(x0)	# x22 = 0xFFFFFFAB GOOD
    lh x23, %lo(SEVEN)(x0)	# x23 = 0xFFFFABCD GOOD
    lhu x24, %lo(SEVEN)(x0)	# x24 = 0x0000ABCD GOOD
    lbu x25, %lo(SIX)(x0)	# x25 = 0x000000AB GOOD
    nop
    addi x21, x0, %lo(ONE)	#GOOD
    addi x29, x0, %lo(TWO)	# GOOD
    addi x30, x0, %lo(THREE)	# GOOD
	addi x31, x0, 0xFFFFFFF8
    nop
    nop
    nop
    nop
	lw x6, 0(x31)
	nop
	nop
	nop
	sw x3, 0(x31)
    sw x3, 0(x21) #x3 = 0x0FF0F0F0 -> ONE	#GOOD
    sh x23, 0(x29) # x23 = 0xFFFFABCD -> TWO			#GOOD
    sb x22, 0(x30) # x22 = 0xFFFFFFAB -> THREE		#GOOD
    nop
    nop
    lw x26, %lo(ONE)(x0) # x26 -> 0x0FF0F0F0
    lh x27, %lo(TWO)(x0) # x27 -> 0xFFFFABCD
    lb x28, %lo(THREE)(x0) #x28 -> 0xFFFFFFAB
    nop
    nop
    nop
    nop
    nop
    jal x20, LOOP		# Go to LOOP. store pc+4 in x20
    nop
    nop
    nop
    nop
    nop
    nop
    nop

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
FIVE: .word 0x80000000 	# ADDED BY MATTHEW


.section .text
.align 4
LOOP:
    lui x6, 10	# x6 = 0x0000a000 GOOD
    auipc x7, 10	# x7 = pc + 0x0000a000 GOOD
    addi x8, x4, 1 # X8 <= 1 + X4 = 0xFFFF0001 GOOD
    xori x9, x1, 3 # X9 <= X1 xor 3 = 2'b10  GOOD
    ori x10, x1, 3 # X10 <= x1 or 3 = 2'b11 GOOD
    andi x11, x2, 15	# x11 = 0xF00FF00F && 0x0000000F = 0x0000000F GOOD
    slli x12, x1, 1	# x12 = x1 << 1 = 0x00000002 GOOD
    srli x13, x5, 16	# x13 = x5 >> 16 = 0x00008000 GOOD
    add x14, x1, x4	# x14 = x1 + x4 = 0xFFFF0001 GOOD
    sll x15, x1, x1	# x15 = x1 << 1 = 2 GOOD
    xor x16, x2, x3	# x16 = x2 xor x3 = 0xFFFF00FF GOOD
    srl x17, x5, x1	# x17 = x5 >> x1 = 0x80000000 >> 1 = 0x40000000 GOOD
    or x18, x2, x1	# x18 = x2 OR x1 = 0xF00FF00F GOOD
    and x19, x2, x3	# x19 = x2 AND x3 = 0x0000F000 GOOD
    jalr x21, %lo(DONEa)(x0)	# we done
    nop
    nop
    nop
    nop
    nop

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
