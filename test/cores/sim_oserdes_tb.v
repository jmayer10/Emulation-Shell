`timescale 1ps/1ps

module sim_oserdes_tb;

parameter halfclkslow = 8000; 
parameter halfclkfast = 2000; 

reg [7:0] data_out_from_device;
wire data_out_to_pins_p, data_out_to_pins_n;
reg clk_in, clk_div_in, io_reset;

initial begin
io_reset = 1'b0 ;
#(1*halfclkslow)
io_reset = 1'b1;
#(2*halfclkslow)
io_reset = 1'b0 ;
end

initial begin
   clk_div_in = 1'b0;
   forever #(halfclkslow) clk_div_in = ~clk_div_in;
end

initial begin
   clk_in = 1'b0;
   #(halfclkslow - halfclkfast)
   forever #(halfclkfast) clk_in = ~clk_in;
end

sim_oserdes myoserdes(
   .data_out_from_device(data_out_from_device),
   .data_out_to_pins_p(data_out_to_pins_p),
   .data_out_to_pins_n(data_out_to_pins_n),
   .clk_in(clk_in), 
   .clk_div_in(clk_div_in),
   .io_reset(io_reset)
);

always @ (posedge clk_div_in or posedge io_reset) begin
   if (io_reset) begin
      data_out_from_device <= 8'h00;
   end
   else begin
      data_out_from_device <= data_out_from_device + 15;
   end
end

endmodule
