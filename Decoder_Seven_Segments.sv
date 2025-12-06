module Decoder_Seven_Segments(

input num0,
input num1,
input num2,
input num3,
input flash5,
input start_flash, 
input flashNone, 
output [6:0]seven_Dashes
); 



wire [3:0]num;
buf(num[0], num3);
buf(num[1], num2);
buf(num[2], num1);
buf(num[3], num0);





//---------------TWO AND GATE -- DEALING WITH INPUTS---------------------
 wire and_1, and_2 ;
and(and_1, start_flash, flash5);
and(and_2, start_flash, flashNone);


//---------------FOUR MUXES ABOVE---------------------
wire [3:0]muxes_Wires;
mux21 m3(muxes_Wires[0], num[0], 0, and_1);
mux21 m4(muxes_Wires[1], num[1], 1, and_1);
mux21 m5(muxes_Wires[2], num[2], 0, and_1);
mux21 m6(muxes_Wires[3], num[3], 1, and_1);


//---------------GATES TO ORs---------------------
wire xnor_7, xnor_8;
xnor(xnor_7, ~muxes_Wires[3], ~muxes_Wires[1]);
xnor(xnor_8, muxes_Wires[3], muxes_Wires[2]);

wire and_9, and_10, and_11, and_12; 
and(and_9, ~muxes_Wires[1], ~muxes_Wires[3]);
and(and_10, ~muxes_Wires[1], muxes_Wires[2]);
and(and_11, ~muxes_Wires[3], muxes_Wires[2]);
and(and_12, ~muxes_Wires[2], muxes_Wires[1], muxes_Wires[3]);


wire and_13, and_14;
and(and_13, ~muxes_Wires[1], ~muxes_Wires[3]);
and(and_14, muxes_Wires[2], ~muxes_Wires[3]);

wire and_15, and_16, and_17;
and(and_15, ~muxes_Wires[3], ~muxes_Wires[2]);
and(and_16, muxes_Wires[1], ~muxes_Wires[2]);
and(and_17, ~muxes_Wires[3], muxes_Wires[1]);


wire and_18, and_19, and_20;
and(and_18, ~muxes_Wires[1], muxes_Wires[2]);
and(and_19, muxes_Wires[2], ~muxes_Wires[3]);
and(and_20, ~muxes_Wires[2], muxes_Wires[1]);



//----------------------------OR GATES----------------------
wire or_21, or_22, or_23, or_24, or_25, or_26, or_27; 
or(or_21, muxes_Wires[2], muxes_Wires[0], xnor_7);
or(or_22, ~muxes_Wires[1], xnor_8);
or(or_23, ~muxes_Wires[2], muxes_Wires[3], muxes_Wires[1]);
or(or_24, and_9, and_10, and_11, and_12);
or(or_25, and_13, and_14);
or(or_26, muxes_Wires[0], and_15, and_16, and_17);
or(or_27, muxes_Wires[0], and_18, and_19, and_20);



//--------------SEVEN SEGMENTs MUXES-----------------
mux21 m30(seven_Dashes[0], or_21, 0, and_2);
mux21 m31(seven_Dashes[1], or_22, 0, and_2);
mux21 m32(seven_Dashes[2], or_23, 0, and_2);
mux21 m33(seven_Dashes[3], or_24, 0, and_2);
mux21 m34(seven_Dashes[4], or_25, 0, and_2);
mux21 m35(seven_Dashes[5], or_26, 0, and_2);
mux21 m36(seven_Dashes[6], or_27, 0, and_2);

endmodule