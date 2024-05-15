module clear_key(
	input clk,
	input sample_enable,
	input key_in,
	output reg clear_key
);
	reg last_key;
	initial begin
		last_key <= 1'b0;
		clear_key<= 1'b0;
	end
	always @(posedge clk) begin
		if (sample_enable)begin
		last_key<=key_in;
			if(last_key==key_in)begin
				clear_key<=key_in;
			end
		end
	end
endmodule	