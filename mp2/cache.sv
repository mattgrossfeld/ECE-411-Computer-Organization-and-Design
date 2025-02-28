import rv32i_types::*;

module cache
(
	input clk,
	input logic [3:0] mem_byte_enable,
	input rv32i_word mem_address,
	input logic mem_read,
	input logic mem_write,
	input rv32i_word mem_wdata,
	input logic pmem_resp,
	input logic [255:0] pmem_rdata,
	
	output rv32i_word mem_rdata,
	output logic mem_resp,
	output logic pmem_read,
	output logic pmem_write,
	output rv32i_word pmem_address,
	output logic [255:0] pmem_wdata
);

/* Instantiate Cache top level blocks here */
logic hit0, hit1;

logic write_data0, write_data1, write_tag0, write_tag1;
logic write_dirty0, write_dirty1, write_valid0, write_valid1;
logic write_lru;

logic valid0_datain, valid0_dataout, valid1_datain, valid1_dataout;
logic dirty0_datain, dirty0_dataout, dirty1_datain, dirty1_dataout;
logic lru_datain, lru_dataout;

logic datainmux_sel;
logic [1:0] addr_mux_sel;

cache_control control
(
	.clk(clk),
	.hit0(hit0),
	.hit1(hit1),	
	.write_data0(write_data0), 
	.write_data1(write_data1), 
	.write_tag0(write_tag0),
	.write_tag1(write_tag1),
	.write_dirty0(write_dirty0),
	.write_dirty1(write_dirty1),
	.write_valid0(write_valid0),
	.write_valid1(write_valid1),
	.write_lru(write_lru),	
	.valid0(valid0_dataout),
	.valid1(valid1_dataout),		
	.valid0_out(valid0_datain),
	.valid1_out(valid1_datain),
	.dirty0(dirty0_dataout),
	.dirty1(dirty1_dataout),
	.dirty0_out(dirty0_datain),
	.dirty1_out(dirty1_datain),
	.lru(lru_dataout),
	.lru_out(lru_datain),				
	.addr_mux_sel(addr_mux_sel),
	.datainmux_sel(datainmux_sel),
	.mem_read(mem_read),
	.mem_write(mem_write),
	.mem_byte_enable(mem_byte_enable),
	.mem_resp(mem_resp),
	.pmem_resp(pmem_resp),
	.pmem_read(pmem_read),
	.pmem_write(pmem_write)
);

cache_datapath datapath
(
.clk(clk),
.hit0(hit0),			
.hit1(hit1), 			
.write_data0(write_data0), 	
.write_data1(write_data1), 	
.write_tag0(write_tag0),	
.write_tag1(write_tag1),	
.write_dirty0(write_dirty0),	
.write_dirty1(write_dirty1),	
.write_valid0(write_valid0),	
.write_valid1(write_valid1),	
.write_lru(write_lru),	
.addr_mux_sel(addr_mux_sel),
.datainmux_sel(datainmux_sel), 
.valid0_dataout(valid0_dataout),	
.valid1_dataout(valid1_dataout),	
.valid0_datain(valid0_datain),	
.valid1_datain(valid1_datain),
.dirty0_dataout(dirty0_dataout),
.dirty1_dataout(dirty1_dataout),
.dirty0_datain(dirty0_datain),
.dirty1_datain(dirty1_datain),
.lru_dataout(lru_dataout),
.lru_datain(lru_datain),
.mem_byte_enable(mem_byte_enable),
.mem_address(mem_address),
.mem_wdata(mem_wdata),
.mem_rdata(mem_rdata),
.pmem_rdata(pmem_rdata),
.pmem_wdata(pmem_wdata),
.pmem_address(pmem_address)
);

endmodule : cache
