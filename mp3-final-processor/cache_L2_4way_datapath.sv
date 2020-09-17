import rv32i_types::*;

module cache_L2_4way_datapath
(
   /* Input and output port declarations */
	input clk,
	/* Datapath controls */
	
	input logic [1:0] hit_sel,	//for choosing which way we use
	
	output logic hit0,			//For tracking hits from way 0
	output logic hit1, 			//For tracking hits from way 1
	output logic hit2,			//For tracking hits from way 2
	output logic hit3, 			//For tracking hits from way 3
	
	input logic write_data0, 	//Write signal data0
	input logic write_data1, 	//Write signal data1
	input logic write_data2, 	//Write signal data2
	input logic write_data3, 	//Write signal data3
	input logic write_tag0,		//Write signal
	input logic write_tag1,		//Write signal
	input logic write_tag2,		//Write signal
	input logic write_tag3,		//Write signal
	input logic write_dirty0,	//Write Signal
	input logic write_dirty1,	//Write Signal
	input logic write_dirty2,	//Write Signal
	input logic write_dirty3,	//Write Signal
	input logic write_valid0,	//Write Signal
	input logic write_valid1,	//Write Signal
	input logic write_valid2,	//Write Signal
	input logic write_valid3,	//Write Signal
	input logic write_lru,		//Write signal
	
	input logic [2:0] addr_mux_sel, //Select bits for pmem_address mux
	input logic datainmux_sel, //Select bit for datain mux
	
	output logic valid0_dataout,					//The current valid0
	output logic valid1_dataout,					//The current valid1
	output logic valid2_dataout,					//The current valid2
	output logic valid3_dataout,					//The current valid3
	input logic valid0_datain,			//The input to valid0
	input logic valid1_datain,			//The input to valid1
	input logic valid2_datain,			//The input to valid2
	input logic valid3_datain,			//The input to valid3
	
	output logic dirty0_dataout,					//The current dirty0
	output logic dirty1_dataout,					//The current dirty1
	output logic dirty2_dataout,					//The current dirty2
	output logic dirty3_dataout,					//The current dirty3
	input logic dirty0_datain,			//The input to dirty0
	input logic dirty1_datain,			//The input to dirty1
	input logic dirty2_datain,			//The input to dirty2
	input logic dirty3_datain,			//The input to dirty3
	
	output logic [2:0] lru_dataout,						//The current LRU value
	input logic [2:0] lru_datain,				//The input to LRU
	
	/* Memory inputs and outputs */
	//input logic [3:0] mem_byte_enable,
	input rv32i_word mem_address,
	input logic [255:0] mem_wdata,
	output logic [255:0] mem_rdata,

	input logic [255:0] pmem_rdata,
	output logic [255:0] pmem_wdata,
	output rv32i_word pmem_address
);

logic [27:0] tag;
//logic [2:0] offset;
logic [3:0] index;

logic [27:0] tag0_dataout;
logic [27:0] tag1_dataout;
logic [27:0] tag2_dataout;
logic [27:0] tag3_dataout;

logic [255:0] data_datain, data0_dataout, data1_dataout, data2_dataout, data3_dataout;
logic [255:0] data_decoder_out;

logic [255:0] waydatamux_out;

//assign offset = mem_address[2:0]; //Offset is first five bits of mem_address
assign index = mem_address[3:0]; //Index is the three bits after offset
assign tag = mem_address[31:4]; //Tag is the remaining 24 bits of mem_address


//Data arrays
array_L2_4way data_array0
(
	.clk(clk),
   .write(write_data0),
   .index(index),
   .datain(data_datain), //Input from datain mux
   .dataout(data0_dataout)
);

array_L2_4way data_array1
(
	.clk(clk),
   .write(write_data1),
   .index(index),
   .datain(data_datain), //Input from datain mux
   .dataout(data1_dataout)
);

array_L2_4way data_array2
(
	.clk(clk),
   .write(write_data2),
   .index(index),
   .datain(data_datain), //Input from datain mux
   .dataout(data2_dataout)
);

array_L2_4way data_array3
(
	.clk(clk),
   .write(write_data3),
   .index(index),
   .datain(data_datain), //Input from datain mux
   .dataout(data3_dataout)
);

//Dirty arrays
array_L2_4way #(.width(1)) dirty0
(
	.clk(clk),
   .write(write_dirty0),
   .index(index),
   .datain(dirty0_datain), //Input should be mem_write
   .dataout(dirty0_dataout)
);

array_L2_4way #(.width(1)) dirty1
(
	.clk(clk),
   .write(write_dirty1),
   .index(index),
   .datain(dirty1_datain), //Input should be mem_write
   .dataout(dirty1_dataout)
);

array_L2_4way #(.width(1)) dirty2
(
	.clk(clk),
   .write(write_dirty2),
   .index(index),
   .datain(dirty2_datain), //Input should be mem_write
   .dataout(dirty2_dataout)
);

array_L2_4way #(.width(1)) dirty3
(
	.clk(clk),
   .write(write_dirty3),
   .index(index),
   .datain(dirty3_datain), //Input should be mem_write
   .dataout(dirty3_dataout)
);

//Valid arrays
array_L2_4way #(.width(1)) valid0
(
	.clk(clk),
   .write(write_valid0),
   .index(index),
   .datain(valid0_datain), //Should just be 1'b1
   .dataout(valid0_dataout)
);

array_L2_4way #(.width(1)) valid1
(
	.clk(clk),
   .write(write_valid1),
   .index(index),
   .datain(valid1_datain), //Should just be 1'b1
   .dataout(valid1_dataout)
);

array_L2_4way #(.width(1)) valid2
(
	.clk(clk),
   .write(write_valid2),
   .index(index),
   .datain(valid2_datain), //Should just be 1'b1
   .dataout(valid2_dataout)
);

array_L2_4way #(.width(1)) valid3
(
	.clk(clk),
   .write(write_valid3),
   .index(index),
   .datain(valid3_datain), //Should just be 1'b1
   .dataout(valid3_dataout)
);

//Tag arrays
array_L2_4way #(.width(28)) tag_array0
(
	.clk(clk),
   .write(write_tag0),
   .index(index),
   .datain(tag), //Input should be the tag in current mem_address
   .dataout(tag0_dataout)
);

array_L2_4way #(.width(28)) tag_array1
(
	.clk(clk),
   .write(write_tag1),
   .index(index),
   .datain(tag), //Input should be the tag in current mem_address
   .dataout(tag1_dataout)
);

array_L2_4way #(.width(28)) tag_array2
(
	.clk(clk),
   .write(write_tag2),
   .index(index),
   .datain(tag), //Input should be the tag in current mem_address
   .dataout(tag2_dataout)
);

array_L2_4way #(.width(28)) tag_array3
(
	.clk(clk),
   .write(write_tag3),
   .index(index),
   .datain(tag), //Input should be the tag in current mem_address
   .dataout(tag3_dataout)
);

//Comparators for Tags. Gets us hits.
is_hit #(.width(28)) is_hit0
(
	.address_tag(tag),
	.cache_tag(tag0_dataout),
	.valid_bit(valid0_dataout),
	.hit(hit0)
);

is_hit #(.width(28)) is_hit1
(
	.address_tag(tag),
	.cache_tag(tag1_dataout),
	.valid_bit(valid1_dataout),
	.hit(hit1)
);

is_hit #(.width(28)) is_hit2
(
	.address_tag(tag),
	.cache_tag(tag2_dataout),
	.valid_bit(valid2_dataout),
	.hit(hit2)
);

is_hit #(.width(28)) is_hit3
(
	.address_tag(tag),
	.cache_tag(tag3_dataout),
	.valid_bit(valid3_dataout),
	.hit(hit3)
);


//LRU array
array_L2_4way #(.width(3)) lru
(
	.clk(clk),
   .write(write_lru),
   .index(index),
   .datain(lru_datain), //Input should just be hit1
   .dataout(lru_dataout)
);

//Mux for pmem_wdata
mux8 #(.width(256)) pmem_wdata_mux
(
	.sel(lru_dataout),
	.a(data0_dataout),
	.b(data0_dataout),
	.c(data2_dataout),
	.d(data3_dataout),
	.e(data1_dataout),
	.f(data1_dataout),
	.g(data2_dataout),
	.h(data3_dataout),
	.out(pmem_wdata)
);

//Mux for getting pmem_address
mux8 #(.width(32)) pmem_address_mux
(
	.sel(addr_mux_sel),
	.a(mem_address),
	.b({tag0_dataout, index}), //Might need to change the zeros to offset
	.c({tag1_dataout, index}),
	.d({tag2_dataout, index}),
	.e({tag3_dataout, index}),
	.f(0),
	.g(0),
	.h(0),
	.out(pmem_address)
);

//Mux for choosing the way
mux4 #(.width(256)) waydata_mux
(
	.sel(hit_sel),
	.a(data0_dataout),
	.b(data1_dataout),
	.c(data2_dataout),
	.d(data3_dataout),
	.f(mem_rdata)
);

//Mux for datain
mux2 #(.width(256)) datain_mux
(
	.sel(datainmux_sel),
	.a(pmem_rdata),
	.b(mem_wdata),
	.f(data_datain)
);

endmodule : cache_L2_4way_datapath