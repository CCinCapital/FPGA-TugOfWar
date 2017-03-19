/*
This module is the AI that sends a pbl_AI signal every time when the game enters dark state with a short delay.
AI has a small chance to jump the light, it depends on how soon the game enters play state from dark state.
*/


module battleAI(rst, state, clk, pbl_AI);
	
	input wire [1:0] state;
	input wire clk, rst;
	
	output reg pbl_AI;  								//AI button push signal

	reg [10:0] count = 0; 							//AI wait until 'count = count_to' to push the button
	reg [10:0] count_to = 11'b10010101111; 	//number depends on the "Difficulty" of the AI, the larger count_to, the easier the AI to gainst with.

	reg new_round; 									//indicates if AI've pushed the button in the round or not
		
	always@(posedge clk or posedge rst)
	begin
		if(rst) pbl_AI <= 0;							//Initiate the signal
		else
		begin
			if(state == 2'b00) 						//Enter the dark state means new round. new_round => 1
			begin 
				new_round <= 1;
			end
			else if(state == 2'b00 | state == 2'b10) //count will keep increment within Dark state and Play state
			begin
				if((count == count_to) && new_round)
				begin 
					pbl_AI <= 1;      //AI press the push button 
					count <= 0;       //reset the counter, prepare for next round 
					new_round <= 0;   //change the status to 'pushed within the round', so this if statement will not be excuted again until next round
				end
				else	count <= count + 1'b1;
			end
			if(pbl_AI == 1) pbl_AI <= 0; 			//release the push button
		end
	end
endmodule
