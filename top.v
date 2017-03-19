module top(CLK_I, rst, switch, pbr, pbl, Led);
	// External Input
    input wire CLK_I; 	//clock from FPGA board
    input wire rst;		//reset button
    input wire pbr;		//right push button
    input wire pbl;		//left push button
	input wire switch;	//switch bettwen battle AI and battle Human
	 
	// Output of System 
    output wire [6:0] Led;	//7 leds

	// Internal Connections
	wire 	clear, 		
			push, 		
			tie, 		
			right, 		
			winrnd, 	
			leds_on, 	
			slowen, 	
			rout, 		
			sypush, 	
			pbl_AI, 	
			clk;		// 500Hz Clock used to drive the game.
	wire [1:0] leds_ctrl;
	wire [6:0] score;

// Clock	
// Slow down the on board clock to the desired 500Hz
// Input: 	CLK_I 	=> Clock from FPGA Board
// 		  	rst   	=> Hard reset button
// Output: 	clk		=> CLK_I / 256 = 500Hz clock master clock
	clk_div	clk_div(	.CLK_I(CLK_I),
						.rst(rst), 
						.clk(clk) );

// Clock divider
// Gives a pulse of one-clock-cycle wide every 256 clock cycles => slowen.
// The pulse is used to drive the flip-flops of the game.
// Input:	clk		=> master clock
// 			rst		=> Hard reset button
//			winrnd	=> someone won the round signal form "OPP"
// Output:	slowen	=> One High pulse every 256 clock cycles
	div256 div256_1(	.clk(clk),
						.rst(rst),
						.winrnd(winrnd), 
						.slowen(slowen));
						
// Pseudo random bit generator
// Generate a semi-randomly generated Rout HIGH used to drive game's finite state machine
// Input: 	clk		=> master clock
//			rst		=> Hard reset button
// Output:	rout	=> semi-randomly generated Rout HIGH
	lfsr lfsr1(		.clk(clk), 
					.rst(rst), 
					.rout(rout));

// Master controller
// Controls the flow of game, the states of FSM, and the light of LEDs
// Input: 	clk		=> master clock
//			rst		=> Hard reset button
//			rout	=> semi-randomly generated Rout HIGH from "lfsr"
//			winrnd	=> someone won the round signal form "OPP"
//			slowen 	=> Slowed one-clock-cycle wide pulse from "div256"
// Output:	leds_on	=> High if enters certain state
//			leds_ctrl=>two bit control signal used to control LED_Mux 
//			clear	=> High to clear user user input of "pbl"
	mc mc1(		.clk(clk),
				.rst(rst),
				.rout(rout), 
				.winrnd(winrnd), 
				.slowen(slowen), 
				.leds_on(leds_on), 
				.leds_ctrl(leds_ctrl), 
				.clear(clear));
					
// Push button latch
// Listen to the button push events and latch the events
// Input:	pbl		=> left push button
//			pbr		=> right push button
//			switch	=> external switch used to change game mode
//			pbl_AI	=> AI button push events
//			rst		=> Hard reset button
//			clear	=> clear current event, from "MC"
// Output:	push	=> High if one button was pushed
//			tie		=> High if buttons were pushed at the same time
//			right	=> High if pbr was pushe first
	pbl pbl1(	.pbl(pbl),
				.pbr(pbr),
				.switch(switch),
				.pbl_AI(pbl_AI),
				.rst(rst),
				.clear(clear),
				.push(push), 
				.tie(tie), 
				.right(right));

// AI Player
// AI joins game when switch is High
// input:	rst		=> Hard reset button	
//			state	=> current state of game
//			clk		=> Master clock
// output:	pbl_AI	=> AI button push event
	battleAI battleAI(	.rst(rst),
						.state(leds_ctrl), 
						.clk(clk), 
						.pbl_AI(pbl_AI));				
					
// Synchronizer
// Sync the async user push signal "push" to master clock
// Input:	push	=> User async push from "pbl"
//			clk		=> Master clock
//			rst		=> Hard reset button
// Output:	sypush	=> Synced push
	synchronizer sync1(	.push(push), 
						.clk(clk), 
						.rst(rst), 
						.sypush(sypush));
						
// One Pules Per Push
// Generates Win Round signal
// Input: 	sypush	=> Synced User push from "Synchronizer"
//			clk		=> Master clock
//			rst		=> Hard reset button
// Output:	winrnd	=> High when sypush is high, only last one clock cycle
	opp opp1(			.sypush(sypush), 
						.clk(clk), 
						.rst(rst), 
						.winrnd(winrnd));
						
// Scorer with "Faver the Loser" logic
// Detemines game score of each button push event
// Input: 	winrnd	=> One clock cycle HIGH win round
//			right	=> Player on the right side pushed first?
//			leds_on => Game state "Leds_on"
//			clk		=> Master clock
//			rst		=> Hard reset button	
//			tie		=> Both buttons were pushed at the same time?
// Output:	score	=> Current score of Game		
	scorer score1(		.winrnd(winrnd), 
						.right(right), 
						.leds_on(leds_on), 
						.clk(clk), 
						.rst(rst), 
						.tie(tie),
						.score(score));

// Led mux
// Drives LEDs based on leds_ctrl from "MC" and score from "Scorer"
// Input:	score	=> Current score of Game
//			leds_ctrl=>Mux control signal
// Output:	leds_on	=> Light on the corresponding External LEDs.
	ledmux ledmux1(		.score(score), 
						.leds_ctrl(leds_ctrl), 
						.leds_out(Led));
						
endmodule      