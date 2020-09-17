import rv32i_types::*;

module control_rom
(
input logic [2:0] funct3,
input logic [6:0] funct7,
input rv32i_reg rs1,
input rv32i_reg rs2,
input rv32i_opcode opcode,
input logic prediction,
output rv32i_control_word ctrl
);

always_comb
begin
/* Default assignments */
ctrl.opcode = opcode;
ctrl.aluop = alu_ops'(funct3);
ctrl.load_regfile = 1'b0;
ctrl.load_pc = 1'b1; //hardcode to 1 for cp1
ctrl.read = 1'b0;
ctrl.write = 1'b0;
ctrl.alumux1_sel = 1'b0; //rs1_out
ctrl.alumux2_sel = 3'b000; //i_imm
ctrl.regfilemux_sel = 4'b0000; //alu_out
ctrl.memdatamux_sel = 2'b00; //Rs2_out
ctrl.cmpmux_sel = 1'b0; //rs2_out
ctrl.pcmux_sel = 1'b0; //pc_out
ctrl.cmpop = branch_funct3_t'(funct3); // Assign control signals based on opcode
ctrl.rs1 = rs1;
ctrl.rs2 = rs2;
ctrl.fwd_rs2 = 1'b0;
ctrl.fwd_stall = 1'b0;
ctrl.prediction = prediction;

case(opcode)
	op_auipc: 
	begin
		ctrl.aluop = alu_add; //Addition
		ctrl.alumux1_sel = 1'b1; //PC
		ctrl.alumux2_sel = 3'b001; //u_imm
		ctrl.load_regfile = 1'b1;
	end
   
	op_lui:   
   begin
		ctrl.load_regfile = 1'b1;
		ctrl.regfilemux_sel = 4'b0010;
   end

   op_jal:   
   begin
		ctrl.prediction = 1'b1;
		ctrl.aluop = alu_add;
		ctrl.alumux1_sel = 1'b1; //PC
		ctrl.alumux2_sel = 3'b100; //j_imm
		ctrl.pcmux_sel = 1'b1; //pc = target address (pc + j_imm)
		ctrl.load_regfile = 1'b1; //Need to load rd. Rd <- pc+4
		ctrl.regfilemux_sel = 4'b1000; // PC + 4
   end

   op_jalr:  
   begin
		ctrl.prediction = 1'b1;
		ctrl.aluop = alu_add;
		ctrl.alumux1_sel = 1'b0; //RS1_OUT
		ctrl.alumux2_sel = 3'b000; //i_imm
		ctrl.pcmux_sel = 1'b1; //pc = target address (rs1_out + i_imm)
		ctrl.load_regfile = 1'b1; //Need to load rd. Rd <- pc+4
		ctrl.regfilemux_sel = 4'b1000; // PC + 4
   end
	
   op_br:
   begin
		ctrl.prediction = prediction;
		ctrl.cmpmux_sel = 1'b0; //RS2. Branch compares rs1 with rs2 ONLY
		ctrl.pcmux_sel = 1'b1;
		ctrl.aluop = alu_add;
		ctrl.alumux1_sel = 1'b1; //PC
		ctrl.alumux2_sel = 3'b010; //b_imm
		ctrl.fwd_rs2 = 1'b1;
   end

   op_load:  
   begin
		ctrl.fwd_stall = 1'b1;
		ctrl.load_regfile = 1'b1;
		ctrl.read = 1'b1;
		
		case (funct3)
			lw:
			begin
				ctrl.regfilemux_sel = 4'b0011; //RS1_out + i_imm
				ctrl.alumux1_sel = 1'b0; //rs1_out
				ctrl.alumux2_sel = 3'b000; //i_imm
				ctrl.aluop = alu_add;
			end
			lh:
			begin
				ctrl.regfilemux_sel = 4'b0100; //RS1_out + i_imm
				ctrl.alumux1_sel = 1'b0; //rs1_out
				ctrl.alumux2_sel = 3'b000; //i_imm
				ctrl.aluop = alu_add;
			end
			lb:
			begin
				ctrl.regfilemux_sel = 4'b0101; //RS1_out + i_imm
				ctrl.alumux1_sel = 1'b0; //rs1_out
				ctrl.alumux2_sel = 3'b000; //i_imm
				ctrl.aluop = alu_add;
			end
			lhu:
			begin
				ctrl.regfilemux_sel = 4'b0110; //RS1_out + i_imm
				ctrl.alumux1_sel = 1'b0; //rs1_out
				ctrl.alumux2_sel = 3'b000; //i_imm
				ctrl.aluop = alu_add;
			end
			lbu:
			begin
				ctrl.regfilemux_sel = 4'b0111; //RS1_out + i_imm
				ctrl.alumux1_sel = 1'b0; //rs1_out
				ctrl.alumux2_sel = 3'b000; //i_imm
				ctrl.aluop = alu_add;
			end
			
			default: ;
		endcase
   end
    
   op_store: 
   begin
		ctrl.write = 1'b1;
		ctrl.alumux1_sel = 1'b0; //rs1_out
		ctrl.alumux2_sel = 3'b011; //s_imm
		ctrl.aluop = alu_add;
		ctrl.fwd_rs2 = 1'b1;
		case(funct3)
			sw:
			begin
				ctrl.memdatamux_sel = 2'b00; // Full word
			end
			
			sh:
			begin
				ctrl.memdatamux_sel = 2'b01; //Half word
			end
			
			sb:
			begin
				ctrl.memdatamux_sel = 2'b10; //byte
			end
			
			default: ;
		endcase
   end

   op_imm: //FOR ALU, THE INPUTS SHOULD BE RS1_OUT AND I_IMM
   begin
		case(funct3)
			slt: //slti
			begin
				ctrl.cmpmux_sel = 1'b1; //i_imm
				ctrl.cmpop = blt; //less than comparison
				ctrl.regfilemux_sel = 4'b0001; //cmp_out (br_en)
				ctrl.load_regfile = 1'b1; //Load into rd
			end
			
			sltu: //sltiu
			begin
				ctrl.cmpmux_sel = 1'b1; //i_imm
				ctrl.cmpop = bltu; //less than unsigned comparison
				ctrl.regfilemux_sel = 4'b0001; //cmp_out (br_en)
				ctrl.load_regfile = 1'b1;
			end
			
			sr: //srai
			begin
				if (funct7[5]) //Bit30 check. If 1, SRAI
				begin
					ctrl.aluop = alu_sra;
					ctrl.load_regfile = 1'b1;
				end
				else //Bit30 check. If 0, SRLI
				begin
					ctrl.aluop = alu_srl;
					ctrl.load_regfile = 1'b1;
				end				
			end
			
			default:
			begin
				ctrl.aluop = alu_ops'(funct3);
				ctrl.load_regfile = 1'b1;
			end
		endcase
   end

   op_reg:   
   begin
		ctrl.fwd_rs2 = 1'b1;
		case(funct3)
			add:
			begin
				if (funct7[5]) //Bit30 check. If 1, we do subtraction
					begin
				ctrl.alumux1_sel = 1'b0; //rs1_out
				ctrl.alumux2_sel = 3'b110; //rs2_out
				ctrl.aluop = alu_sub;
				ctrl.regfilemux_sel = 4'b0000; //alu_out
				ctrl.load_regfile = 1'b1;
					end
				else //Bit30 check. If 0, we do addition
					begin
				ctrl.alumux1_sel = 1'b0; //rs1_out
				ctrl.alumux2_sel = 3'b110; //rs2_out
				ctrl.aluop = alu_add;
				ctrl.regfilemux_sel = 4'b0000; //alu_out
				ctrl.load_regfile = 1'b1;
					end
			end
			
			sll:
			begin
				ctrl.load_regfile = 1'b1;
				ctrl.alumux1_sel = 1'b0; //rs1_out
				ctrl.alumux2_sel = 3'b110; //rs2_out
				ctrl.regfilemux_sel = 4'b0000; //alu_out
				ctrl.aluop = alu_sll;
			end
			
			slt:
			begin
				ctrl.load_regfile = 1'b1;
				ctrl.regfilemux_sel = 4'b0001; //cmp_out (br_en)
				ctrl.cmpmux_sel = 1'b0; //rs2_out
				ctrl.cmpop = blt;
			end
			
			sltu:
			begin
				ctrl.load_regfile = 1'b1;
				ctrl.regfilemux_sel = 4'b0001; //cmp_out (br_en)
				ctrl.cmpmux_sel = 1'b0; //rs2_out
				ctrl.cmpop = bltu;
			end
			
			axor:
			begin
				ctrl.load_regfile = 1'b1;
				ctrl.alumux1_sel = 1'b0; //rs1_out
				ctrl.alumux2_sel = 3'b110; //rs2_out
				ctrl.aluop = alu_xor;
				ctrl.regfilemux_sel = 4'b0000; //alu_out
			end
			
			sr: //CURRENTLY (CHECKPOINT 1) IT IS JUST LOGICAL SHIFT
			begin
					if (funct7[5]) //Bit30 check. if 1, arithmetic shift.
					begin
						ctrl.load_regfile = 1'b1;
						ctrl.alumux1_sel = 1'b0; //rs1_out
						ctrl.alumux2_sel = 3'b110; //rs2_out
						ctrl.regfilemux_sel = 4'b0000; //alu_out
						ctrl.aluop = alu_sra;
					end
					else //Bit30 check. if 0, logical shift.
					begin
						ctrl.load_regfile = 1'b1;
						ctrl.alumux1_sel = 1'b0; //rs1_out
						ctrl.alumux2_sel = 3'b110; //rs2_out
						ctrl.regfilemux_sel = 4'b0000; //alu_out
						ctrl.aluop = alu_srl;
					end
			end
			
			aor:
			begin
				ctrl.load_regfile = 1'b1;
				ctrl.alumux1_sel = 1'b0; //rs1_out
				ctrl.alumux2_sel = 3'b110; //rs2_out
				ctrl.regfilemux_sel = 4'b0000; //alu_out
				ctrl.aluop = alu_or;
			end
			
			aand:
			begin
				ctrl.load_regfile = 1'b1;
				ctrl.alumux1_sel = 1'b0; //rs1_out
				ctrl.alumux2_sel = 3'b110; //rs2_out
				ctrl.regfilemux_sel = 4'b0000; //alu_out
				ctrl.aluop = alu_and;
			end
			
			default:
			begin
				ctrl.aluop = alu_ops'(funct3);
				ctrl.load_regfile = 1'b1;
				ctrl.alumux1_sel = 1'b0; //rs1_out
				ctrl.alumux2_sel = 3'b110; //rs2_out
			end
		endcase
   end
    
/*   op_csr:
   begin

   end
*/
	default: 
	begin
		ctrl = 0; /* Unknown opcode, set control word to zero */
	end
	
endcase

end

endmodule : control_rom