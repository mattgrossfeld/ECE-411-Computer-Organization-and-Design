import rv32i_types::*; /* Import types defined in rv32i_types.sv */

module control
(
    /* Input and output port declarations */
	input clk,
	/* Datapath controls */
	input rv32i_opcode opcode,
	input logic [2:0] funct3,
	input logic [6:0] funct7, //funct7[5] = bit30
//	input logic bit30,
	input logic br_en,
	output logic load_pc,
	output logic load_ir,
	output logic load_regfile,
	output logic load_mar,
	output logic load_mdr,
	output logic load_data_out,
	output logic [1:0] pcmux_sel,
	output logic [2:0] regfilemux_sel,
	output logic [1:0] memdatamux_sel,
	output logic marmux_sel,
	output logic cmpmux_sel,
	output logic alumux1_sel,
	output logic [2:0] alumux2_sel,
	output alu_ops aluop,
	output branch_funct3_t cmpop,
	/* et cetera */
	/* Memory signals */
	input mem_resp,
	output logic mem_read,
	output logic mem_write,
	output rv32i_mem_wmask mem_byte_enable
);

enum int unsigned {
    /* List of states */
	 fetch1,
	 fetch2,
	 fetch3,
	 decode,
	 s_auipc,
	 s_imm,
	 s_reg, //For the register-register arithmetic
	 jal1,	//Jump and link: PC = PC + SEXT(j_imm)
	 jal2,	//rd = pc + 4
	 jalr1, //Jump and Link register
	 jalr2, //rd = pc + 4
	 s_lui,
	 br,
	 calc_addr,
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
	 load_data_out = 0;
	 pcmux_sel = 0;
	 cmpop = branch_funct3_t'(funct3);
	 alumux1_sel = 1'b0;
	 alumux2_sel = 3'b000;
	 regfilemux_sel = 2'b00;
	 memdatamux_sel = 2'b00;
	 marmux_sel = 1'b0;
	 cmpmux_sel = 1'b0;
	 aluop = alu_ops'(funct3);
	 mem_read = 1'b0;
	 mem_write = 1'b0;
	 mem_byte_enable = 4'b1111;
    /* Actions for each state */
	 case(state)
		fetch1: begin
		/* MAR <= PC */
			load_mar = 1;
		end
		
		fetch2: begin
		/* Read memory */
			mem_read = 1;
			load_mdr = 1;
		end
		
		fetch3: begin
		/* Load IR */
			load_ir = 1;
		end	
		
		decode: /* Do nothing */;

		s_auipc: begin
		/* DR <= PC + u_imm */
			load_regfile = 1;
		//PC is the first input to the ALU
			alumux1_sel = 1;
		//the u-type immediate is the second input to the ALU
			alumux2_sel = 1;
		//in the case of auipc, funct3 is some random bits so we
		//must explicitly set the aluop
			aluop = alu_ops'(alu_add);
		/* PC <= PC + 4 */
			load_pc = 1;
		end
		
		s_imm:
		begin
			case(funct3) //SLTI.
				
				slt:
				begin
					cmpmux_sel = 1;
					cmpop = blt;
					regfilemux_sel = 1;
					load_regfile = 1;
					load_pc = 1;
				end
				
				sltu: //SLTIU
				begin
					cmpmux_sel = 1;
					cmpop = bltu;
					regfilemux_sel = 1;
					load_regfile = 1;
					load_pc = 1;
				end
			
				sr: //SRAI
				begin
					aluop = alu_sra;
					load_regfile = 1;
					load_pc = 1;
				end
				
			default:
				begin
					aluop = alu_ops'(funct3);
					load_regfile = 1;
					load_pc = 1;
				end
			endcase
		end
		
		s_reg:
		begin
			case(funct3)
			   add: //check bit30 for sub if op_reg opcode
				begin
					if (funct7[5]) //Reg-Reg sub
						begin
							load_regfile = 1;
							alumux1_sel = 0;
							alumux2_sel = 6;
							regfilemux_sel = 0;
							aluop = alu_sub;
							load_pc = 1;
						end
					else	//Reg-Reg  addition
						begin
							load_regfile = 1;
							alumux1_sel = 0;
							alumux2_sel = 6;
							regfilemux_sel = 0;
							aluop = alu_add;
							load_pc = 1;
						end
				end
				
				sll:
				begin
						load_pc = 1;
						load_regfile = 1;
						alumux1_sel = 0;
						alumux2_sel = 6;
						regfilemux_sel = 0;
						aluop = alu_sll;	
				end
				
				slt:
				begin
						cmpmux_sel = 0;
						cmpop = blt;
						regfilemux_sel = 1;
						load_regfile = 1;
						load_pc = 1;
				end
				
				sltu:
				begin	
						cmpmux_sel = 0;
						cmpop = bltu;
						regfilemux_sel = 1;
						load_regfile = 1;
						load_pc = 1;
				end
				
				axor:
				begin	
						load_regfile = 1;
						alumux1_sel = 0;
						alumux2_sel = 6;
						regfilemux_sel = 0;
						aluop = alu_xor;
						load_pc = 1;
				end
				
				sr: //check bit30 for logical/arithmetic
				begin
					if (funct7[5]) //Arithmetic
					begin
						load_regfile = 1;
						alumux1_sel = 0;
						alumux2_sel = 6;
						regfilemux_sel = 0;
						aluop = alu_sra;
						load_pc = 1;
					end
	
					else //Logical
					begin
						load_regfile = 1;
						alumux1_sel = 0;
						alumux2_sel = 6;
						regfilemux_sel = 0;
						aluop = alu_srl;
						load_pc = 1;
					end
				end

				aor:
				begin	
						load_regfile = 1;
						alumux1_sel = 0;
						alumux2_sel = 6;
						regfilemux_sel = 0;
						aluop = alu_or;
						load_pc = 1;
				end
				
				aand:
				begin	
						load_regfile = 1;
						alumux1_sel = 0;
						alumux2_sel = 6;
						regfilemux_sel = 0;
						aluop = alu_and;
						load_pc = 1;
				end
				
				default:
				begin
					aluop = alu_ops'(funct3);
					load_regfile = 1;
					load_pc = 1;
				end
			endcase
		end
		
		s_lui:
		begin
			load_regfile = 1;
			load_pc = 1;
			regfilemux_sel = 2;
		end
		
		br:
		begin
			pcmux_sel = br_en;
			load_pc = 1;
			alumux1_sel = 1;
			alumux2_sel = 2;
			aluop = alu_add;
		end
		
		calc_addr:
			begin
			case(opcode)
				op_load: //LW
					begin
						aluop = alu_add;
						load_mar = 1;
						marmux_sel = 1;
					end
			
				op_store: //SW
					begin
						alumux2_sel = 3;
						aluop = alu_add;
						load_mar = 1;
						load_data_out = 1;
						marmux_sel = 1;
						
						case(funct3)
							sw:
							begin
								memdatamux_sel = 0;
							end
							
							sh:
							begin
								memdatamux_sel = 1;
							end
							
							sb:
							begin
								memdatamux_sel = 2;
							end
						endcase
					end
			endcase
			end
	
		ldr1:
			begin
				load_mdr = 1;
				mem_read = 1;
			end
			
		ldr2:
			begin
				case(funct3)
					lw:
					begin
						regfilemux_sel = 3;
						load_regfile = 1;
						load_pc = 1;
					end
					
					lh:
					begin
						regfilemux_sel = 4;
						load_regfile = 1;
						load_pc = 1;
					end
					
					lb:
					begin
						regfilemux_sel = 5;
						load_regfile = 1;
						load_pc = 1;
					end
					
					lhu:
					begin
						regfilemux_sel = 6;
						load_regfile = 1;
						load_pc = 1;
					end
					
					lbu:
					begin
						regfilemux_sel = 7;
						load_regfile = 1;
						load_pc = 1;
					end
					
				endcase
			end
			
		str1:
			begin
				mem_write = 1;
			end
		
		str2:
			begin
				load_pc = 1;
			end
	
		jal1:
			begin
				pcmux_sel = 1;
				load_pc = 1;
				alumux1_sel = 1;
				alumux2_sel = 4;
				aluop = alu_add;
			end
			
		jal2:
		begin
		/* DR <= PC + u_imm */
			load_regfile = 1;
			regfilemux_sel = 0;
		//PC is the first input to the ALU
			alumux1_sel = 1;
		//DECIMAL 4 is the second input to the ALU
			alumux2_sel = 6;
			aluop = alu_add;
		end
			
		jalr1:
			begin
				pcmux_sel = 2;
				load_pc = 1;
				alumux1_sel = 0;
				alumux2_sel = 0;
				aluop = alu_add;
			end
		/*
		jalr2:
			begin
				load_regfile = 1;
				regfilemux_sel = 0;
				alumux1_sel = 1;
				alumux2_sel = 6;
				aluop = alu_add;
			end
		*/	
	default: /* Do nothing */;
	
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
				case(opcode)
					op_auipc: next_state = s_auipc;
					op_lui: next_state = s_lui;
					op_br: next_state = br;
					op_load: next_state = calc_addr;
					op_store: next_state = calc_addr;
					op_imm:   next_state = s_imm;
					op_reg: next_state = s_reg;
					op_jal: next_state = jal1;
					op_jalr: next_state = jalr1;
					default: $display("Unknown opcode");
				endcase
			end
		/*
		Unecessary code
			s_auipc: next_state = fetch1;
			s_imm: next_state = fetch1;
			s_lui: next_state = fetch1;
			br: next_state = fetch1;
		*/	
			calc_addr:
				begin
					case(opcode)
						op_load: next_state = ldr1;
						op_store: next_state = str1;
					//	default: $display("Unknown opcode");
					endcase
				end
			ldr1:	
			begin
				if (mem_resp) next_state = ldr2;
				else next_state = ldr1;
			end
			str1: 
			begin
				if (mem_resp) next_state = str2;
				else next_state = str1;
			end
			
			jal1: next_state = jal2;
			
			jalr1: next_state = jal2;
			
		default: next_state = fetch1;
endcase

end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
	 state <= next_state;
end

endmodule : control
