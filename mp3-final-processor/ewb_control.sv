import rv32i_types::*;

module ewb_control
(
	input clk,
	input logic hit,
	input logic write_ewb, read_ewb,
	input logic pmem_resp,
	output logic read_entry, write_entry, entry_written, 
	output logic ewb_resp,
	output logic pmem_read, pmem_write
);

enum int unsigned {
    /* List of states */
	read_mem,
	ewb_stall,
	ewb_idle,
	ewb_ready
} state, next_state;

always_comb
begin : state_actions
	/* Default Assignments */
	read_entry = 1'b1;
	write_entry = 1'b0;
	entry_written = 1'b0;
	ewb_resp = 1'b0;
	pmem_read = 1'b0;
	pmem_write = 1'b0;
	
	case(state)
		read_mem:
		begin
			if (pmem_resp)
			begin
				ewb_resp = 1'b1; //We have a response
				pmem_read = 1'b1; //We are ready to read.
			end
			
			else
				pmem_read = 1'b1; ///Still ready to read.
		end
		
		ewb_stall:
		begin
			entry_written = 1'b1; //Stall so we can write to memory
			pmem_write = 1'b1; //Write signal set.
		end
		
		ewb_idle:
		begin
			if (read_ewb && hit) //Don't read the entry.
			begin
				ewb_resp = 1'b1;
				read_entry = 1'b0;
			end
			else if (write_ewb) //Write to the entry.
			begin
				ewb_resp = 1'b1;
				write_entry = 1'b1;
			end
		end
		
		ewb_ready:
		begin
			if (hit && read_ewb)
				read_entry = 1'b0;
			else
				read_entry = 1'b1;
		end
		
		default: ; //Default values for default.
	endcase
	
end

always_comb
begin : next_state_logic
	next_state = state;
	case(state)
		read_mem:
		begin
			if (pmem_resp)
				next_state = ewb_ready; //Memory read. Now we are ready to finish up the process.
		end
		
		ewb_stall:
		begin
			if (pmem_resp)
				next_state = ewb_idle; //Stall one cycle so we go to idle next.
		end
		
		ewb_idle:
		begin
			if (write_ewb || (read_ewb && hit)) //Write or read with hit, we're ready to use ewb
				next_state = ewb_ready;
			else if (read_ewb && !hit) //Miss so we need to read
				next_state = read_mem;
		end
		
		ewb_ready:
		begin
			if (write_ewb || (read_ewb && hit)) //Similar to idle, but now we go to stall.
				next_state = ewb_stall;
			else
				next_state = ewb_idle;
		end
		
		default: next_state = ewb_idle; //By default, just let it sit idle.
	endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
	 state <= next_state;
end

endmodule : ewb_control