module is_hit
(
    input logic [23:0] address_tag,
    input logic [23:0] cache_tag,
	 input logic valid_bit,
    output logic hit
);

always_comb
begin
	hit = (address_tag == cache_tag) && valid_bit;
end

endmodule : is_hit

