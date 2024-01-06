module VGA_controller (
input i_CLK,
input i_RESET,
//RRRGGGGBB based on user manual
input [7:0] i_RGB,
output o_HSYNC,
output o_VSYNC,
output [3:0] o_RED,
output [3:0] o_GREEN,
output [3:0] o_BLUE
);

//horizontal states
reg [7:0] r_H_STATE = 3'b000;
parameter s_H_ACTIVE = 3'b000;
parameter s_H_FRONT = 3'b001;
parameter s_H_SYNC = 3'b010;
parameter s_H_BACK = 3'b011;

//horizontal cycles
parameter c_H_ACTIVE_CYCLES = 640 ;
parameter c_H_FRONT_CYCLES = 16;
parameter c_H_SYNC_CYCLES = 96;
parameter c_H_BACK_CYCLES = 48;

//horizontal registers and variables
reg [15:0] r_H_COUNTER = 0;
reg [15:0] r_V_COUNTER = 0;

//starts in high because default for many states in state machine
reg r_HSYNC_SIG = 1'b1; 
reg r_VSYNC_SIG = 1'b1;

//RGB regs
reg [3:0] r_Red = 4'b0;
reg [3:0] r_Green = 4'b0
reg [3:0] r_Blue = 4'b0;



//vertical states
reg [7:0] r_V_STATE = 3'b100;
parameter s_V_ACTIVE = 3'b100;
parameter s_V_FRONT = 3'b101;
parameter s_V_SYNC = 3'b110;
parameter s_V_BACK = 3'b111;

//vertical cycles
parameter c_V_ACTIVE_CYCLES = 480;
parameter c_V_FRONT_CYCLES = 33;
parameter c_V_SYNC_CYCLES = 2;
parameter c_V_BACK_CYCLES = 10; 

parameter c_HIGH = 1'b1;
parameter c_LOW = 1'b0;

//end of line to indicate end of a pixel line
reg r_END_LINE = 1'b0;	

//assign statements
assign o_HSYNC = r_HSYNC_SIG;
assign o_VSYNC = r_VSYNC_SIG;
assign o_RED = r_Red;
assign o_GREEN = r_Green;
assign o_BLUE = r_Blue;


always @ (posedge i_CLK) 
	begin
		case (r_H_STATE) 
		s_H_ACTIVE: 
			begin
				r_HSYNC_SIG <= c_HIGH;
			
				//not end of line yet
				r_END_LINE <= c_LOW;
		
				// 640 cycles
				if (r_H_COUNTER < c_H_ACTIVE_CYCLES) begin
					r_H_COUNTER <= r_H_COUNTER + 1'd1;
					r_H_STATE <= s_H_ACTIVE;
				end else begin
					r_H_COUNTER <= 0;
					r_H_STATE <= s_H_FRONT;
				end
			end
		s_H_FRONT:
			begin
				r_HSYNC_SIG <= c_HIGH;
		
				//not end of line yet
				r_END_LINE <= c_LOW;
		
				// 16 cycles
				if (r_H_COUNTER < c_H_FRONT_CYCLES) begin
					r_H_COUNTER <= r_H_COUNTER + 1'd1;
					r_H_STATE <= s_H_FRONT;
				end else begin
					r_H_COUNTER <= 0;
					r_H_STATE <= s_H_SYNC;
				end
			end
		s_H_SYNC:
			begin
				//sync pulse requires hsync signal to be driven low
				r_HSYNC_SIG <= c_LOW;
				
				r_END_LINE <= c_LOW;
				//96
				if (r_H_COUNTER < c_H_SYNC_CYCLES) begin
					r_H_COUNTER <= r_H_COUNTER + 1'd1;
					r_H_STATE <= s_H_SYNC;
				end else begin
					r_H_COUNTER <= 0;
					r_H_STATE <= s_H_BACK;
				end
				
			end
			
		s_H_BACK:
			begin
				r_HSYNC_SIG <= c_HIGH;
				
				if (r_H_COUNTER < c_H_BACK_CYCLES) begin
					r_H_COUNTER <= r_H_COUNTER + 1'd1;
					r_H_STATE <= s_H_BACK;
				end else begin
					r_H_COUNTER <= 0;
					r_H_STATE <= s_H_ACTIVE;
				end
				
				//set the end line signal to high
				//one clock cycle offset for synchronous transition
				if (r_H_COUNTER < (c_H_BACK_CYCLES - 1)) begin
					r_END_LINE <= c_LOW;
				end else begin
					r_END_LINE <= c_HIGH;
				end
			end
		default: 
			begin
				//hsync signal high most of the times
				r_HSYNC_SIG <= c_HIGH;
				r_END_LINE <= c_LOW;
				r_H_COUNTER <= 0;
			end
		endcase
		
		case (r_V_STATE)
		s_V_ACTIVE: 
			begin
				r_VSYNC_SIG <= c_HIGH;
				
				if (r_END_LINE == c_HIGH) begin
					if (r_V_COUNTER < c_V_ACTIVE_CYCLES) begin
						r_V_COUNTER <= r_V_COUNTER + 1'd1;
						r_V_STATE <= s_V_ACTIVE;
					end else begin
						r_V_COUNTER <= 0;
						r_V_STATE <= s_V_FRONT;
					end
				end else begin
					r_V_COUNTER <= r_V_COUNTER;
					r_V_STATE <= s_V_ACTIVE;
				end
			
			end
		s_V_FRONT:
			begin
				r_VSYNC_SIG <= c_HIGH;
				
				if (r_END_LINE == c_HIGH) begin
					if (r_V_COUNTER < c_V_FRONT_CYCLES) begin
						r_V_COUNTER <= r_V_COUNTER + 1'd1;
						r_V_STATE <= s_V_FRONT;
					end else begin
						r_V_COUNTER <= 0;
						r_V_STATE <= s_V_SYNC;
					end
				end else begin
					r_V_COUNTER <= r_V_COUNTER;
					r_V_STATE <= s_V_FRONT;
				end
			end
		s_V_SYNC:
			begin
				r_VSYNC_SIG <= c_LOW;
				
				if (r_END_LINE == c_HIGH) begin
					if (r_V_COUNTER < c_V_SYNC_CYCLES) begin
						r_V_COUNTER <= r_V_COUNTER + 1'd1;
						r_V_STATE <= s_V_SYNC;
					end else begin
						r_V_COUNTER <= 0;
						r_V_STATE <= s_V_BACK;
					end
				end else begin
					r_V_COUNTER <= r_V_COUNTER;
					r_V_STATE <= s_V_SYNC;
				end
			end
		s_V_BACK:
			begin
				r_VSYNC_SIG <= c_HIGH;
				
				if (r_END_LINE == c_HIGH) begin
					if (r_V_COUNTER < c_V_BACK_CYCLES) begin
						r_V_COUNTER <= r_V_COUNTER + 1'd1;
						r_V_STATE <= s_V_BACK;
					end else begin
						r_V_COUNTER <= 0;
						r_V_STATE <= s_V_ACTIVE;
					end
				end else begin
					r_V_COUNTER <= r_V_COUNTER;
					r_V_STATE <= s_V_BACK;
				end
			end
		default: 
			begin
				//vsync signal high most of the times
				r_V_COUNTER <= 0;
				r_V_STATE <= s_V_ACTIVE;
				r_V_COUNTER <= 0;
			end
		endcase
		
		//if they are in horizontal and vertical active states
		if (r_H_STATE == s_H_STATE) begin
			if (r_V_STATE == s_V_ACTIVE) begin
				r_Red <= {i_RGB [7:5], 1'b0};
				r_Green <= {i_RGB [4:2], 1'b0};
				r_Blue <= {i_RGB [1:0], 2'b00};
			end else begin
				r_Red <= 4'b0;
				r_Green <= 4'b0;
				r_Blue <= 4'b0;
			end
		end else begin
			r_Red <= 4'b0;
			r_Green <= 4'b0;
			r_Blue <= 4'b0;
		end

	end




endmodule