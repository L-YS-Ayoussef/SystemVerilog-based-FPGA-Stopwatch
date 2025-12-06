module FourBitCounterMinutes (
   input clk,    // Clock
   input m,
   input reset,
   input add2,
   input sub2,
   input pause,
   output forceclock,
   output [3:0]o
);

wire [3:0]qcomp;
wire [2:0]intermedites1;
wire [2:0]intermedites2;
wire [2:0]intermedites3;
wire [3:0]oinit;

wire Wand16;
wire Wand17;
wire Wand18;
wire Wand19;

wire Wand20;
wire Wand21;
wire Wand22;
wire Wand23;


wire OrReset1, OrReset2, OrReset3, OrReset4;
wire OrSet1, OrSet4;



T_Flip_Flop tff1(clk,1'd1,OrSet1,OrReset1,pause,oinit[0],qcomp[0]);
and (intermedites1[0],~m,oinit[0]),(intermedites1[1],m,qcomp[0]);
or (intermedites1[2],intermedites1[0],intermedites1[1]);
T_Flip_Flop tff2(clk,intermedites1[2],Wand21,OrReset2,pause,oinit[1],qcomp[1]);
and (intermedites2[0],intermedites1[0],oinit[1]),(intermedites2[1],intermedites1[1],qcomp[1]);
or (intermedites2[2],intermedites2[0],intermedites2[1]);
T_Flip_Flop tff3(clk,intermedites2[2],Wand22,OrReset3,pause,oinit[2],qcomp[2]);
and (intermedites3[0],intermedites2[0],oinit[2]),(intermedites3[1],intermedites2[1],qcomp[2]);
or (intermedites3[2],intermedites3[0],intermedites3[1]);
T_Flip_Flop tff4(clk,intermedites3[2],OrSet4,OrReset4,pause,oinit[3],qcomp[3]);




wire Wnor0;
wire Wand0;
nor(Wnor0,~reset,m);
and(Wand0,reset,m);
wire Wmux0;
mux21 mu0(Wmux0,~add2,sub2,sub2);
wire Wnor1;
wire Wor0;

nor(Wnor1,add2,sub2);
or(Wor0,add2,sub2);

wire [3:0]oregs;
wire w1, w2, w3, w4;
D_Flip_Flop d0(Wor0,oinit[0],1'd0,reset,1'd1,oregs[0], w1);

D_Flip_Flop d1(Wor0,oinit[1],1'd0,reset,1'd1,oregs[1], w2);
D_Flip_Flop d2(Wor0,oinit[2],1'd0,reset,1'd1,oregs[2], w3);
D_Flip_Flop d3(Wor0,oinit[3],1'd0,reset,1'd1,oregs[3], w4);

wire [3:0]oaddsub;
wire cout;
FourBitAdderSubtractor faddsub(Wmux0,oregs,oaddsub, cout);

wire [3:0]selectors;

mux21 mu1(o[0],oaddsub[0],oinit[0],selectors[0]);
mux21 mu2(o[1],oaddsub[1],oinit[1],selectors[1]);
mux21 mu3(o[2],oaddsub[2],oinit[2],selectors[2]);
mux21 mu4(o[3],oaddsub[3],oinit[3],selectors[3]);

wire Wand1;
wire Wand1_5;
wire orWand1;

and(Wand1,m,oinit[0],oinit[1],oinit[2],oinit[3]);
and(Wand1_5,m,~oinit[0],oinit[1],oinit[2],oinit[3]);

or(orWand1, Wand1, Wand1_5);

wire Wnor2;
wire Wnor3;
wire Wnor4;
wire Wnor5;

nor(Wnor2,o[0],o[2],~o[3],m);
nor(Wnor3,~o[0],o[2],~o[3],m);
nor(Wnor4,o[0],o[1],o[2],o[3],~m);
nor(Wnor5,~o[0],o[1],o[2],o[3],~m);

wire [3:0]dfwire6_4;
////////////////////////////////
wire [3:0]t;
D_Flip_Flop d4(Wnor1,Wnor2,1'd0,reset,1'd1,dfwire6_4[0], t[0]);
D_Flip_Flop d5(Wnor1,Wnor3,1'd0,reset,1'd1,dfwire6_4[1], t[1]);
D_Flip_Flop d6(Wnor1,Wnor4,1'd0,reset,1'd1,dfwire6_4[2], t[2]);
D_Flip_Flop d7(Wnor1,Wnor5,1'd0,reset,1'd1,dfwire6_4[3], t[3]);
////////////////////////////////
wire Wand2;
wire Wand3;
wire Wand4;
wire Wand4_5;

and(Wand2,Wor0,dfwire6_4[0]);
and(Wand3,Wor0,dfwire6_4[1]);
and(Wand4,Wor0,dfwire6_4[2]);
and(Wand4_5,Wor0,dfwire6_4[3]);


or(forceclock, Wand2, Wand3, Wand4, Wand4_5);    // Last Edit



wire Wor1;
/////////////////////////
or(Wor1,Wnor1,pause,Wand2);

or(selectors[3],Wand3,Wor1, reset);
or(selectors[2],Wand3,Wor1,Wand4, Wand4_5, reset);
or(selectors[1],Wand3,Wor1,Wand4, Wand4_5, reset);
or(selectors[0],Wand4,Wor1, reset);
//////////////////////////
wire Wand5;
wire Wand6;
wire Wand7;
wire Wand8;
wire Wand9;
wire Wand10;
wire Wand5_5;

and(Wand5_5,Wand4_5,Wor0);
and(Wand5,Wand4,Wor0);
and(Wand6,Wand3,Wor0);
and(Wand7,o[0],Wor0);
and(Wand8,o[1],Wor0);
and(Wand9,o[2],Wor0);
and(Wand10,o[3],Wor0);

wire Wand11;

and(Wand11,~m,oinit[3],oinit[1],Wnor1);




wire Wand12;
wire Wand13;
wire Wand14;
wire Wand15;

and(Wand12,~Wnor1,~o[3]);
and(Wand13,~Wnor1,~o[2]);
and(Wand14,~Wnor1,~o[1]);
and(Wand15,~Wnor1,~o[0]);

wire Wor2;
wire Wor3;
wire Wor4;
wire Wor5;

or(Wor2,Wand15,Wand11,Wand2,Wand4);
or(Wor3,Wand11,Wand2,Wand4,Wand1,Wand14,Wand3,Wand0, Wand4_5);
or(Wor4,Wand11,Wand2,Wand4,Wand3,Wand0,Wand13,Wand1, Wand4_5);
or(Wor5,Wand11,Wand2,Wand3,Wand12);



and(Wand16,Wor2,~pause, ~reset);
and(Wand17,Wor3,~pause, ~reset);
and(Wand18,Wor4,~pause, ~reset);
and(Wand19,Wor5,~pause, ~reset);


wire Wor6;
wire Wor7;

or(Wor6,Wand7,orWand1,Wand6, Wand5_5);
or(Wor7,orWand1,Wand5,Wand10, Wand5_5);


and(Wand20,~pause,Wor6, ~reset);
and(Wand21,~pause,Wand8, ~reset);
and(Wand22,~pause,Wand9, ~reset);
and(Wand23,~pause,Wor7, ~reset);





or(OrReset1, Wnor0, Wand16);
or(OrReset2, Wnor0, Wand17);
or(OrReset3, Wnor0, Wand18);
or(OrReset4, Wnor0, Wand19);

or(OrSet1, Wand0, Wand20);

or(OrSet4, Wand0, Wand23);







endmodule