//3-bit delay shift register
//can output 2 bits if needed
module SR3 (
   input        clk,
   input        rst,
   input        datain,
   output [1:0] dataout
);

reg [3:0] shift_reg;

assign dataout = shift_reg[3:2];

always @ (posedge clk or posedge rst)
begin
   if (rst) begin
      shift_reg <= 4'h0;
   end
   else begin
      shift_reg <= {shift_reg[2:0],datain};
   end
end

endmodule

//16-bit shift reg, parameterized to channel
module SR16 (
   input  clk,
   input  rst,
   input  [1:0] datain,
   input  [1:0] ctrl,
   output valid,
   output [15:0] dataout
);

parameter channel = 4'h0;

reg [16:0] shift_reg;
reg [ 3:0] shift_count;
reg        valid_i, shift_mux;
reg [15:0] mux_data;

assign valid   = valid_i;
assign dataout = mux_data;

//Output Mux
always @(*) begin 
   if(shift_mux == 1'b1) begin
      mux_data = shift_reg[16:1];
   end
   else begin
      mux_data = shift_reg[15:0];
   end
end

//Shift Register
always @ (posedge clk or posedge rst) begin
   if (rst) begin
      shift_reg   <= 17'h00000;
      shift_count <= channel;
      valid_i     <= 1'b0;
      shift_mux   <= 1'b0;
   end
   else begin
      if (ctrl == 2'b01) begin
         shift_reg   <= {shift_reg[15:0], datain[0]};
         if (shift_count == 4'hf) begin 
            shift_count <= 4'h0;
            valid_i     <= 1'b1;
            shift_mux   <= 1'b0;
         end
         else  begin
            shift_count <= shift_count + 1;
            shift_mux   <= 1'b0;
            valid_i     <= 1'b0;
         end
      end
      else if (ctrl == 2'b11) begin
         shift_reg   <= {shift_reg[14:0], datain[1], datain[0]}; 
         if (shift_count == 4'hf) begin
            shift_count <= 4'h1;
            valid_i     <= 1'b1;
            shift_mux   <= 1'b1;
         end
         else if (shift_count == 4'he) begin
            shift_count <= 4'h0;
            valid_i     <= 1'b1;
            shift_mux   <= 1'b0;
         end
         else begin
            shift_count <= shift_count + 2;
            shift_mux   <= 1'b0; 
            valid_i     <= 1'b0;
         end
      end
      else begin
         shift_reg   <= shift_reg;
         shift_mux   <= shift_mux;
         shift_count <= shift_count;
         valid_i     <= 1'b0;
      end
   end
end

endmodule
