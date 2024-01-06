//////////////////////////////////////////////////////////////////////
// File Downloaded from http://www.nandland.com
//////////////////////////////////////////////////////////////////////

// This testbench will exercise the UART RX.
// It sends out byte 0x37, and ensures the RX receives it correctly.
/*
`timescale 1ns/10ps
`include "../hdl/UART_RX.v"
module UART_RX_tb();

  // Testbench uses a 25 MHz clock (same as Go Board)
  // Want to interface to 115200 baud UART
  // 25000000 / 115200 = 217 Clocks Per Bit.
  parameter c_CLOCK_PERIOD_NS = 40;
  parameter c_CLKS_PER_BIT    = 217;
  parameter c_BIT_PERIOD      = 8600;
  
  reg r_Clock = 0;
  reg r_RX_Serial = 1;
  wire [7:0] w_RX_Byte;
  

  // Takes in input byte and serializes it 
  task UART_WRITE_BYTE;
    input [7:0] i_Data;
    integer     ii;
    begin
      
      // Send Start Bit
      r_RX_Serial <= 1'b0;
      #(c_BIT_PERIOD);
      #1000;
      
      // Send Data Byte
      for (ii=0; ii<8; ii=ii+1)
        begin
          r_RX_Serial <= i_Data[ii];
          #(c_BIT_PERIOD);
        end
      
      // Send Stop Bit
      r_RX_Serial <= 1'b1;
      #(c_BIT_PERIOD);
     end
  endtask // UART_WRITE_BYTE
  
  
  UART_RX #(.CLKS_PER_BIT(c_CLKS_PER_BIT)) UART_RX_INST
    (.i_Clock(r_Clock),
     .i_RX_Serial(r_RX_Serial),
     .o_RX_DV(),
     .o_RX_Byte(w_RX_Byte)
     );
  
  always
    #(c_CLOCK_PERIOD_NS/2) r_Clock <= !r_Clock;

  
  // Main Testing:
  initial
    begin
      // Send a command to the UART (exercise Rx)
      @(posedge r_Clock);
      UART_WRITE_BYTE(8'h37);
      @(posedge r_Clock);
            
      // Check that the correct command was received
      if (w_RX_Byte == 8'h37)
        $display("Test Passed - Correct Byte Received");
      else
        $display("Test Failed - Incorrect Byte Received");
    $stop;
    end
  
  initial 
  begin
    // Required to dump signals to EPWave
    $dumpfile("dump.vcd");
    $dumpvars(0);
  end
  
endmodule
*/

 `timescale 1ns/10ps
 `include "../hdl/UART_RX.v"

module UART_RX_tb ();

//50 MHz clock
parameter c_CYCLES_PER_SECOND = 50000000;
//baud rate or in this case 1-bit bit rate
parameter c_BAUD_RATE = 115200;
//434 cycles/bit currently
parameter c_CYCLES_PER_BIT = 217;
// 1/50 000 000 HZ
parameter c_CYCLE_PERIOD_NS = 40;
// 434 * 20 = 8680
parameter c_BIT_PERIOD = 8680;

parameter c_HIGH = 1'b1;
parameter c_LOW = 1'b0;
parameter c_BIT_LENGTH = 1'd8;
parameter c_EXPECTED_VALUE = 8'h26;

reg r_CLK = 1'b0;
reg r_SERIAL_DATA = 1'b1;

//Received data is driven to a wire but that value is
//only read when a valid data pulse is emitted
wire [7:0] w_DATA_DRIVEN;

wire w_VALID;

UART_RX #( .c_CYCLES_PER_BIT(c_CYCLES_PER_BIT) ) UUT 
(	
	.i_CLK(r_CLK),
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
		r_SERIAL_DATA <= 1'b0;
		#(c_BIT_PERIOD);
		#1000;
		
		//send data bit
		for (p_count = 0; p_count < 8; p_count = p_count + 1) begin
			r_SERIAL_DATA <= p_BYTE [p_count];
			#(c_BIT_PERIOD);
		end
		
		//send stop bit and wait for one bit cycle
		r_SERIAL_DATA <= 1'b1;
		#(c_BIT_PERIOD);
		
	end

endtask
 
always 
	#(c_CYCLE_PERIOD_NS/2) r_CLK <= !r_CLK;

 
initial 
	begin
//		forever # (/2) r_CLK = !r_CLK;
		
		@(posedge r_CLK);
		WRITE_TO_RX(8'h26);
		@(posedge r_CLK);
		
		if (w_DATA_DRIVEN == 8'h26) begin
			$display ("Correct value received");
		end else begin 
			$display ("Incorrect value received");
		end
			
		$stop;
		
	
		
	end
	

endmodule
