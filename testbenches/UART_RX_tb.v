
 `timescale 1ns/10ps
 `include "../hdl/UART_RX.v"

module UART_RX_tb ();

/***************************************
50 MHz clock not working for some reason
25 MHz is standard for now
****************************************/

parameter c_CYCLES_PER_SECOND = 50000000;

//baud rate or in this case 1-bit bit rate
parameter c_BAUD_RATE = 115200;

//should be 434 cycles/bit but for some reason only 217 cycles/bit work
parameter c_CYCLES_PER_BIT = 217;

/*
//*******************************
1 second/frequency
1 second/50 000 000 Hz = 20 ns
1 second/25 000 000 Hz = 40 ns
*******************************/
parameter c_CYCLE_PERIOD_NS = 40;

/********************************
time per cycle * number of cycles per bit
434 * 20 = 8680
217 * 40 = 8680
*********************************/
parameter c_BIT_PERIOD = 8680;

parameter c_HIGH = 1'b1;
parameter c_LOW = 1'b0;
parameter c_BIT_LENGTH = 1'd8;
//in 8 bits, 00011010
parameter c_EXPECTED_VALUE = 8'b0011010;

reg r_CLK = 1'b0;
reg r_RESET = 1'b0;
reg r_SERIAL_DATA = 1'b1;


//Received data is driven to a wire but that value is
//only read when a valid data pulse is emitted
wire [7:0] w_DATA_DRIVEN;

wire w_VALID;

UART_RX #( .c_CYCLES_PER_BIT(c_CYCLES_PER_BIT) ) UUT 
(	
	.i_CLK(r_CLK),
	.i_RESET (r_RESET),
	.i_SERIAL_DATA(r_SERIAL_DATA),
	.o_DATA_RX(w_DATA_DRIVEN),
	.o_RX_DATA_VALID(w_VALID)
	
/*	.i_Clock(r_CLK),
   .i_RX_Serial(r_SERIAL_DATA),
   .o_RX_DV(w_VALID),
   .o_RX_Byte(w_DATA_DRIVEN)
	*/
);

task WRITE_TO_RX; 
	input [7:0] p_BYTE;
	integer p_count;
	begin
		//send start bit and wait for one bit cycle
		r_SERIAL_DATA <= c_LOW;
		#(c_BIT_PERIOD);
		#1000;
		
		//send data bit
		for (p_count = 0; p_count < 8; p_count = p_count + 1) begin
			r_SERIAL_DATA <= p_BYTE [p_count];
			$display(p_BYTE[p_count]);
			#(c_BIT_PERIOD);
		end
		
		//send stop bit and wait for one bit cycle
		r_SERIAL_DATA <= c_HIGH;
		#(c_BIT_PERIOD);
		
	end

endtask

always
	#(c_CYCLE_PERIOD_NS/2) r_CLK <= !r_CLK;

 
initial 
	begin
		
		@(posedge r_CLK);
		WRITE_TO_RX(c_EXPECTED_VALUE);
		@(posedge r_CLK);
		
		if (w_DATA_DRIVEN == c_EXPECTED_VALUE) begin
			$display ("Correct value received");
		end else begin 
			$display ("Incorrect value received");
		end
			
		$stop;
		
	
		
	end
	

endmodule
