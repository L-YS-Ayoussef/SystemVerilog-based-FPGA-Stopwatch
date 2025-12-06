module mux21(out,a,b,s);
input a,b,s;
wire and_1,and_2,s_c;
output out;
not (s_c,s);
and (and_1,a,s_c);
and (and_2,b,s);
or (out,and_1,and_2);
endmodule