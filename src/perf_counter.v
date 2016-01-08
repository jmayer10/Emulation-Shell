module perf_counter(
   input rst, clk,
   input start,
   input stop,
   output [31:0] value
);

reg [31:0] counter_i, counter;
reg count_i, count;

always @ (*) begin
   if (start & !count) begin
      count_i = 1'b1;
      counter_i = 32'd0;
   end
   else if (stop & count) begin
      count_i = 1'b0;
      counter_i = counter;
   end
   else if (count) begin
      count_i = count;
      counter_i = counter + 1;
   end
   else begin
      count_i = count;
      counter_i = counter;
   end
end

always @ (posedge clk or posedge rst) begin
   if (rst) begin
      count   <= 1'b0;
      counter <= 32'd0;
   end
   else begin
      count <= count_i;
      counter <= counter_i;
   end
end

assign value = counter;

endmodule
