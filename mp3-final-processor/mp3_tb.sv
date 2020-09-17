import rv32i_types::*;

module mp3_tb;

timeunit 1ns;
timeprecision 1ns;

logic clk;
logic pmem_resp;
logic pmem_read;
logic pmem_write;
rv32i_word pmem_address;
logic [255:0] pmem_wdata;
logic [255:0] pmem_rdata;

/* autograder signals */
logic [255:0] write_data;
logic [27:0] write_address;
logic write;
logic halt;
logic [31:0] registers [32];
logic [255:0] i_data0 [8];
logic [255:0] i_data1 [8];
logic [23:0] i_tags0 [8];
logic [23:0] i_tags1 [8];
logic [255:0] d_data0 [8];
logic [255:0] d_data1 [8];
logic [23:0] d_tags0 [8];
logic [23:0] d_tags1 [8];
/*
logic [255:0] data0_L2 [16];
logic [255:0] data1_L2 [16];
logic [255:0] data2_L2 [16];
logic [255:0] data3_L2 [16];
logic [22:0] tags0_L2 [16];
logic [22:0] tags1_L2 [16];
logic [22:0] tags2_L2 [16];
logic [22:0] tags3_L2 [16];
*/
/* Clock generator */
initial clk = 0;
always #5 clk = ~clk;

assign registers = dut.cpu.regfile.data;
assign halt = ((dut.cpu.if_id.data == 32'h00000063) | (dut.cpu.if_id.data == 32'h0000006F));
assign i_data0 = dut.instruction_cache.datapath.data_array0.data;
assign i_data1 = dut.instruction_cache.datapath.data_array1.data;
assign i_tags0 = dut.instruction_cache.datapath.tag_array0.data;
assign i_tags1 = dut.instruction_cache.datapath.tag_array1.data;
assign d_data0 = dut.data_cache.datapath.data_array0.data;
assign d_data1 = dut.data_cache.datapath.data_array1.data;
assign d_tags0 = dut.data_cache.datapath.tag_array0.data;
assign d_tags1 = dut.data_cache.datapath.tag_array1.data;
/*
assign data0_L2 = dut.cacheL2.datapath.data_array0.data;
assign data1_L2 = dut.cacheL2.datapath.data_array1.data;
assign data2_L2 = dut.cacheL2.datapath.data_array2.data;
assign data3_L2 = dut.cacheL2.datapath.data_array3.data;
assign tags0_L2 = dut.cacheL2.datapath.tag_array0.data;
assign tags1_L2 = dut.cacheL2.datapath.tag_array1.data;
assign tags2_L2 = dut.cacheL2.datapath.tag_array2.data;
assign tags3_L2 = dut.cacheL2.datapath.tag_array3.data;
*/
always @(posedge clk)
begin
    if (pmem_write & pmem_resp) begin
        write_address = pmem_address[31:5];
        write_data = pmem_wdata;
        write = 1;
    end else begin
        write_address = 27'hx;
        write_data = 256'hx;
        write = 0;
    end
end


mp3 dut(
    .*
);

physical_memory memory(
    .clk,
    .read(pmem_read),
    .write(pmem_write),
    .address(pmem_address),
    .wdata(pmem_wdata),
    .resp(pmem_resp),
    .rdata(pmem_rdata)
);

endmodule : mp3_tb

