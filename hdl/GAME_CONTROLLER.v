

module GAME_CONTROLLER (

//-------CLOCK-------
input i_ADC_CLK_10,
input i_MAX_10_CLK1_50,
input i_MAX_10_CLK2_50,

//////////// SEG7 //////////
output		     [7:0]		o_HEX0,
output		     [7:0]		o_HEX1,
output		     [7:0]		o_HEX2,
output		     [7:0]		o_HEX3,
output		     [7:0]		o_HEX4,
output		     [7:0]		o_HEX5,

//////////// KEY //////////
//for testing SDRAM
input 		     [1:0]		i_KEY,

//////////// LED //////////
output		     [9:0]		o_LEDR,

//////////// SWITCHES //////////
input 		     [9:0]		i_SWITCH,

//////////// VGA //////////
//connect to VGA pins on the board
output    		  [3:0]     o_VGA_R,
output 		     [3:0]		o_VGA_G,
output 		     [3:0]		o_VGA_B,
output 		     				o_VGA_HS, //horizontal sync
output 							o_VGA_VS, //vertical sync

//////////// GSENSOR/ACCEL //////////
output							o_GSENSOR_CS_n, //I2C/SPI mode selection - use 0 for SPI
input 		     [2:1]		i_GSENSOR_INT, //SPI interupts 1 and 2
output		          		o_GSENSOR_SCLK, //SPI serial clock
inout 		          		io_GSENSOR_SDI, //SPI serial data input 4-wire
inout 		          		io_GSENSOR_SDO  //SPI serial data output
);


pll_100 pll_100_inst (
  .inclk0 ( i_MAX_10_CLK1_50 ),
  .c0 ( ),
  .c1 ( ),
  .c2 ( )
);
         


wire w_clock;
assign w_clock = i_MAX_10_CLK1_50;

endmodule