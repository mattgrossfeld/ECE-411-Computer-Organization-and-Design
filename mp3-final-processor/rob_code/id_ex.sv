import rv32i_types::*;

module id_ex(
   input clk,		//Clk
   input load,	//Load in values
	input clear, //Clears the entire register. Sets everything to zero
	input rv32i_control_word control_word_in, //CONTROL WORD PASSES THROUGH EVERY STAGE
	input logic [31:0] pc_in,	//Need pc
	input rv32i_reg rd_in,		//Push rd through
	input rv32i_word u_imm_in,
	input rv32i_word b_imm_in,
	input rv32i_word s_imm_in,
	input rv32i_word j_imm_in,
	input rv32i_word i_imm_in,
	input rv32i_word rs1_data_in,
	input rv32i_word rs2_data_in,
  input cmp_data_in,

	output logic [31:0] pc_out,
	output rv32i_control_word control_word_out, //CONTROL WORD PASSES THROUGH EVERY STAGE
	output rv32i_word rs1_data_out,
	output rv32i_word rs2_data_out,
	output rv32i_reg rd_out,
	output rv32i_word u_imm_out,
	output rv32i_word b_imm_out,
	output rv32i_word s_imm_out,
	output rv32i_word j_imm_out,
	output rv32i_word i_imm_out,
  output logic cmp_data_out
);

logic [31:0] pc;
rv32i_word i_imm;
rv32i_word s_imm;
rv32i_word b_imm;
rv32i_word u_imm;
rv32i_word j_imm;
rv32i_word rs1_data;
rv32i_word rs2_data;
logic [4:0] rd;
logic cmp;

assign pc_out = pc;
assign i_imm_out = i_imm;
assign s_imm_out = s_imm;
assign b_imm_out = b_imm;
assign u_imm_out = u_imm;
assign j_imm_out = j_imm;
assign rs1_data_out = rs1_data;
assign rs2_data_out = rs2_data;
assign rd_out = rd;
assign cmp_data_out = cmp;

always_ff @(posedge clk)
begin
    if (clear)
		begin
        	control_word_out <= 0;
        	i_imm <= 0;
        	s_imm <= 0;
        	b_imm <= 0;
        	u_imm <= 0;
        	j_imm <= 0;
        	rs1_data <= 0;
        	rs2_data <= 0;
        	rd <= rd_in;
			    pc <= pc_in;
          cmp <= 0;
		end

	 else if (load) //Load will be mem_resp from instruction memory
		begin
			control_word_out <= control_word_in;
			pc <= pc_in;
			i_imm <= i_imm_in;
			s_imm <= s_imm_in;
			b_imm <= b_imm_in;
			u_imm <= u_imm_in;
			j_imm <= j_imm_in;
			rs1_data <= rs1_data_in;
			rs2_data <= rs2_data_in;
			rd <= rd_in;
      cmp <= cmp_data_in;
		end
end


endmodule : id_ex
