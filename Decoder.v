`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc 2011
// Engineer: Michelle Yu
//				 Josh Sackos
// Create Date:    07/23/2012
//
// Module Name:    Decoder
// Project Name:   PmodKYPD_Demo
// Target Devices: Nexys3
// Tool versions:  Xilinx ISE 14.1
// Description: This file defines a component Decoder for the demo project PmodKYPD. The Decoder scans
//					 each column by asserting a low to the pin corresponding to the column at 1KHz. After a
//					 column is asserted low, each row pin is checked. When a row pin is detected to be low,
//					 the key that was pressed could be determined.
//
// Revision History:
// 						Revision 0.01 - File Created (Michelle Yu)
//							Revision 0.02 - Converted from VHDL to Verilog (Josh Sackos)
//            REVISION 2019 - ADDED PRESSED FLAG REGISTER TO DETECT IF KEYS PRESSED
//////////////////////////////////////////////////////////////////////////////////////////////////////////
// WE PARTIALLY MODIFIED THE CODE GIVEN BY DIGILENT IN THEIR REFERENCE MANUAL
// ==============================================================================================
// 												Define Module
// ==============================================================================================
module Decoder(
    clk,
    Row,
    Col,
    DecodeOut
    );

// ==============================================================================================
// 											Port Declarations
// ==============================================================================================
    input clk;						// 100MHz onboard clock
    input [3:0] Row;				// Rows on KYPD
    output [3:0] Col;			// Columns on KYPD
    output [4:0] DecodeOut;	// Output data

// ==============================================================================================
// 							  		Parameters, Regsiters, and Wires
// ==============================================================================================

	// Output wires and registers
	reg [3:0] Col;
	reg [4:0] DecodeOut;

	// Count register
	reg [19:0] sclk;
  reg pressed;

// ==============================================================================================
// 												Implementation
// ==============================================================================================

	always @(posedge clk) begin

			// 1ms
			if (sclk == 20'b00011000011010100000) begin
				//C1
				Col <= 4'b0111;
				sclk <= sclk + 1'b1;
			end

			// check row pins
			else if(sclk == 20'b00011000011010101000) begin
				//R1
				if (Row == 4'b0111) begin
					DecodeOut <= 5'b0001;		//1
          pressed <= 1'b1;
				end
				//R2
				else if(Row == 4'b1011) begin
					DecodeOut <= 5'b0100; 		//4
          pressed <= 1'b1;
				end
				//R3
				else if(Row == 4'b1101) begin
					DecodeOut <= 5'b0111; 		//7
          pressed <= 1'b1;
				end
				//R4
				else if(Row == 4'b1110) begin
					DecodeOut <= 5'b0000; 		//0
          pressed <= 1'b1;
				end
        else begin
        //  DecodeOut <= 5'b11111;
        end
				sclk <= sclk + 1'b1;
			end

			// 2ms
			else if(sclk == 20'b00110000110101000000) begin
				//C2
				Col<= 4'b1011;
				sclk <= sclk + 1'b1;
			end

			// check row pins
			else if(sclk == 20'b00110000110101001000) begin
				//R1
				if (Row == 4'b0111) begin
					DecodeOut <= 5'b0010; 		//2
          pressed <= 1'b1;
				end
				//R2
				else if(Row == 4'b1011) begin
					DecodeOut <= 5'b0101; 		//5
          pressed <= 1'b1;
				end
				//R3
				else if(Row == 4'b1101) begin
					DecodeOut <= 5'b1000; 		//8
          pressed <= 1'b1;
				end
				//R4
				else if(Row == 4'b1110) begin
					DecodeOut <= 5'b1111; 		//F
          pressed <= 1'b1;
				end
        else begin
        //  DecodeOut <= 5'b11111;
        end
				sclk <= sclk + 1'b1;
			end

			//3ms
			else if(sclk == 20'b01001001001111100000) begin
				//C3
				Col<= 4'b1101;
				sclk <= sclk + 1'b1;
			end

			// check row pins
			else if(sclk == 20'b01001001001111101000) begin
				//R1
				if(Row == 4'b0111) begin
					DecodeOut <= 5'b0011; 		//3
          pressed <= 1'b1;
				end
				//R2
				else if(Row == 4'b1011) begin
					DecodeOut <= 5'b0110; 		//6
          pressed <= 1'b1;
				end
				//R3
				else if(Row == 4'b1101) begin
					DecodeOut <= 5'b1001; 		//9
          pressed <= 1'b1;
				end
				//R4
				else if(Row == 4'b1110) begin
					DecodeOut <= 5'b1110; 		//E
          pressed <= 1'b1;
				end
        else begin
      //    DecodeOut <= 5'b11111;
        end
				sclk <= sclk + 1'b1;
			end

			//4ms
			else if(sclk == 20'b01100001101010000000) begin
				//C4
				Col<= 4'b1110;
				sclk <= sclk + 1'b1;
			end

			// Check row pins
			else if(sclk == 20'b01100001101010001000) begin
				//R1
				if(Row == 4'b0111) begin
					DecodeOut <= 5'b1010; //A
          pressed <= 1'b1;
				end
				//R2
				else if(Row == 4'b1011) begin
					DecodeOut <= 5'b1011; //B
          pressed <= 1'b1;
				end
				//R3
				else if(Row == 4'b1101) begin
					DecodeOut <= 5'b1100; //C
          pressed <= 1'b1;
				end
				//R4
				else if(Row == 4'b1110) begin
					DecodeOut <= 5'b1101; //D
          pressed <= 1'b1;
				end

        else if(pressed == 1'b0) begin
          DecodeOut <= 5'b11111;
        end

				sclk <= 20'b00000000000000000000;
        pressed <= 1'b0;
			end

			// Otherwise increment
			else begin
				sclk <= sclk + 1'b1;
			end

	end

endmodule
