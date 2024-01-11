module UART_RX 
//relate clock frequency with bit rate
//how many clock pulses are generated per bit transmitted
//50 MHz, and baud rate of 115200 => 50 000 000 / 115200 =  434 cycles/second
//for some reason 434 cycles break the machine so for now a PLL of 25 MHz should be made
# (parameter c_CYCLES_PER_BIT = 217)
(
	input i_CLK,
	input i_RESET_n,
	input i_SERIAL_DATA,
	output o_RX_DATA_VALID,
	output [7:0] o_DATA_RX
	//tells the module upstream that the data inside of the byte is actually valid
	//the upstream module will not look at the byte until it has seen a pulse from here
	
);

reg [2:0] r_STATE  = 3'b000;


reg [7:0] r_COUNTER = 0;
reg [2:0] r_BIT_INDEX = 0;
reg r_RX_DV = 1'b0;
reg [7:0] r_DATA_RX;

/******************************
- synchronisation variables
- prevent metastability
- RX_DATA_I - intermediate
- RX_DATA_S - synchronized
*******************************/
reg r_RX_DATA_I, r_RX_DATA_S;

/******************************
- 5 states
*******************************/
parameter s_IDLE = 3'b000;
parameter s_START = 3'b001;
parameter s_DATA = 3'b010;
parameter s_END = 3'b011;
parameter s_TRANSITION = 3'b100;


parameter c_HIGH = 1'b1;
parameter c_LOW = 1'b0;
//enable generator to turn 50 MHz to 25MHz
parameter c_25MHz = 2;


//double register to synchronize inputs and avoid metastability
always @ (posedge i_CLK)
	begin
		r_RX_DATA_I <= i_SERIAL_DATA;
		r_RX_DATA_S <= r_RX_DATA_I;
	end
	
//reset 

	
//FSM
always @(posedge i_CLK or negedge ~i_RESET_n)
	begin
	if (~i_RESET_n) begin
		r_STATE <= s_IDLE;
	end 
	else begin
		case (r_STATE) 
		//default state
		s_IDLE:
			begin
				//default assignment
				r_RX_DV <= c_LOW; 
				r_COUNTER <= 0;
				r_BIT_INDEX <= 0;
				
				if (i_SERIAL_DATA == c_LOW) begin
					r_STATE <= s_START;
				end else begin
					r_STATE <= s_IDLE;
				end
					
			end
		s_START:
			begin
				if (r_COUNTER == ((c_CYCLES_PER_BIT - 1)/2) ) begin
					//in the middle of the start bit
					if (r_RX_DATA_S == c_LOW) begin
						r_STATE <= s_DATA;
						r_COUNTER <= 0;
					end else begin
						r_STATE <= s_IDLE;
					end
				end else begin
					r_COUNTER <= r_COUNTER + 1;
					r_STATE <= s_START;
				end
			end
			
		s_DATA:
			begin
					//samples at the middle of the bit to avoid hold time metastability
					if (r_COUNTER == (c_CYCLES_PER_BIT - 1)) begin
					
					//assign synchronised value to receiver data
						r_DATA_RX [r_BIT_INDEX] <= r_RX_DATA_S;
						r_COUNTER <= 0;
					
						if (r_BIT_INDEX < 7) begin
							r_BIT_INDEX <= r_BIT_INDEX + 1;
							r_STATE <=  s_DATA;
						end else begin
							r_BIT_INDEX <= 0;
							r_STATE <= s_END;
						end						
					end else begin
							r_COUNTER <= r_COUNTER + 1;
							r_STATE <= s_DATA;	
					end
					
				
					/*if (r_COUNTER < (c_CYCLES_PER_BIT - 1)) begin
						r_COUNTER <= r_COUNTER + 1;
						r_STATE <= s_DATA;		
					end else begin		
						r_DATA_RX [r_BIT_INDEX] <= i_SERIAL_DATA;
						r_COUNTER <= 0;
					
						if (r_BIT_INDEX < 7) begin
							r_BIT_INDEX <= r_BIT_INDEX + 1;
							r_STATE <=  s_DATA;
						end else begin
							r_BIT_INDEX <= 0;
							r_STATE <= s_END;
						end			
					end
					*/
			end
			
		s_END:
			begin
			
				//wait out the whole bit cycle for the stop bit to finish
				//still sample at the half bit
				if (r_COUNTER == (c_CYCLES_PER_BIT - 1)) begin
					r_RX_DV <= c_HIGH; //data is valid and can now be sent
					r_COUNTER <= 0;
					r_STATE <= s_TRANSITION;
				end else begin
					r_COUNTER <= r_COUNTER + 1;
					r_STATE <= s_END;
				end

		/*	
					if (r_COUNTER < (c_CYCLES_PER_BIT - 1)) begin
						r_COUNTER <= r_COUNTER + 1;
						r_STATE <= s_END;	
					end else begin		
						r_RX_DV <= 1'b1;
						r_COUNTER <= 0;
						r_STATE <= s_TRANSITION;
					end	
			*/		
				end
			
		s_TRANSITION:
			begin
				//wait for one clock cycle before continuing
				r_RX_DV <= c_LOW;
				r_STATE <= s_IDLE;
			end
			
		default : r_STATE <= s_IDLE;
			
		
		endcase
		end //i_RESET
	end //FSM
	
assign o_DATA_RX = r_DATA_RX;
assign o_RX_DATA_VALID = r_RX_DV;

endmodule


