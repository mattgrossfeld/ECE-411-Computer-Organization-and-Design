import rv32i_types::*;

module mp3
(
	input clk,
	input logic pmem_resp,	//The response from memory
	output logic pmem_read, //Read from memory to L2 cache
	output logic pmem_write, //Write to memory from L2 cache
	output rv32i_word pmem_address, //Physical memory address
	input logic [255:0] pmem_rdata, // Block being read from physical memory
	output logic [255:0] pmem_wdata //Block being written to physical memory
);

/* Logic for instruction cache */
rv32i_word mem_rdata_i, /*mem_wdata_i, */mem_address_i;
logic mem_read_i, /*mem_write_i,*/ mem_resp_i;
//logic [3:0] mem_byte_enable_i;

logic [255:0] pmem_rdata_i, pmem_wdata_i;
rv32i_word pmem_address_i;
logic pmem_read_i, pmem_write_i, pmem_resp_i;

/* Logic for data cache */
rv32i_word mem_rdata_d, mem_wdata_d, mem_address_d;
logic mem_read_d, mem_write_d, mem_resp_d;
logic [3:0] mem_byte_enable_d;

logic [255:0] pmem_rdata_d, pmem_wdata_d;
rv32i_word pmem_address_d;
logic pmem_read_d, pmem_write_d, pmem_resp_d;

/* Logic for L2 cache */
rv32i_word mem_address_out;
logic [255:0] mem_wdata_out, mem_rdata_out;
logic mem_read_out, mem_write_out, mem_resp_out;

/* Logic for Eviction Write Buffer (and some from L2)*/
logic ewb_resp;
logic [255:0] rdata_ewb;
logic pmem_read_L2, pmem_write_L2;
rv32i_word pmem_address_L2;
logic [255:0] pmem_wdata_L2;

/* hit and miss counters */
logic [1:0] counter_pick_d, counter_pick_i, counter_pick_L2;

ewb eviction_write_buffer
(
	.clk(clk), 
	.read_ewb(pmem_read_L2),  
	.write_ewb(pmem_write_L2), 
	.wdata_ewb(pmem_wdata_L2), 
	.address_ewb(pmem_address_L2),
	.pmem_resp(pmem_resp), 
	.pmem_rdata(pmem_rdata),
	.ewb_resp(ewb_resp), 
	.rdata_ewb(rdata_ewb), 
	.pmem_read(pmem_read),
	.pmem_write(pmem_write),
	.pmem_address(pmem_address),
	.pmem_wdata(pmem_wdata)
);

cache_L2_4way cacheL2
(
	.clk(clk),
	.mem_address(mem_address_out),
	.mem_read(mem_read_out),
	.mem_write(mem_write_out),
	.mem_wdata(mem_wdata_out),
	.pmem_resp(ewb_resp), //Now goes to EWB
	.pmem_rdata(rdata_ewb), //Now goes to EWB
	.mem_rdata(mem_rdata_out),
	.mem_resp(mem_resp_out),
	.pmem_read(pmem_read_L2),
	.pmem_write(pmem_write_L2),
	.pmem_address(pmem_address_L2),
	.pmem_wdata(pmem_wdata_L2),
	.counter_pick(counter_pick_L2)
);

arbiter arbiter
(
	.clk,

	// L1 instr
	.pmem_resp_i,
	.pmem_rdata_i,

	.pmem_read_i,
	.pmem_write_i,
	.pmem_address_i,
	.pmem_wdata_i,

	// L1 data
	.pmem_resp_d,
	.pmem_rdata_d,

	.pmem_read_d,
	.pmem_write_d,
	.pmem_address_d,
	.pmem_wdata_d,

	.mem_address_out,
	.mem_read_out,
	.mem_write_out,
	.mem_wdata_out,
	.mem_rdata_out,
	.mem_resp_out

);

cache instruction_cache
(
	.clk(clk),
	.mem_byte_enable(4'b1111),
	.mem_address(mem_address_i),
	.mem_read(mem_read_i),
	.mem_write(1'b0),
	.mem_wdata(32'b0),
	.pmem_resp(pmem_resp_i),
	.pmem_rdata(pmem_rdata_i),
	.mem_rdata(mem_rdata_i),
	.mem_resp(mem_resp_i),
	.pmem_read(pmem_read_i),
	.pmem_write(pmem_write_i),
	.pmem_address(pmem_address_i),
	.pmem_wdata(pmem_wdata_i),
	.counter_pick(counter_pick_i)
);

cache data_cache
(
	.clk(clk),
	.mem_byte_enable(mem_byte_enable_d),
	.mem_address(mem_address_d),
	.mem_read(mem_read_d),
	.mem_write(mem_write_d),
	.mem_wdata(mem_wdata_d),
	.pmem_resp(pmem_resp_d),
	.pmem_rdata(pmem_rdata_d),
	.mem_rdata(mem_rdata_d),
	.mem_resp(mem_resp_d),
	.pmem_read(pmem_read_d),
	.pmem_write(pmem_write_d),
	.pmem_address(pmem_address_d),
	.pmem_wdata(pmem_wdata_d),
	.counter_pick(counter_pick_d)
);

pipe_datapath cpu
(
	 .clk(clk),
    .read_a(mem_read_i),
	 .address_a(mem_address_i),
    .resp_a(mem_resp_i),
    .rdata_a(mem_rdata_i),
	 .read_b(mem_read_d),
    .write_b(mem_write_d),
    .wmask_b(mem_byte_enable_d),
    .address_b(mem_address_d),
    .wdata_b(mem_wdata_d),
    .resp_b(mem_resp_d),
    .rdata_b(mem_rdata_d),
	 .counter_pick_i,
	 .counter_pick_d,
	 .counter_pick_L2
);


endmodule : mp3
