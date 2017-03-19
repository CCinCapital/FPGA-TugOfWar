module mc(clk, rst, rout, winrnd, slowen, leds_on, leds_ctrl, clear);
	input wire clk;
	input wire rst;
	input wire rout;
	input wire winrnd;
	input wire slowen;
	output reg leds_on;
	output reg [1:0] leds_ctrl;
	output reg clear;

	//states
	`define RESET  3'b000
	`define wait_a  3'b001
	`define wait_b  3'b010
	`define dark  3'b011
	`define play  3'b100
	`define gloat_a  3'b101
	`define gloat_b  3'b110
	reg [2:0] state;
	reg [2:0] next_state;

	always@(posedge rst or posedge clk)
		if(rst) state <= `RESET;
		else state <= next_state;

	always@(state or rst or slowen or winrnd or rout)
	begin
		case(state)
			`RESET: 	if(~rst)next_state <= `wait_a;
						else next_state <= `RESET;
			`wait_a: 	if(slowen) next_state <= `wait_b;
						else next_state <= state;
			`wait_b:	if(slowen) next_state <= `dark;
						else next_state <= state;
			`dark:		if(slowen & rout) next_state <= `play;
						else if(winrnd) next_state <= `gloat_a;
						else next_state <= state;	
			`play: 		if(winrnd) next_state <= `gloat_a;
						else next_state <= state;
			`gloat_a: 	if(slowen) next_state <= `gloat_b;
						else next_state <= state;
			`gloat_b: 	if(slowen) next_state <= `dark;
						else next_state <= state;
			default: 	next_state <= state;
		endcase
	end
	
	always@(state)
	begin
		case(state)
			`RESET: 		begin clear	<= 1; leds_on <= 1; leds_ctrl <= 2'b01; end
			`wait_a: 		begin clear <= 1; leds_on <= 1; leds_ctrl <= 2'b11; end
			`wait_b: 		begin clear <= 1; leds_on <= 1; leds_ctrl <= 2'b11; end
			`dark: 			begin clear <= 0; leds_on <= 0; leds_ctrl <= 2'b00; end
			`play: 			begin clear <= 0; leds_on <= 1; leds_ctrl <= 2'b10; end
			`gloat_a:		begin clear <= 1; leds_on <= 1; leds_ctrl <= 2'b10; end
			`gloat_b:		begin clear <= 1; leds_on <= 0; leds_ctrl <= 2'b10; end
			default:		begin clear <= 1; leds_on <= 1; leds_ctrl <= 2'b01; end
		endcase
	end

endmodule
