module RD53_top (
   input  reset,
   input  sysclk_in_n, sysclk_in_p,
   input  q3_clk0_gtrefclk_pad_n_in, q3_clk0_gtrefclk_pad_p_in,
   input  ttc_datan, ttc_datap,
   output out_n, out_p
);

wire tx_locked, tx_rst_done, txusrclk2, datain, valid_i;
wire fifo_data_valid, clk160_i, clk320_i, clk160, clk320, mmcm_locked, clr_valid;
wire [15:0] data_i, fifo_dataout;
wire [ 1:0] tx_bufstts;  

//LVDS in to IBUFDS
// #(
//          .DIFF_TERM("FALSE"),
//         .IBUF_LOW_PWR("TRUE"),
//         .IOSTANDARD("DEFAULT")
//)
IBUFDS IBUFDS_inst (
         .O(datain),
         .I(ttc_datap),
         .IB(ttc_datan)
);

ttc_top ttc_in(
   .clk(clk160),
   .clk2x(clk320),
   .rst(reset),
   .datain(datain),
   .clr_valid(clr_valid),
   .valid(valid_i),
   .data(data_i)
);

fifo_controller comptroller(
   .rst(reset),
   .clk160(clk160),
   .txusrclk(txusrclk2),
   .datain(data_i),
   .datain_valid(valid_i),
   .tx_ready(tx_rst_done),
   .clr_valid(clr_valid),
   .fifo_full(),
   .dataout(fifo_dataout),
   .dataout_valid(fifo_data_valid)
);

BUFG BUFG_inst320(
   .O(clk320),
   .I(clk320_i)
);

BUFG BUFG_inst160(
   .O(clk160),
   .I(clk160_i)
);

clk_wiz_0 mypll(
   .clk_in1(txusrclk2),
   .clk_out1(clk320_i),
   .clk_out2(clk160_i),
   .reset(reset),
   .locked(mmcm_locked)
);

gtwizard_0 gtx_core(
   .soft_reset_in(reset),
   .dont_reset_on_data_error_in(1'b0),
   .q3_clk0_gtrefclk_pad_n_in(q3_clk0_gtrefclk_pad_n_in),
   .q3_clk0_gtrefclk_pad_p_in(q3_clk0_gtrefclk_pad_p_in),
   .gt0_tx_mmcm_lock_out(tx_locked),
   .gt0_tx_fsm_reset_done_out(),
   .gt0_rx_fsm_reset_done_out(),
   .gt0_data_valid_in(fifo_data_valid),
   .gt0_txusrclk_out(),
   .gt0_txusrclk2_out(txusrclk2),
   .gt0_cpllfbclklost_out(),
   .gt0_cplllock_out(),
   .gt0_cpllreset_in(reset),
   .gt0_drpaddr_in(9'd0),
   .gt0_drpdi_in(16'h0000),
   .gt0_drpdo_out(),
   .gt0_drpen_in(1'b0),
   .gt0_drprdy_out(),
   .gt0_drpwe_in(1'b0),
   .gt0_dmonitorout_out(),
   .gt0_eyescanreset_in(reset),
   .gt0_eyescandataerror_out(),
   .gt0_eyescantrigger_in(1'b0),
   .gt0_rxmonitorout_out(),
   .gt0_rxmonitorsel_in(2'b00),
   .gt0_gtrxreset_in(reset),
   .gt0_gttxreset_in(reset),
   .gt0_txuserrdy_in(mmcm_locked),
   .gt0_txbufstatus_out(tx_bufstts),
   .gt0_txdata_in(fifo_dataout),
   .gt0_gtxtxn_out(out_n),
   .gt0_gtxtxp_out(out_p),
   .gt0_txoutclkfabric_out(),
   .gt0_txoutclkpcs_out(),
   .gt0_txcharisk_in(2'b00),
   .gt0_txresetdone_out(tx_rst_done),
   .gt0_qplloutclk_out(),
   .gt0_qplloutrefclk_out(),
   .DRP_CLK_O(), 
   .sysclk_in_p(sysclk_in_p),
   .sysclk_in_n(sysclk_in_n)
);

endmodule
