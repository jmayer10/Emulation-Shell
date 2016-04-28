`timescale 1ps/1ps

module sim_pll_tb;

parameter halfclk200 = 2500;

reg clk_in_n, clk_in_p, reset;
wire locked;
wire [4:0] clk_out;

initial begin
reset = 1'b0 ;
#(1*halfclk200)
reset = 1'b1;
#(8*halfclk200)
reset = 1'b0 ;
end

initial begin
   clk_in_p = 1'b1;
   forever #(halfclk200) clk_in_p = ~clk_in_p;
end

always @ (*) begin
   clk_in_n <= !clk_in_p;
end

sim_pll #(.CLK0_PERIOD(12500), .CLK1_PERIOD(3125)) mypll
(
   .clk_in_p(clk_in_p),
   .clk_in_n(clk_in_n),
   .reset(reset),
   .locked(locked),
   .clk_out(clk_out)
);

endmodule
