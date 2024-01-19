module UART_TX
# (parameter c_CYCLES_PER_BIT = 217)
(
	input i_CLK,
	input i_RESET_n,
	//comes from the transmitter
	input i_TX_DV,
	input [7:0] i_PARALLEL_DATA,
	output reg o_SERIAL_DATA,
	output reg o_TX_ACTIVE,
	output reg o_TX_DONE
);

reg r_STATE = 5'b00000;
//counter goes up to 217
reg [7:0] r_COUNTER = 1'd0;
reg r_BIT_INDEX = 1'd0;

parameter s_IDLE = 5'b00001;
parameter s_START = 5'b00010;
parameter s_DATA = 5'b00100;
parameter s_END = 5'b01000;
parameter s_TRANSITION = 5'b10000;

parameter c_LOW = 1'b0;
parameter c_HIGH = 1'b1;


always @(posedge i_CLK or negedge i_RESET_n) 
	if (~i_RESET_n) begin
		r_STATE <= s_IDLE;
		r_COUNTER <= 1'd0;
		o_TX_DONE <= c_LOW;
	end else begin
	
	begin
		case (r_STATE)
		
		s_IDLE:
			begin
				r_COUNTER <= 1'd0;
				o_TX_ACTIVE <= c_LOW;
				o_TX_DONE <= c_LOW;
				r_BIT_INDEX <= 1'd0;
				
				if (i_TX_DV == c_HIGH) begin 
					o_TX_ACTIVE <= c_HIGH;
					r_STATE <= s_START;
				end else begin
					r_STATE <= s_IDLE;
				end
			end
		s_START:
			//send the start bit
			begin
				o_SERIAL_DATA <= c_LOW;
				o_TX_ACTIVE <= c_HIGH;
				
				//wait out one cycle
				if (r_COUNTER < c_CYCLES_PER_BIT - 1) begin
					o_TX_ACTIVE <= c_LOW;
					r_COUNTER <= r_COUNTER + 1'd1;
					r_STATE <= s_START;
				end else begin
					r_COUNTER <= 1'd0;
					r_STATE <= s_DATA;
				end
			
			end
		s_DATA:
			begin
				o_TX_ACTIVE <= c_HIGH;
				if (r_COUNTER < c_CYCLES_PER_BIT - 1) begin
					r_COUNTER <= r_COUNTER + 1'd1;
					r_STATE <= s_DATA;

				end else begin
					o_SERIAL_DATA <= i_PARALLEL_DATA [r_BIT_INDEX];
					r_COUNTER <= 1'd0;
					
					if (r_BIT_INDEX < 7) begin
						r_BIT_INDEX = r_BIT_INDEX + 1'd1;
						r_STATE <= s_DATA;
					end else begin
						r_BIT_INDEX <= 1'd0;
						r_COUNTER <= 1'd0;
						r_STATE <= s_END;
					end
				end
				
			
			end
		s_END:
			begin
				//send stop bit
				o_SERIAL_DATA <= c_HIGH;
				//wait for one bit cycle
				if (r_COUNTER < c_CYCLES_PER_BIT - 1) begin
					r_COUNTER <= r_COUNTER + 1'd1;
					r_STATE <= s_END;
				end else begin
					r_COUNTER <= 1'd0;
					r_STATE <= s_TRANSITION;
				end
				
			end
		s_TRANSITION:
		//wait for one clock cycle before taking in another bit
			begin
				//send a done pulse to notify RX
				o_TX_DONE <= 1'b1;
				o_TX_ACTIVE <= 1'b0;
				r_STATE <= s_IDLE;
			end
		
 
		default: r_STATE <= s_IDLE;
		endcase

	end
	
	end
	


endmodule
