import rv32i_types::*;

module ewb_datapath
(
	input clk, 
	input logic read_entry, write_entry, //When we are accessing entry for read/write.
	input logic entry_written, //When we write entry to memory
	input logic [255:0] wdata_ewb, //The write data we're storing in entry
	input rv32i_word address_ewb,
	input logic [255:0] pmem_rdata,
	
	output logic [255:0] rdata_ewb,
	output logic [255:0] pmem_wdata,
	output rv32i_word pmem_address,
	output logic hit
);

logic [255:0] entry_data;
rv32i_word entry_address;
logic valid_entry; //For checking if entry can be overwritten.
logic [288:0] entry_reg_out;

assign entry_data = entry_reg_out[288:33];
assign entry_address = entry_reg_out[32:1];
assign valid_entry = entry_reg_out[0];


always_comb
begin
/*Default Assignment */
	pmem_address = address_ewb; //By default just use the address from L2
	pmem_wdata = entry_data; //By default, our write data will be the data in the entry.
	hit = 1'b0; //By default, miss (don't write)
	
	if (entry_written) //Writing to memory, set the pmem address to our entry's address
		pmem_address = entry_address;
		
	if (valid_entry && (address_ewb == entry_address)) //If our entry is valid (Needs to be written to pmem) and our entry is the same as our L2 memory address.
		hit = 1'b1; //We got a hit.
end

//Create register to hold entry (if multiple entries, change to array)
register #(.width(289)) entry_reg /* 256 (wdata) + 32 (addr) + 1 (valid bit) = 289 bits */
(
	.clk(clk),
	.load(write_entry),
	.in({wdata_ewb, address_ewb, 1'b1}),
	.out(entry_reg_out)
);

mux2 #(.width(256)) rdata_mux
(
	.sel(read_entry),
	.a(entry_data),
	.b(pmem_rdata),
	.f(rdata_ewb)
);

endmodule : ewb_datapath