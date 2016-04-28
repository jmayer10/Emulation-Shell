`timescale 1ps/1ps

module sim_ddr_tb;

parameter halfclk200 = 2500;
parameter halfclk100 = 1250;

reg clk_in, D, reset, S, clk100;
reg D1,D2, sel;
wire Q1, Q2;
reg [3:0] counter;

initial begin
reset = 1'b0 ;
#(1*halfclk200)
reset = 1'b1;
#(8*halfclk200)
reset = 1'b0 ;
end

initial begin
   clk_in = 1'b1;
   forever #(halfclk200) clk_in = ~clk_in;
end

initial begin
   clk100 = 1'b1;
   forever #(halfclk100) clk100 = ~clk100;
end

sim_ddr iddr (
   .Q1(Q1),
   .Q2(Q2),
   .C(clk_in),
   .CE(1'b1),
   .D(D),
   .R(reset),
   .S(1'b0)
);

always @ (posedge clk100 or posedge reset) begin
   if (reset) begin
      D<= 1'b0;
      sel <= 1'b0;
      D1 <= 1'b0;
      D2 <= 1'b0;
      counter <= 4'h0;
   end
   else begin
      sel <= !sel;
      counter <= counter + 1;
      D1 <= counter[0];
      D2 <= counter [2];
      D <= sel ? D2 : D1; 
   end
end

endmodule
