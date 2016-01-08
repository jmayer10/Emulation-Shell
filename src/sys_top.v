module sys_top(
   input  rst,
   input  sysclk_in_n, sysclk_in_p,
   input  ttc_data_n, ttc_data_p,
   input  clkin40,
   input  trigger,
   input  command,
   output dataout_n, dataout_p,
   output trig_out,
   output cmd_out_n, cmd_out_p
);

wire clk40out, htl;

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

perf_counter perf0(
   .rst(htl),
   .clk(clk40out),
   .start(trigger),
   .stop(trig_out),
   .value()
);

endmodule
