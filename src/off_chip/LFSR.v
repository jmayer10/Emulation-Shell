//The LFSR increments whenever a command pulse is seen
module LFSR #(parameter seed = 16'hBBBB)
(
   input  clk, rst,
   input  gen_cmd, 
   output wr_cmd,
   output [15:0] dataout
);

reg [15:0] lfsr_reg, lfsr_reg_i, lfsr_reg_ii;
reg nextbitup, wr_out;

always @ (*) begin //Fibonacci type
   nextbitup   = lfsr_reg[4] ^ (lfsr_reg[10] ^ (lfsr_reg[14] ^ lfsr_reg[15]));
   lfsr_reg_ii = {lfsr_reg[14:0], nextbitup};
   case (lfsr_reg_ii) //Don't duplicate trigger codes
      16'hAAA1: lfsr_reg_i = 16'hAAA1+1;  
      16'hAAA2: lfsr_reg_i = 16'hAAA2+1;
      16'hAAA4: lfsr_reg_i = 16'hAAA4+1;
      16'hAAA8: lfsr_reg_i = 16'hAAA8+1;
      16'hAA1A: lfsr_reg_i = 16'hAA1A+1;  
      16'hAA2A: lfsr_reg_i = 16'hAA2A+1;
      16'hAA4A: lfsr_reg_i = 16'hAA4A+1;
      16'hAA8A: lfsr_reg_i = 16'hAA8A+1;
      16'hA1AA: lfsr_reg_i = 16'hA1AA+1;  
      16'hA2AA: lfsr_reg_i = 16'hA2AA+1;
      16'hA4AA: lfsr_reg_i = 16'hA4AA+1;
      16'hA8AA: lfsr_reg_i = 16'hA8AA+1;
      16'h1AAA: lfsr_reg_i = 16'h1AAA+1;  
      16'h2AAA: lfsr_reg_i = 16'h2AAA+1;
      16'h4AAA: lfsr_reg_i = 16'h4AAA+1;
      16'h8AAA: lfsr_reg_i = 16'h8AAA+1;
      default: lfsr_reg_i = lfsr_reg_ii;
   endcase
end

always @ (posedge clk or posedge rst) begin
   if (rst) begin
      lfsr_reg  <= seed;
      wr_out    <= 1'b0;
   end
   else begin
      if (gen_cmd) begin
         lfsr_reg <= lfsr_reg_i;
         wr_out   <= 1'b1;
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
