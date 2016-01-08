//LFSR and 40-160 cross domain command word FIFO
module cmd_top (
   input  rst, clk40, clk160, 
   input  gen_cmd,
   input  rd_cmd,
   output cmd_valid,
   output [15:0] cmd_data
);

wire fifo_full, wr_cmd;
wire [15:0] lfsr_data;

LFSR lfsr_inst(
   .clk(clk40),
   .rst(rst),
   .gen_cmd(gen_cmd),
   .wr_cmd(wr_cmd),
   .dataout(lfsr_data)
);

cmd_fifo cmd_fifo_inst(
    .rst(rst), 
    .wr_clk(clk40), 
    .rd_clk(clk160), 
    .din(lfsr_data), 
    .wr_en(wr_cmd),
    .rd_en(rd_cmd), 
    .dout (cmd_data), 
    .full (fifo_full), 
    .empty(), 
    .valid(cmd_valid) 
);

endmodule
