import rv32i_types::*;

module bht_datapath
(
	input clk,
	input rv32i_word pc_out, //The outputted pc in IF
	input rv32i_word pc_ex, //the PC in MEM
	input rv32i_opcode ex_opcode, //ctrl_mem.opcode. Check if we have a branch in MEM.
	input logic br_en, //Our last branch
	output logic branch_prediction //Outputs our prediction to the PC mux logic.
);

logic br_prediction; //In-between logic for holding our branch prediction

logic [3:0] br_history_a;
logic [3:0] br_history_b; 

assign branch_prediction = br_prediction;

/*history_array br_history_array
(
	 .clk(clk),
    .write(ex_opcode == op_br || ex_opcode == op_jal || ex_opcode == op_jalr),
    .br_en(br_en), //datain  
    .index_a(pc_out[5:2]),
    .index_b(pc_ex[5:2]),
    .br_history_a(br_history_a), //dataout
    .br_history_b(br_history_b)
);
*/
predictor_array predict_array
(
	.clk(clk),
	.write(ex_opcode == op_br || ex_opcode == op_jal || ex_opcode == op_jalr), //Write if ex_opcode == op_br
	.br_en(br_en), //Update the prediction with the latest branch.
	.index_a(pc_out[5:2]), //Will be from IF.
	.index_b(pc_ex[5:2]), //Will be from EX.
	.br_prediction(br_prediction) //Outputs our prediction based on the count. Used in IF to use outputted prediction.
);

endmodule : bht_datapath