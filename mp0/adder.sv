import lc3b_types::*;

module adder #(parameter width = 16)
(
	input lc3b_word offset, //from the ADJ9 (and IR)
	input lc3b_word addr_in, //from the PC
	output lc3b_word addr_out
);

always_comb
begin
	//total_offset = {7b'0000000,offset9}; //Zero extend
	addr_out = addr_in + offset;
end

endmodule : adder