`include "../hdl/VGA_CONTROLLER.v"
`include "../hdl/VGA_TESTGEN.v"
`timescale 1ns/10ps

module VGA_tb();


//25MHz 25.175 MHz to be more exact) pixel clock - 25 million pixels per second
//displays resolution of 640 x 480 @ 60Hz
//40 ns period

parameter c_clk_speed = 25000000;
parameter c_cycle_period = 40;

/*
reg r_clk = 0;
reg r_reset_n = 1;
reg [7:0] r_RGB_data;

//counter for self-checking
//check to see if RGB value is supposed to be



wire w_hsync;
wire w_vsync;
wire [3:0] w_red;
wire [3:0] w_green;
wire [3:0] w_blue;


VGA_CONTROLLER UUT(
	.i_CLK(r_clk),
	.i_RESET(r_reset_n),
	.i_RGB(r_RGB_data),
	.o_HSYNC(w_hsync),
	.o_VSYNC(w_vsync),
	.o_RED(w_red),
	.o_GREEN(w_green),
	.o_BLUE(w_blue)
);

always
	(#c_cycle_period) r_clk = !r_clk;
	
task write_RGB_data;
	input [7:0] i_byte;
	begin
		r_RGB_data <= i_byte; 
	
	
	
	end
endtask
*/

initial 
	begin
		
		
	end