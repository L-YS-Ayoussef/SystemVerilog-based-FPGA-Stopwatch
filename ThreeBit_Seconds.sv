module ThreeBit_Seconds (
	input clk,    // Clock
   input m,
   input reset,
   input pause,
   output [2:0]o
	
);

wire [2:0]qcomp;
wire [2:0]intermedites1;
wire [2:0]intermedites2;
wire count_down_res;
wire count_up_res;
wire res0;
wire res1;
wire res2;
wire set0;
wire set1;

wire Wand0; 
wire Wnor0;

and(Wand0, m, reset);
nor(Wnor0, m, ~reset);




T_Flip_Flop tff1(clk, 1'd1,set0,res0,pause,o[0],qcomp[0]);
and (intermedites1[0],~m,o[0]),(intermedites1[1],m,qcomp[0]);
or (intermedites1[2],intermedites1[0],intermedites1[1]);
T_Flip_Flop tff2(clk,intermedites1[2],set1,res1,pause,o[1],qcomp[1]);
and (intermedites2[0],intermedites1[0],o[1]),(intermedites2[1],intermedites1[1],qcomp[1]);
or (intermedites2[2],intermedites2[0],intermedites2[1]);
T_Flip_Flop tff3(clk,intermedites2[2],count_down_res,res2,pause,o[2],qcomp[2]);








and(count_down_res,m,o[0],o[1],o[2]); // count down
and(count_up_res,~m,o[2],o[1]);       // count up



or(res0, Wnor0, count_up_res);
or(res1, count_up_res, count_down_res);
or(res2, count_up_res, Wnor0, Wand0);

or(set0, Wand0, count_down_res);
or(set1, Wand0, Wnor0);


endmodule