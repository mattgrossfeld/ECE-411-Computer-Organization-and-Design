import rv32i_types::*;

module cmp #(parameter width = 32)
(
    input branch_funct3_t cmpop,
    input rv32i_word a, b,
    output logic out
);

//logic data;

/* Altera device registers are 0 at power on. Specify this
 * so that Modelsim works as expected.
 */

always_comb
begin
    case(cmpop)
		beq: //beq
		begin
			out = ($signed(a) == $signed(b));
		end

		bne: //bne
		begin
			out = ($signed(a) != $signed(b));
		end
	 
		blt: //blt
		begin
			out = ($signed(a) < $signed(b));
		end
	 
		bge: //bge
		begin
			out = ($signed(a) >= $signed(b));
		end
	 
		bltu: //bltu
		begin
			out = ($unsigned(a) < $unsigned(b));
		end
		
		default:
		begin
			out = ($unsigned(a) >= $unsigned(b));
		end
	// out = data;
	endcase
end

endmodule : cmp
