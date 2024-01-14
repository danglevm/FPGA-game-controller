module BINARY_TO_7SEG_DISPLAY (
	input [3:0] i_BINARY,
	output reg [6:0] o_SEVEN_SEG
);


always @ (i_BINARY) begin
	case (i_BINARY)
	//6543210
	0  : o_SEVEN_SEG = 7'b0111111; //0
	1  : o_SEVEN_SEG = 7'b0000110; //1
	2  : o_SEVEN_SEG = 7'b1011011; //2
	3  : o_SEVEN_SEG = 7'b1001111; //3
	4  : o_SEVEN_SEG = 7'b1100110; //4
	5  : o_SEVEN_SEG = 7'b1101101; //5
	6  : o_SEVEN_SEG = 7'b1111101; //6
	7  : o_SEVEN_SEG = 7'b0000111; //7
	8  : o_SEVEN_SEG = 7'b1111111; //8
	9  : o_SEVEN_SEG = 7'b1100111; //9
	10 : o_SEVEN_SEG = 7'b1110111; //10
	11 : o_SEVEN_SEG = 7'b1111100; //11
	12 : o_SEVEN_SEG = 7'b0111001; //12
	13 : o_SEVEN_SEG = 7'b1011110; //13
	14 : o_SEVEN_SEG = 7'b1111001; //14
	15 : o_SEVEN_SEG = 7'b1110001; //15
	default: o_SEVEN_SEG = 7'b0000000; //no display
	endcase
end



endmodule
