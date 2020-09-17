onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mp2_tb/clk
add wave -noupdate /mp2_tb/pmem_resp
add wave -noupdate /mp2_tb/pmem_read
add wave -noupdate /mp2_tb/pmem_write
add wave -noupdate /mp2_tb/pmem_address
add wave -noupdate /mp2_tb/pmem_wdata
add wave -noupdate /mp2_tb/pmem_rdata
add wave -noupdate /mp2_tb/write_data
add wave -noupdate /mp2_tb/write_address
add wave -noupdate /mp2_tb/write
add wave -noupdate /mp2_tb/halt
add wave -noupdate /mp2_tb/dut/cpu/datapath/regfile/data
add wave -noupdate /mp2_tb/dut/cache/control/mem_read
add wave -noupdate /mp2_tb/dut/cache/control/mem_write
add wave -noupdate /mp2_tb/dut/cache/control/mem_resp
add wave -noupdate /mp2_tb/dut/cache/datapath/data_array0/clk
add wave -noupdate /mp2_tb/dut/cache/datapath/data_array0/write
add wave -noupdate /mp2_tb/dut/cache/datapath/data_array0/index
add wave -noupdate /mp2_tb/dut/cache/datapath/data_array0/datain
add wave -noupdate /mp2_tb/dut/cache/datapath/data_array0/dataout
add wave -noupdate /mp2_tb/dut/cache/datapath/data_array0/data
add wave -noupdate /mp2_tb/dut/cache/datapath/data_array1/clk
add wave -noupdate /mp2_tb/dut/cache/datapath/data_array1/write
add wave -noupdate /mp2_tb/dut/cache/datapath/data_array1/index
add wave -noupdate /mp2_tb/dut/cache/datapath/data_array1/datain
add wave -noupdate /mp2_tb/dut/cache/datapath/data_array1/dataout
add wave -noupdate /mp2_tb/dut/cache/datapath/data_array1/data
add wave -noupdate /mp2_tb/dut/cache/datapath/lru/clk
add wave -noupdate /mp2_tb/dut/cache/datapath/lru/write
add wave -noupdate /mp2_tb/dut/cache/datapath/lru/index
add wave -noupdate /mp2_tb/dut/cache/datapath/lru/datain
add wave -noupdate /mp2_tb/dut/cache/datapath/lru/dataout
add wave -noupdate /mp2_tb/dut/cache/datapath/lru/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {4999050 ps} {5000050 ps}
