`timescale 1ns/10ps
`include "../hdl/BINARY_TO_7SEG_DISPLAY.v"

module BINARY_TO_7SEG_DISPLAY_tb();

//Clock speed of 25MHz
//1s = 1e+9
//Period of 40ns
//half clock cycle of 20ns

//parameter c_PERIOD = 40;


/**************************
	WIRE DECLARATIONS
***************************/
//reg r_CLK = 1'b0;
reg [3:0] r_BINARY = 4'b0000;
integer i = 0;

wire [6:0] w_SEVEN_SEG;


BINARY_TO_7SEG_DISPLAY UUT (
	.i_BINARY(r_BINARY),
	.o_SEVEN_SEG (w_SEVEN_SEG)
);

//always
	//	#(c_PERIOD/2) r_CLK = !r_CLK;


initial
	begin
		//for loops perform differently from software languages and can be used in both synthesizable and non-synthesizable code
		//goes up to F, or the 15 limit for displaying on the 7 seg bit
		for (i = 0; i < 16; i = i + 1) 
		begin
			r_BINARY = i;
			#40;
			
			case (r_BINARY)
				0 : 
					begin
						r_BINARY = 4'b0000;
						if (w_SEVEN_SEG == 7'b0111111) $display("Pass 0");
						else $display("Fail 0");
					end	
				1 : 
					begin
						r_BINARY = 4'b0001;
						if (w_SEVEN_SEG == 7'b0000110) $display("Pass 1");
						else $display("Fail 1");
					end
				2 : //2
					begin
						r_BINARY = 4'b0010;
						if (w_SEVEN_SEG == 7'b1011011) $display("Pass 2");
						else $display("Fail 2");
					end
				3 : //3
					begin
						r_BINARY = 4'b0011;
						if (w_SEVEN_SEG == 7'b1001111) $display("Pass 3");
						else $display("Fail 3");
					end
				4 : //4
					begin
						r_BINARY = 4'b0100;
						if (w_SEVEN_SEG == 7'b1100110) $display("Pass 4");
						else $display("Fail 4");
					end
				5 : //5
					begin
						r_BINARY = 4'b0101;
						if (w_SEVEN_SEG == 7'b1101101) $display("Pass 5");
						else $display("Fail 5");
					end
				6 : //6
					begin
						r_BINARY = 4'b0110;
						if (w_SEVEN_SEG == 7'b1111101) $display("Pass 6");
						else $display("Fail 6");
					end
				7 : //7
					begin
						r_BINARY = 4'b0111;
						if (w_SEVEN_SEG == 7'b0000111) $display("Pass 7");
						else $display("Fail 7");
					end
				8 : //8
					begin
						r_BINARY = 4'b1000;
						if (w_SEVEN_SEG == 7'b1111111) $display("Pass 8");
						else $display("Fail 8");
					end
				9 : //9
					begin
						r_BINARY = 4'b1001;
						if (w_SEVEN_SEG == 7'b1100111) $display("Pass 9");
						else $display("Fail 9");
					end
				10 : //10
					begin
						r_BINARY = 4'b1010;
						if (w_SEVEN_SEG == 7'b1110111) $display("Pass 10/A");
						else $display("Fail 10/A");
					end
				11 : //11
					begin
						r_BINARY = 4'b1011;
						if (w_SEVEN_SEG == 7'b1111100) $display("Pass 11/b");
						else $display("Fail 11/b");
					end
				12 : //12
					begin
						r_BINARY = 4'b1100;
						if (w_SEVEN_SEG == 7'b0111001) $display("Pass 12/C");
						else $display("Fail 12/C");
					end
				13 : //13
					begin
						r_BINARY = 4'b1101;
						if (w_SEVEN_SEG == 7'b1011110) $display("Pass 13/d");
						else $display("Fail 13/d");
					end
				14 : //14
					begin
						r_BINARY = 4'b1110;
						if (w_SEVEN_SEG == 7'b1111001) $display("Pass 14/E");
						else $display("Fail 14/E");
					end
				15 : //15
					begin
						r_BINARY = 4'b1111;
						if (w_SEVEN_SEG == 7'b1110001) $display("Pass 15/F");
						else $display("Fail 15/F");
					end
			endcase
			
			
			
		end //for loop
		
		$display ("Test completed");
		$stop;
		
	end
	
endmodule


