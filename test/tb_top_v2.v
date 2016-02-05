`timescale 1ps/1ps

module tb_top_v2;

reg clksend;
reg clkin;
reg clkin2x;
reg clkin4x;
reg rstin;
reg datain;
reg clr_valid;
reg read;
reg clk40, clk401;
reg [1:0] count40, count401;
integer counter;
integer other_counter;
reg [15:0] datareg, upnext;
wire [15:0] dataout, dataout1;
wire valid, valid1, rec_clk, rec_clk1;

always @(posedge clksend or posedge rstin) begin
if (rstin) begin
	datain  <= 1'b0;
   datareg <= 16'h817E;
   upnext <= 16'hf0f0;
   counter <= 32'd0;
   other_counter <= 32'd0;
end 
else begin
   if (counter < 32'd15) begin
      datain  <= datareg[15];
      counter <= counter + 1;
      datareg <= {datareg[14:0],datareg[15]};
   end
   else begin
      other_counter <= other_counter + 1;
      datain  <= datareg[15];
      counter <= 32'd0;
      if (other_counter < 32'd16) begin
         datareg <= {datareg[14:0],datareg[15]};
      end
      else begin
         datareg <= upnext;
         upnext  <= upnext + 1;
      end
   end
end
end 

always @(*) begin
   read = !(|counter);
end

initial begin
   clksend = 1'b0;
   forever #3105 clksend = ~clksend;
end
initial begin
   clkin = 1'b0;
   forever #3124 clkin = ~clkin;
end
initial begin
   clkin2x = 1'b0;
   #1562
   forever #1562 clkin2x = ~clkin2x;
end
initial begin
   clkin4x = 1'b0;
   #1562
   #781
   forever #781 clkin4x = ~clkin4x;
end

always @ (posedge rec_clk or posedge rstin) begin
   if (rstin) begin
      count40 <= 2'b11;
      clk40 <= 1'b0;
   end
   else begin
      count40 <= count40 + 1;
      if (count40[1] == 1'b1) begin
         clk40 <= 1'b1;
      end
      else begin
         clk40 <= 1'b0;
      end
   end
end

always @ (posedge rec_clk1 or posedge rstin) begin
   if (rstin) begin
      count401 <= 2'b11;
      clk401 <= 1'b0;
   end
   else begin
      count401 <= count401 + 1;
      if (count401[1] == 1'b1) begin
         clk401 <= 1'b1;
      end
      else begin
         clk401 <= 1'b0;
      end
   end
end

ttc_top chip(
	.clk640(clkin4x),
   .clk320(clkin2x),
   .clk160(clkin),
   .rst(rstin),
   .datain(datain),
   .valid(valid),
   .data(dataout),
   .recovered_clk(rec_clk)
);

initial
begin
rstin = 1'b1 ;
#12500
#1562
rstin = 1'b0 ;
//$stop
end 

endmodule
