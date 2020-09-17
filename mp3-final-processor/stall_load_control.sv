import rv32i_types::*;

module stall_load_control
(
	input logic icache_resp,
	input logic dcache_resp,
	input logic d_write,
	input logic d_read,
	input logic stall_for_load,
	input logic eb_stall_for_load,
	input logic ex_prediction,
	input logic mem_prediction,
	input logic [31:0] pc_ex,
	input logic [31:0] pc_mem,
	input logic [31:0] pc_wb,
	input logic cmpout,
	input br_en,
	input rv32i_control_word ctrl_mem,
	input rv32i_opcode ex_opcode,
	output logic load_pc,
	output logic load_if_id,
	output logic load_id_ex,
	output logic load_ex_mem,
	output logic load_mem_wb,
	output logic load_count,
	output logic clear_ex_mem,
	output logic clear_id_ex
);

always_comb
begin
	load_pc = 1;
	load_if_id = 1;
	load_id_ex = 1;
	load_ex_mem = 1;
	load_mem_wb = 1;
	load_count = 1;
	clear_ex_mem = (br_en && !mem_prediction) && (ctrl_mem.opcode == op_br || ctrl_mem.opcode == op_jal || ctrl_mem.opcode == op_jalr);
	clear_id_ex = (!cmpout && ex_prediction) && (ex_opcode == op_br || ex_opcode == op_jal || ex_opcode == op_jalr);

	/* STALL for icache */
	if (!icache_resp) begin
		load_pc = 0;
		load_if_id = 0;
		load_id_ex = 0;
		load_ex_mem = 0;
		load_mem_wb = 0;
		load_count = 0;
	end
	/* STALL for dcache */
	else if ((d_write || d_read) && !dcache_resp) begin
		load_pc = 0;
		load_if_id = 0;
		load_id_ex = 0;
		load_ex_mem = 0;
		load_mem_wb = 0;
		load_count = 0;
	end
	else if ((pc_ex == pc_mem) && eb_stall_for_load) begin
		clear_id_ex = 1'b1;
	end
	//if icache and dcache have responded,
	//and we were stalling for load: clear ex_mem
	else if ((pc_mem == pc_wb) && stall_for_load) begin
		clear_ex_mem = 1'b1;
	end

	/* if stalling for load in MEM stage, stall only previous stages */
	if (stall_for_load) begin
		load_pc = 0;
		load_if_id = 0;
		load_id_ex = 0;
		load_ex_mem = 0;
	end

	if (eb_stall_for_load) begin
		load_pc = 0;
		load_if_id = 0;
		load_id_ex = 0;
	end

	// when next pc is from branch and not icache
	// load pc immediately
	if ((br_en && !mem_prediction) && (ctrl_mem.opcode == op_br || ctrl_mem.opcode == op_jal || ctrl_mem.opcode == op_jalr))
		load_pc = 1'b1; //T but predicted NT. PC = alu_mem.
	else if ((!cmpout && ex_prediction) && (ex_opcode == op_br || ex_opcode == op_jal || ex_opcode == op_jalr))
		load_pc = 1'b1; //NT but predicted T. Then PC = PC_EX + 4
end

endmodule : stall_load_control
