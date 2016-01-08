`timescale 1ps/1ps

module shiftalign_tb ;

reg  clk, rst;
reg  [15:0] valid_in; 
reg  [255:0] datain;
wire [15:0] dataout;
wire valid;

integer i, x;

parameter half_clock = 3125;

initial begin
rst = 1'b1 ;
#(4*half_clock)
rst = 1'b0 ;
end

initial begin
   clk = 1'b0;
   forever #(half_clock) clk = ~clk;
end

always @ (posedge clk or posedge rst) begin
   if (rst) begin
      valid_in <= 16'h0000;
      datain   <= 255'd0;
      x        <= 32'd0;
   end
   else begin
      if (x < 5) begin
         valid_in[1]   <= 16'b1;
         datain[31:16] <= 16'h817E;
         valid_in[3]   <= 16'b1;
         datain[63:48] <= 16'h817E; 
      end
      else if (x > 20) begin
         valid_in[1]   <= 16'b1;
         datain[31:16] <= 16'hAAAA;
         valid_in[3]   <= 16'b1;
         datain[63:48] <= 16'h817E; 
      end
      else begin
         valid_in[1]   <= 16'b1;
         datain[31:16] <= 16'h817E;
         valid_in[3]   <= 16'b0;
         datain[63:48] <= 16'h0000; 
      end
      x = x + 1;
   end
end

shift_align SA(
   .clk(clk),
   .rst(rst),
   .valid_in(valid_in),
   .datain(datain),
   .valid(valid),
   .dataout(dataout)
);

endmodule
