module UART_TX
# (parameter c_CYCLES_PER_BIT)
(
	input i_CLK,
	//comes from the transmitter
	input i_TX_DV,
	input [7:0] i_PARALLEL_DATA,
	output reg o_SERIAL_DATA,
	output o_TX_ACTIVE,
	output o_TX_DONE
);

reg s_STATE = 5'b00000;
//counter goes up to 434
reg [31:0] r_COUNTER = 0;
reg r_BIT_INDEX = 0;
reg r_TX_ACTIVE = 0;
reg r_TX_DONE = 0;

parameter s_IDLE = 5'b00001;
parameter s_START = 5'b00010;
parameter s_DATA = 5'b00100;
parameter s_END = 5'b01000;
parameter s_TRANSITION = 5'b10000;

always @(posedge i_CLK) 
	begin
		case (s_STATE)
		
		s_IDLE:
			begin
				r_COUNTER <= 0;
				r_TX_ACTIVE <= 1'b0;
				r_TX_DONE <= 1'b0;
				r_BIT_INDEX <= 0;
				
				if (i_TX_DV == 1'b1) begin 
					r_TX_ACTIVE <= 1'b1;
					s_STATE <= s_START;
				end else begin
					s_STATE <= s_IDLE;
				end
			end
		s_START:
			//send the start bit
			begin
				o_SERIAL_DATA <= 1'b0;
				
				if (r_COUNTER < c_CYCLES_PER_BIT - 1) begin
					r_COUNTER <= 0;
					s_STATE <= s_START;
				end else begin
					s_STATE <= s_DATA;
				end
			
			end
		s_DATA:
			begin
				if (r_COUNTER < c_CYCLES_PER_BIT - 1) begin
					r_COUNTER <= r_COUNTER + 1'd1;
					s_STATE <= s_DATA;

				end else begin
					o_SERIAL_DATA <= i_PARALLEL_DATA [r_BIT_INDEX];
					r_COUNTER <= 0;
					
					if (r_BIT_INDEX < 7) begin
						r_BIT_INDEX = r_BIT_INDEX + 1'd1;
						s_STATE <= s_DATA;
					end else begin
						r_BIT_INDEX <= 0;
						r_COUNTER <= 0;
						s_STATE <= s_END;
					end
				end
				
			
			end
		s_END:
			begin
				//send stop bit
				o_SERIAL_DATA <= 1'b1;
				//wait for one bit cycle
				if (r_COUNTER < c_CYCLES_PER_BIT - 1) begin
					r_COUNTER <= r_COUNTER + 1'd1;
					s_STATE <= s_END;
				end else begin
					r_TX_DONE <= 1'b1;
					r_TX_ACTIVE <= 1'b0;
					s_STATE <= s_TRANSITION;
				end
				
			end
		s_TRANSITION:
		//wait for one clock cycle before taking in another bit
			begin
				r_TX_DONE <= 1'b1;
				r_TX_ACTIVE <= 1'b0;
				s_STATE <= s_IDLE;
			end
		
 
		default: s_STATE <= s_IDLE;
		endcase

	end
	
assign o_TX_ACTIVE = r_TX_ACTIVE;
assign o_TX_DONE = r_TX_DONE;

endmodule
