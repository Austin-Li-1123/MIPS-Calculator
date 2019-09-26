//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/09/2016 04:15:30 PM
// Design Name:
// Module Name: wallace_tb
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module wallace_tb(
    );
    reg [7:0] a, b;
    wire [15:0] c;

    wallace w(.a(a), .b(b), .p(c));

    initial
    begin
        a=8'b1011;
        b=8'b1111;
        #20;

        a=8'b1111;
        b=8'b1111;
        #20;

        a=8'b1101;
        b=8'b1011;
        #20;

        a=8'b10101;
        b=8'b100011;
        #20;

        a=8'b1100100;
        b=8'b101;
        #20;

        a=8'b1010;
        b=8'b110;
        #20;
    end
	initial
		$monitor("At time %t, a = %d b = %d c = %d",
				$time, a, b, c);
endmodule
