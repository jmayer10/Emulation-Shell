//Selects a 160MHz phase to start 40MHz clock from
module clock_picker(
   input  clk160,
   input  rst,
   input  [1:0] phase_sel,
   output clk40
);

reg [1:0] phase_seli, phase_cnt, clk_div;
reg clk_out;

assign clk40 = clk_out;

always @ (posedge clk160 or posedge rst) begin
   if (rst) begin
      phase_seli <= 2'b00;
      phase_cnt  <= 2'b00;
      clk_div    <= 2'b01;
      clk_out    <= 1'b0;
   end
   else begin
      phase_cnt  <= phase_cnt + 1;
      if (phase_seli == phase_cnt) begin
         phase_seli <= phase_sel;
         clk_div    <= 2'b01;
         clk_out    <= 1'b1;
      end
      else begin
         clk_div <= clk_div + 1;
         if (clk_div[1] == 1'b1) begin
            clk_out <= 1'b0;
         end
         else begin
            clk_out <= 1'b1;
         end
      end
   end
end

endmodule
