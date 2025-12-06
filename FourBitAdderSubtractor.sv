module FourBitAdderSubtractor (
	input Add_Or_Subtract,
	input [3:0]d,
	output [3:0]s,
	output cout
);

wire intermedite[2:0];

FullAdder fa0(d[0],Add_Or_Subtract,Add_Or_Subtract,s[0],intermedite[0]);
FullAdder fa1(d[1],~Add_Or_Subtract,intermedite[0],s[1],intermedite[1]);
FullAdder fa2(d[2],Add_Or_Subtract,intermedite[1],s[2],intermedite[2]);
FullAdder fa3(d[3],Add_Or_Subtract,intermedite[2],s[3],cout);


endmodule