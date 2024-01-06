`timescale 1ns/1ps

module BINARY_TO_7SEG_DISPLAY_tb();

reg r_CLK = 1'b0;
reg r_BINARY = 4'b0000;
integer i 0;

wire w_SEG_0;
wire w_SEG_1;
wire w_SEG_2;
wire w_SEG_3;
wire w_SEG_4;
wire w_SEG_5;
wire w_SEG_6;


BINARY_TO_7SEG_DISPLAY UUT (
	.i_CLK (r_CLK),
	.i_BINARY(r_BINARY),
	.o_SEG_0 (w_SEG_0),
	.o_SEG_1 (w_SEG_1),
	.o_SEG_2 (w_SEG_2),
	.o_SEG_3 (w_SEG_3),
	.o_SEG_4 (w_SEG_4),
	.o_SEG_5 (w_SEG_5),
	.o_SEG_6 (w_SEG_6)
);

initial 
	begin
		forever
			#20 r_CLK = !r_CLK;
	end


initial
	begin
		//for loops perform differently from software languages and can be used in both synthesizable and non-synthesizable code
		for (i = 0; i < 16; ++i) 
		begin
			r_BINARY = i;
		end
	end
	
endmodule


