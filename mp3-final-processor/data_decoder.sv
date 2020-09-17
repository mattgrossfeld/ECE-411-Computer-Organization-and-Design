import rv32i_types::*;

module data_decoder #(parameter width = 32)
(
	input logic [3:0] mem_byte_enable, //Which bytes datain a word we're writing over.
	input logic [4:0] offset, //Byte offset of the cache block
	input logic [width-1:0] mem_wdata, //The word that will be put into the data.
	input logic [255:0] datain,
	output logic [255:0] dataout
);


/*Where each word is datain the block:
1	[31:0]
2	[63:32]
3	[95:64]
4	[127:96]
5	[159:128] 
6	[191:160] 
7	[223:192] 
8	[255:224]
*/

always_comb
begin
	dataout = datain;
	case(offset[4:2]) //Chooses the word.
		3'b000: //First word
			begin
				if (mem_byte_enable[0]) //First byte
					dataout[7:0] = mem_wdata[7:0];
				if (mem_byte_enable[1])
					dataout[15:8] = mem_wdata[15:8]; //Second byte
				if (mem_byte_enable[2])
					dataout[23:16] = mem_wdata[23:16]; //Third byte
				if (mem_byte_enable[3])
					dataout[31:24] = mem_wdata[31:24]; //Fourth byte
			end
			
		3'b001: //Second word
			begin
				if (mem_byte_enable[0]) //First byte
					dataout[39:32] = mem_wdata[7:0];
				if (mem_byte_enable[1])
					dataout[47:40] = mem_wdata[15:8]; //Second byte
				if (mem_byte_enable[2])
					dataout[55:48] = mem_wdata[23:16]; //Third byte
				if (mem_byte_enable[3])
					dataout[63:56] = mem_wdata[31:24]; //Fourth byte
			end
			
		3'b010: //Third word
			begin
				if (mem_byte_enable[0]) //First byte
					dataout[71:64] = mem_wdata[7:0];
				if (mem_byte_enable[1])
					dataout[79:72] = mem_wdata[15:8]; //Second byte
				if (mem_byte_enable[2])
					dataout[87:80] = mem_wdata[23:16]; //Third byte
				if (mem_byte_enable[3])
					dataout[95:88] = mem_wdata[31:24]; //Fourth byte
			end
			
		3'b011: //Fourth word
			begin
				if (mem_byte_enable[0]) //First byte
					dataout[103:96] = mem_wdata[7:0];
				if (mem_byte_enable[1])
					dataout[111:104] = mem_wdata[15:8]; //Second byte
				if (mem_byte_enable[2])
					dataout[119:112] = mem_wdata[23:16]; //Third byte
				if (mem_byte_enable[3])
					dataout[127:120] = mem_wdata[31:24]; //Fourth byte
			end
			
		3'b100: //Fifth word
			begin
				if (mem_byte_enable[0]) //First byte
					dataout[135:128] = mem_wdata[7:0];
				if (mem_byte_enable[1])
					dataout[143:136] = mem_wdata[15:8]; //Second byte
				if (mem_byte_enable[2])
					dataout[151:144] = mem_wdata[23:16]; //Third byte
				if (mem_byte_enable[3])
					dataout[159:152] = mem_wdata[31:24]; //Fourth byte
			end
			
		3'b101: //Sixth word
			begin
				if (mem_byte_enable[0]) //First byte
					dataout[167:160] = mem_wdata[7:0];
				if (mem_byte_enable[1])
					dataout[175:168] = mem_wdata[15:8]; //Second byte
				if (mem_byte_enable[2])
					dataout[183:176] = mem_wdata[23:16]; //Third byte
				if (mem_byte_enable[3])
					dataout[191:184] = mem_wdata[31:24]; //Fourth byte
			end
			
		3'b110: //Seventh word
			begin
				if (mem_byte_enable[0]) //First byte
					dataout[199:192] = mem_wdata[7:0];
				if (mem_byte_enable[1])
					dataout[207:200] = mem_wdata[15:8]; //Second byte
				if (mem_byte_enable[2])
					dataout[215:208] = mem_wdata[23:16]; //Third byte
				if (mem_byte_enable[3])
					dataout[223:216] = mem_wdata[31:24]; //Fourth byte
			end
			
		3'b111: //Eighth word
			begin
				if (mem_byte_enable[0]) //First byte
					dataout[231:224] = mem_wdata[7:0];
				if (mem_byte_enable[1])
					dataout[239:232] = mem_wdata[15:8]; //Second byte
				if (mem_byte_enable[2])
					dataout[247:240] = mem_wdata[23:16]; //Third byte
				if (mem_byte_enable[3])
					dataout[255:248] = mem_wdata[31:24]; //Fourth byte
			end
			
		default: /*Do Nothing*/ ;
	endcase
end

endmodule : data_decoder
