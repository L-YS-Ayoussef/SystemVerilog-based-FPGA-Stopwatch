module clk_div_pll (
	input clk_in,
	output reg Clock_out
);

reg [30:0] counter;

initial begin
	Clock_out = 0;
end

always @(posedge clk_in)
begin
	counter = counter + 1;
	if (counter == 25000000)
	begin
		Clock_out = ~Clock_out;
		counter = 0;
	end

end



endmodule