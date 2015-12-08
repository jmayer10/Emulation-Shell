`timescale 1ps/1ps 

module emulator_tb;

reg clk160, clk156, clk156_n, clk156_p, clk200, clk200_n, clk200_p;
reg rst, ttc_data, ttc_data_n, ttc_data_p;

wire dataout, dataout_n, dataout_p;

parameter halfclk200 = 2500;
parameter halfclk160 = 3125;
parameter halfclk156 = 3200;


initial begin
rst = 1'b0 ;
#(1*halfclk200)
rst = 1'b1;
#(8*halfclk200)
rst = 1'b0 ;
end

initial begin
   clk200 = 1'b0;
   forever #(halfclk200) clk200 = ~clk200;
end

initial begin
   clk160 = 1'b0;
   forever #(halfclk160) clk160 = ~clk160;
end

initial begin
   clk156 = 1'b0;
   forever #(halfclk156) clk156 = ~clk156;
end

//Turn into differential signals
always @ (*) begin
   clk200_n   <= clk200;
   clk200_p   <= !clk200;
   clk156_n   <= clk156;
   clk156_p   <= !clk156;
   ttc_data_n <= ttc_data;
   ttc_data_p <= !ttc_data;
end

IBUFDS IBUFDS_out (
         .O(dataout),
         .I(dataout_p),
         .IB(dataout_n)
);

RD53_top Emulator(
   .reset(rst),
   .sysclk_in_n(clk156_n),
   .sysclk_in_p(clk156_p),
   .q3_clk0_gtrefclk_pad_n_in(clk200_n),
   .q3_clk0_gtrefclk_pad_p_in(clk200_p),
   .ttc_datan(ttc_data_n),
   .ttc_datap(ttc_data_p),
   .out_n(dataout_n),
   .out_p(dataout_p)
);

//Stimulus
parameter sync_pattern = 16'h817E;
integer counter;
integer other_counter;
reg [15:0] datareg, upnext;
always @(posedge clk160 or posedge rst) begin
   if (rst) begin
   	ttc_data <= 1'b0;
      datareg  <= sync_pattern; //For lock
      upnext   <= 16'hf0f0; //For something different
      counter  <= 32'd0;
      other_counter <= 32'd0;
   end 
   else begin
      if (counter < 32'd15) begin
         ttc_data <= datareg[15];
         counter  <= counter + 1;
         datareg  <= {datareg[14:0],datareg[15]};
      end
      else begin
         other_counter <= other_counter + 1;
         ttc_data <= datareg[15];
         counter  <= 32'd0;
         if (other_counter < 32'd125) begin
            datareg <= {datareg[14:0],datareg[15]};
         end
         else begin
            datareg <= upnext;
            upnext  <= upnext + 1;
         end
      end
   end
end

endmodule
