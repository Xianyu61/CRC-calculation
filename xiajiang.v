module xiajiang(
	input a,
	input clk,
	output e
);

	reg d;
	wire b;
	reg c;
	assign b = ~a;
	assign e = b & c;
	
	initial begin
	d <= 1'b0;
	c <= 1'b0;
end
	always @(posedge clk)begin
	d <= a;
	c <= d;
end

endmodule 