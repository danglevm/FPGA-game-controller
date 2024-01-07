module SPI_MASTER

#(parameter c_SPI_MODE = 3, //SPI_mode is 3, so CPOL = 1 and CPHA = 1, can be changed later
	/***********************
	clocking
	system clock - 50 MHz
	SPI clock - 12.5 MHz - recommendation for an 8-bit MCU, don't know if it applies here
	clocks per bit - 4 clks/bit
	clocks per half bit - 2clks
	***********************/
	
  parameter c_CLKS_PER_HALF_BIT = 2)
(
	input i_CLK,
	input i_RESET,
	
	
	/************************
	both MOSI and MISO viewed from a higher level module perspective
	*************************/
	//MOSI - TX - master get data from higher-level
	input [7:0] i_TX_BYTE,
	input i_TX_DV,
	output o_TX_READY, //ready to accept input from higher-level module
	
	
	//MISO - RX - master receives data from slave, then outputs it to higher level
	output o_RX_DV,
	output [7:0] o_RX_DATA,
	
	/**********************
		SPI interface - writing onto data lines
	***********************/
	input  i_SPI_MISO,
	output o_SPI_CLK,
	output o_SPI_MOSI
	
);

wire w_CPOL = 0;
wire w_CPHA = 0;


reg r_RX_DV = 0;


/**************************
        Parameters
**************************/
localparam c_EDGE_PER_BYTE = 16;

/**************************
			Assignment
***************************/

//bitwise operators - one of them correct and it's good
assign w_CPOL = (SPI_MODE == 2) | (SPI_MODE == 3);
assign w_CPHA = (SPI_MODE == 1) | (SPI_MODE == 3);

/***************************
		PLLs - 2MHz, and 2MHz with 270 degrees phase shift - recommended for better data sampling
****************************/




/****************************
		MOSI
*****************************/
always @ (posedge i_CLK or posedge i_RESET) begin
	
	if (i_RESET) begin
	
	
	end else begin
	
	
	
	end //if reset
	
	
	
	

end //always

endmodule