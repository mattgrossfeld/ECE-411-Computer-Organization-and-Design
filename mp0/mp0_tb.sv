module mp0_tb;

timeunit 1ns;
timeprecision 1ns;

logic clk;
logic mem_resp;
logic mem_read;
logic mem_write;
logic [1:0] mem_byte_enable;
logic [15:0] mem_address;
logic [15:0] mem_rdata;
logic [15:0] mem_wdata;
logic [15:0] write_data;
logic [15:0] write_address;
logic write;
logic halt;
logic [15:0] registers [8];

/* Clock generator */
initial clk = 0;
always #5 clk = ~clk;

assign registers = dut.datapath.regfile.data;
assign halt = dut.datapath.IR.data == 16'h0FFF;

always @(posedge clk)
begin
    if (mem_write & mem_resp) begin
        write_address = mem_address;
        write_data = mem_rdata;
        write = 1;
    end else begin
        write_address = 'X;
        write_data = 'X;
        write = 0;
    end
end

mp0 dut
(
    .clk,
    .mem_resp,
    .mem_rdata,
    .mem_read,
    .mem_write,
    .mem_byte_enable,
    .mem_address,
    .mem_wdata
);

magic_memory memory
(
    .clk,
    .read(mem_read),
    .write(mem_write),
    .wmask(mem_byte_enable),
    .address(mem_address),
    .wdata(mem_wdata),
    .resp(mem_resp),
    .rdata(mem_rdata)
);

endmodule : mp0_tb
