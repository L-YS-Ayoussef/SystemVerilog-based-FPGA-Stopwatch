module T_Flip_Flop (
  input wire clk,
  input wire t,
  input wire set,
  input wire reset,
  input wire enable,
  output wire q,
  output wire not_q
);
reg q_reg, not_q_reg;

//initial
   //begin
     // q_reg = 0;
   //end
  always @(posedge clk or posedge set or posedge reset) begin
    if (reset) begin
      q_reg <= 1'b0;
      not_q_reg <= 1'b1;
    end else if (set) begin
      q_reg <= 1'b1;
      not_q_reg <= 1'b0;
    end else if(!enable)begin
      if(t) begin
         q_reg <= not_q_reg;
      not_q_reg <= q_reg;
	
      end
	
    end
  end
assign q = q_reg;
assign not_q = not_q_reg;
endmodule
