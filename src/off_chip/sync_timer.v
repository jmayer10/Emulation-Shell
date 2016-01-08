//Counts the number of words sent 
//To know when to send the sync word
module sync_timer #(parameter freq = 16) //No greater than 31
( 
   input rst, clk,
   input word_sent,
   input sync_sent,
   output sync_time
);

reg [5:0] sync_count;
reg sync_rdy;

always @ (posedge clk or posedge rst) begin
   if (rst) begin
      sync_rdy   <= 1'b0;
      sync_count <= 5'd0;
   end
   else begin
      if (sync_sent) begin
         sync_rdy   <= 1'b0;
         sync_count <= 5'd0;
      end
      else if (sync_count == freq) begin
         sync_rdy   <= 1'b1;
         sync_count <= sync_count; 
      end
      else if (word_sent) begin
         sync_rdy   <= 1'b0;
         sync_count <= sync_count + 1; 
      end
      else begin
         sync_rdy   <= 1'b0;
         sync_count <= sync_count; 
      end
   end
end

assign sync_time = sync_rdy;

endmodule
