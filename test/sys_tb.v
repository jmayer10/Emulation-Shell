`timescale 1ps/1ps 

module sys_tb;

reg rst, clk200, clk160, clk40;
reg clk200_n, clk200_p;
reg trig, cmd;

reg [3:0] shift_in;

wire trig_out, data_n, data_p;
wire cmd_out_n, cmd_out_p;

integer x;

parameter halfclk200 = 2500;
parameter halfclk160 = 3125;
parameter halfclk40 = 12500;

initial begin
rst = 1'b0 ;
#(1*halfclk200)
rst = 1'b1;
#(8*halfclk200)
rst = 1'b0 ;
end

initial begin
   clk200 = 1'b0;
   #(halfclk40 - halfclk200)
   forever #(halfclk200) clk200 = ~clk200;
end

initial begin
   clk160 = 1'b0;
   #(halfclk40 - halfclk160)
   forever #(halfclk160) clk160 = ~clk160;
end

initial begin
   clk40 = 1'b0;
   forever #(halfclk40) clk40 = ~clk40;
end

//Turn into differential signals
always @ (*) begin
   clk200_n   <= !clk200;
   clk200_p   <= clk200;
end

sys_top dut(
   .rst(rst),
   .sysclk_in_n(clk200_n), 
   .sysclk_in_p(clk200_p),
   .ttc_data_n(data_n), 
   .ttc_data_p(data_p),
   .clkin40(clk40),
   .trigger(trig),
   .command(cmd),
   .dataout_n(data_n), //off_chip dataout
   .dataout_p(data_p),
   .trig_out(trig_out),
   .cmd_out_n(cmd_out_n), 
   .cmd_out_p(cmd_out_p)
);

always @ (posedge clk40 or posedge rst) begin
   if (rst) begin
      trig     <= 1'b0;
      cmd      <= 1'b0;
      x        <=    0;
   end
   else begin
      if ( x < 200) begin
         x <= x + 1;
      end
      else begin
         x <= x;
      end
      if (x == 180 | trig_out == 1'b1) begin
         trig <= 1'b1;
      end
      else begin
         trig <= 1'b0;
      end
      if (&shift_in & x > 180) begin
         cmd <= 1'b1;
      end
      else begin
         cmd <= 1'b0;
      end
   end
end

always @ (posedge clk160 or posedge rst) begin
   if (rst) begin
      shift_in <= 4'h0;
   end
   else begin
      shift_in <= {shift_in[2:0], data_p};
   end
end

endmodule
