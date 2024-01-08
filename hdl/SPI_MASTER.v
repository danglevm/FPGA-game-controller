`include "../ip/pll_100_inst.v"

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
	output reg o_TX_READY, //ready to accept input from higher-level module
	
	
	//MISO - RX - master receives data from slave, then outputs it to higher level
	output reg o_RX_DV,
	output reg [7:0] o_RX_DATA,
	
	/**********************
		SPI interface - writing onto data lines
	***********************/
	input  i_SPI_MISO,
	output reg o_SPI_CLK,
	output reg o_SPI_MOSI
	
);

/**************************
        Wires
**************************/
wire w_CPOL = 0;
wire w_CPHA = 0;

/**************************
        Registers
**************************/
reg [7:0] r_TX_BYTE = 0;

//store number of edges
reg [3:0]

//tell the SPI clock to send out a signal to shift or read incoming bits
//here falling or rising edge doesn't matter == CPOL doesn't matter because the bit read/shift operation is done only during leading/trailing edge 
reg r_LEADING_EDGE = 1'b0;
reg r_TRAILING_EDGE = 1'b0;

reg [2:0] r_TX_BIT_INDEX = 1'd8; //starts from MSb
reg [2:0] r_RX_BIT_INDEX = 1'd8; //starts from MSb
reg [2:0] r_CLK_CNT = 0; 
reg r_TX_DV = 0;




/**************************
        Parameters
**************************/
localparam c_EDGE_PER_BYTE = 16;
localparam c_HIGH = 1'b1;
localparam c_LOW = 1'b0;

/**************************
			Assignment
***************************/

//bitwise operators - one of them correct and it's good
assign w_CPOL = (SPI_MODE == 2) | (SPI_MODE == 3);
assign w_CPHA = (SPI_MODE == 1) | (SPI_MODE == 3);
assign r_TX_BYTE = i_TX_BYTE;



/****************************
		Generate SPI trailing and falling edges
*****************************/

always @ (posedge i_CLK or posedge i_RESET) begin
	
	if (i_RESET) begin
		o_TX_READY <= 0;
		r_CLK_CNT <= 0;
		r_LEADING_EDGE <= 0;
		r_TRAILING_EDGE <= 0;
	
	end else begin 
		r_LEADING_EDGE;
		r_TRAILING_EDGE;
	
		//data sent in from higher module is ready
		if (i_TX_DV) begin 
	
			//at the end of the second half of the clock cycle
			if (r_CLK_CNT == (c_CLKS_PER_HALF_BIT*2 - 1)) begin
				r_CLK_CNT <= 0;
				r_LEADING_EDGE <= 0;
				r_TRAILING_EDGE <= 1;
			
				//takes one clock cycle to add the value then another clock cycle to resolve this so -1
			end else if (r_CLK_CNT == (c_CLKS_PER_HALF_BIT - 1)) begin
				//send leading edge signal
				r_LEADING_EDGE <= 1;
				r_TRAILING_EDGE <= 0;
				
			end else begin
				r_CLK_CNT <= r_CLK_CNT + 1;
			end
		
	
	end //if reset
	
end //always



/****************************
		MOSI
*****************************/
always @ (posedge i_CLK or posedge i_RESET) begin
	
	if (i_RESET) begin
		o_TX_READY <= c_LOW;
		r_TX_BIT_INDEX <= 3'b111;
	
	end else begin 
		
		
		//data signal ready to be sent
		if (o_TX_READY) begin
			r_TX_BIT_INDEX <= 3'b111;
			
		else if (r_TX_DV && ~w_CPHA) begin
			o_SPI_MOSI <= r_TX_BYTE[3'b111];
			r_TX_BIT_INDEX <= 3'b110;
			
		//CPHA = 1 --> trailing edge. CPHA = 0 --> leading edge
		//sample data from input parallel bits
		end else if ((r_TRAILING_EDGE && w_CPHA) || (r_LEADING_EDGE && ~w_CPHA) begin
			o_SPI_MOSI <= r_TX_BYTE [r_TX_BIT_INDEX];
			r_TX_BYTE <= r_TX_BYTE - 1'd1;
		end
		
	
	end //if reset
	
end //always


/****************************
		MISO
*****************************/
always @ (posedge i_CLK or posedge i_RESET) begin
	
	if (i_RESET) begin
		o_RX_DV <= c_LOW;
		r_TX_BIT_INDEX <= 3'b111;
	
	end else begin 
	
		if () begin
		

		
		end else if ((r_LEADING_EDGE && w_CPHA) || (r_TRAILING_EDGE && ~w_CPHA)) begin
		//send rx data onto the miso line
		
		end
		
	
	end //if reset
	
end //always


endmodule