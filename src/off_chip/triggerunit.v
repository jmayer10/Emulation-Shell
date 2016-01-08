//Contains shift register in 40MHz domain
//And decode and output in 160MHz
//All completed in 4 40MHz clocks
module triggerunit (
   input  rst, clk40, clk160,
   input  trigger, 
   input  trig_clr,
   output trigger_rdy,
   output [15:0] enc_trig
);

reg [ 3:0] trig_sr40, trig_sr160;
reg [ 1:0] trig_cnt;
reg [15:0] encoded_trig, encoded_trig_i;
reg trig_load, trig_pres;

//Input shift register
always @ (posedge clk40 or posedge rst) begin
   if (rst) begin
      trig_sr40  <= 4'h0;
      trig_cnt   <= 2'b00; 
   end
   else begin
      trig_sr40  <= {trig_sr40[2:0], trigger};
      trig_cnt   <= trig_cnt + 1; 
   end
end

//Inter-domain signals
always @ (*) begin
   trig_load <= &trig_cnt;
   trig_pres <= |trig_sr160;
end

//Encoding and 160 domain latching
always @ (posedge clk160 or posedge rst) begin
   if (rst) begin
      trig_sr160 <= 4'h0;
      encoded_trig <= 16'h0000;
   end
   else begin
      if (trig_clr) begin
         trig_sr160 <= 4'h0;
      end
      else if (trig_load) begin
         trig_sr160 <= trig_sr40;
      end
      else begin
         trig_sr160 <= trig_sr160;
      end
      encoded_trig <= encoded_trig_i;
   end
end

//Trigger Encoding (One-hot and then A) for now
//I made this up
always @ (*) begin
   case (trig_sr160)
      4'b0000: encoded_trig_i = 16'hAAA1;  
      4'b0001: encoded_trig_i = 16'hAAA2;
      4'b0010: encoded_trig_i = 16'hAAA4;
      4'b0011: encoded_trig_i = 16'hAAA8;
      4'b0100: encoded_trig_i = 16'hAA1A;  
      4'b0101: encoded_trig_i = 16'hAA2A;
      4'b0110: encoded_trig_i = 16'hAA4A;
      4'b0111: encoded_trig_i = 16'hAA8A;
      4'b1000: encoded_trig_i = 16'hA1AA;  
      4'b1001: encoded_trig_i = 16'hA2AA;
      4'b1010: encoded_trig_i = 16'hA4AA;
      4'b1011: encoded_trig_i = 16'hA8AA;
      4'b1100: encoded_trig_i = 16'h1AAA;  
      4'b1101: encoded_trig_i = 16'h2AAA;
      4'b1110: encoded_trig_i = 16'h4AAA;
      4'b1111: encoded_trig_i = 16'h8AAA;
      default: encoded_trig_i = 16'h0000;
   endcase
end

//Outputs
assign trigger_rdy = trig_pres;
assign enc_trig = encoded_trig;

endmodule
