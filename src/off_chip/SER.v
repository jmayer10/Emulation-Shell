//16-1 Parrellel to serial output
//Next signal tells when a word has been complete sent and the new datain is
//being loaded
module SER (
   input rst, clk,
   input [15:0] datain,
   output next,
   output dataout
);

reg [15:0] shift_reg;
reg [ 3:0] count;
reg next_i;

always @ (posedge clk or posedge rst) begin
   if (rst) begin
      shift_reg <= 16'h0000;
      count     <=  4'hF;
      next_i    <=  1'b0;
   end
   else begin
      if(count == 4'd15) begin
         shift_reg <= datain;
         next_i    <= 1'b1;
      end
      else begin
         shift_reg <= {shift_reg[14:0], 1'b0};
         next_i    <= 1'b0;
      end
      count <= count + 1;
   end
end

assign next = next_i;
assign dataout = shift_reg[15];

endmodule
