module history_array #(parameter width = 4)
(
	input clk,
	input logic write, //Write on branch in MEM
	input logic br_en, //The latest branch from MEM stage
	input logic [3:0] index_a, //The index we need to check for our prediction in IF
	input logic [3:0] index_b, //The index we need for updating our history.

	output logic [width-1:0] br_history_a, //Our history to be XOR'd with the pc_out[5:2] so we can get our predicted value and send it to the BTB.
	output logic [width-1:0] br_history_b //Last four branches taken. XOR'd with pc_mem[5:2] so we can update prediction with the history.
);

logic [width-1:0] data [15:0];

initial
begin
    for (int i = 0; i < $size(data); i++)
    begin
        data[i] = 1'b0; //Initialize our history to all NT.
    end
end

always_ff @(posedge clk)
begin
	if (write) //If we can write to the branch
		data[index_b] = (data[index_b] << 1) | br_en; //Shift the bits by one. Then add the branch as last bit.
end

assign br_history_a = data[index_a];
assign br_history_b = data[index_b];

endmodule : history_array