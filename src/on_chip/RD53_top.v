module RD53_top (
   input  rst,
   input  sysclk_in_n, sysclk_in_p,
   input  ttc_data_n, ttc_data_p,
   output trig_out,
   output cmd_out_n, cmd_out_p
);

wire valid_i, mmcm_locked;
wire rst_or_lock;
wire rclk, clk40_i, clk40;
wire [15:0] data_i;

IBUFDS IBUFDS_inst(
   .O(ttc_data),
   .I(ttc_data_p),
   .IB(ttc_data_n)
);

wire clk160, clk640; //  clk320,

clk_wiz_0 mypll(
   .clk_in1_p(sysclk_in_p),
   .clk_in1_n(sysclk_in_n),
   .clk_out1(clk640),
   .clk_out2(clk160),
   .reset(rst),
   .locked(mmcm_locked)
);

assign rst_or_lock = rst | !mmcm_locked;

ttc_top ttc_in(
   .clk640(clk640),
//   .clk320(clk320),
   .clk160(clk160),
   .rst(rst_or_lock),
   .datain(ttc_data),
   .valid(valid_i),
   .data(data_i),
   .recovered_clk(rclk)
);

BUFG BUFG_inst40(
   .O(clk40),
   .I(clk40_i)
);

//Fix this
clock_picker phase_pick(
   .clk160(rclk),
   .rst(rst_or_lock),
   .phase_sel(2'b00),
   .clk40(clk40_i)
);

chip_output cout(
   .rst(rst_or_lock),
   .clk640(clk640),
   .clk160(clk160),
   .clk40(clk40),
   .word_valid(valid_i),
   .data_in(data_i),
   .trig_out(trig_out),
   .cmd_out_n(cmd_out_n),
   .cmd_out_p(cmd_out_p)
);

endmodule
