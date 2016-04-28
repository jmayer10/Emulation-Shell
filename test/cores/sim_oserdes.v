//Simulation version of Xilinx OSERDES
//Output in reverse order
//Output is on both pos and neg edge of fast clock (DDR)
module sim_oserdes(
   input [7:0] data_out_from_device,
   output data_out_to_pins_p,
   output data_out_to_pins_n,
   input  clk_in, //the fast clock
   input  clk_div_in, //the slow divided clock (must be in phase)
   input  io_reset
);
   
   reg [7:0] shift_reg;
   reg [2:0] load_counter;
   reg mux_out;

   always@(posedge clk_div_in or posedge io_reset) begin
      if(io_reset) begin
         shift_reg <= 8'h00;
      end
      else begin
         shift_reg <= data_out_from_device;
      end
   end

   always@(posedge clk_in or negedge clk_in or posedge io_reset) begin
      if(io_reset) begin
         load_counter <= 3'b111;
      end
      else begin
         load_counter <= load_counter + 1;
      end
   end

   always @ (*) begin
      case(load_counter)
         3'b000:  mux_out = shift_reg[0];
         3'b001:  mux_out = shift_reg[1];
         3'b010:  mux_out = shift_reg[2];
         3'b011:  mux_out = shift_reg[3];
         3'b100:  mux_out = shift_reg[4];
         3'b101:  mux_out = shift_reg[5];
         3'b110:  mux_out = shift_reg[6];
         3'b111:  mux_out = shift_reg[7];
         default: mux_out = shift_reg[0];
      endcase
   end

   assign data_out_to_pins_p =  mux_out;
   assign data_out_to_pins_n = !mux_out;

endmodule
