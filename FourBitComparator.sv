module FourBitComparator(
	input A3, 
	input A2, 
	input A1, 
	input A0,
	input B3, 
	input B2, 
	input B1, 
	input B0,
	output Greater, 
	output Equal,
	output Less
);


wire xnor1, xnor2, xnor3, xnor4;
xnor(xnor1, A3, B3);
xnor(xnor2, A2, B2);
xnor(xnor3, A1, B1);
xnor(xnor4, A0, B0);

////////////////////////////////////////////////////////

wire and1, and2, and3, and4, and5, and6, and7, and8;

and(and1, A3, ~B3);
and(and2, A2, ~B2, xnor1);
and(and3, A1, ~B1, xnor1, xnor2);
and(and4, A0, ~B0, xnor1, xnor2, xnor3);

and(and5, ~A3, B3);
and(and6, ~A2, B2, xnor1);
and(and7, ~A1, B1, xnor1, xnor2);
and(and8, ~A0, B0, xnor1, xnor2, xnor3);

////////////////////////////////////////////////////////

or(Greater, and1, and2, and3, and4);
and(Equal, xnor1, xnor2, xnor3, xnor4);
or(Less, and5, and6, and7, and8);

endmodule