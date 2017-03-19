module div256(clk, rst, winrnd, slowen);

	input wire clk;
	input wire rst;
	input wire winrnd;
	output wire slowen;
	reg [7:0] state;
	
	always@(posedge clk or posedge rst or posedge winrnd)
	begin
		if(rst) state <= 0;
		else if(winrnd) state <= 0;
		else state <= state + 1'b1;
	end	

	assign slowen = &state;
	
endmodule 
