module FullAdder (
	input d1,
	input d0,
	input Cin,
	output sum,
	output carry
);

wire Xor;
wire Wand[1:0];

xor(Xor,d1,d0);
and(Wand[0],d1,d0);
and(Wand[1],Xor,Cin);
xor(sum,Xor,Cin);
or(carry,Wand[0],Wand[1]);

endmodule