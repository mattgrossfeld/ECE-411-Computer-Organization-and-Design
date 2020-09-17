module is_hit #(parameter width = 24)
(
    input logic [width-1:0] address_tag,
    input logic [width-1:0] cache_tag,
	  input logic valid_bit,
    output logic hit
);

always_comb
begin
	hit = (address_tag == cache_tag) && valid_bit;
end

endmodule : is_hit
