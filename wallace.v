module wallace(a, b, p);
	input [7:0] a, b;
	output [15:0] p;
 
	assign p[0] = a[0] & b[0];
	wire a1b0 = a[1] & b[0];
	wire a0b1 = a[0] & b[1];

	wire a2b0 = a[2] & b[0];
	wire a1b1 = a[1] & b[1];
	wire a0b2 = a[0] & b[2];

	wire a3b0 = a[3] & b[0];
	wire a2b1 = a[2] & b[1];
	wire a1b2 = a[1] & b[2];

	wire a3b1 = a[3] & b[1];
	wire a2b2 = a[2] & b[2];
	wire a1b3 = a[1] & b[3];

	wire a3b2 = a[3] & b[2];
	wire a2b3 = a[2] & b[3];

	wire a0b3 = a[0] & b[3];

	wire a3b3 = a[3] & b[3];

	////////////////////////////////////////////////////////////////

	wire [55:0] cout, sum;

	////row 1//////
	halfadder half1(p[1], cout[0], a0b1, a1b0);
	fulladder full1(sum[1], cout[1], a1b1, a2b0, cout[0]);
	fulladder full2(sum[3], cout[3], a2b1, a3b0, cout[1]);
	wire a4b0 = a[4] & b[0];
	fulladder full3(sum[6], cout[6], a3b1, a4b0, cout[3]);
	wire a5b0 = a[5] & b[0];
	wire a4b1 = a[4] & b[1];
	fulladder full4(sum[10], cout[10], a4b1, a5b0, cout[6]);
	wire a6b0 = a[6] & b[0];
	wire a5b1 = a[5] & b[1];
	fulladder full5(sum[15], cout[15], a5b1, a6b0, cout[10]);
	wire a7b0 = a[7] & b[0];
	wire a6b1 = a[6] & b[1];
	fulladder full6(sum[21], cout[21], a6b1, a7b0, cout[15]);
	wire a7b1 = a[7] & b[1];
	wire a7b2 = a[7] & b[2];
	wire a6b2 = a[6] & b[2];
	fulladder full7(sum[28], cout[28], a6b2, a7b1, cout[21]);
	wire a6b3 = a[6] & b[3];
	fulladder full8(sum[35], cout[35], a6b3, a7b2, cout[28]);
	wire a7b3 = a[7] & b[3];
	wire a6b4 = a[6] & b[4];
	fulladder full9(sum[41], cout[41], a7b3, a6b4, cout[35]);
	wire a7b4 = a[7] & b[4];
	wire a6b5 = a[6] & b[5];
	fulladder full10(sum[46], cout[46], a6b5, a7b4, cout[41]);
	wire a7b5 = a[7] & b[5];
	wire a6b6 = a[6] & b[6];
	fulladder full11(sum[50], cout[50], a6b6, a7b5, cout[46]);
	wire a6b7 = a[6] & b[7];
	wire a7b6 = a[7] & b[6];
	fulladder full12(sum[53], cout[53], a6b7, a7b6, cout[50]);
	wire a7b7 = a[7] & b[7];
	fulladder full13(p[14], p[15], cout[54], a7b7, cout[53]);

	////////row 2//////////
	halfadder half2(p[2], cout[2], sum[1], a0b2);
	fulladder full14(sum[4], cout[4], sum[3], a1b2, cout[2]);
	fulladder full15(sum[7], cout[7], sum[6], a2b2, cout[4]);
	fulladder full16(sum[11], cout[11], sum[10], a3b2, cout[7]);
	wire a4b2 = a[4] & b[2];
	fulladder full17(sum[16], cout[16], sum[15], a4b2, cout[11]);
	wire a5b2 = a[5] & b[2];
	fulladder full18(sum[22], cout[22], sum[21], a5b2, cout[16]);
	wire a5b3 = a[5] & b[3];
	fulladder full18_2(sum[29], cout[29], sum[28], a5b3, cout[22]);
	wire a5b4 = a[5] & b[4];
	fulladder full19(sum[36], cout[36], sum[35], a5b4, cout[29]);
	wire a5b5 = a[5] & b[5];
	fulladder full20(sum[42], cout[42], sum[41], a5b5, cout[36]);
	wire a5b6 = a[5] & b[6];
	fulladder full21(sum[47], cout[47], sum[46], a5b6, cout[42]);
	wire a5b7 = a[5] & b[7];
	fulladder full22(sum[51], cout[51], sum[50], a5b7, cout[47]);
	fulladder full23(p[13], cout[54], sum[53], cout[51], cout[52]);

	////////////row 3//////////////
	halfadder half3(p[3], cout[5], sum[4], a0b3);
	fulladder full24(sum[8], cout[8], sum[7], a1b3, cout[5]);
	fulladder full25(sum[12], cout[12], sum[11], a2b3, cout[8]);
	fulladder full26(sum[17], cout[17], sum[16], a3b3, cout[12]);
	wire a4b3 = a[4] & b[3];
	fulladder full27(sum[23], cout[23], sum[22], a4b3, cout[17]);
	wire a4b4 = a[4] & b[4];
	fulladder full28(sum[30], cout[30], sum[29], a4b4, cout[23]);
	wire a4b5 = a[4] & b[5];
	fulladder full29(sum[37], cout[37], sum[36], a4b5, cout[30]);
	wire a4b6 = a[4] & b[6];
	fulladder full30(sum[43], cout[43], sum[42], a4b6, cout[37]);
	wire a4b7 = a[4] & b[7];
	fulladder full31(sum[48], cout[48], sum[47], a4b7, cout[43]);
	fulladder full32(p[12], cout[52], sum[51], cout[48], cout[49]);

	//////////////row 4/////////////////
	wire a0b4 = a[0] & b[4];
	halfadder half4(p[4], cout[9], sum[8], a0b4);
	wire a1b4 = a[1] & b[4];
	fulladder full33(sum[13], cout[13], sum[12], a1b4, cout[9]);
	wire a2b4 = a[2] & b[4];
	fulladder full34(sum[18], cout[18], sum[17], a2b4, cout[13]);
	wire a3b4 = a[3] & b[4];
	fulladder full35(sum[24], cout[24], sum[23], a3b4, cout[18]);
	wire a3b5 = a[3] & b[5];
	fulladder full36(sum[31], cout[31], sum[30], a3b5, cout[24]);
	wire a3b6 = a[3] & b[6];
	fulladder full37(sum[38], cout[38], sum[37], a3b6, cout[31]);
	wire a3b7 = a[3] & b[7];
	fulladder full38(sum[44], cout[44], sum[43], a3b7, cout[38]);
	fulladder full39(p[11], cout[49], sum[48], cout[44], cout[45]);


	/////////////row 5////////////////////
	wire a0b5 = a[0] & b[5];
	halfadder half5(p[5], cout[14], sum[13], a0b5);
	wire a1b5 = a[1]  & b[5];
	fulladder full40(sum[19], cout[19], sum[18], a1b5, cout[14]);
	wire a2b5 = a[2] & b[5];
	fulladder full41(sum[25], cout[25], sum[24], a2b5, cout[19]);
	wire a2b6 = a[2] & b[6];
	fulladder full42(sum[32], cout[32], sum[31], a2b6, cout[25]);
	wire a2b7 = a[2] & b[7];
	fulladder full43(sum[39], cout[39], sum[38], a2b7, cout[32]);
	fulladder full44(p[10], cout[45], sum[44], cout[39], cout[40]);


	/////////////////row 6///////////////////
	wire a0b6 = a[0] & b[6];
	halfadder half6(p[6], cout[20], sum[19], a0b6);
	wire a1b6 = a[1] & b[6];
	fulladder full45(sum[26], cout[26], sum[25], a1b6, cout[20]);
	wire a1b7 = a[1] & b[7];
	fulladder full46(sum[33], cout[33], sum[32], a1b7, cout[26]);
	fulladder full47(p[9], cout[40], sum[39], cout[33], cout[34]);


	/////////////row 7/////////////////////
	wire a0b7 = a[0] & b[7];
	halfadder half7(p[7], cout[27], sum[26], a0b7);
	halfadder half8(p[8], cout[34], sum[33], cout[27]);

endmodule
