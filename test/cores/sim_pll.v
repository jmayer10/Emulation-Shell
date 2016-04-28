`timescale 1ps/1ps

//Replicates (to some extend) the behavior of the Xilinx Core PLLs
//Only used in simulation
//Output clocks do not have to be multiples of input clock
//Clock periods should be in picoseconds or whatever your simulation resolution is.
//ALWAYS PUT CLOCKS IN ASCENDING ORDER OF PERIOD
module sim_pll #(parameter CLK0_PERIOD = 1000000,
                 parameter CLK1_PERIOD = 1000000,
                 parameter CLK2_PERIOD = 1000000,
                 parameter CLK3_PERIOD = 1000000,
                 parameter CLK4_PERIOD = 1000000)
(
   input clk_in_n,
   input clk_in_p,
   input reset,
   output locked,
   output [4:0] clk_out //Max 5 different output clocks
);

   reg locked_i;
   reg clks_i [4:0];
   reg [13:0] lock_count;

   always@(posedge clk_in_n or posedge reset) begin
      if (reset) begin
         lock_count <= 14'd0;
         locked_i <= 1'b0;
      end
      else begin
         if (lock_count < 14'd1498) begin
            lock_count <= lock_count + 1;
            locked_i   <= 1'b0;
         end
         else begin
            lock_count <= lock_count;
            locked_i   <= 1'b1;
         end 
      end
   end

   initial begin
      clks_i[0] = 1'b0;
      forever #(CLK0_PERIOD) clks_i[0] = ~clks_i[0];
   end

   initial begin
      clks_i[1] = 1'b0;
      #(CLK0_PERIOD - CLK1_PERIOD)
      forever #(CLK1_PERIOD) clks_i[1] = ~clks_i[1];
   end

   initial begin
      clks_i[2] = 1'b1;
      #(CLK0_PERIOD - CLK2_PERIOD)
      forever #(CLK2_PERIOD) clks_i[2] = ~clks_i[2];
   end

   initial begin
      clks_i[3] = 1'b1;
      #(CLK0_PERIOD - CLK3_PERIOD)
      forever #(CLK3_PERIOD) clks_i[3] = ~clks_i[3];
   end

   initial begin
      clks_i[4] = 1'b1;
      #(CLK0_PERIOD - CLK4_PERIOD)
      forever #(CLK4_PERIOD) clks_i[4] = ~clks_i[4];
   end

   assign locked = locked_i;
   assign clk_out[0] = clks_i[0] & locked_i;
   assign clk_out[1] = clks_i[1] & locked_i;
   assign clk_out[2] = clks_i[2] & locked_i;
   assign clk_out[3] = clks_i[3] & locked_i;
   assign clk_out[4] = clks_i[4] & locked_i;

endmodule
