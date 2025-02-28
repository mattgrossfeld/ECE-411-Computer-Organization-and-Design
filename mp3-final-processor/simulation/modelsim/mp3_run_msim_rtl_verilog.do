transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/rv32i_types.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/cache_L2_4way_control.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/counter.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/register.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/regfile.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/plus4.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/pc_reg.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/mux8.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/mux4.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/mux2.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/mux16.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/array_L2_4way.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/is_hit.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/ewb_control.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/data_decoder.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/cache_control.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/array.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/control_rom.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/cache_L2_4way_datapath.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/fwd_logic.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/stall_load_control.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/if_id.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/mem_wb.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/id_ex.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/ex_mem.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/ewb_datapath.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/ewb.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/cmp.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/cache_datapath.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/cache.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/arbiter.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/alu.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/pipe_datapath.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/cache_L2_4way.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/mp3.sv}

vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/mp3_tb.sv}
vlog -sv -work work +incdir+/home/xkuissi2/ece411/mp3 {/home/xkuissi2/ece411/mp3/physical_memory.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L stratixiii_ver -L rtl_work -L work -voptargs="+acc"  mp3_tb

add wave *
view structure
view signals
run 1000 ns
