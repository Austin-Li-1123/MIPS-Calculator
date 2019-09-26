module dffe(q, d, clk, enable);
   output q;
   reg    q;
   input  d;
   input  clk, enable;

//   always@(reset)
//     if (reset == 1'b1)
//       q <= 0;

   always@(posedge clk) begin
     if (enable == 1'b1) begin
       q <= d;
       end
       end
endmodule // dffe

