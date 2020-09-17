onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mp3_tb/pmem_address
add wave -noupdate /mp3_tb/dut/cpu/ex_mem/control_word_out.opcode
add wave -noupdate -radix decimal /mp3_tb/dut/cpu/ex_mem/control_word_out.rs1
add wave -noupdate -radix unsigned /mp3_tb/dut/cpu/ex_mem/control_word_out.rs2
add wave -noupdate -radix decimal /mp3_tb/dut/cpu/ex_mem/rd
add wave -noupdate -radix decimal /mp3_tb/dut/cpu/line
add wave -noupdate /mp3_tb/dut/cpu/control_rom/ctrl
add wave -noupdate /mp3_tb/dut/cpu/id_ex/control_word_in
add wave -noupdate /mp3_tb/dut/cpu/id_ex/control_word_out
add wave -noupdate /mp3_tb/dut/cpu/ex_mem/control_word_in
add wave -noupdate /mp3_tb/dut/cpu/ex_mem/control_word_out
add wave -noupdate /mp3_tb/dut/cpu/mem_wb/control_word_in
add wave -noupdate /mp3_tb/dut/cpu/mem_wb/control_word_out
add wave -noupdate /mp3_tb/dut/cpu/rd_wb
add wave -noupdate /mp3_tb/registers
add wave -noupdate /mp3_tb/dut/cpu/wbmux/sel
add wave -noupdate /mp3_tb/dut/cpu/wbmux/a
add wave -noupdate /mp3_tb/dut/cpu/wbmux/b
add wave -noupdate /mp3_tb/dut/cpu/wbmux/c
add wave -noupdate /mp3_tb/dut/cpu/wbmux/d
add wave -noupdate /mp3_tb/dut/cpu/wbmux/e
add wave -noupdate /mp3_tb/dut/cpu/wbmux/f
add wave -noupdate /mp3_tb/dut/cpu/wbmux/g
add wave -noupdate /mp3_tb/dut/cpu/wbmux/h
add wave -noupdate /mp3_tb/dut/cpu/wbmux/i
add wave -noupdate /mp3_tb/dut/cpu/wbmux/j
add wave -noupdate /mp3_tb/dut/cpu/wbmux/k
add wave -noupdate /mp3_tb/dut/cpu/wbmux/l
add wave -noupdate /mp3_tb/dut/cpu/wbmux/m
add wave -noupdate /mp3_tb/dut/cpu/wbmux/n
add wave -noupdate /mp3_tb/dut/cpu/wbmux/o
add wave -noupdate /mp3_tb/dut/cpu/wbmux/p
add wave -noupdate /mp3_tb/dut/cpu/wbmux/out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {13114051 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 172
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {12983151 ps} {13651045 ps}
