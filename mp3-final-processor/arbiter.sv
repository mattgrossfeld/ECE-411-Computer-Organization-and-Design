import rv32i_types::*;

module arbiter
(
	input clk,
	
	// L1 instr
	output logic pmem_resp_i,
	output logic [255:0] pmem_rdata_i,
	
	input logic pmem_read_i,
	input logic pmem_write_i,
	input rv32i_word pmem_address_i,
	input logic [255:0] pmem_wdata_i,
	
	// L1 data
	output logic pmem_resp_d,
	output logic [255:0] pmem_rdata_d,
	
	input logic pmem_read_d,
	input logic pmem_write_d,
	input rv32i_word pmem_address_d,
	input logic [255:0] pmem_wdata_d,
	
	// L2
	output rv32i_word mem_address_out,
	output logic mem_read_out,
	output logic mem_write_out,
	output logic [255:0] mem_wdata_out,
	
	input [255:0] mem_rdata_out,
	input mem_resp_out
);

enum int unsigned {
    /* List of states */
	s_1,
	s_2
} state, next_state;

always_comb
begin : state_actions
	// initialize L2 cache to read/write L1 instr cache
	mem_address_out = pmem_address_i;
	mem_read_out = pmem_read_i;
	mem_write_out = pmem_write_d;
	mem_wdata_out = pmem_wdata_d;
	pmem_rdata_i = mem_rdata_out;
	pmem_resp_i = mem_resp_out;
	pmem_rdata_d = 0;
	pmem_resp_d = 0;
	
	case(state)
		s_1:
		begin
			if (pmem_read_d || pmem_write_d)
			begin
				mem_address_out = pmem_address_d;
				mem_read_out = pmem_read_d;
				mem_write_out = pmem_write_d;
				mem_wdata_out = pmem_wdata_d;
				pmem_rdata_d = mem_rdata_out;
				pmem_resp_d = mem_resp_out;
				pmem_resp_i = 0;
				pmem_rdata_i = 0;
			end
		end
		
		s_2:
		begin
			if (pmem_read_i || pmem_write_i)
				begin
					mem_address_out = pmem_address_i;
					mem_read_out = pmem_read_i;
					mem_write_out = pmem_write_i;
					mem_wdata_out = pmem_wdata_i;
					pmem_rdata_i = mem_rdata_out;
					pmem_resp_i = mem_resp_out;
					pmem_rdata_d = 0;
					pmem_resp_d = 0;
				end
		end
		default: ;
	endcase
	
end

always_comb
begin : next_state_logic
	next_state = state;
	case(state)
		s_1:
		begin
			if (pmem_read_d || pmem_write_d)
			begin
				if(mem_resp_out) 
					next_state = s_2;
				else
					next_state = s_1;
			end
			else //if (pmem_read_i)
			begin
				next_state = s_2;
			end
		/*		if(mem_resp_out) 
					next_state = s_1;
		*/
		end
		
		s_2:
		begin
			if (pmem_read_i)
			begin
				if(mem_resp_out) 
					next_state = s_2;
				else
					next_state = s_2;
			end
			if (pmem_read_d || pmem_write_d)
				next_state = s_1;
		end
		
		default: next_state = s_2;
	endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
	 state <= next_state;
end

endmodule : arbiter