module predictor_array
(
	input clk,
	input logic write, //Write if mem_opcode == op_br
	input logic br_en, //Update the prediction with the latest branch.
	input logic [3:0] index_a, //Will be from IF.
	input logic [3:0] index_b, //Will be from MEM.
	output logic br_prediction //Outputs our prediction based on the count
);

logic [1:0] data [15:0];
logic prediction [15:0];

initial
begin
	for (int i = 0; i < $size(data); i++)
	begin
		prediction[i] = 1'b0;
		data[i] = 2'b01; //Weak not taken initially.
	end
end

always_ff @(posedge clk)
begin
	if (write)
	begin
		case (data[index_b])
			2'b00: //Strong NT
			begin
				prediction[index_b] <= 1'b0;
				if (br_en)
					data[index_b] <= 2'b01; //Weak NT
				else
					data[index_b] <= 2'b00; //Strong NT
			end
			
			2'b01: //Weak NT
			begin
				prediction[index_b] <= 1'b0;
				if (br_en)
					data[index_b] <= 2'b10; //Weak T
				else
					data[index_b] <= 2'b00; //Strong NT
			end
			
			2'b10: //Weak T
			begin
				prediction[index_b] <= 1'b1;
				if (br_en)
					data[index_b] <= 2'b11;
				else
					data[index_b] <= 2'b01;
			end

			2'b11: //Strong T
			begin
				prediction[index_b] <= 1'b1;
				if (br_en)
					data[index_b] <= 2'b11;
				else
					data[index_b] <= 2'b10;
			end
		endcase
	end
end

assign br_prediction = prediction[index_a];

endmodule : predictor_array
