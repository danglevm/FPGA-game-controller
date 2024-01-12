
`timescale 1ns/1ps
`include "../hdl/UART_TX.v"
`include "../hdl/UART_RX.v"

module UART_TX_tb();

//50 MHz clock
parameter c_CYCLES_PER_SECOND = 50000000;
//baud rate or in this case 1-bit bit rate
parameter c_BAUD_RATE = 115200;
//217 cycles/bit currently
integer CYCLES_PER_BIT = 217;

parameter c_HIGH = 1'b1;
parameter c_LOW = 1'b0;
parameter c_BIT_LENGTH = 1'd8;
parameter c_EXPECTED_VALUE = 8'h27;
//parameter c_PARALLEL_DATA = 8'b11001011;

reg r_CLK = 1'b0;
reg r_DATA_VALID = 1'b0;
reg r_RESET_TX_n = 1'b1;
reg r_RESET_RX_n = 1'b1;
reg [7:0] r_TX_PARALLEL = 8'h27;
reg [7:0] r_PARALLEL_OUTPUT = 0;
reg r_RX_INPUT_SERIAL;

wire w_TX_OUTPUT_SERIAL;
wire [7:0] w_RX_OUTPUT_PARALLEL;
wire w_TX_ACTIVE;
wire w_VALID;
wire w_TX_DONE;

UART_TX  #( .c_CYCLES_PER_BIT (CYCLES_PER_BIT) ) UUT_TX 
(
	.i_CLK (r_CLK),
	.i_RESET_n (r_RESET_TX_n)
	.i_TX_DV (r_DATA_VALID),
	.i_PARALLEL_DATA (r_TX_PARALLEL),
	.o_SERIAL_DATA (w_TX_OUTPUT_SERIAL),
	.o_TX_ACTIVE (w_TX_ACTIVE),
	.o_TX_DONE (w_TX_DONE)
);

UART_RX #( .c_CYCLES_PER_BIT (CYCLES_PER_BIT) ) UUT_RX
(
	.i_CLK (r_CLK),
	.i_RESET_n (r_RESET_RX_n),
	.i_SERIAL_DATA(w_RX_INPUT_SERIAL),
	.o_DATA_RX(w_RX_OUTPUT_PARALLEL),
	.o_RX_DATA_VALID(w_VALID)
);
//if the transmitter signal is active, then wire follows serial output from transmitter
//or is at logic high, which is default for idle state of UART_RX
assign w_RX_INPUT_SERIAL = w_TX_ACTIVE ? w_TX_OUTPUT_SERIAL : c_HIGH;

always 
	#(c_CYCLES_PER_BIT/2) r_CLK = !r_CLK;

initial
	begin
		
		@(posedge r_CLK)
		r_DATA_VALID <= c_HIGH;
		r_PARALLEL_INPUT <= c_EXPECTED_VALUE;
		@(posedge r_CLK)
		if (w_VALID == c_HIGH) begin
			if (w_RX_OUTPUT_PARALLEL == c_EXPECTED_VALUE) begin
				$display ("Correct value received");
			end else begin
				$display ("Incorrect value received");
			end
		end
		
		
	end

endmodule

