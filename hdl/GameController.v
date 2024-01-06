module GameController (

//-------CLOCK-------
input i_ADC_CLK_10,
input i_CLK1_50,
input i_CLK2_50



);

wire w_clock;
assign w_clock = i_ADC_CLK_10;

endmodule