`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/29/2016 12:46:06 PM
// Design Name:
// Module Name: bcd2led_tb
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


module BCDToLED(seg, x);
	output [6:0] seg;
 //   output [3:0] an;
	input [4:0] x;

// 0~9
	//assign seg[0] = (x[2] & ~x[1] & ~x[0]) | (~x[3] & ~x[2] & ~x[1] & x[0]);
	//assign seg[1] = (x[2] & ~x[1] & x[0]) | (x[2] & x[1] & ~x[0]);
	//assign seg[2] = (~x[2] & x[1] & ~x[0]);
	//assign seg[3] = (x[2] & ~x[1] & ~x[0]) | (x[2] & x[1] & x[0]) | (~x[3] & ~x[2] & ~x[1] & x[0]);
	//assign seg[4] = x[0] | (x[2] & ~x[1]);
	//assign seg[5] = (~x[2] & x[1]) | (~x[3] & ~x[2] & x[0]) | (x[1] & x[0]);
	//assign seg[6] = (~x[3] & ~x[2] & ~x[1]) | (x[2] & x[1] & x[0]);

// (0 ~ 9) and (14=E, 15=r, 16=S, 17=u, 18=b, 19=P, 20=L, 21 = U,22,23,24)
	assign seg[0] = (x == 5'd1) | (x == 5'd4) | (x == 5'd15) | (x == 5'd17) | (x == 5'd18) | (x == 5'd20) | (x == 5'd21) | (x == 5'd22);
	assign seg[1] = (x == 5'd5) | (x == 5'd6) | (x == 5'd14) | (x == 5'd15) | (x == 5'd16) | (x == 5'd17) | (x == 5'd18) | (x == 5'd20) | (x == 5'd22) | (x == 5'd23) | (x == 5'd24);
	assign seg[2] = (x == 5'd2) | (x == 5'd14) | (x == 5'd15) | (x == 5'd19) | (x == 5'd20) | (x == 5'd22) | (x == 5'd23) | (x == 5'd24);
	assign seg[3] = (x == 5'd1) | (x == 5'd4) | (x == 5'd7) | (x == 5'd15) | (x == 5'd19) | (x == 5'd22);
	assign seg[4] = (x == 5'd1) | (x == 5'd3) | (x == 5'd4) | (x == 5'd5) | (x == 5'd7) | (x == 5'd9) | (x == 5'd16) | (x == 5'd22) | (x == 5'd23) | (x == 5'd24);
	assign seg[5] = (x == 5'd1) | (x == 5'd2) | (x == 5'd3) | (x == 5'd15) | (x == 5'd17) | (x == 5'd22) | (x == 5'd23) | (x == 5'd24);
	assign seg[6] = (x == 5'd0) | (x == 5'd1) | (x == 5'd7) | (x == 5'd17) | (x == 5'd20) | (x == 5'd21) | (x == 5'd24);
//	assign an[3:0] = 4'b 1110;

endmodule
