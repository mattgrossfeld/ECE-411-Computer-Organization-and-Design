//import rv32i_types::*; /* Import types defined in rv32i_types.sv */

module cache_L2_control
(
	output logic [1:0] counter_pick,
    /* Input and output port declarations */
	input clk,
	/* Datapath controls */
	input logic hit0,	//For tracking hits from way 0
	input logic hit1, //For tracking hits from way 1
	
	output logic write_data0, //Write signal data0
	output logic write_data1, //Write signal data1
	output logic write_tag0,	//Write signal
	output logic write_tag1,	//Write signal
	output logic write_dirty0,	//Write Signal
	output logic write_dirty1,	//Write Signal
	output logic write_valid0, //Write Signal
	output logic write_valid1,	//Write Signal
	output logic write_lru,		//Write signal
	
	input logic valid0,					//The current valid0
	input logic valid1,					//The current valid1
	output logic valid0_out,			//The input to valid0
	output logic valid1_out,			//The input to valid1
	
	input logic dirty0,					//The current dirty0
	input logic dirty1,					//The current dirty1
	output logic dirty0_out,			//The input to dirty0
	output logic dirty1_out,			//The input to dirty1
		
	input logic lru,						//The current LRU value
	output logic lru_out,				//The input to LRU
	
	output logic [1:0] addr_mux_sel,			// Select signal for the address mux
	output logic datainmux_sel,		//Select signal for choosing input to data arrays
	
	/* Memory inputs and outputs */
	input logic mem_read,
	input logic mem_write,
	//input logic [3:0] mem_byte_enable,
	output logic mem_resp,
	
	input logic pmem_resp,
	output logic pmem_read,
	output logic pmem_write
	);

enum int unsigned {
    /* List of states */
	idle_action,
	writeback,
	allocate
} state, next_state;

always_comb
begin : state_actions
    /* Default output assignments */
		dirty0_out = 1'b0;
		dirty1_out = 1'b0;
		valid0_out = 1'b0;
		valid1_out = 1'b0;
		lru_out = 1'b0;
		write_data0 = 1'b0;
		write_data1 = 1'b0;
		write_tag0 = 1'b0;	
		write_tag1 = 1'b0;	
		write_dirty0 = 1'b0;	
		write_dirty1 = 1'b0;	
		write_valid0 = 1'b0; 
		write_valid1 = 1'b0;	
		write_lru = 1'b0;
		mem_resp = 1'b0;
		pmem_write = 1'b0;
		pmem_read = 1'b0;
		addr_mux_sel = 2'b00;
		datainmux_sel = 1'b0;
    /* Actions for each state */
	 case(state)
		idle_action: 
		begin
			if ((hit0 || hit1) && mem_read) //If we get a hit and read.
				begin
					mem_resp = 1'b1; //We got the read signal successfully.
					write_lru = 1'b1; //Change the LRU to reflect the read operation.
					if (hit0)
						lru_out = 1'b1;
					if (hit1)
						lru_out = 1'b0;
				end
			else if ((hit0 || hit1) && mem_write)
				begin
					if (hit0 && valid0) //If way 0 is valid and we got a hit from there
						begin
							mem_resp = 1'b1; //We got the write signal.
							write_lru = 1'b1; //Change the LRU bit
							datainmux_sel = 1'b1;
							write_data0 = 1'b1;
							write_dirty0 = 1'b1;
							write_tag0 = 1'b1;
							//write_valid0 = 1'b1;
						end
					if (hit1 && valid1) //If way 1 is valid and we got a hit from there
						begin
							mem_resp = 1'b1; //We got the write signal.
							write_lru = 1'b1; //Change the LRU bit
							datainmux_sel = 1'b1;
							write_data1 = 1'b1;
							write_dirty1 = 1'b1;
							write_tag1 = 1'b1;
							//write_valid1 = 1'b1;
						end
				end
		end
		
		writeback: //For writing.
		begin
			case (lru) //If way 0 was least recently used.
				1'b0:	
				begin
					pmem_write = 1'b1;
					addr_mux_sel = 2'b01;
				end
				
				1'b1:
				begin
					pmem_write = 1'b1;
					addr_mux_sel = 2'b10;
				end
			endcase
		end
		
		allocate: 
		begin
			pmem_read = 1'b1;
			if (pmem_resp) begin
				if (!lru) //If LRU way is way 0.
					begin
						//pmem_read = 1'b1; //Read from physical memory.
						addr_mux_sel = 2'b00; //pmem_address = mem_address.
						write_valid0 = pmem_resp; //1'b1;
						valid0_out = 1'b1;
						write_data0 = pmem_resp; //1'b1;
						write_tag0 = pmem_resp; //1'b1;
						write_dirty0 = pmem_resp; //1'b1;
						dirty0_out = 1'b0;
					end
				
				else if (lru) //If LRU way is way 1.
					begin
						//pmem_read = 1'b1; //Read from physical memory.
						addr_mux_sel = 2'b00; //pmem_address = mem_address.
						write_valid1 = pmem_resp; //1'b1;
						valid1_out = 1'b1;
						write_data1 = pmem_resp; //1'b1;
						write_tag1 = pmem_resp; //1'b1;
						write_dirty1 = pmem_resp; //1'b1;
						dirty1_out = 1'b0;
					end
			end
		end	
	
		default: /* Do nothing */;
	endcase

end

always_comb
begin : next_state_logic
    /* Next state information and conditions (if any)
     * for transitioning between states */
		next_state = state;
		case(state)
			idle_action:
			begin
				if ((mem_read || mem_write) && (!hit0 && !hit1) && (!dirty0 && !dirty1)) //If we miss (hit1, hit0 are both 0)
				begin
					counter_pick = 1;
					next_state = allocate; //The write-back policy
				end
				else if ((mem_read || mem_write) && (!hit0 && !hit1) && (dirty0 || dirty1)) //If we get a miss but we have dirty blocks
				begin
					counter_pick = 1;
					next_state = writeback; //For lazy-writes.
				end
				else
				begin
					counter_pick = 0;
					next_state = idle_action;
				end
			end
			
			writeback:
			begin
				counter_pick = 2;
				if (!pmem_resp)
					next_state = writeback;
				else
					next_state = allocate;
			end
			
			allocate:
			begin
				counter_pick = 1;
				if (!pmem_resp) //If physical memory hasnt given us a response, stay in allocate state
					next_state = allocate;
				else
					next_state = idle_action;
			end
			
		default: 
		begin
			counter_pick = 3;
			next_state = idle_action;
		end
	endcase

end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
	 state <= next_state;
end

endmodule : cache_L2_control
