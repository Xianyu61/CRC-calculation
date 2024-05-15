module maichong(
	input clk,
	output reg p
);
	parameter [25:0] MAX = 26'd49999; 
	reg [25:0] cnt;
	initial begin
		p <= 1'b0;
		cnt <= 1'b0;
	end
   always @(posedge clk) begin
		cnt <= cnt + 1'b1;
		if (cnt == MAX) begin
			p <= 1'b1;
			cnt <= 1'b0;
		end 
		else begin
			p <= 1'b0;
		end
	 end
endmodule