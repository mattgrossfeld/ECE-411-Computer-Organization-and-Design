import rv32i_types::*;

module if_id(
    input clk,		//Clk
    input load,	//Load in values
	 input clear, //Clears the entire register. Sets everything to zero
//	 input rv32i_control_word control_word_in, //CONTROL WORD PASSES THROUGH EVERY STAGE
	 input logic [31:0] read_data_in, //THIS IS THE INSTRUCTION
	 input logic [31:0] pc_in,
	 input logic prediction_if,
	 
//	 output rv32i_control_word control_word_out,
	 output logic [31:0] pc_out,
	 output rv32i_reg rs1,
	 output rv32i_reg rs2,
	 output rv32i_reg rd,
	 output rv32i_word u_imm, 
	 output rv32i_word b_imm, 
	 output rv32i_word s_imm, 
	 output rv32i_word j_imm,
	 output rv32i_word i_imm,
	 output rv32i_opcode opcode,
	 output logic [2:0] funct3,
	 output logic [6:0] funct7,
	 output logic prediction_id
);

logic [31:0] data;
logic [31:0] pc;
logic prediction;

assign prediction_id = prediction;
assign pc_out = pc;
assign funct3 = data[14:12];
assign funct7 = data[31:25];
assign opcode = rv32i_opcode'(data[6:0]);
assign i_imm = {{21{data[31]}}, data[30:20]};
assign s_imm = {{21{data[31]}}, data[30:25], data[11:7]};
assign b_imm = {{20{data[31]}}, data[7], data[30:25], data[11:8], 1'b0};
assign u_imm = {data[31:12], 12'h000};
assign j_imm = {{12{data[31]}}, data[19:12], data[20], data[30:21], 1'b0};
assign rs1 = data[19:15];
assign rs2 = data[24:20];
assign rd = data[11:7];

always_ff @(posedge clk)
begin
    if (clear)
		begin
        data <= 0;
		  pc <= pc_in;
		  prediction <= prediction_if; 
		end
	 
	 else if (load) //Load will be mem_resp from instruction memory
		begin
			data <= read_data_in;
			pc <= pc_in;
			prediction <= prediction_if;
		end
end


endmodule : if_id