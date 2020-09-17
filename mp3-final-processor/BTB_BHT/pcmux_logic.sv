import rv32i_types::*;

module pcmux_logic
(
input logic p_if, //prediction in IF
input logic p_mem, //prediction in MEM
input logic br_en,
input rv32i_opcode if_opcode,
input rv32i_opcode mem_opcode,
output logic [1:0] pcmux_sel,
output logic clear_stages //1 if p_mem != br_en. 0 if pmem == br_en. Clear signal for registers
);

logic branch; 
logic prediction; 
logic [1:0] mem_check;
logic new_prediction;

assign prediction = p_mem && ((mem_opcode == op_jal) || (mem_opcode == op_jalr) || (mem_opcode == op_br));
assign branch = br_en && ((mem_opcode == op_jal) || (mem_opcode == op_jalr) || (mem_opcode == op_br));

assign new_prediction = p_if && ((if_opcode == op_jal) || (if_opcode == op_jalr) || (if_opcode == op_br));

assign mem_check = {prediction, branch}; //Check our prediction in MEM stage once we get the branch.
assign clear_stages = (prediction != branch); //Determines if we mispredicted.

always_comb
begin
	case(mem_check)
		2'b00: //Predicted NT correctly
		begin
			pcmux_sel = {new_prediction, 1'b0}; //PC+4 or new prediction.
		end

		2'b01: //Predicted NT, but got T
		begin
			pcmux_sel = 2'b01; //alu_mem for target address.
		end

		2'b10: //Predicted T but got NT.
		begin
			pcmux_sel = 2'b11; //pc_mem + 4
		end

		2'b11: //Predicted T correctly. got T
		begin
			pcmux_sel = {new_prediction, 1'b0}; //pc+4 or new prediction.
		end
	endcase
end

endmodule : pcmux_logic