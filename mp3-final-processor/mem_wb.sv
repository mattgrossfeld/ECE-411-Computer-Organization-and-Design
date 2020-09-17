import rv32i_types::*;

module mem_wb
(
   input clk,		//Clk
   input load,	//Load in values
	input clear, //Clears the entire register. Sets everything to zero
	input rv32i_control_word control_word_in, //CONTROL WORD PASSES THROUGH EVERY STAGE
	input resp_b_in,
	input rv32i_reg rd_in,		//Push rd through
	input rv32i_word mem_rdata_in,
	input rv32i_word alu_data_in,
	input rv32i_word u_mem,
	input br_en,
	input logic [31:0] pc_mem,
	output logic [31:0] pc_wb,
	output rv32i_word br_en_zext,
	output rv32i_word u_wb,
	output rv32i_control_word control_word_out, //CONTROL WORD PASSES THROUGH EVERY STAGE
	output resp_b_out,
	output rv32i_reg rd_out,		//Push rd through
	output rv32i_word mem_rdata_out,
	output rv32i_word alu_data_out
);

rv32i_control_word control_word;
logic resp_b;
rv32i_reg rd;
rv32i_word mem_rdata;
rv32i_word alu_data;
rv32i_word u_imm;
logic [31:0] pc;

assign pc_wb = pc;
assign control_word_out = control_word;
assign resp_b_out = resp_b;
assign rd_out = rd;
assign mem_rdata_out = mem_rdata;
assign alu_data_out = alu_data;
assign u_wb = u_imm;
assign br_en_zext = {31'h00000000, br_en};

always_ff @(posedge clk)
begin
    if (clear)
		begin
        	control_word <= 0;
        	resp_b <= 0;
        	mem_rdata <= 0;
        	rd <= rd_in;
			alu_data <= 0;
			u_imm <= 0;
			pc <= pc_mem;
		end
	 
	 else if (load) //Load will be mem_resp from instruction memory
		begin
			control_word <= control_word_in;
        	resp_b <= resp_b_in;
        	mem_rdata <= mem_rdata_in;
        	rd <= rd_in;
			alu_data <= alu_data_in;
			u_imm <= u_mem;
			pc <= pc_mem;
		end
end


endmodule : mem_wb
