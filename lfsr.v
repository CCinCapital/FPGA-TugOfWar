module lfsr(clk, rst, rout);
	input wire clk;
	input wire rst;
	output wire rout;
	
	reg[9:0] lfsr;

	always@(posedge clk or posedge rst)
		if (rst) lfsr[9:0] <= 1;
		else
		begin
			lfsr[8:0] <= lfsr[9:1];
			lfsr[9] <= lfsr[0]^lfsr[3];
		end

	assign rout = lfsr[9];

endmodule
