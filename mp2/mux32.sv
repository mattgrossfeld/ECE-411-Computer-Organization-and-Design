module word_mux #(parameter width = 32)
(
input [4:0] sel,
input [width-1:0] a, b, c, d, e, f, g, h,
output logic [width-1:0] out
);
always_comb
begin
	if (sel == 1'b00000) //0
		out = a;
	else if (sel == 1'b00001) //1
		out = a;
	else if (sel == 00010) //2
		out = a;
	else if (sel == 00011) //3
		out = a;
	else if (sel == 00100) //4
		out = b;
	else if (sel == 00101) //5
		out = b;
	else if (sel == 00110) //6
		out = b;
	else if (sel == 00111) //7
		out = b;
	else if (sel == 01000) //8
		out = c;
	else if (sel == 01001) //9
		out = c;
	else if (sel == 01010) //10
		out = c;
	else if (sel == 01011) //11
		out = c;
	else if (sel == 01100) //12
		out = d;
	else if (sel == 01101) //13
		out = d;
	else if (sel == 01110) //14
		out = d;
	else if (sel == 01111) //15
		out = d;
	else if (sel == 10000) //16
		out = e;
	else if (sel == 10001) //17
		out = e;
	else if (sel == 10010) //18
		out = e;
	else if (sel == 10011) //19
		out = e;
	else if (sel == 10100) //20
		out = f;
	else if (sel == 10101) //21
		out = f;
	else if (sel == 10110) //22
		out = f;
	else if (sel == 10111) //23
		out = f;
	else if (sel == 11000) //24
		out = g;
	else if (sel == 11001) //25
		out = g;
	else if (sel == 11010) //26
		out = g;
	else if (sel == 11011) //27
		out = g;
	else if (sel == 11100) //28
		out = h;
	else if (sel == 11101) //29
		out = h;
	else if (sel == 11110) //30
		out = h;
	else //31
		out = h;

end
endmodule : word_mux