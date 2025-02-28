import rv32i_types::*;

module cache_L2_4way
(
	input clk,
	//input logic [3:0] mem_byte_enable,
	input rv32i_word mem_address,
	input logic mem_read,
	input logic mem_write,
	input logic [255:0] mem_wdata,
	input logic pmem_resp,
	input logic [255:0] pmem_rdata,
	
	output logic [255:0] mem_rdata,
	output logic mem_resp,
	output logic pmem_read,
	output logic pmem_write,
	output rv32i_word pmem_address,
	output logic [255:0] pmem_wdata,
	output logic [1:0] counter_pick
);

/* Instantiate Cache top level blocks here */
logic [1:0] hit_sel;
logic hit0, hit1, hit2, hit3;

logic write_data0, write_data1, write_data2, write_data3, write_tag0, write_tag1, write_tag2, write_tag3;
logic write_dirty0, write_dirty1, write_dirty2, write_dirty3, write_valid0, write_valid1, write_valid2, write_valid3;
logic write_lru;

logic valid0_datain, valid0_dataout, valid1_datain, valid1_dataout, valid2_datain, valid2_dataout, valid3_datain, valid3_dataout;
logic dirty0_datain, dirty0_dataout, dirty1_datain, dirty1_dataout, dirty2_datain, dirty2_dataout, dirty3_datain, dirty3_dataout;
logic [2:0] lru_datain, lru_dataout;

logic datainmux_sel;
logic [2:0] addr_mux_sel;

cache_L2_4way_control control
(
	.counter_pick,
	.hit_sel,
	.clk(clk),
	.hit0(hit0),
	.hit1(hit1),
	.hit2(hit2),
	.hit3(hit3),
	.write_data0(write_data0), 
	.write_data1(write_data1),
	.write_data2(write_data2), 
	.write_data3(write_data3),	
	.write_tag0(write_tag0),
	.write_tag1(write_tag1),
	.write_tag2(write_tag2),
	.write_tag3(write_tag3),
	.write_dirty0(write_dirty0),
	.write_dirty1(write_dirty1),
	.write_dirty2(write_dirty2),
	.write_dirty3(write_dirty3),
	.write_valid0(write_valid0),
	.write_valid1(write_valid1),
	.write_valid2(write_valid2),
	.write_valid3(write_valid3),
	.write_lru(write_lru),	
	.valid0(valid0_dataout),
	.valid1(valid1_dataout),
	.valid2(valid2_dataout),
	.valid3(valid3_dataout),
	.valid0_out(valid0_datain),
	.valid1_out(valid1_datain),
	.valid2_out(valid2_datain),
	.valid3_out(valid3_datain),
	.dirty0(dirty0_dataout),
	.dirty1(dirty1_dataout),
	.dirty2(dirty2_dataout),
	.dirty3(dirty3_dataout),
	.dirty0_out(dirty0_datain),
	.dirty1_out(dirty1_datain),
	.dirty2_out(dirty2_datain),
	.dirty3_out(dirty3_datain),
	.lru(lru_dataout),
	.lru_out(lru_datain),				
	.addr_mux_sel(addr_mux_sel),
	.datainmux_sel(datainmux_sel),
	.mem_read(mem_read),
	.mem_write(mem_write),
	//.mem_byte_enable(mem_byte_enable),
	.mem_resp(mem_resp),
	.pmem_resp(pmem_resp),
	.pmem_read(pmem_read),
	.pmem_write(pmem_write)
);

cache_L2_4way_datapath datapath
(
.clk(clk),
.hit_sel,
.hit0(hit0),			
.hit1(hit1),
.hit2(hit2),			
.hit3(hit3),  			
.write_data0(write_data0), 	
.write_data1(write_data1),
.write_data2(write_data2), 	
.write_data3(write_data3), 	
.write_tag0(write_tag0),	
.write_tag1(write_tag1),
.write_tag2(write_tag2),	
.write_tag3(write_tag3),		
.write_dirty0(write_dirty0),	
.write_dirty1(write_dirty1),
.write_dirty2(write_dirty2),	
.write_dirty3(write_dirty3),	
.write_valid0(write_valid0),	
.write_valid1(write_valid1),
.write_valid2(write_valid2),	
.write_valid3(write_valid3),	
.write_lru(write_lru),	
.addr_mux_sel(addr_mux_sel),
.datainmux_sel(datainmux_sel), 
.valid0_dataout(valid0_dataout),	
.valid1_dataout(valid1_dataout),
.valid2_dataout(valid2_dataout),	
.valid3_dataout(valid3_dataout),		
.valid0_datain(valid0_datain),	
.valid1_datain(valid1_datain),
.valid2_datain(valid2_datain),	
.valid3_datain(valid3_datain),
.dirty0_dataout(dirty0_dataout),
.dirty1_dataout(dirty1_dataout),
.dirty2_dataout(dirty2_dataout),
.dirty3_dataout(dirty3_dataout),
.dirty0_datain(dirty0_datain),
.dirty1_datain(dirty1_datain),
.dirty2_datain(dirty2_datain),
.dirty3_datain(dirty3_datain),
.lru_dataout(lru_dataout),
.lru_datain(lru_datain),
//.mem_byte_enable(mem_byte_enable),
.mem_address(mem_address),
.mem_wdata(mem_wdata),
.mem_rdata(mem_rdata),
.pmem_rdata(pmem_rdata),
.pmem_wdata(pmem_wdata),
.pmem_address(pmem_address)
);


endmodule : cache_L2_4way