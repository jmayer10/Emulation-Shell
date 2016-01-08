`timescale 1ps/1ps 

module off_chip_tb;

parameter halfclk40 = 12500;
parameter halfclk160 = 3125;

reg rst, clk40, clk160, trig, cmd; 
wire dataout;
reg [3:0] shift_in;

initial begin
rst = 1'b0 ;
#(1*halfclk160)
rst = 1'b1;
#(7*halfclk160)
rst = 1'b0 ;
end

initial begin
   clk40 = 1'b0;
   forever #(halfclk40) clk40 = ~clk40;
end

initial begin
   clk160 = 1'b0;
   forever #(halfclk160) clk160 = ~clk160;
end

off_chip_top nchip(
   .rst(rst),
   .clkin40(clk40),
   .trigger(trig),
   .command(cmd),
   .dataout(dataout)
);

always @ (posedge clk40 or posedge rst) begin
   if (rst) begin
      trig     <= 1'b0;
      cmd      <= 1'b0;
   end
   else begin
      if (^shift_in) begin
         trig <= 1'b1;
         cmd  <= 1'b1;
      end
      else begin
         trig <= 1'b0;
         cmd  <= 1'b0;
      end
   end
end

always @ (posedge clk160 or posedge rst) begin
   if (rst) begin
      shift_in <= 4'h0;
   end
   else begin
      shift_in <= {shift_in[2:0], dataout};
   end
end

endmodule
