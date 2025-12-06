module ModeWithPause( 
   input clk,  
   input mode,  
   input pause,
   output modeOut  
);




wire and1, and2;
and (and1, pause, ~mode);
and (and2, pause, mode);

wire and3, and4;

and (and3, ~pause, ~modeOut);
and (and4, ~pause, modeOut);


wire or1, or2;
or(or1, and3, and1);
or(or2, and4, and2);

wire mux1;
mux21 M1(mux1, ~or1, or2, mode);

wire empty;
D_Flip_Flop D1(clk, mux1, 0, 0, 1, modeOut, empty);

endmodule

