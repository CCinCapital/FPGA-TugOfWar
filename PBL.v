module pbl(switch, pbl, pbr, pbl_AI, rst, clear, push, tie, right); 
	input 	pbl, 
			pbr, 
			pbl_AI, 
			rst, 
			clear, 
			switch;	//switch is used to select the battle opponent
	output	push, 
			tie, 
			right;

	wire leftPush;
	//use intermediary value trig for the trigger for each RS latch 
	wire trG;
	wire trH;
	wire Gx;
	wire Hx;
	
	assign isPbr = pbr & switch;		//Human is required when switch is high
	assign isAI = pbl_AI & ~switch;		//AI will join the game when siwtch is low
	
	assign leftPush = isPbr | isAI;		//one player is always required on right side, either human or AI may use the left side.
	
	assign trigH = (leftPush)&~G;
	assign trigG = pbl&~H;
	
	assign Gx = (trigG | G);
	assign G = Gx & ~(rst|clear);
	
	assign Hx = (trigH | H);
	assign H = Hx & ~(rst|clear);
	
	assign push = (G|H);
	assign tie = (G&H);
	
	assign right = ((H&~G)&~tie);
endmodule
	
