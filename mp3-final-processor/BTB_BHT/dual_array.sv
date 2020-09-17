import rv32i_types::*;

module dual_array #(parameter width = 32)
(
    input clk,
    input write_a,
    input write_b,
    input [3:0] index_a, //4 bits. 16 entries. 
    input [3:0] index_b,
    input [width-1:0] datain_a,
    input [width-1:0] datain_b,
    output logic [width-1:0] dataout_a,
    output logic [width-1:0] dataout_b
);

logic [width-1:0] data [15:0] /* synthesis ramstyle = "logic" */;

/* Initialize array */
initial
begin
    for (int i = 0; i < $size(data); i++)
    begin
        data[i] = 1'b0;
    end
end

always_ff @(posedge clk)
begin
    if (write_a == 1)
    begin
        data[index_a] = datain_a;
    end

    if (write_b == 1)
    begin
        data[index_b] = datain_b;
    end
end

assign dataout_a = data[index_a];
assign dataout_b = data[index_b];

endmodule : dual_array

