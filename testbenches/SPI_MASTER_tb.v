`include "../hdl/SPI_MASTER.v"

module SPI_MASTER_tb ();

SPI_MASTER UUT #( .c_SPI_MODE(3), c_CLKS_PER_HALF_BIT(2) )
( 
	.i_CLK(),
	.i_RESET(),
	.i_TX_BYTE(),
	.i_TX_DV(),
	
);

endmodule

