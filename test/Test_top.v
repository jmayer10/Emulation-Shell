module RD53_top (
   input  lvds_clk_n,
   input  lvds_clk_p,
   input  ttc_datan,
   input  ttc_datap,
   input  reset,
   output out_n,
   output out_p
);

wire tx_locked, tx_rst_done, txclkusr2, tx_bufstts, datain, valid_i;
wire fifo_data_valid, fifo_full, clk160, clk320, mmcm_locked;
wire [15:0] data_i;

gtwizard_0 gtx_core(
   soft_reset_in(reset),
   dont_reset_on_data_error_in(1'b0),
   q0_clk0_gtrefclk_pad_n_in(lvds_clk_n),
   q0_clk0_gtrefclk_pad_p_in(lvds_clk_p),
   gt0_tx_mmcm_lock_out(tx_locked),
   gt0_tx_fsm_reset_done_out(),
   gt0_rx_fsm_reset_done_out(),
   gt0_data_valid_in(fifo_data_valid),
   gt0_txusrclk_out(),
   gt0_txusrclk2_out(txclkusr2),
   gt0_cpllfbclklost_out(),
   gt0_cplllock_out(),
   gt0_cpllreset_in(reset),
   gt0_drpaddr_in(8'h00),
   gt0_drpdi_in(16'h0000),
   gt0_drpdo_out(),
   gt0_drpen_in(1'b0),
   gt0_drprdy_out(),
   gt0_drpwe_in(1'b0),
   gt0_dmonitorout_out(),
   gt0_eyescanreset_in(reset),
   gt0_eyescandataerror_out(),
   gt0_eyescantrigger_in(1'b0),
   gt0_rxmonitorout_out(),
   gt0_rxmonitorsel_in(2'b00),
   gt0_gtrxreset_in(reset),
   gt0_gttxreset_in(reset),
   gt0_txuserrdy_in(mmcm_locked),
   gt0_txbufstatus_out(tx_bufstts),
   gt0_txdata_in(fifo_dataout),
   gt0_gtxtxn_out(out_n),
   gt0_gtxtxp_out(out_p),
   gt0_txoutclkfabric_out(),
   gt0_txoutclkpcs_out(),
   gt0_txcharisk_in(2'b00),
   gt0_txresetdone_out(tx_rst_done),
   gt0_qplloutclk_out(),
   gt0_qplloutrefclk_out(),
   DRP_CLK_O(), 
   sysclk_in_p(lvds_clk_n),
   sysclk_in_n(lvds_clk_p)
);

clk_wiz_0 mypll(
   .clk_in1(txclkusr2),
   .clk_out1(clk160),
   .clk_out2(clk320),
   .reset(reset),
   .locked(mmcm_locked)
);

//LVDS in to IBUFDS
IBUFDS #(.DIFF_TERM("FALSE"),
         .IBUF_LOW_PWR("TRUE"),
         .IOSTANDARD("DEFAULT")
) IBUFDS_inst (
         .O(datain),
         .I(ttc_datap),
         .IB(ttc_datan)
);

ttc_top ttc_in(
   .clk(clk160),
   .clk2x(clk320),
   .rst(reset),
   .datain(datain),
   .clr_valid(),
   .valid(valid_i),
   .data(data_i)
);

fifo_controller comptroller(
   .rst(reset),
   .clk160(clk160),
   .txusrclk(txclkusr2),
   .datain(data_i),
   .datain_valid(valid_i),
   .fifo_full(fifo_full),
   .dataout(fifo_dataout),
   .dataout_valid(fifo_data_valid)
);

endmodule
