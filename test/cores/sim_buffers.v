//Simulaiton replacement for any BUFG etc. primitives
module sim_buf(
   input  I,
   output O
);

assign O = I;

endmodule

//Simulation replacement for IBUFDS
module sim_ds2s_buf(
   output O,
   input  I,
   input  IB
);

assign O = I & !IB;

endmodule

//Simulation replacement for single to differential signalling
module sim_s2ds_buf (
   input  I,
   output O,
   output OB
);

assign O  = I;
assign OB = !I;

endmodule
