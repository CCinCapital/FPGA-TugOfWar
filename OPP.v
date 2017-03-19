module opp(sypush, clk, rst, winrnd);
	input sypush, clk, rst;
	output winrnd;

	reg Q;

	always @ (posedge clk) 
	begin
		if(rst)
			Q <= 0;
		else
			Q <= sypush;
	end
	assign winrnd = sypush & ~Q;

endmodule
		
