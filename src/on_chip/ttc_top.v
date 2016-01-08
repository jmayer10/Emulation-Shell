`timescale 1ps/1ps
//TTC Input Decoder
module ttc_top (
   input  clk640, 
//   input  clk320, 
   input  clk160, 
   input  rst,   //Global external rest
   input  datain, //TTC Serial Stream
   output valid,  //Data word valid signal
   output [15:0] data, //16-bit word out, in same domain as clkin
   output recovered_clk
);

//wire clk160, clk320, clk640;
reg  aap, bbp, ccp, ddp, a2, b2;
reg  aan, bbn, ccn, ddn, c2, d2;
reg  usea, useb, usec, used, ce;
reg  useaint, usebint, usecint, usedint;
reg  [ 1:0] ctrl_reg0, ctrl_reg1, srdata;
reg  [ 1:0] ddrq_dly;
reg  [15:0] dataout;
reg  validout;
reg  [3:0] ddrq_data, data_in, data_in_dly;

wire [  1:0] a, b, c, d; //The oversample domains
wire [255:0] data_concat;
wire [  1:0] sdataa, sdatab, sdatac, sdatad,
             shifta, shiftb, shiftc, shiftd;
wire [ 15:0] dataint_array [0:15];
wire valid_i;
wire [15:0] data_i, validint;
wire [1:0] DDRQ;

//****************Other Shit*********************
reg sample, cheap320, pos2x, neg2x;
reg posOR, negOR, totOR, negOR_reg, posOR_reg;

always @ (*) begin
   posOR <= !rst & ( (useaint & !pos2x) | (usecint & pos2x) ); 
   negOR <= !rst & ( (usebint & !neg2x) | (usedint & neg2x) );
   totOR <= posOR_reg | negOR_reg; 
end

always @ (posedge cheap320 or posedge rst) begin
   if (rst) begin
      pos2x <= 1'b0;
      posOR_reg <= 1'b0;
   end
   else begin
      pos2x <= !pos2x;
      posOR_reg <= posOR;
   end
end
always @ (negedge cheap320 or posedge rst) begin
   if (rst) begin
      neg2x <= 1'b0;
      negOR_reg <= 1'b0;
   end
   else begin
      neg2x <= !neg2x;
      negOR_reg <= negOR;
   end
end

always @ (posedge clk640 or posedge rst) begin
   if (rst) begin
      sample   <= 1'b0;
      cheap320 <= 1'b0;
   end
   else begin
      sample   <= totOR;
      cheap320 <= !cheap320;
   end
end

assign recovered_clk = sample;
//****************Other Shit*********************

//Oversample serial data in 4 time domains
//IDDR IDDR_inst(
//   .Q1(DDRQ[1]),
//   .Q2(DDRQ[0]),
//   .C(clk320),
//   .CE(1'b1),
//   .D(datain),
//   .R(rst),
//   .S(1'b0)
//);
//
//always @ (posedge clk320 or posedge rst) begin
//   if (rst) begin
//      ddrq_dly  <= 2'b00;
//      ddrq_data <= 4'h0;
//   end
//   else begin
//      ddrq_dly  <= DDRQ;
//      ddrq_data <= {ddrq_dly,DDRQ};
//   end
//end
always @ (posedge clk640 or posedge rst)
begin
   if (rst) begin
      ddrq_data <= 4'h0;
   end
   else begin
      ddrq_data <= {ddrq_data[2:0], datain};
   end
end

always @ (posedge clk160 or posedge rst)
begin
   if (rst) begin
      data_in     <= 4'h0;
      data_in_dly <= 4'h0;
   end
   else begin
      data_in     <= ddrq_data;
      data_in_dly <= data_in;
   end
end

assign a[0] = data_in[3];
assign b[0] = data_in[2];
assign c[0] = data_in[1];
assign d[0] = data_in[0];
assign a[1] = data_in_dly[3];
assign b[1] = data_in_dly[2];
assign c[1] = data_in_dly[1];
assign d[1] = data_in_dly[0];

//Edge detection  and use logic
always @ (posedge clk160 or posedge rst)
begin
   if (rst) begin
      a2   <= 1'b0; b2   <= 1'b0; c2   <= 1'b0; d2   <= 1'b0;
      aap  <= 1'b0; bbp  <= 1'b0; ccp  <= 1'b0; ddp  <= 1'b0;
      aan  <= 1'b0; bbn  <= 1'b0; ccn  <= 1'b0; ddn  <= 1'b0;
      usea <= 1'b0; useb <= 1'b0; usec <= 1'b0; used <= 1'b0;
      useaint <= 1'b0; usebint <= 1'b0; usecint <= 1'b0; usedint <= 1'b0;
      ce <= 1'b0; ctrl_reg0 <= 2'b00; ctrl_reg1 <= 2'b00; srdata <= 2'b00;
   end
   else begin
      //t = 2T
      a2   <= a[1]; b2 <= b[1]; c2 <= c[1]; d2 <= d[1]; 
      //t = 3T
      //aap  <= (a[0] ^ a[1]) & ~a[1]; 
      //bbp  <= (b[0] ^ b[1]) & ~b[1];
      //ccp  <= (c[0] ^ c[1]) & ~c[1];
      //ddp  <= (d[0] ^ d[1]) & ~d[1];
      //aan  <= (a[0] ^ a[1]) &  a[1];
      //bbn  <= (b[0] ^ b[1]) &  b[1];
      //ccn  <= (c[0] ^ c[1]) &  c[1];
      //ddn  <= (d[0] ^ d[1]) &  d[1];
      aap  <= (a[1] ^ a2) & ~a2; 
      bbp  <= (b[1] ^ b2) & ~b2;
      ccp  <= (c[1] ^ c2) & ~c2;
      ddp  <= (d[1] ^ d2) & ~d2;
      aan  <= (a[1] ^ a2) &  a2;
      bbn  <= (b[1] ^ b2) &  b2;
      ccn  <= (c[1] ^ c2) &  c2;
      ddn  <= (d[1] ^ d2) &  d2;
      //t = 4T
      usea <= (bbp & ~ccp & ~ddp &  aap) | (bbn & ~ccn & ~ddn &  aan);
      useb <= (ccp & ~ddp &  aap &  bbp) | (ccn & ~ddn &  aan &  bbn);
      usec <= (ddp &  aap &  bbp &  ccp) | (ddn &  aan &  bbn &  ccn);
      used <= (aap & ~bbp & ~ccp & ~ddp) | (aan & ~bbn & ~ccn & ~ddn);
      //t = 5T
      if (usea | useb | usec | used) begin
         ce      <= 1'b1;
         useaint <= usea;
         usebint <= useb;
         usecint <= usec;
         usedint <= used;
      end
      if (usedint & usea) begin
         ctrl_reg0 <= 2'b00;
      end
      else if (useaint & used) begin
         ctrl_reg0 <= 2'b11;
      end 
      else begin
         ctrl_reg0 <= 2'b01;
      end
      //t = 6T
      if (ce) begin
         srdata <= sdataa | sdatab | sdatac | sdatad;
         ctrl_reg1 <= ctrl_reg0;
      end
   end
end

assign sdataa = {(shifta[1] && useaint), (shifta[0] && useaint)};
assign sdatab = {(shiftb[1] && usebint), (shiftb[0] && usebint)};
assign sdatac = {(shiftc[1] && usecint), (shiftc[0] && usecint)};
assign sdatad = {(shiftd[1] && usedint), (shiftd[0] && usedint)};

SR3  srl3a(.clk(clk160), .rst(rst), .datain(a2), .dataout(shifta));
SR3  srl3b(.clk(clk160), .rst(rst), .datain(b2), .dataout(shiftb));
SR3  srl3c(.clk(clk160), .rst(rst), .datain(c2), .dataout(shiftc));
SR3  srl3d(.clk(clk160), .rst(rst), .datain(d2), .dataout(shiftd));

//Channels
SR16 #(4'hf) ch0(.clk(clk160), .rst(rst), .datain(srdata), .ctrl(ctrl_reg1), .valid(validint[0]), .dataout(dataint_array[0]));
SR16 #(4'he) ch1(.clk(clk160), .rst(rst), .datain(srdata), .ctrl(ctrl_reg1), .valid(validint[1]), .dataout(dataint_array[1]));
SR16 #(4'hd) ch2(.clk(clk160), .rst(rst), .datain(srdata), .ctrl(ctrl_reg1), .valid(validint[2]), .dataout(dataint_array[2]));
SR16 #(4'hc) ch3(.clk(clk160), .rst(rst), .datain(srdata), .ctrl(ctrl_reg1), .valid(validint[3]), .dataout(dataint_array[3]));
SR16 #(4'hb) ch4(.clk(clk160), .rst(rst), .datain(srdata), .ctrl(ctrl_reg1), .valid(validint[4]), .dataout(dataint_array[4]));
SR16 #(4'ha) ch5(.clk(clk160), .rst(rst), .datain(srdata), .ctrl(ctrl_reg1), .valid(validint[5]), .dataout(dataint_array[5]));
SR16 #(4'h9) ch6(.clk(clk160), .rst(rst), .datain(srdata), .ctrl(ctrl_reg1), .valid(validint[6]), .dataout(dataint_array[6]));
SR16 #(4'h8) ch7(.clk(clk160), .rst(rst), .datain(srdata), .ctrl(ctrl_reg1), .valid(validint[7]), .dataout(dataint_array[7]));
SR16 #(4'h7) ch8(.clk(clk160), .rst(rst), .datain(srdata), .ctrl(ctrl_reg1), .valid(validint[8]), .dataout(dataint_array[8]));
SR16 #(4'h6) ch9(.clk(clk160), .rst(rst), .datain(srdata), .ctrl(ctrl_reg1), .valid(validint[9]), .dataout(dataint_array[9]));
SR16 #(4'h5) ch10(.clk(clk160), .rst(rst), .datain(srdata), .ctrl(ctrl_reg1), .valid(validint[10]), .dataout(dataint_array[10]));
SR16 #(4'h4) ch11(.clk(clk160), .rst(rst), .datain(srdata), .ctrl(ctrl_reg1), .valid(validint[11]), .dataout(dataint_array[11]));
SR16 #(4'h3) ch12(.clk(clk160), .rst(rst), .datain(srdata), .ctrl(ctrl_reg1), .valid(validint[12]), .dataout(dataint_array[12]));
SR16 #(4'h2) ch13(.clk(clk160), .rst(rst), .datain(srdata), .ctrl(ctrl_reg1), .valid(validint[13]), .dataout(dataint_array[13]));
SR16 #(4'h1) ch14(.clk(clk160), .rst(rst), .datain(srdata), .ctrl(ctrl_reg1), .valid(validint[14]), .dataout(dataint_array[14]));
SR16 #(4'h0) ch15(.clk(clk160), .rst(rst), .datain(srdata), .ctrl(ctrl_reg1), .valid(validint[15]), .dataout(dataint_array[15]));

assign data_concat = {dataint_array[15],dataint_array[14],dataint_array[13],dataint_array[12],dataint_array[11],dataint_array[10],dataint_array[9],dataint_array[8],dataint_array[7],dataint_array[6],dataint_array[5],dataint_array[4],dataint_array[3],dataint_array[2],dataint_array[1],dataint_array[0]};
//Choose the channel to align to
shift_align channel_align(.clk(clk160), .rst(rst), .valid_in(validint), .datain(data_concat), .valid(valid_i), .dataout(data_i));

//Only write to that FIFO once!
//always @ (posedge clk160 or posedge rst) begin
//   if (rst) begin
//   end
//   else begin
//   end
//end

assign valid   = valid_i;
assign data    = data_i;

endmodule
