module sys_top(
   input  rst,
   input  sysclk_in_n, sysclk_in_p,
   input  ttc_data_n, ttc_data_p,
   input  clkin40,
   input  trigger,
   input  command,
   output dataout_n, dataout_p,
   output trig_out,
   output cmd0_out_n, cmd0_out_p,
   output cmd1_out_n, cmd1_out_p,
   output cmd2_out_n, cmd2_out_p,
   output cmd3_out_n, cmd3_out_p
);

wire clk40out, htl;
wire [3:0] cmd_out_n, cmd_out_p;

off_chip_top ext(
   .rst(rst),
   .clkin40(clkin40),
   .trigger(trigger),
   .command(command),
   .clk40out(clk40out),
   .htl(htl),
   .dataout_n(dataout_n),
   .dataout_p(dataout_p)
);

RD53_top emulator(
   .rst(rst),
   .sysclk_in_n(sysclk_in_n),
   .sysclk_in_p(sysclk_in_p),
   .ttc_data_n(ttc_data_n),
   .ttc_data_p(ttc_data_p),
   .trig_out(trig_out),
   .cmd_out_n(cmd_out_n),
   .cmd_out_p(cmd_out_p)
);

assign cmd0_out_n = cmd_out_n[0]; assign cmd0_out_p = cmd_out_p[0];
assign cmd1_out_n = cmd_out_n[1]; assign cmd1_out_p = cmd_out_p[1];
assign cmd2_out_n = cmd_out_n[2]; assign cmd2_out_p = cmd_out_p[2];
assign cmd3_out_n = cmd_out_n[3]; assign cmd3_out_p = cmd_out_p[3];

perf_counter perf0(
   .rst(htl),
   .clk(clk40out),
   .start(trigger),
   .stop(trig_out),
   .value()
);

endmodule
