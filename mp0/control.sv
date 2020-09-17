import lc3b_types::*; /* Import types defined in lc3b_types.sv */

module control
(
	 input clk,
    /* Input and output port declarations */
	 input lc3b_opcode opcode,
	 input logic branch_enable,
	 output logic load_pc,
	 output logic load_ir,
	 output logic load_regfile,
	 output logic load_mar,
	 output logic load_mdr,
	 output logic load_cc,
	 output logic pcmux_sel,
	 output logic storemux_sel,
	 output logic alumux_sel,
	 output logic regfilemux_sel,
	 output logic marmux_sel,
	 output logic mdrmux_sel,
	 output lc3b_aluop aluop,
	 
	 /* Memory signals */
	 input mem_resp,
	 output logic mem_read,
	 output logic mem_write,
	 output lc3b_mem_wmask mem_byte_enable
);

enum int unsigned {
    /* List of states */
	 fetch1,
	 fetch2,
	 fetch3,
	 decode,
	 s_add,
	 s_and,
	 s_not,
	 br,
	 br_taken,
	 calc_addr, //For LDR and STR
	 ldr1,
	 ldr2,
	 str1,
	 str2
} state, next_state;

always_comb
begin : state_actions
    /* Default output assignments */
	 load_pc = 1'b0;
	 load_ir = 1'b0;
	 load_regfile = 1'b0;
	 load_mar = 1'b0;
	 load_mdr = 1'b0;
	 load_cc = 1'b0;
	 pcmux_sel = 1'b0;
	 storemux_sel = 1'b0;
	 alumux_sel = 1'b0;
	 regfilemux_sel = 1'b0;
	 marmux_sel = 1'b0;
	 mdrmux_sel = 1'b0;
	 aluop = alu_add;
	 mem_read = 1'b0;
	 mem_write = 1'b0;
	 mem_byte_enable = 2'b11;
    /* Actions for each state */
	 
	 case(state)
		fetch1: 
			begin
			/* MAR <= PC */
				marmux_sel = 1;
				load_mar = 1;
			/* PC <= PC + 2 */
				pcmux_sel = 0;
				load_pc = 1;
			end

		fetch2: 
			begin
			/* READ MEMORY */
				mem_read = 1;
				mdrmux_sel = 1;
				load_mdr = 1;
			end
			
		fetch3: 
			begin
			/* LOAD IR */
				load_ir = 1;
			end
		
		decode: /*do nothing*/;
		
		s_add: 
			begin
			/* DR <= SRA + SRB */
				aluop = alu_add;
				load_regfile = 1;
				regfilemux_sel = 0;
				load_cc = 1;
			end
		
		s_and: 
			begin
			/* DR <= SRA & SRB */
				aluop = alu_and;
				load_regfile = 1;
				regfilemux_sel = 0;
				load_cc = 1;
			end
		
		s_not: 
			begin
			/* DR <= NOT(SRA) */
				aluop = alu_not;
				load_regfile = 1;
				regfilemux_sel = 0;
				load_cc = 1;
			end
		
		br: /*do nothing*/;
		
		br_taken:
			begin
				/* PC <= PC + SEXT(IR[8:0] << 1) */
				pcmux_sel = 1;
				load_pc = 1;
			end
		
		calc_addr: 
			begin
			/* MAR <= SRA + SEXT(IR[5:0] << 1) */
				alumux_sel = 1;
				aluop = alu_add;
				load_mar = 1;
			end
			
		ldr1: 
			begin
			/* MDR <= M[MAR] */
				mdrmux_sel = 1;
				load_mdr = 1;
				mem_read = 1;
			end
		
		ldr2:
			begin
			/* DR <= MDR */
				regfilemux_sel = 1;
				load_regfile = 1;
				load_cc = 1;
			end
		
		str1:
			begin
			/* MDR <= SR */
				storemux_sel = 1;
				aluop = alu_pass;
				load_mdr = 1;
			end
		
		str2:
			begin
			/* M[MAR] <= MDR */
				mem_write = 1;
			end
		
		default: /* do nothing*/;
	endcase
end

always_comb
begin : next_state_logic
    /* Next state information and conditions (if any)
     * for transitioning between states */
	  next_state = state;
	  case(state)
			fetch1: next_state = fetch2;
			fetch2: if (mem_resp) next_state = fetch3;
			fetch3: next_state = decode;
			decode: begin
				case (opcode)
					op_add: next_state = s_add;
					op_and: next_state = s_and;
					op_not: next_state = s_not;
					op_br: next_state = br;
					op_ldr: next_state = calc_addr;
					op_str: next_state = calc_addr;
					default: $display("Unknown opcode");
				endcase
			end
			br: begin
				if (branch_enable) 
					next_state = br_taken;
				else
					next_state = fetch1;
			end
			calc_addr: begin
				case (opcode)
					op_ldr: next_state = ldr1;
					op_str: next_state = str1;
					default: $display("Unknown opcode");
				endcase
			end
			ldr1: begin
				if (mem_resp) next_state = ldr2;
				else next_state = ldr1;
			end
			str1: next_state = str2;
			str2: begin
				if (mem_resp) next_state = fetch1;
				else next_state = str2;
			end
			default: next_state = fetch1;
		endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
	 state <= next_state;
end

endmodule : control
