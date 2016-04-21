module command_out(
   input  rst, clk640, clk160, clk40,
   input  wr_cmd,
   input  [15:0] datain,
   output fifo_full,
   output [3:0] cmd_out_n, cmd_out_p
);

localparam sync_pattern = 16'b1000_0001_0111_1110;

reg [ 7:0] oserdes_datain;
reg top_nbottom, cmd_nsync;

wire [15:0] word_out;
wire [7:0] oserdes_reverse;
wire word_valid, rd_cmd;

assign rd_cmd = cmd_nsync & top_nbottom;

fifo_generator_0 cd_fifo(
   .rst(rst),
   .wr_clk(clk40),
   .rd_clk(clk160),
   .din(datain),
   .wr_en(wr_cmd),
   .rd_en(rd_cmd),
   .dout(word_out),
   .full(fifo_full),
   .empty(),
   .valid(word_valid)
);

//16-bit words downto 8-bit for oserdes
//If no command fill output with sync_pattern
always @ (posedge clk160 or posedge rst) begin
   if (rst) begin
      oserdes_datain <= sync_pattern[15:8];
      top_nbottom    <= 1'b1;
      cmd_nsync      <= 1'b0;
   end
   else begin
      if (cmd_nsync & top_nbottom) begin
         oserdes_datain <= word_out[7:0];
         cmd_nsync      <= cmd_nsync;
      end
      else if (!cmd_nsync & top_nbottom) begin
         oserdes_datain <= sync_pattern[7:0];
         cmd_nsync      <= cmd_nsync;
      end
      else begin
         if (word_valid) begin
            cmd_nsync      <= 1'b1;
            oserdes_datain <= word_out[15:8];
         end
         else begin
            oserdes_datain <= sync_pattern[15:8];
            cmd_nsync      <= 1'b0;
         end
      end
      top_nbottom <= !top_nbottom;
   end
end

assign oserdes_reverse = {<<{oserdes_datain}};

//OSERDES Interface
//(640*2)/8=160
//Clocks must be in phase from same MMCM/PLL
//Rst synced with clkdiv
cmd_oserdes piso0_1280(
   .data_out_from_device(oserdes_reverse), //Reverse order b/c D1 is first bit out
   .data_out_to_pins_p(cmd_out_p[0]),
   .data_out_to_pins_n(cmd_out_n[0]),
   .clk_in(clk640),
   .clk_div_in(clk160),
   .io_reset(rst)
);

cmd_oserdes piso1_1280(
   .data_out_from_device(oserdes_reverse), //Reverse order b/c D1 is first bit out
   .data_out_to_pins_p(cmd_out_p[1]),
   .data_out_to_pins_n(cmd_out_n[1]),
   .clk_in(clk640),
   .clk_div_in(clk160),
   .io_reset(rst)
);

cmd_oserdes piso2_1280(
   .data_out_from_device(oserdes_reverse), //Reverse order b/c D1 is first bit out
   .data_out_to_pins_p(cmd_out_p[2]),
   .data_out_to_pins_n(cmd_out_n[2]),
   .clk_in(clk640),
   .clk_div_in(clk160),
   .io_reset(rst)
);

cmd_oserdes piso3_1280(
   .data_out_from_device(oserdes_reverse), //Reverse order b/c D1 is first bit out
   .data_out_to_pins_p(cmd_out_p[3]),
   .data_out_to_pins_n(cmd_out_n[3]),
   .clk_in(clk640),
   .clk_div_in(clk160),
   .io_reset(rst)
);

endmodule
