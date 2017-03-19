module synchronizer(push, clk, rst, sypush);
	input push, clk, rst;
	output sypush;

	reg sypush;
	
	always @ (posedge clk)
	begin
		if(rst)
			sypush <= 0;
		else
			sypush <= push;
	end
endmodule


