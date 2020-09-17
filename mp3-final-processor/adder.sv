module adder
(
	input [31:0] a,
	input [31:0] b,
	output logic [31:0] out
);

always_comb
begin
	out = a + b;
end

endmodule : adder