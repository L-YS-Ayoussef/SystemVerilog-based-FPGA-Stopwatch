module D_Flip_Flop( Clock,
                   D,
                   Preset,
                   Reset,
                   Tick,
                   Q,
                   Q_bar);

   parameter ActiveLevel = 1;

   input  Clock;
   input  D;
   input  Preset;
   input  Reset;
   input  Tick;


   output Q;
   output Q_bar;


   wire s_next_state;
   reg[1:0] s_current_state_reg;

   assign Q     = s_current_state_reg[ActiveLevel];
   assign Q_bar = ~(s_current_state_reg[ActiveLevel]);

   assign s_next_state = D;

   initial
   begin
      s_current_state_reg = 0;
   end

   always @(posedge Reset or posedge Preset or negedge Clock)
   begin
      if (Reset) s_current_state_reg[0] <= 1'b0;
      else if (Preset) s_current_state_reg[0] <= 1'b1;
      else if (Tick) s_current_state_reg[0] <= s_next_state;
   end

   always @(posedge Reset or posedge Preset or posedge Clock)
   begin
      if (Reset) s_current_state_reg[1] <= 1'b0;
      else if (Preset) s_current_state_reg[1] <= 1'b1;
      else if (Tick) s_current_state_reg[1] <= s_next_state;
   end


endmodule
