`include "../hdl/VGA_controller.v"
`timescale 1ns/10ps

module VGA_tb();

reg r_clk = 0;
reg r_reset = 0;
reg [7:0] r_RGB_data;

//counter for self-checking
//check to see if RGB value is supposed to be
reg [7:0] r_COUNTER = 0;


wire w_hsync;
wire w_vsync;
wire w_red, w_green, w_blue;


VGA_controller UUT(
	.i_CLK(r_CLK),
	.i_RESET(r_reset),
	.i_RGB(r_RGB_data),
	.o_HSYNC(w_hsync),
	.o_VSYNC(w_vsync),
	.o_RED(w_red),
	.o_GREEN(w_green),
	.o_BLUE(w_blue)
);

initial 
	begin
		forever #10 r_clk = !r_clk;
		
		
	end