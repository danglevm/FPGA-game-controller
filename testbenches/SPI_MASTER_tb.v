`include "../hdl/SPI_MASTER.v"

module SPI_MASTER_tb ();

integer SPI_MODE = 3;
integer CLKS_PER_HALF_BIT = 2;

parameter c_LOW = 1'b0;
parameter c_HIGH = 1'b1;

reg r_CLK = 1'b0;
reg r_RESET = 1'b0;
reg [7:0] r_TX_BYTE = 8'b0;
reg r_TX_DV = 1'b0;
reg r_SPI_MISO = 1'b0;
 

wire w_TX_READY;
wire w_RX_DV;
wire w_RX_BYTE;
wire w_SPI_CLK;
wire w_SPI_MOSI;


SPI_MASTER UUT #( .c_SPI_MODE(SPI_MODE), c_CLKS_PER_HALF_BIT(CLKS_PER_HALF_BIT) )
( 
	.i_CLK(r_CLK),
	.i_RESET(r_RESET),
	.i_TX_BYTE(r_TX_BYTE),
	.i_TX_DV(r_TX_DV),
	.i_SPI_MISO(r_SPI_MISO),
	.o_TX_READY(w_TX_READY), 
	.o_RX_DV(w_RX_DV),
	.o_RX_BYTE(w_RX_BYTE),
	.o_SPI_CLK(w_SPI_CLK),
	.o_SPI_MOSI(w_SPI_MOSI)
	
);

task WRITE_TO_MASTER;

end

endmodule

