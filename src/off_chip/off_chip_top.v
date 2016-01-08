module off_chip_top (
   input  rst,
   input  clkin40,
   input  trigger,
   input  command,
   output clk40out,
   output htl, //hold_while_locking_out
   output dataout_n,
   output dataout_p
);

wire clk40, clk160; 
wire trig_rdy, sync_rdy, cmd_rdy;
wire word_sent, pll_locked, rst_or_lock, dataout;
wire [15:0] trig_data, cmd_data;

reg  [15:0] ser_data_i;
reg  [ 4:0] lock_count;
reg  [ 3:0] pres_state, next_state;
reg  sync_sent_i; 
reg  trig_clr, get_cmd_i; 
reg  trig_i, trig_ii, cmd_i, cmd_ii;
reg  hold_while_locking, hold_while_locking_i;

localparam lock_num     = 24; //Check the counter size
localparam lock_send    = 4'b0001;
localparam sync_send    = 4'b0010;
localparam trig_send    = 4'b0100;
localparam cmd_send     = 4'b1000;
localparam sync_pattern = 16'b1000_0001_0111_1110;

off_chip_pll pll0(
   .clk_in1(clkin40),
   .clk_out1(clk40),
   .clk_out2(clk160),
   .reset(rst),
   .locked(pll_locked)
);

assign rst_or_lock = rst | !pll_locked;
assign htl = hold_while_locking;
assign clk40out = clk40;

//Always double flop your inputs
always @ (posedge clk40 or posedge rst_or_lock) begin
   if (rst_or_lock) begin
      trig_i <= 1'b0; trig_ii <= 1'b0;
      cmd_i  <= 1'b0; cmd_ii  <= 1'b0;
   end
   else begin
      trig_i <= trigger; trig_ii <= trig_i;
      cmd_i  <= command; cmd_ii  <= cmd_i;
   end
end

triggerunit trig_handler(
   .rst(hold_while_locking),
   .clk40(clk40),
   .clk160(clk160),
   .trigger(trig_ii),
   .trig_clr(trig_clr),
   .trigger_rdy(trig_rdy),
   .enc_trig(trig_data)
);

sync_timer syncer(
   .rst(hold_while_locking),
   .clk(clk160),
   .word_sent(word_sent),
   .sync_sent(sync_sent_i),
   .sync_time(sync_rdy)
);

cmd_top command_top(
   .rst(hold_while_locking),
   .clk40(clk40),
   .clk160(clk160),
   .gen_cmd(cmd_ii),
   .rd_cmd(get_cmd_i),
   .cmd_valid(cmd_rdy),
   .cmd_data(cmd_data)
);

//A cool state machine
always @ (*) begin
   case (pres_state)
      lock_send: begin
         ser_data_i  = sync_pattern;
         get_cmd_i   = 1'b0;
         sync_sent_i = 1'b0;
         trig_clr    = 1'b0;
         hold_while_locking_i = 1'b1;
         if (lock_count >= lock_num) begin
            next_state = sync_send;
         end
         else begin
            next_state = lock_send;
         end
      end
      sync_send: begin
         ser_data_i = sync_pattern;
         get_cmd_i  = 1'b0;
         trig_clr   = 1'b0;
         hold_while_locking_i = 1'b0;
         if (trig_rdy) begin
            next_state  = trig_send;
            sync_sent_i = 1'b0;
         end
         else if (cmd_rdy & !sync_rdy) begin
            next_state  = cmd_send;
            sync_sent_i = 1'b0;
         end
         else if (word_sent) begin
            next_state  = sync_send;
            sync_sent_i = 1'b1;
         end
         else begin
            next_state  = sync_send;
            sync_sent_i = 1'b0;
         end
      end
      trig_send: begin
         ser_data_i  = trig_data;
         get_cmd_i   = 1'b0;
         sync_sent_i = 1'b0;
         hold_while_locking_i = 1'b0;
         if (word_sent) begin
            next_state = sync_send;
            trig_clr    = 1'b1;
         end
         else begin
            next_state = trig_send;
            trig_clr    = 1'b0;
         end
      end
      cmd_send: begin
         ser_data_i  = cmd_data;
         sync_sent_i = 1'b0;
         trig_clr    = 1'b0;
         hold_while_locking_i = 1'b0;
         if (trig_rdy) begin
            get_cmd_i  = 1'b0;
            next_state = trig_send;
         end
         else if (sync_rdy) begin
            get_cmd_i  = 1'b0;
            next_state = sync_send;
         end
         else if (word_sent) begin
            get_cmd_i  = 1'b1;
            next_state = sync_send;
         end
         else begin
            get_cmd_i  = 1'b0;
            next_state = cmd_send;
         end
      end
      default: begin
         ser_data_i  = sync_pattern;
         next_state  = sync_send;
         get_cmd_i   = 1'b0;
         sync_sent_i = 1'b0;
         trig_clr    = 1'b0;
         hold_while_locking_i = 1'b0;
      end
   endcase
end

always @ (posedge clk160 or posedge rst_or_lock) begin
   if (rst_or_lock) begin
      pres_state <= lock_send; 
      lock_count <= 5'h00;
      hold_while_locking <= 1'b1;
   end
   else begin
      pres_state <= next_state;
      hold_while_locking <= hold_while_locking_i;
      if (word_sent) begin
         lock_count <= lock_count + 1;
      end
      else begin
         lock_count <= lock_count;
      end
   end
end

SER serializer(
   .rst(rst_or_lock),
   .clk(clk160),
   .datain(ser_data_i),
   .next(word_sent),
   .dataout(dataout)
);

OBUFDS OBUFDS_inst(
   .O(dataout_p),
   .OB(dataout_n),
   .I(dataout)
);

endmodule
