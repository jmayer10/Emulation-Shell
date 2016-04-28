/*
Parameters needed: Depth, input & output widths
Non-Params: FWFT, CDC, full & empty, valid flag, data_count
Implements a circular buffer
*/
module sim_fifo #(parameter FIFO_DEPTH = 1024,
                  parameter DEPTH_EXP = 10,
                  parameter WORD_WIDTH = 16 )
(
   input  reset,
   input  wr_clk,
   input  rd_clk,
   input  [WORD_WIDTH-1:0] din,
   input  wr_en,
   input  rd_en,
   output [WORD_WIDTH-1:0] dout,
   output full,
   output empty,
   output valid,
   output [DEPTH_EXP-1:0] rd_data_count
);

   reg valid_i, full_i;
   reg [WORD_WIDTH-1:0] dout_i;
   reg [WORD_WIDTH-1:0] fifo [FIFO_DEPTH-1:0];
   reg [DEPTH_EXP-1:0] wr_gray, rd_gray;
   reg [DEPTH_EXP-1:0] wr_pointer, rd_pointer, rd_pointer_i;
   reg [DEPTH_EXP-1:0] wr_domain_diff_i, rd_domain_diff_i;
   reg [DEPTH_EXP-1:0] wr_pnt_gray_rd_domain, rd_pnt_gray_wr_domain; 
   reg [DEPTH_EXP-1:0] wr_pnt_gray_rd_domain_i, rd_pnt_gray_wr_domain_i;
   reg [DEPTH_EXP-1:0] rd_pnt_ungray, wr_domain_diff, wr_pnt_ungray, rd_domain_diff;

   //Write domain process
   integer fifox;
   always@(posedge wr_clk or posedge reset) begin
      if(reset) begin
         full_i         <= 1'b0;
         wr_pointer     <=  'b0;
         wr_domain_diff <=  'b0;
         rd_pnt_gray_wr_domain_i <= 'b0;
         rd_pnt_gray_wr_domain   <= 'b0;
         for(fifox = 0; fifox < FIFO_DEPTH; fifox=fifox+1) begin
            fifo[fifox] <= 'b0;
         end
      end
      else begin
         rd_pnt_gray_wr_domain_i <= rd_gray;
         rd_pnt_gray_wr_domain   <= rd_pnt_gray_wr_domain_i;
         wr_domain_diff          <= wr_domain_diff_i;
         //When to write
         if (wr_en) begin
            fifo[wr_pointer] <= din;
            wr_pointer       <= wr_pointer + 1;
         end
         else begin
            wr_pointer <= wr_pointer;
         end
         //When to assert full
         if (wr_domain_diff > 'd1020) begin
            full_i <= 1'b1;
         end
         else begin
            full_i <= 1'b0;
         end
      end
   end
   
   //Gray code the write pointer for the read domain crossing
   //integer wrx;
   always@(*) begin
      //wr_gray[DEPTH_EXP-1] = wr_pointer[DEPTH_EXP-1]; 
      //for(wrx = 0; wrx < DEPTH_EXP-1; wrx=wrx+1) begin
      //   wr_gray[wrx] = wr_pointer[wrx+1] ^ wr_pointer[wrx];
      //end
      wr_gray = wr_pointer ^ {1'b0, wr_pointer[7:1]};
   end

   //Undo gray code of read pointer in write domain
   //Find the difference in addresses
   integer wrux;
   always@(*) begin
      rd_pnt_ungray[DEPTH_EXP-1] = rd_pnt_gray_wr_domain[DEPTH_EXP-1];
      for(wrux = DEPTH_EXP-2; wrux > -1; wrux=wrux-1) begin //Has to be a chain all the way down
         rd_pnt_ungray[wrux] = rd_pnt_ungray[wrux+1] ^ rd_pnt_gray_wr_domain[wrux];
      end
      wr_domain_diff_i = wr_pointer - rd_pnt_ungray;
   end

   //Read domain process
   always@(posedge rd_clk or posedge reset) begin
      if(reset) begin
         rd_pointer     <= 'b0;
         wr_pnt_gray_rd_domain_i <= 'b0;
         wr_pnt_gray_rd_domain   <= 'b0;         
         rd_domain_diff          <= 'b0;
         dout_i         <= 'b0;
      end
      else begin
         wr_pnt_gray_rd_domain_i <= wr_gray; 
         wr_pnt_gray_rd_domain   <= wr_pnt_gray_rd_domain_i;        
         rd_domain_diff          <= rd_domain_diff_i;
         dout_i                  <= fifo[rd_pointer];
         rd_pointer              <= rd_pointer_i;
      end
   end

   //Gray code the read pointer for the write domain crossing
   //integer rdx;
   always@(*) begin
      //rd_gray[DEPTH_EXP-1] = rd_pointer[DEPTH_EXP-1]; 
      //for(rdx = 0; rdx < DEPTH_EXP-1; rdx=rdx+1) begin
      //   rd_gray[rdx] = rd_pointer[rdx+1] ^ rd_pointer[rdx];
      //end
      rd_gray = rd_pointer ^ {1'b0, rd_pointer[7:1]};
   end

   //Undo gray code of read pointer in write domain
   //Find the difference in addresses
   integer rdux;
   always@(*) begin
      wr_pnt_ungray[DEPTH_EXP-1] = wr_pnt_gray_rd_domain[DEPTH_EXP-1];
      for(rdux = DEPTH_EXP-2; rdux > -1; rdux=rdux-1) begin
         wr_pnt_ungray[rdux] = wr_pnt_ungray[rdux+1] ^ wr_pnt_gray_rd_domain[rdux];
      end
      rd_domain_diff_i = wr_pnt_ungray - rd_pointer;
      valid_i = (rd_domain_diff_i > 'b0) ? 1'b1:1'b0;
      rd_pointer_i = rd_pointer + (rd_en & valid_i);
   end

   assign dout  = dout_i;
   assign full  = full_i;
   assign valid = valid_i;
   assign empty = !valid_i;
   assign rd_data_count = rd_domain_diff;

endmodule
