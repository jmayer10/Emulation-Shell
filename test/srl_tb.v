`timescale 1ps/1ps

module srl_tb ;

reg  clk, rst, onepass;
reg  [1:0] datain, ctrl;
reg  [15:0] datareg;
wire [15:0] data_out;
wire valid;
integer counter;

parameter half_clock = 3125;

initial begin
rst = 1'b1 ;
#(4*half_clock) rst = 1'b0 ;
end

initial begin
   clk = 1'b0;
   forever #(half_clock) clk = ~clk;
end

always @ (posedge clk or posedge rst) begin
   if (rst) begin
      datain  <= 2'b00;
      onepass <= 1'b0;
      ctrl    <= 2'b00;
      counter <= 32'd0;
      datareg <= 16'h817E;
   end
   else begin
      if (counter < 32'd15) begin
         if (ctrl == 2'b11) begin
            datareg <= {datareg[14:0],datareg[15]};
            ctrl    <= 2'b01;
            datain  <= {datareg[0], datareg[15]};
            counter <= counter + 2;
         end
         else begin
            counter <= counter + 1;
            if (onepass) begin
               ctrl <= 2'b11;
               datareg <= {datareg[13:0],datareg[15:14]};
               datain  <= {datareg[15], datareg[14]};
            end
            else begin
               datareg <= {datareg[14:0],datareg[15]};
               ctrl <= 2'b01;
               datain  <= {datareg[0], datareg[15]};
            end
         end
         if (counter == 32'd14) begin
            onepass <= 1'b1;
         end
         else begin
            onepass <= 1'b0;
         end
      end
      else begin
         if (ctrl == 2'b11) begin
            datareg <= {datareg[14:0],datareg[15]};
            ctrl    <= 2'b01;
            datain  <= {datareg[0], datareg[15]};
         end
         else begin
            if (onepass) begin
               datareg <= {datareg[13:0],datareg[15:14]};
               ctrl <= 2'b11;
               datain  <= {datareg[15], datareg[14]};
            end
            else begin
               datareg <= {datareg[14:0],datareg[15]};
               ctrl <= 2'b01;
               datain  <= {datareg[0], datareg[15]};
            end
         end
         counter <= 32'd0;
         onepass <= 1'b0;
      end
   end
end

SR16 srl16(
   .clk(clk),
   .rst(rst),
   .datain(datain),
   .ctrl(ctrl),
   .valid(valid),
   .dataout(data_out)
);

endmodule
