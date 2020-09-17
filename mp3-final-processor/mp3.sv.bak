import rv32i_types::*;

module mp2
(
    input clk,
	 input logic pmem_resp,
	 output logic pmem_read,
	 output logic pmem_write,
	 output rv32i_word pmem_address, //Physical memory address
	 input logic [255:0] pmem_rdata, // Block being read from physical memory
	 output logic [255:0] pmem_wdata //Block being written to physical memory
);

rv32i_word mem_rdata, mem_wdata, mem_address;
logic mem_read, mem_write, mem_resp;
logic [3:0] mem_byte_enable;


mp1 cpu
(
    .clk(clk),
    .mem_resp(mem_resp),
    .mem_rdata(mem_rdata),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_byte_enable(mem_byte_enable),
    .mem_address(mem_address),
    .mem_wdata(mem_wdata)
);

cache cache
(
	.clk(clk),
	.mem_byte_enable(mem_byte_enable),
	.mem_address(mem_address),
	.mem_read(mem_read),
	.mem_write(mem_write),
	.mem_wdata(mem_wdata),
	.mem_rdata(mem_rdata),
	.mem_resp(mem_resp),
	.pmem_resp(pmem_resp),
	.pmem_rdata(pmem_rdata),
	.pmem_read(pmem_read),
	.pmem_write(pmem_write),
	.pmem_address(pmem_address),
	.pmem_wdata(pmem_wdata)
);

endmodule : mp2
