//The LFSR increments whenever a command pulse is seen
module LFSR #(parameter seed = 16'hAAAA)
(
   input  clk, rst,
   input  gen_cmd, 
   output wr_cmd,
   output [15:0] dataout
);

reg [15:0] lfsr_reg;
reg nextbitup, wr_out;

always @ (*) begin //Fibonacci type
   nextbitup = lfsr_reg[4] ^ (lfsr_reg[10] ^ (lfsr_reg[14] ^ lfsr_reg[15]));
end

always @ (posedge clk or posedge rst) begin
   if (rst) begin
      lfsr_reg  <= seed;
      wr_out    <= 1'b0;
   end
   else begin
      if (gen_cmd) begin
         lfsr_reg <= {lfsr_reg[14:0], nextbitup};
         wr_out    <= 1'b1;
      end
      else begin
         lfsr_reg <= lfsr_reg;
         wr_out    <= 1'b0;
      end
   end
end

assign wr_cmd  = wr_out;
assign dataout = lfsr_reg;

endmodule
