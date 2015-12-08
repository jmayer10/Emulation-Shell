module fifo_controller(
   input  rst,
   input  clk160,
   input  txusrclk,
   input  [15:0] datain,
   input  datain_valid,
   input  tx_ready,
   output clr_valid,
   output fifo_full,
   output [15:0] dataout,
   output dataout_valid
);

wire fifo_data_valid;
wire [15:0] fifo_dataout;

reg rd_fifo, dataout_valid_i, clr_valid_i;
reg [15:0] dataout_i;

fifo_generator_0 tx_fifo(
   .rst(rst),
   .wr_clk(clk160),
   .rd_clk(txusrclk),
   .din(datain),
   .wr_en(datain_valid),
   .rd_en(rd_fifo),
   .dout(fifo_dataout),
   .full(fifo_full),
   .empty(),
   .valid(fifo_data_valid)
);

always @ (posedge clk160 or posedge rst) begin
   if (rst) begin
      clr_valid_i <= 1'b0;
   end
   else begin
      if (datain_valid) begin
         clr_valid_i <= 1'b1;
      end
      else begin
         clr_valid_i <= 1'b0;
      end
   end
end

always @ (fifo_data_valid or tx_ready) begin
   rd_fifo <= fifo_data_valid && tx_ready;
end

always @ (posedge txusrclk or posedge rst) begin
   if (rst) begin
      dataout_valid_i <= 1'b0;
      dataout_i       <= 16'h0000;
   end
   else begin
      if (fifo_data_valid && tx_ready) begin
         dataout_valid_i <= 1'b1;
         dataout_i       <= fifo_dataout;
      end
      else begin
         dataout_valid_i <= 1'b0;
         dataout_i       <= dataout_i;
      end
   end
end

assign dataout = dataout_i;
assign clr_valid = clr_valid_i;
assign dataout_valid = dataout_valid_i;

endmodule
