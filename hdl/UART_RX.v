module UART_RX 
//relate clock frequency with bit rate
//how many clock pulses are generated per bit transmitted
# (parameter c_CYCLES_PER_BIT = 217)
(
	input i_CLK,
	input i_SERIAL_DATA,
	output o_RX_DATA_VALID,
	output [7:0] o_DATA_RX
	//tells the module upstream that the data inside of the byte is actually valid
	//the upstream module will not look at the byte until it has seen a pulse from here
	
);

reg [2:0] r_STATE  = 3'b000;
//reg r_TRANSMISSION = 1'b1;
//counter goes up to 434 cycles/second
reg [7:0] r_COUNTER = 0;
reg [2:0] r_BIT_INDEX = 0;
reg r_RX_DV = 1'b0;
reg [7:0] r_DATA_RX;

//variables for avoiding metastability
//RX_DATA_I - intermediate
//RX_DATA_S - synchronized
reg r_RX_DATA_I, r_RX_DATA_S;

parameter s_IDLE = 3'b000;
parameter s_START = 3'b001;
parameter s_DATA = 3'b010;
parameter s_END = 3'b011;
parameter s_TRANSITION = 3'b100;


//parameter c_HIGH = 1'b1;
//parameter c_LOW = 1'b0;


//double register to synchronize inputs and avoid metastability

always @ (posedge i_CLK)
	begin
		r_RX_DATA_I <= i_SERIAL_DATA;
		r_RX_DATA_S <= r_RX_DATA_I;
	end
	
//reset 

	
//FSM
always @(posedge i_CLK) 
	begin
		case (r_STATE) 
		s_IDLE:
			begin
				//r_TRANSMISSION <= 1'b1;
				r_RX_DV <= 1'b0;
				r_COUNTER <= 0;
				r_BIT_INDEX <= 0;
				
				if (i_SERIAL_DATA == 1'b0) begin
					r_STATE <= s_START;
				end else begin
					r_STATE <= s_IDLE;
				end
					
			end
		s_START:
			begin
				if (r_COUNTER == ((c_CYCLES_PER_BIT - 1)/2) ) begin
					//in the middle of the start bit
					if (r_RX_DATA_S == 1'b0) begin
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
			/*
					if (r_COUNTER == (c_CYCLES_PER_BIT - 1)) begin
						r_DATA [r_BIT_INDEX] <= r_RX_DATA_S;
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
				*/
					if (r_COUNTER < (c_CYCLES_PER_BIT - 1)) begin
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
			end
			
		s_END:
			begin
			
				//wait out the whole bit cycle for the stop bit to finish
			//	if (r_COUNTER == (c_CYCLES_PER_BIT - 1)) begin
			//		r_RX_DV <= c_HIGH;
			//		r_COUNTER <= 0;
			//		r_STATE <= s_TRANSITION;
			//	end else begin
			//		r_COUNTER <= r_COUNTER + 1;
			//		r_STATE <= s_END;
			//	end
		//	end
			
			if (r_COUNTER < (c_CYCLES_PER_BIT - 1)) begin
						r_COUNTER <= r_COUNTER + 1;
						r_STATE <= s_END;	
					end else begin		
						r_RX_DV <= 1'b1;
						r_COUNTER <= 0;
						r_STATE <= s_TRANSITION;
					end			
				end
			
		s_TRANSITION:
			begin
				//wait for one clock cycle before continuing
				//r_TRANSMISSION <= 1'b1;
				r_RX_DV <= 1'b0;
				r_STATE <= s_IDLE;
			end
			
		default : r_STATE <= s_IDLE;
			
		
		endcase
	end
	
assign o_DATA_RX = r_DATA_RX;
assign o_RX_DATA_VALID = r_RX_DV;

endmodule


/////////////////////////////////////////////////////////////////////
// File Downloaded from http://www.nandland.com
/////////////////////////////////////////////////////////////////////
// This file contains the UART Receiver.  This receiver is able to
// receive 8 bits of serial data, one start bit, one stop bit,
// and no parity bit.  When receive is complete o_rx_dv will be
// driven high for one clock cycle.
// 
// Set Parameter CLKS_PER_BIT as follows:
// CLKS_PER_BIT = (Frequency of i_Clock)/(Frequency of UART)
// Example: 25 MHz Clock, 115200 baud UART
// (25000000)/(115200) = 217
 /*
module UART_RX
  #(parameter CLKS_PER_BIT = 217)
  (
   input        i_Clock,
   input        i_RX_Serial,
   output       o_RX_DV,
   output [7:0] o_RX_Byte
   );
   
  parameter IDLE         = 3'b000;
  parameter RX_START_BIT = 3'b001;
  parameter RX_DATA_BITS = 3'b010;
  parameter RX_STOP_BIT  = 3'b011;
  parameter CLEANUP      = 3'b100;
  
  reg [7:0]     r_Clock_Count = 0;
  reg [2:0]     r_Bit_Index   = 0; //8 bits total
  reg [7:0]     r_RX_Byte     = 0;
  reg           r_RX_DV       = 0;
  reg [2:0]     r_SM_Main     = 0;
  
  
  // Purpose: Control RX state machine
  always @(posedge i_Clock)
  begin
      
    case (r_SM_Main)
      IDLE :
        begin
          r_RX_DV       <= 1'b0;
          r_Clock_Count <= 0;
          r_Bit_Index   <= 0;
          
          if (i_RX_Serial == 1'b0)          // Start bit detected
            r_SM_Main <= RX_START_BIT;
          else
            r_SM_Main <= IDLE;
        end
      
      // Check middle of start bit to make sure it's still low
      RX_START_BIT :
        begin
          if (r_Clock_Count == (CLKS_PER_BIT-1)/2)
          begin
            if (i_RX_Serial == 1'b0)
            begin
              r_Clock_Count <= 0;  // reset counter, found the middle
              r_SM_Main     <= RX_DATA_BITS;
            end
            else
              r_SM_Main <= IDLE;
          end
          else
          begin
            r_Clock_Count <= r_Clock_Count + 1;
            r_SM_Main     <= RX_START_BIT;
          end
        end // case: RX_START_BIT
      
      
      // Wait CLKS_PER_BIT-1 clock cycles to sample serial data
      RX_DATA_BITS :
        begin
          if (r_Clock_Count < CLKS_PER_BIT-1)
          begin
            r_Clock_Count <= r_Clock_Count + 1;
            r_SM_Main     <= RX_DATA_BITS;
          end
          else
          begin
            r_Clock_Count          <= 0;
            r_RX_Byte[r_Bit_Index] <= i_RX_Serial;
            
            // Check if we have received all bits
            if (r_Bit_Index < 7)
            begin
              r_Bit_Index <= r_Bit_Index + 1;
              r_SM_Main   <= RX_DATA_BITS;
            end
            else
            begin
              r_Bit_Index <= 0;
              r_SM_Main   <= RX_STOP_BIT;
            end
          end
        end // case: RX_DATA_BITS
      
      
      // Receive Stop bit.  Stop bit = 1
      RX_STOP_BIT :
        begin
          // Wait CLKS_PER_BIT-1 clock cycles for Stop bit to finish
          if (r_Clock_Count < CLKS_PER_BIT-1)
          begin
            r_Clock_Count <= r_Clock_Count + 1;
     	    r_SM_Main     <= RX_STOP_BIT;
          end
          else
          begin
       	    r_RX_DV       <= 1'b1;
            r_Clock_Count <= 0;
            r_SM_Main     <= CLEANUP;
          end
        end // case: RX_STOP_BIT
      
      
      // Stay here 1 clock
      CLEANUP :
        begin
          r_SM_Main <= IDLE;
          r_RX_DV   <= 1'b0;
        end
      
      
      default :
        r_SM_Main <= IDLE;
      
    endcase
  end    
  
  assign o_RX_DV   = r_RX_DV;
  assign o_RX_Byte = r_RX_Byte;
  
endmodule // UART_RX
*/