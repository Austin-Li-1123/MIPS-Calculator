// REFERENCE: http://verilogcodes.blogspot.com/2015/11/synthesisable-verilog-code-for-division.html
// USED IN DIVISION COMPUTATION FOR CALCULATOR
// Date: Tuesday, November 17, 2015
module division(A,B,Res);

//the size of input and output ports of the division module is generic.
    parameter WIDTH = 10;
//input and output ports.
    input [WIDTH-1:0] A;
    input [WIDTH-1:0] B;
    output [WIDTH-1:0] Res;
//internal variables
    reg [WIDTH-1:0] Res = 0;
    reg [WIDTH-1:0] a1,b1;
    reg [WIDTH:0] p1;
    integer i;

    always@ (A or B)
      begin
//initialize the variables.
      a1 = A;
      b1 = B;
      p1= 0;
    for(i=0;i < WIDTH;i=i+1) begin //start the for loop
      p1 = {p1[WIDTH-2:0],a1[WIDTH-1]};
      a1[WIDTH-1:1] = a1[WIDTH-2:0];
      p1 = p1-b1;
      if(p1[WIDTH-1] == 1) begin
      a1[0] = 0;
      p1 = p1 + b1; end
      else
      a1[0] = 1;
      end
      Res = a1;
      end

endmodule
