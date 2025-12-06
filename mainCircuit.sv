module mainCircuit(
   input clkfpga,    
   input m,
   input reset,
   input pause,
   input AddORSub,
   input speedup, 
   input speeddown, 
   output [6:0]seven_Dashes_counter1,
   output [6:0]seven_Dashes_counter2,
   output [6:0]seven_Dashes_counter3,
   output [6:0]seven_Dashes_counter4
);

//----------------------SET THE GENARAL GATES-------------------------------------

// MODE
wire and_sub_to_reset1, and_sub_to_reset2, and_sub_to_reset3;
wire finalReset;
wire output_mode;
wire clk;
clk_div_pll div(clkfpga,clk);
ModeWithPause main_mode(clk, m, pause, output_mode);

wire [3:0]o1;
wire [2:0]o2;
wire [3:0]o3;
wire [2:0]o4;

// Flash

wire flash5;
wire flashNone;
wire dWire;

wire And_Flash_Start;
and(And_Flash_Start, speedup, speeddown);


// RESET  

//PAUSE

wire and2, nor4, nor5, nor6;
wire orPAUSE_12, andPAUSE_8, andPAUSE_3;

and (and2, o2[0], o2[1], o3[0], o3[3], ~output_mode, o4[2]);  
nor(nor4, o1[3], o1[2], o1[1], o1[0]); 
and(andPAUSE_3, nor4, and2);  

nor(nor5, o2[0], o2[2]); 
nor(nor6, o3[0], o3[1], o3[2], o3[3]); 
and (andPAUSE_8, nor4, o2[1], nor5, nor6, o4[0], ~o4[1], output_mode); 

or(orPAUSE_12, pause, andPAUSE_8, andPAUSE_3, And_Flash_Start);



//TWO Muxes

wire andForTwoMuxes;
and(andForTwoMuxes, ~AddORSub, ~orPAUSE_12);

wire and_Mux1, and_Mux2;
and (and_Mux1, 1'd1, output_mode);
and (and_Mux2, 1'd1, ~output_mode);

wire muxOut1, muxOut2;
mux21 M3(muxOut1, 1'd0, and_Mux1, andForTwoMuxes);
mux21 M4(muxOut2, 1'd0, and_Mux2, andForTwoMuxes);




// CLOCK DIVIDER 

wire [2:0]clks;
wire clkeff;

Clock_Divider clkdiv(clk,clks[0],clks[1],clks[2]);

mux42 m42(clkeff,clks[0],clks[1],clks[2],0,speedup,speeddown);





D_Flip_Flop D_Flip_Flop_Flash(emptyclk2, dWire, clk, ~clk, 1, flash5, flashNone);


//-------------FourBitCounterSeconds - UP - DOWN -----------------------------

FourBitCounterSeconds counter1(clkeff, output_mode, finalReset, orPAUSE_12, o1); 

wire  and_1UP, nor_1DOWN, orUP_DOWN_1;


nor(nor_1DOWN, o1[0], o1[1],o1[2],o1[3], ~output_mode);
and(and_1UP, ~output_mode, o1[0], o1[3]);  
or(orUP_DOWN_1, nor_1DOWN, and_1UP);  

//wire [6:0]seven_Dashes_counter1;
Decoder_Seven_Segments Seven_Segment1(o1[0], o1[1], o1[2], o1[3], flash5, And_Flash_Start, flashNone, seven_Dashes_counter1);


// Comparators for reset  
wire great_4_sec_add, less_4_sec_add, equal_4_sec_add;
FourBitComparator comp_4_sec_add(o1[3], o1[2],o1[1], o1[0], 0, 0, 0, 0, great_4_sec_add, equal_4_sec_add, less_4_sec_add);

wire great_4_sec_sub, less_4_sec_sub, equal_4_sec_sub;
FourBitComparator comp_4_sec_sub(o1[3], o1[2],o1[1], o1[0], 0, 0, 0, 0, great_4_sec_sub, equal_4_sec_sub, less_4_sec_sub);



//-------------THREE Bit Counter Seconds - UP - DOWN - CLK - PAUSE-----------------------------

wire nor_2_DOWN, and_2_UP, orUP_DOWN_2;  //WIRES UP DOWN
wire or_2_pause;  // WIRES PAUSE

nor(nor_2_DOWN, o2[0], ~output_mode, o2[1], o2[2]);
and(and_2_UP, ~output_mode, o2[0], o2[2]);  

or(orUP_DOWN_2, and_2_UP, nor_2_DOWN);  


or (or_2_pause, ~orUP_DOWN_1, orPAUSE_12);  



ThreeBit_Seconds counter2(clkeff, output_mode, finalReset, or_2_pause, o2);  

//wire [6:0]seven_Dashes_counter2;
Decoder_Seven_Segments Seven_Segment2(o2[0], o2[1], o2[2], 0, flash5, And_Flash_Start, flashNone, seven_Dashes_counter2);


// Comparators for reset  
wire great_3_sec_add, less_3_sec_add, equal_3_sec_add;
FourBitComparator comp_3_sec_add(0, o2[2],o2[1], o2[0], 0, 0, 1, 1, great_3_sec_add, equal_3_sec_add, less_3_sec_add);

wire great_3_sec_sub, less_3_sec_sub, equal_3_sec_sub;
FourBitComparator comp_3_sec_sub(0, o2[2],o2[1], o2[0], 0, 0, 1, 0, great_3_sec_sub, equal_3_sec_sub, less_3_sec_sub);


//-------------FOUR Bit Counter MINUTES - UP - DOWN - CLK - PAUSE-----------------------------

wire nor_3_DOWN, and_3_UP, orUP_DOWN_3;  //WIRES UP DOWN
wire or_3_pause;  // WIRES PAUSE
wire and_3_toPause;
wire nand_rev_pause1;
wire nand_rev_pause2;
wire nand_rev_pause3;
wire and_final_Pause;



nor(nor_3_DOWN, o3[0], o3[1], o3[2], o3[3], ~output_mode);
and(and_3_UP, o3[0], o3[3], ~output_mode);  
or(orUP_DOWN_3, nor_3_DOWN, and_3_UP); 

nand(nand_rev_pause1, o3[0], o3[1], o3[2], o3[3]);
nand(nand_rev_pause2, o3[1], o3[3]);
nand(nand_rev_pause3, ~o3[0], o3[1], o3[2], o3[3]);




and(and_3_toPause, orUP_DOWN_2, orUP_DOWN_1);
or(or_3_pause, ~and_3_toPause, orPAUSE_12);  


and(and_final_Pause, or_3_pause, ~finalReset, ~muxOut2, ~muxOut1, nand_rev_pause1, nand_rev_pause2, nand_rev_pause3);

wire ForceClock;
FourBitCounterMinutes counter3(clkeff, output_mode, finalReset, muxOut2, muxOut1, and_final_Pause, ForceClock, o3); 

//wire [6:0]seven_Dashes_counter3;
Decoder_Seven_Segments Seven_Segment3(o3[0], o3[1], o3[2], o3[3], flash5, And_Flash_Start, flashNone, seven_Dashes_counter3);



wire and_sub1;
wire and_sub2;

wire nor_add1;
wire nor_add2;
wire or_add;

wire and_with_add;
wire and_with_sub;
wire and_add_sub;

wire and_final_force;

wire ForceClock2;

and(and_sub1, o3[0], o3[1], o3[2], ~o3[3]);
and(and_sub2, ~o3[0], ~o3[1], ~o3[2], o3[3]);

nor(nor_add1, o3[0], o3[1], o3[2], o3[3]);
nor(nor_add2, ~o3[0], o3[1], o3[2], o3[3]);
or(or_add, nor_add1, nor_add2);

and(and_with_add, or_add, muxOut2);
and(and_with_sub, and_sub2, muxOut1);

and(and_add_sub, ~and_sub1, ~and_with_sub);


and(and_final_force, and_add_sub, ~and_with_add, ForceClock);

D_Flip_Flop D_Flip_Flop_ClockNext(emptyCLK, emptyD, and_final_force, ~and_final_force, 1, ForceClock2, emptyQnot);



// Comparators for reset  
wire great_4_min_add, less_4_min_add, equal_4_min_add;
FourBitComparator comp_4_min_add(o3[3], o3[2],o3[1], o3[0], 1, 0, 0, 1, great_4_min_add, equal_4_min_add, less_4_min_add);

wire great_4_min_sub, less_4_min_sub, equal_4_min_sub;
FourBitComparator comp_4_min_sub(o3[3], o3[2],o3[1], o3[0], 0, 0, 0, 0, great_4_min_sub, equal_4_min_sub, less_4_min_sub);



//-------------THREE Bit Counter MINUTES - ADD - SUB - CLK - PAUSE-----------------------------


wire and_4_toPause;

and(and_4_toPause, orUP_DOWN_3, and_3_toPause);
or(or_4_pause, ~and_4_toPause, orPAUSE_12); 




ThreeBit_Minutes counter4(clkeff, output_mode, finalReset, or_4_pause, ForceClock2, o4);  

//wire [6:0]seven_Dashes_counter4;
Decoder_Seven_Segments Seven_Segment4(o4[0], o4[1], o4[2], 0, flash5, And_Flash_Start, flashNone, seven_Dashes_counter4);




// Comparators for reset  
wire great_3_min_add, less_3_min_add, equal_3_min_add;
FourBitComparator comp_3_min_add(0, o4[2],o4[1], o4[0], 0, 1, 0, 0, great_3_min_add, equal_3_min_add, less_3_min_add);

wire great_3_min_sub, less_3_min_sub, equal_3_min_sub;
FourBitComparator comp_3_min_sub(0, o4[2],o4[1], o4[0], 0, 0, 0, 1, great_3_min_sub, equal_3_min_sub, less_3_min_sub);


//-------------------------------------------*****---------------------------------------------------


// ----------------------COMPARATORS ADD CONNECTIONS ----------------------------------

// Add - not to over 49:30
wire and_add1, and_add2, and_add3;
wire or_add_to_reset;
and(and_add1, great_3_min_add, great_4_min_add);
and(and_add2, great_3_min_add, great_4_min_add, great_3_sec_add);
and(and_add3, great_3_min_add, great_4_min_add, great_3_sec_add, great_4_sec_add);
or(or_add_to_reset, great_3_min_add, and_add1, and_add2, and_add3);


// Sub - not to down 10:20
wire or_sub_to_reset;

and(and_sub_to_reset1, less_3_min_sub, equal_4_min_sub);
and(and_sub_to_reset2, less_3_min_sub, equal_4_min_sub, less_3_sec_sub);
and(and_sub_to_reset3, less_3_min_sub, equal_4_min_sub, less_3_sec_sub, equal_4_sec_sub);
or(or_sub_to_reset, less_3_min_sub, and_sub_to_reset1, and_sub_to_reset2, and_sub_to_reset2);



or(finalReset, ~reset, or_add_to_reset, or_sub_to_reset);

endmodule
