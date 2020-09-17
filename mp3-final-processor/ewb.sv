import rv32i_types::*;

module ewb
(
	input clk, 
	input logic read_ewb,  
	input logic write_ewb, 
	input logic [255:0] wdata_ewb, 
	input rv32i_word address_ewb,
	input logic pmem_resp, //From PMEM
	input logic [255:0] pmem_rdata, //rdata From PMEM
	
	output logic ewb_resp, 
	output logic [255:0] rdata_ewb, //Read data from buffer
	output logic pmem_read,
	output logic pmem_write,
	output rv32i_word pmem_address,
	output logic [255:0] pmem_wdata
);

//Additional logic
	logic read_entry;
	logic write_entry; 
	logic hit;
	logic entry_written;

	ewb_control ewb_control
	(
		.clk(clk),
		.hit(hit),
		.write_ewb(write_ewb),
		.read_ewb(read_ewb),
		.read_entry(read_entry),
		.write_entry(write_entry),
		.entry_written(entry_written),
		.ewb_resp(ewb_resp),
		.pmem_resp(pmem_resp),
		.pmem_read(pmem_read),
		.pmem_write(pmem_write)
	);
	
	ewb_datapath ewb_datapath
	(
	.clk(clk), 
	.read_entry(read_entry), 
	.write_entry(write_entry), //When we are accessing entry for read/write.
	.entry_written(entry_written), //When we write entry to memory
	.wdata_ewb(wdata_ewb), //The write data we're storing in entry
	.address_ewb(address_ewb),
	.pmem_rdata(pmem_rdata),
	.rdata_ewb(rdata_ewb),
	.pmem_wdata(pmem_wdata),
	.pmem_address(pmem_address),
	.hit(hit)
	);
endmodule : ewb