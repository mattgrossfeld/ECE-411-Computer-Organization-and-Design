module plus4 #(parameter width = 32)
(
    input [width-1:0] in,
    output logic [width-1:0] out
);

assign out = in + 32'h00000004;

endmodule : plus4