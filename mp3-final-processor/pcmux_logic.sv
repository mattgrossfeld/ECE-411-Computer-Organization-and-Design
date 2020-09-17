import rv32i_types::*;

module pcmux_logic
(
input logic p_if, //prediction in IF
input logic p_ex, //Prediction in EX
input logic p_mem, //prediction in MEM
input logic br_en, //br_en. Comes from MEM stage.
input logic cmp_out, //cmp_out. Comes from EX stage. Our early resolution branch signal.
input rv32i_opcode if_opcode,
input rv32i_opcode ex_opcode,
input rv32i_opcode mem_opcode,
output logic [1:0] pcmux_sel,
output logic clear_from_ex, //Clear regs from EX and prior.
output logic clear_from_mem //Clear regs from MEM and prior
);

logic ex_br; //Br signal from execute stage
logic ex_prediction; //Prediction from ex stage.
logic branch; 
logic prediction; 
logic [1:0] ex_check;
logic [1:0] mem_check;
logic new_prediction;

assign ex_br = cmp_out && (ex_opcode == op_jal || ex_opcode == op_jalr || ex_opcode == op_br);
assign ex_prediction = p_ex && (ex_opcode == op_jal || ex_opcode == op_jalr || ex_opcode == op_br);
assign prediction = p_mem && ((mem_opcode == op_jal) || (mem_opcode == op_jalr) || (mem_opcode == op_br));
assign branch = br_en && ((mem_opcode == op_jal) || (mem_opcode == op_jalr) || (mem_opcode == op_br));

assign new_prediction = p_if && ((if_opcode == op_jal) || (if_opcode == op_jalr) || (if_opcode == op_br));
assign ex_check = {ex_prediction, ex_br}; //Check our prediction and branch in the EX stage.
assign mem_check = {prediction, branch}; //Check our prediction in MEM stage once we get the branch.

always_comb
begin
	if (ex_check == 2'b00) //Predicted NT correctly. In EX stage.
	begin
		pcmux_sel = {new_prediction, 1'b0}; //PC+4 or new prediction.
		clear_from_ex = 1'b0;
		clear_from_mem = 1'b0;
	end

	else if (ex_check == 2'b10) //Predicted T but got NT. In EX stage
	begin
		pcmux_sel = 2'b11; //pc_ex + 4
		clear_from_ex = 1'b1;	
		clear_from_mem = 1'b0;
	end
	
	else if (mem_check == 2'b01) //Predicted NT but got T. in MEM stage.
	begin
		pcmux_sel = 2'b01; //alu_mem for target address.
		clear_from_mem = 1'b1;
		clear_from_ex = 1'b0;
	end
	
	else if (mem_check == 2'b11) //predicted T correctly.
	begin
		pcmux_sel = {new_prediction, 1'b0}; //pc+4 or new prediction.
			clear_from_ex = 1'b0;
			clear_from_mem = 1'b0;
	end
	
	else	
	begin
		pcmux_sel = {new_prediction, 1'b0};
		clear_from_ex = 1'b0;
		clear_from_mem = 1'b0;
	end
	
end

endmodule : pcmux_logic