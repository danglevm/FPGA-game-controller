module BINARY_TO_7SEG_DISPLAY (
	input i_CLK,
	input [3:0] i_BINARY,
	output o_SEG_0,
	output o_SEG_1,
	output o_SEG_2,
	output o_SEG_3,
	output o_SEG_4,
	output o_SEG_5,
	output o_SEG_6
);

reg [6:0] r_SEVEN_SEG = 7'b0000000;


always @ (posedge i_CLK) begin
	case (i_BINARY)
	4'b0000 : r_SEVEN_SEG <= 7'b0111111;
	4'b0001 : r_SEVEN_SEG <= 7'b0000110;
	4'b0010 : r_SEVEN_SEG <= 7'b1011011;
	4'b0011 : r_SEVEN_SEG <= 7'b1001111;
	4'b0100 : r_SEVEN_SEG <= 7'b1100110;
	4'b0101 : r_SEVEN_SEG <= 7'b1101101;
	4'b0110 : r_SEVEN_SEG <= 7'b1111101;
	4'b0111 : r_SEVEN_SEG <= 7'b0000111;
	4'b1000 : r_SEVEN_SEG <= 7'b1111111;
	4'b1001 : r_SEVEN_SEG <= 7'b1100111;
	4'b1010 : r_SEVEN_SEG <= 7'b1110111;
	4'b1011 : r_SEVEN_SEG <= 7'b1111100;
	4'b1100 : r_SEVEN_SEG <= 7'b1011000;
	4'b1101 : r_SEVEN_SEG <= 7'b1011110;
	4'b1110 : r_SEVEN_SEG <= 7'b1111001;
	4'b1111 : r_SEVEN_SEG <= 7'b1110001;
	
	endcase
end

assign o_SEG_6 = r_SEVEN_SEG[6];
assign o_SEG_5 = r_SEVEN_SEG[5];
assign o_SEG_4 = r_SEVEN_SEG[4];
assign o_SEG_3 = r_SEVEN_SEG[3];
assign o_SEG_2 = r_SEVEN_SEG[2];
assign o_SEG_1 = r_SEVEN_SEG[1];
assign o_SEG_0 = r_SEVEN_SEG[0];

endmodule
