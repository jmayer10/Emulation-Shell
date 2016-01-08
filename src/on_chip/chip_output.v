module chip_output(
   input  rst, clk640, clk160, clk40,
   input  word_valid,
   input  [15:0] data_in,
   output trig_out, //40Mb/s
   output cmd_out_n, cmd_out_p //1.28Gb/s
);

reg [15:0] fifo_data;
reg [ 3:0] trig_sr_i, trig_sr;
reg rd_word;
reg wr_cmd_i, wr_cmd;

wire [15:0] fifo_data_i; 
wire fifo_full, fifo_data_valid, trig_done, cmd_full;
//Cross that uncertain clock domain
fifo_generator_0 word_fifo(
   .rst(rst),
   .wr_clk(clk160),
   .rd_clk(clk40),
   .din(data_in),
   .wr_en(word_valid),
   .rd_en(rd_word),
   .dout(fifo_data_i),
   .full(fifo_full),
   .empty(),
   .valid(fifo_data_valid)
);

//Decode FSM, decode ant decide if trigger or command
always @ (*) begin
   case (fifo_data_i)
      16'hAAA2: begin
         trig_sr_i = 4'b0001;
         wr_cmd_i  = 1'b0;
      end
      16'hAAA4: begin
         trig_sr_i = 4'b0010;
         wr_cmd_i  = 1'b0;
      end
      16'hAAA8: begin
         trig_sr_i = 4'b0011;
         wr_cmd_i  = 1'b0;
      end
      16'hAA1A: begin
         trig_sr_i = 4'b0100;
         wr_cmd_i  = 1'b0;
      end
      16'hAA2A: begin
         trig_sr_i = 4'b0101;
         wr_cmd_i  = 1'b0;
      end
      16'hAA4A: begin
         trig_sr_i = 4'b0110;
         wr_cmd_i  = 1'b0;
      end
      16'hAA8A: begin
         trig_sr_i = 4'b0111;
         wr_cmd_i  = 1'b0;
      end
      16'hA1AA: begin
         trig_sr_i = 4'b1000;
         wr_cmd_i  = 1'b0;
      end
      16'hA2AA: begin
         trig_sr_i = 4'b1001;
         wr_cmd_i  = 1'b0;
      end
      16'hA4AA: begin
         trig_sr_i = 4'b1010;
         wr_cmd_i  = 1'b0;
      end
      16'hA8AA: begin
         trig_sr_i = 4'b1011;
         wr_cmd_i  = 1'b0;
      end
      16'h1AAA: begin
         trig_sr_i = 4'b1100;
         wr_cmd_i  = 1'b0;
      end
      16'h2AAA: begin
         trig_sr_i = 4'b1101;
         wr_cmd_i  = 1'b0;
      end
      16'h4AAA: begin
         trig_sr_i = 4'b1110;
         wr_cmd_i  = 1'b0;
      end
      16'h8AAA: begin
         trig_sr_i = 4'b1111;
         wr_cmd_i  = 1'b0;
      end
      default : begin
         trig_sr_i = 4'b0000;
         wr_cmd_i  = 1'b1 & fifo_data_valid & !cmd_full;
      end
   endcase
end

always @ (posedge clk40 or posedge rst) begin
   if (rst) begin
      trig_sr   <= 4'h0;
      rd_word   <= 1'b0;
      wr_cmd    <= 1'b0;
      fifo_data <= 16'h0000;
   end
   else begin
      trig_sr   <= trig_sr_i;
      wr_cmd    <= wr_cmd_i;
      fifo_data <= fifo_data_i;
      rd_word   <= wr_cmd_i | trig_done; 
   end
end

//Trigger Out
trigger_out trig_proc(
   .rst(rst),
   .clk40(clk40),
   .datain(trig_sr),
   .trig_done(trig_done),
   .trig_out(trig_out)
);

//Command Out
command_out cmd_proc(
   .rst(rst),
   .clk640(clk640),
   .clk160(clk160),
   .clk40(clk40),
   .wr_cmd(wr_cmd),
   .datain(fifo_data),
   .fifo_full(cmd_full),
   .cmd_out_n(cmd_out_n),
   .cmd_out_p(cmd_out_p)
);

endmodule
