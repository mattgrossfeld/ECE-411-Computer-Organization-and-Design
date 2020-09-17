import lc3b_types::*;

module cc_comp
(
	input lc3b_nzp nzp_value,
	input lc3b_reg ir_dest,
	output logic branch_enable
);

always_comb
begin
	if ( (nzp_value[0] && ir_dest[0]) || (nzp_value[1] && ir_dest[1]) || (nzp_value[2] && ir_dest[2]) )
		branch_enable = 1;
	else
		branch_enable = 0;
end
endmodule : cc_comp