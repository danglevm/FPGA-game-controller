`timescale 1ns/10ps
`include "../hdl/BINARY_TO_7SEG_DISPLAY.v"

module BINARY_TO_7SEG_DISPLAY_tb();

//Clock speed of 25MHz
//1s = 1e+9
//Period of 40ns

parameter c_PERIOD = 40;


/**************************
	WIRE DECLARATIONS
***************************/
reg r_CLK = 1'b0;
reg r_BINARY = 4'b0000;
integer i = 1'd0;

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

always
		#(c_PERIOD) r_CLK = !r_CLK;


initial
	begin
		//for loops perform differently from software languages and can be used in both synthesizable and non-synthesizable code
		//goes up to F, or the 15 limit for displaying on the 7 seg bit
		for (i = 0; i < 16; ++i) 
		begin
			r_BINARY = i;
			
			case (r_BINARY)
				4'b0000 : 
					begin
						if (w_SEG_0 && w_SEG_1 && w_SEG_2 && w_SEG_3 && w_SEG_4 && w_SEG_5 && ~w_SEG_6) $display("Pass 0");
						else $display("Fail 0");
					end	
				4'b0001 : 
					begin
						if (~w_SEG_0 && w_SEG_1 && w_SEG_2 && ~w_SEG_3 && ~w_SEG_4 && ~w_SEG_5 && ~w_SEG_6) $display("Pass 1");
						else $display("Fail 1");
					end
				4'b0010 : 
					begin
						if (w_SEG_0 && w_SEG_1 && ~w_SEG_2 && w_SEG_3 && w_SEG_4 && ~w_SEG_5 && w_SEG_6) $display("Pass 2");
						else $display("Fail 2");
					end
				4'b0011 :
					begin
						if (w_SEG_0 && w_SEG_1 && w_SEG_2 && w_SEG_3 && ~w_SEG_4 && ~w_SEG_5 && w_SEG_6) $display("Pass 3");
						else $display("Fail 3");
					end
				4'b0100 : 
					begin
						if (~w_SEG_0 && w_SEG_1 && w_SEG_2 && ~w_SEG_3 && ~w_SEG_4 && w_SEG_5 && w_SEG_6) $display("Pass 4");
						else $display("Fail 4");
					end
				4'b0101 : 
					begin
						if (w_SEG_0 && ~w_SEG_1 && w_SEG_2 && w_SEG_3 && ~w_SEG_4 && w_SEG_5 && w_SEG_6) $display("Pass 5");
						else $display("Fail 5");
					end
				4'b0110 : 
					begin
						if (w_SEG_0 && ~w_SEG_1 && w_SEG_2 && w_SEG_3 && w_SEG_4 && w_SEG_5 && w_SEG_6) $display("Pass 6");
						else $display("Fail 6");
					end
				4'b0111 : 
					begin
						if (w_SEG_0 && w_SEG_1 && w_SEG_2 && ~w_SEG_3 && ~w_SEG_4 && ~w_SEG_5 && ~w_SEG_6) $display("Pass 7");
						else $display("Fail 7");
					end
				4'b1000 : 
					begin
						if (w_SEG_0 && w_SEG_1 && w_SEG_2 && w_SEG_3 && w_SEG_4 && w_SEG_5 && w_SEG_6) $display("Pass 8");
						else $display("Fail 8");
					end
				4'b1001 : 
					begin
						if (w_SEG_0 && w_SEG_1 && w_SEG_2 && ~w_SEG_3 && ~w_SEG_4 && w_SEG_5 && w_SEG_6) $display("Pass 9");
						else $display("Fail 9");
					end
				4'b1010 : 
					begin
						if (w_SEG_0 && w_SEG_1 && w_SEG_2 && ~w_SEG_3 && w_SEG_4 && w_SEG_5 && w_SEG_6) $display("Pass 10/A");
						else $display("Fail 10/A");
					end
				4'b1011 : 
					begin
						if (~w_SEG_0 && ~w_SEG_1 && w_SEG_2 && w_SEG_3 && w_SEG_4 && w_SEG_5 && w_SEG_6) $display("Pass 11/b");
						else $display("Fail 11/b");
					end
				4'b1100 :
					begin
						if (w_SEG_0 && ~w_SEG_1 && ~w_SEG_2 && w_SEG_3 && w_SEG_4 && w_SEG_5 && w_SEG_6) $display("Pass 12/C");
						else $display("Fail 12/C");
					end
				4'b1101 : 
					begin
						if (~w_SEG_0 && w_SEG_1 && w_SEG_2 && w_SEG_3 && w_SEG_4 && ~w_SEG_5 && w_SEG_6) $display("Pass 13/d");
						else $display("Fail 13/d");
					end;
				4'b1110 : 
					begin
						if (w_SEG_0 && w_SEG_1 && w_SEG_2 && w_SEG_3 && ~w_SEG_4 && ~w_SEG_5 && w_SEG_6) $display("Pass 3");
						else $display("Fail 3");
					end
				4'b1111 : r_SEVEN_SEG <= 7'b1110001;
			endcase
		end
	end
	
endmodule


