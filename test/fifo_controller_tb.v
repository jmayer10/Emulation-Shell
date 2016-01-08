`timescale 1ps/1ps

module fifo_controller_tb;

parameter half_clock1 = 3125;
parameter half_clock2 = 2000;

integer x;

reg  rst, clk160, txusrclk, datain_valid, tx_ready;
reg  [15:0] datain;

wire clr_valid, fifo_full, dataout_valid;
wire [15:0] dataout;

initial begin
rst = 1'b0 ;
#(1*half_clock2)
rst = 1'b1;
#(8*half_clock2)
rst = 1'b0 ;
end

initial begin
   clk160 = 1'b0;
   forever #(half_clock1) clk160 = ~clk160;
end

initial begin
   txusrclk = 1'b0;
   forever #(half_clock2) txusrclk = ~txusrclk;
end


//Write datain
always @ (posedge clk160 or posedge rst) begin
   if (rst) begin
      datain_valid <= 1'b0;
      datain       <= 16'h0000;
   end
   else begin
      if (!fifo_full) begin
         datain_valid <= 1'b1;
         datain       <= datain + 1;
      end
   end
end

//Write datain
always @ (posedge txusrclk or posedge rst) begin
   if (rst) begin
      tx_ready <= 1'b0;
      x        <= 32'd0;
   end
   else begin
      if (x > 32'd8) begin
         tx_ready <= 1'b1;
      end
      x  <= x + 1;
   end
end

fifo_controller comptroller(
   .rst(rst),
   .clk160(clk160),
   .txusrclk(txusrclk),
   .datain(datain),
   .datain_valid(datain_valid),
   .tx_ready(tx_ready),
   .clr_valid(clr_valid),
   .fifo_full(fifo_full),
   .dataout(dataout),
   .dataout_valid(dataout_valid)
);

endmodule
