`include "UART_RX.v"
`include "BINARY_TO_7SEG_DISPLAY.v"

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


//////////// UART_RX //////////
input 							i_UART_RX,
//////////// KEY //////////
input 		     [1:0]		i_KEY, //for testing SDRAM

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

/************
	PARAMETERS
*************/
parameter c_CYCLES_PER_BIT = 217; //number of cycles per bits for UART RX and TX

/************
	WIRES
*************/

/// UART_RX
wire w_CLK;
wire [7:0] w_RX_BYTE;
wire w_RX_DV;

/// 7SEG
wire [6:0] w_HEX0;
wire [6:0] w_HEX1;

/************
	REGISTERS
*************/
reg r_TX_RESET_n = 1'b1; //active low

/************
	ASSIGN
*************/
assign o_HEX0 = ~w_HEX0; //active low
assign o_HEX1 = ~w_HEX1; //active low

/******
c0 - 25 MHz
c1 - 2 MHz
c2 - 2 MHz
******/

pll_100 pll_100_inst (
  .inclk0 ( i_MAX_10_CLK1_50 ),
  .c0 (w_CLK),
  .c1 ( ),
  .c2 ( )
);

UART_RX #(.c_CYCLES_PER_BIT(c_CYCLES_PER_BIT)) inst1_uart_RX (
	.i_CLK (w_CLK),
	.i_RESET_n (r_TX_RESET_n),
	.i_SERIAL_DATA (i_UART_RX),
	.o_RX_DATA_VALID (w_RX_DV),
	.o_DATA_RX (w_RX_BYTE)
);

//Active low display
BINARY_TO_7SEG_DISPLAY inst1_7seg (
	.i_BINARY(w_RX_BYTE[7:4]),
	.o_SEVEN_SEG (w_HEX0)
);

BINARY_TO_7SEG_DISPLAY inst2_7seg(
	.i_BINARY(w_RX_BYTE[3:0]),
	.o_SEVEN_SEG (w_HEX1)
);
         



endmodule