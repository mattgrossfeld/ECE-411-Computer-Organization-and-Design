import rv32i_types::*;

module btb_datapath
(
   /* Input and output port declarations */
	input clk,
	input rv32i_word pc_out, //output from PC in IF stage.
	input rv32i_word pc_ex, //PC from EX stage
	input rv32i_word pc_mem, //the value of PC in the MEM stage.
	input rv32i_opcode if_opcode, //rdata_a[6:0]. Check if branch or jump.
	input rv32i_opcode ex_opcode, //EX opcode.
	input rv32i_opcode mem_opcode, // ctrl_mem.opcode
	input logic br_en, //Take in the branch
	input rv32i_word calculated_addr, //The calculated target address in MEM (alu_mem)

	output rv32i_word target_address, // The target address in the IF stage.
	output logic branch_prediction //The outputted prediction (T/NT).
);

rv32i_word pc_array_out;
rv32i_word target_mem;
logic br_prediction;
logic write_pc_if;
logic write_valid_mem;
logic write_target_mem;
logic valid_out_a;
logic valid_out_b;
logic write_valid_if;
array16 #(.width(32)) pc_array
(
   .clk(clk),
   .write(write_pc_if),
   .index(pc_out[5:2]), //Entry for IF
   .datain(pc_out), //Input from PC
   .dataout(pc_array_out)
);

dual_array #(.width(1)) valid_array //Check if our values are valid
(
	.clk(clk),
    .write_a(write_valid_if),
    .write_b(write_valid_mem),
    .index_a(pc_out[5:2]),
    .index_b(pc_mem[5:2]),
    .datain_a(1'b0), //If we update from IF, then that means we wrote over an entry and the target address is invalid.
    .datain_b(1'b1), //If we update from MEM, we fixed the target address so its now valid.
    .dataout_a(valid_out_a),
    .dataout_b(valid_out_b)
);

dual_array target_array
(
   .clk(clk),
   .write_a(1'b0), //Should be 0
   .write_b(write_target_mem),
   .index_a(pc_out[5:2]),
   .index_b(pc_mem[5:2]),
   .datain_a(32'b0), //Never write to target array in IF
   .datain_b(calculated_addr),
   .dataout_a(target_address),
   .dataout_b(target_mem) //Should never be used.
);

bht_datapath branch_history_table
(
	.clk(clk),
	.pc_out(pc_out), //The outputted pc in IF
	.pc_ex(pc_ex), //the PC in MEM
	.ex_opcode(ex_opcode), //ctrl_mem.opcode. Check if we have a branch in MEM.
	.br_en(br_en), //Our last branch
	.branch_prediction(br_prediction) //Outputs our prediction to the PC mux logic.
);

assign write_pc_if = (pc_out != pc_array_out) && ((if_opcode == op_br) || (if_opcode == op_jal) || (if_opcode == op_jalr));
assign write_valid_if = (pc_out != pc_array_out) && ((if_opcode == op_br) || (if_opcode == op_jal) || (if_opcode == op_jalr));
assign write_valid_mem = ((mem_opcode == op_br) || (mem_opcode == op_jal) || (mem_opcode == op_jalr)) && !valid_out_b;
assign write_target_mem = (!valid_out_b || (calculated_addr != target_mem)) && ((mem_opcode == op_br) || (mem_opcode == op_jal) || (mem_opcode == op_jalr));

always_comb//always_ff @(posedge clk) //Might need to be always_comb
begin
	if ((if_opcode == op_jal || if_opcode == op_jalr) && (pc_out == pc_array_out) && valid_out_a)
		branch_prediction = 1'b1;
	else if ((if_opcode == op_br && pc_out == pc_array_out) && valid_out_a)
		branch_prediction = br_prediction;
	else
		branch_prediction = 1'b0;
end


endmodule : btb_datapath
