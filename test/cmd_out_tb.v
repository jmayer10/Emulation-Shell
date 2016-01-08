`timescale 1ps/1ps 

module cmd_out_tb;

reg rst, wr_cmd;
reg clk160, clk640, clk40;
reg [15:0] datain;

wire fifo_full, cmd_out_n, cmd_out_p;

parameter halfclk640 =   781;
parameter halfclk160 =  3125;
parameter halfclk40  = 12500;

initial
begin
rst = 1'b1 ;
#((halfclk40*3)-300)
rst = 1'b0 ;
//$stop
end 

initial begin
   clk160 = 1'b0;
   #(halfclk40-halfclk160)
   forever #halfclk160 clk160 = ~clk160;
end
initial begin
   clk640 = 1'b0;
   #(halfclk40-halfclk640)
   forever #halfclk640 clk640 = ~clk640;
end
initial begin
   clk40 = 1'b0;
   forever #halfclk40 clk40 = ~clk40;
end

command_out dut(
   .rst(rst),
   .clk640(clk640),
   .clk160(clk160),
   .clk40(clk40),
   .wr_cmd(wr_cmd),
   .datain(datain),
   .fifo_full(fifo_full),
   .cmd_out_n(cmd_out_n),
   .cmd_out_p(cmd_out_p)
);

always @ (posedge clk40 or posedge rst) begin
   if (rst) begin
      wr_cmd <= 1'b0;
      datain <= 16'h000A;
   end
   else begin
      if (!fifo_full) begin
         wr_cmd <= 1'b1;
         datain <= datain + 1;
      end
      else begin
         wr_cmd <= 1'b0;
         datain <= datain;
      end
   end
end

endmodule
