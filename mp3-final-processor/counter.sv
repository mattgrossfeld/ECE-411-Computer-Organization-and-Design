module counter #(WIDTH = 32)
(
	input clk,
	input datain,
	input clear,
	output logic [WIDTH-1:0] dataout
);

logic [WIDTH-1:0] count;

always_ff @(posedge clk)
begin
	if(clear)
		count <= 0;
	else if(datain)
		count <=  count + 1;
	else
		count <= count;
end

always_comb
begin
	dataout = count;
end

endmodule : counter
