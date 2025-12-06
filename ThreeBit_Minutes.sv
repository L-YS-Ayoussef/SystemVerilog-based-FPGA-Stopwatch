module ThreeBit_Minutes (
   input clk,    // Clock
   input m,
   input reset,
   input pause,
   input ForceClock,
   output [2:0]o
);

wire [2:0]qcomp;
wire [2:0]intermedites1;
wire [2:0]intermedites2;

wire OrClock;
wire reserFin;
wire reset1;
wire reset2;
wire andClockPause;
wire PauseForce;



and(andClockPause, clk, ~ForceClock);
or(OrClock, ForceClock, andClockPause);
mux21 muxForcePause(PauseForce, pause, ~ForceClock, ForceClock);


wire buffer1, buffer2, buffer3, buffer4, newCLk;

buf(buffer1, OrClock);
buf(buffer2, buffer1);
buf(buffer3, buffer2);
buf(buffer4, buffer3);
buf(newCLk, buffer4);


T_Flip_Flop tff1(newCLk, 1'd1,reset2,reset1,PauseForce,o[0],qcomp[0]);
and (intermedites1[0],~m,o[0])   ,    (intermedites1[1],m,qcomp[0]);
or (intermedites1[2],intermedites1[0],intermedites1[1]);


T_Flip_Flop tff2(newCLk, intermedites1[2], 0,reserFin,PauseForce,o[1],qcomp[1]);
and (intermedites2[0],intermedites1[0],o[1])   ,   (intermedites2[1],intermedites1[1],qcomp[1]);
or (intermedites2[2],intermedites2[0],intermedites2[1]);

T_Flip_Flop tff3(newCLk, intermedites2[2],reset1,reset2,PauseForce,o[2],qcomp[2]);





nor(reset2, ~reset, m);
and (reset1, m, reset);
or(reserFin, reset1, reset2);


endmodule