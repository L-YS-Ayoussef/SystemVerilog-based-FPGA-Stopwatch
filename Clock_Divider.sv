module Clock_Divider( CLK,
                     Clock,
                     DoubleClock,
                     HalfClock);
   input  CLK;
   output Clock;
   output DoubleClock;
   output HalfClock;
   not(DoubleClock,CLK);
   wire nQ0;
   wire nQ1;
   D_Flip_Flop d0(CLK,nQ0,0,0,1,Clock,nQ0);
   D_Flip_Flop d1(nQ0,nQ1,0,0,1,HalfClock,nQ1);
endmodule
