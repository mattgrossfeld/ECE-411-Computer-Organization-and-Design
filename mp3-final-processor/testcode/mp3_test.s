lw_sw_all:
.align 4
.section .text
.globl _start
_start:

    # Get some base addresses
    addi x1, x0, 4 # R0

.section .rodata
.balign 256
.zero 96
