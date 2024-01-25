`include "VGA_CONTROLLER.v"

//8 bit registers and wires right now
module VGA_TESTGEN (
//250 pixels
input i_CLK,
input i_RESET_n,
input [4:0] i_PATTERN,
//RRRGGGGBB based on user manual
input [7:0] i_RGB,
output o_HSYNC,
output o_VSYNC,
output [3:0] o_RED,
output [3:0] o_GREEN,
output [3:0] o_BLUE
);

//states
parameter c_PATTERN_1 = 4'b0000;
parameter c_PATTERN_2 = 4'b0001;
parameter c_PATTERN_3 = 4'b0010;
parameter c_PATTERN_4 = 4'b0011;
parameter c_PATTERN_5 = 4'b0100;
parameter c_PATTERN_6 = 4'b0101;
parameter c_PATTERN_7 = 4'b0110;
parameter c_PATTERN_8 = 4'b0111;
parameter c_PATTERN_9 = 4'b1000;
parameter c_PATTERN_10 = 4'b1001;
parameter c_PATTERN_11 = 4'b1010;
parameter c_PATTERN_12 = 4'b1011;
parameter c_PATTERN_13 = 4'b1100;
parameter c_PATTERN_14 = 4'b1101;
parameter c_PATTERN_15 = 4'b1110;
parameter c_PATTERN_16 = 4'b1111;

reg [4:0] r_Pattern_State = 4'b0000; 




//the question is do I need to set the values in an always block or do I plan to assign it
//An array of 8 indices of 4-bits wide
wire [3:0] w_Pattern_Red [7:0];
wire [3:0] w_Pattern_Green [7:0];
wire [3:0] w_Pattern_Blue [7:0];

//default state - no pattern
assign w_Pattern_Red [0] = 0;
assign w_Pattern_Green [0] = 0;
assign w_Pattern_Blue [0] = 0;
 