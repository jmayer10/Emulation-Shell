`timescale 1ps/1ps

module sim_fifo_tb;

parameter halfclkslow = 8000; 
parameter halfclkfast = 2000; 

reg  reset, wr_clk, rd_clk;
reg  [15:0] din;
reg  rd_en, wr_en;
wire [15:0] dout;
wire full, empty, valid;
wire [9:0] rd_data_count;

initial begin
reset = 1'b0 ;
#(1*halfclkslow)
reset = 1'b1;
#(2*halfclkslow)
reset = 1'b0 ;
end

initial begin
   wr_clk = 1'b0;
   forever #(halfclkslow) wr_clk = ~wr_clk;
end

initial begin
   rd_clk = 1'b0;
   #(halfclkslow - halfclkfast)
   forever #(halfclkfast) rd_clk = ~rd_clk;
end

sim_fifo myfifo(
   .reset(reset),
   .wr_clk(wr_clk),
   .rd_clk(rd_clk),
   .din(din),
   .wr_en(wr_en),
   .rd_en(rd_en),
   .dout(dout),
   .full(full),
   .empty(empty),
   .valid(valid),
   .rd_data_count(rd_data_count)
);

   always @ (posedge wr_clk or posedge reset) begin
      if (reset) begin
         din <= 16'd0;
         wr_en <= 1'b0;
      end
      else begin
         din <= din + 1;
         wr_en <= 1'b1;
      end
   end

   always @ (posedge rd_clk or posedge reset) begin
      if (reset) begin
         rd_en <= 1'b0;
      end
      else begin
         rd_en <= 1'b1;
      end
   end

endmodule
