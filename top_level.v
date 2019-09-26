module top_level(seg, an, clk_in, sw, JA, led);
	output [6:0] seg;
	output [3:0] an;
	input clk_in;
	inout  [7:0] JA;
	input   sw;
	output [15:0] led;

	wire clk, clk_dsp, clk_debug;

	wire reset = sw;
	wire [7:0] alu_out;
	wire [4:0] hundreds_val;
	wire [4:0] tens_val;
	wire [4:0] ones_val;
	wire [1:0] mux_signal;

	wire ONES, TENS, HUNDREDS;
  wire ones_next = (HUNDREDS & ~ONES & ~TENS) | reset;
  wire tens_next = (ONES & ~TENS & ~ HUNDREDS) & ~reset;
  wire hundreds_next = (TENS & ~ONES & ~HUNDREDS) & ~reset;

	dffe ones_ff(ONES, ones_next, clk_dsp, 1'b1);
	dffe tens_ff(TENS, tens_next, clk_dsp, 1'b1);
	dffe hundreds_ff(HUNDREDS, hundreds_next, clk_dsp, 1'b1);

	assign mux_signal[0] = TENS;
	assign mux_signal[1] = HUNDREDS;

	wire [3:0] final_hundreds, final_tens, final_ones, prev_hundreds, prev_tens, prev_ones;

  clk_wiz cw(clk_in, clk);
	clock_divider cd(clk, clk_dsp);                // f = 250
	clock_divider_two cd2(clk_dsp, clk_debug);     // f = 1
	wire [4:0] display_number;
	mux3v #(5) m(display_number, ones_val, tens_val, hundreds_val, mux_signal);
	BCDToLED btl2(seg, display_number);

	assign an[0] = ~ONES;
	assign an[1] = ~TENS;
	assign an[2] = ~HUNDREDS;
	assign an[3] = 1'b1;

////////////////////Translate from peripheral keys to board///////////////////////////////

// map rows & columns into numbers
	wire [7:0] number_in_bits, curr;
	assign number_in_bits[7:5] = 3'b000;
	Decoder dec(
	   .clk(clk_in),
       .Row(JA[7:4]),
       .Col(JA[3:0]),
       .DecodeOut(number_in_bits[4:0]));

// take >1 digit numbers
	wire equal = (curr[4:0] == 5'b01110) & ~DIGIT_ONE;
	wire mem_read = curr[4:0] == 5'b01111;
	wire is_number = (curr[3] == 1'b0) | (curr[2:1] == 2'b00);
	wire is_sign = ~is_number;

//////////////////////////////Main FSM for digits on board////////////////////////////////////

  wire DIGIT_ONE_uno, DIGIT_ONE_di, DIGIT_ONE_tri, DIGIT_RESTART_EQ, DIGIT_ONE, DIGIT_TWO, DIGIT_THREE, OPT, WAIT_STOP, WAIT_one, WAIT_two, WAIT_three, WAIT_all, DIGIT_RESTART_error, DIGIT_RESTART_mem;
	wire WAIT_STOP_uno, WAIT_STOP_dos, WAIT_STOP_tres, DIGIT_RESTART_EQ_uno, DIGIT_RESTART_EQ_dos, WAIT_STOP_tres;

	wire DIGIT_ONE_next = ((WAIT_all | WAIT_one | WAIT_two | WAIT_three) & is_sign & number_in_bits == 5'b11111 & ~equal) | (DIGIT_ONE & number_in_bits == 5'b11111 & ~equal) | reset;
	wire DIGIT_RESTART_EQ_next = (WAIT_STOP & is_sign & number_in_bits == 5'b11111 & equal) | (DIGIT_RESTART_EQ & number_in_bits == 5'b11111 & equal) & ~reset;
	wire DIGIT_RESTART_error_next = ((WAIT_all & is_number) & number_in_bits == 5'b11111) | (DIGIT_RESTART_error & number_in_bits == 5'b11111 & ~equal) & ~reset & ~equal;
	wire DIGIT_RESTART_mem_next = (WAIT_MEM & number_in_bits == 5'b11111) | (DIGIT_RESTART_mem & number_in_bits == 5'b11111 & ~equal & mem_read) & ~reset & ~equal;
///////////////////////////////////Split FSM States//////////////////////////////////////////////

	wire DIGIT_ONE_uno_next = (WAIT_two & is_sign & number_in_bits == 5'b11111 & ~equal) | (DIGIT_ONE_uno & number_in_bits == 5'b11111 & ~equal) & ~reset & ~equal;
	wire DIGIT_ONE_di_next = (WAIT_three & is_sign & number_in_bits == 5'b11111 & ~equal) | (DIGIT_ONE_di & number_in_bits == 5'b11111 & ~equal) & ~reset & ~equal;
	wire DIGIT_ONE_tri_next = (WAIT_all & is_sign & number_in_bits == 5'b11111 & ~equal) | (DIGIT_ONE_tri & number_in_bits == 5'b11111 & ~equal) & ~reset & ~equal;
	dffe DIGIT_ONE_uno_ff(DIGIT_ONE_uno, DIGIT_ONE_uno_next, clk_in, 1'b1);
	dffe DIGIT_ONE_di_ff(DIGIT_ONE_di, DIGIT_ONE_di_next, clk_in, 1'b1);
	dffe DIGIT_ONE_tri_ff(DIGIT_ONE_tri, DIGIT_ONE_tri_next, clk_in, 1'b1);

	wire DIGIT_RESTART_EQ_uno_next = (WAIT_two & number_in_bits == 5'b11111 & equal) | (DIGIT_RESTART_EQ_uno & number_in_bits == 5'b11111 & equal) & ~reset;
	wire DIGIT_RESTART_EQ_dos_next = (WAIT_three & is_sign & number_in_bits == 5'b11111 & equal) | (DIGIT_RESTART_EQ_dos & number_in_bits == 5'b11111 & equal) & ~reset;
	wire DIGIT_RESTART_EQ_tres_next = (WAIT_all & is_sign & number_in_bits == 5'b11111 & equal) | (DIGIT_RESTART_EQ_tres & number_in_bits == 5'b11111 & equal) & ~reset;

	dffe DIGIT_RESTART_EQ_uno_ff(DIGIT_RESTART_EQ_uno, DIGIT_RESTART_EQ_uno_next, clk_in, 1'b1);
	dffe DIGIT_RESTART_EQ_dos_ff(DIGIT_RESTART_EQ_dos, DIGIT_RESTART_EQ_dos_next, clk_in, 1'b1);
	dffe DIGIT_RESTART_EQ_tres_ff(DIGIT_RESTART_EQ_tres, DIGIT_RESTART_EQ_tres_next, clk_in, 1'b1);

	///////////////////////////////////Split FSM States//////////////////////////////////////////////

	wire DIGIT_TWO_next = (WAIT_one & is_number & number_in_bits == 5'b11111) | (DIGIT_TWO & number_in_bits == 5'b11111) & ~reset & ~equal & ~is_sign;
  wire DIGIT_THREE_next = (WAIT_two & is_number & number_in_bits == 5'b11111) | (DIGIT_THREE & number_in_bits == 5'b11111) & ~reset & ~equal & ~is_sign;
  wire OPT_next = (WAIT_three & is_number & number_in_bits == 5'b11111) | (OPT & number_in_bits == 5'b11111) & ~reset;
	wire WAIT_STOP_next = (WAIT_STOP |  (equal & ~(WAIT_STOP | DIGIT_RESTART_EQ))) & number_in_bits != 5'b11111 & ~reset;
  wire WAIT_one_next = ((DIGIT_ONE | WAIT_one | DIGIT_RESTART_EQ | DIGIT_RESTART_error| DIGIT_RESTART_mem) & number_in_bits != 5'b11111) & ~reset & (~equal | (DIGIT_RESTART_EQ & equal));
  wire WAIT_two_next =  ((DIGIT_TWO | WAIT_two) & number_in_bits != 5'b11111) & ~reset;
  wire WAIT_three_next =  ((DIGIT_THREE | WAIT_three) & number_in_bits != 5'b11111) & ~reset;
	wire WAIT_all_next =  ((OPT | WAIT_all) & number_in_bits != 5'b11111) & ~reset;

	wire WAIT_MEM_next = (WAIT_MEM |  (mem_read & ~(WAIT_STOP | DIGIT_RESTART_EQ))) & number_in_bits != 5'b11111 & ~reset;

////////////////////////////////////////////////////////

	dffe DIGIT_ONE_ff(DIGIT_ONE, DIGIT_ONE_next, clk_in, 1'b1);
	dffe DIGIT_TWO_ff(DIGIT_TWO, DIGIT_TWO_next, clk_in, 1'b1);
	dffe DIGIT_THREE_ff(DIGIT_THREE, DIGIT_THREE_next, clk_in, 1'b1);
	dffe DIGIT_RESTART_EQ_ff(DIGIT_RESTART_EQ, DIGIT_RESTART_EQ_next, clk_in, 1'b1);
	dffe DIGIT_RESTART_error_ff(DIGIT_RESTART_error, DIGIT_RESTART_error_next, clk_in, 1'b1);
	dffe DIGIT_RESTART_mem_ff(DIGIT_RESTART_mem, DIGIT_RESTART_mem_next, clk_in, 1'b1);

	dffe OPT_ff(OPT, OPT_next, clk_in, 1'b1);
	dffe WAIT_STOP_ff(WAIT_STOP, WAIT_STOP_next, clk_in, 1'b1);
    dffe WAIT_one_ff(WAIT_one, WAIT_one_next, clk_in, 1'b1);
    dffe WAIT_two_ff(WAIT_two, WAIT_two_next, clk_in, 1'b1);
    dffe WAIT_three_ff(WAIT_three, WAIT_three_next, clk_in, 1'b1);
    dffe WAIT_all_ff(WAIT_all, WAIT_all_next, clk_in, 1'b1);
			dffe WAIT_MEM_ff(WAIT_MEM, WAIT_MEM_next, clk_in, 1'b1);

  register #(8) get_new_val(curr, number_in_bits, clk_in, (number_in_bits != 8'b11111), reset);

	wire [4:0] first_digit, second_digit, third_digit;
	register #(5) first_do(first_digit, curr[4:0], clk_dsp, DIGIT_TWO, reset);
	register #(5) second_do(second_digit, curr[4:0], clk_dsp, DIGIT_THREE, reset);
	register #(5) three_do(third_digit, curr[4:0], clk_dsp, OPT, reset);


	wire [3:0] tens_sig;
	wire [15:0] n;  //nothing
	wire add_opt = (DIGIT_ONE & (curr == 5'd10));
	wire sub_opt = (DIGIT_ONE & (curr == 5'd11));
	wire mul_opt = (DIGIT_ONE & (curr == 5'd12));
	wire div_opt = (DIGIT_ONE & (curr == 5'd13));

	assign tens_sig[0] = DIGIT_THREE | OPT | sub_opt | div_opt | DIGIT_RESTART_mem;
	assign tens_sig[1] = OPT | (DIGIT_ONE & ~div_opt & ~mul_opt) | DIGIT_RESTART_EQ | DIGIT_RESTART_mem;
	assign tens_sig[2] = DIGIT_RESTART_error | mul_opt | div_opt | DIGIT_RESTART_EQ | DIGIT_RESTART_mem;
	assign tens_sig[3] = add_opt | sub_opt | mul_opt | div_opt | DIGIT_RESTART_EQ | DIGIT_RESTART_mem;

	mux16v #(5) hundreds_mux(hundreds_val, 5'b0, 5'b0, 5'b0,first_digit, 5'd14, n,n,n,n,n,5'd19,5'd16,5'd24,5'd22,final_hundreds_out,prev_hundreds,tens_sig);

	mux16v #(5) tens_mux(tens_val, 5'b0, first_digit, 5'b0, second_digit, 5'd15, n,n,n,n,n,5'd20,5'd17,5'd22,5'd23,final_tens_out,prev_tens,tens_sig);

	mux16v #(5) ones_mux(ones_val, first_digit, second_digit, 5'b0, third_digit, 5'd15, n,n,n,n,n,5'd21,5'd18,5'd24,5'd22,final_ones_out,prev_ones,tens_sig);

	//assign led[0] = tens_sig[0];
	//assign led[1] = tens_sig[1];
	//assign led[2] = tens_sig[2];
	//assign led[3] = tens_sig[3];
	//assign led[4] = 1'b1;
	//assign led[5] = 1'b1;
	//assign led[6] = 1'b1;
	//assign led[7] = 1'b1;
	//assign led[8] = 1'b1;
	//assign led[9] = 1'b1;
	//assign led[10] = 1'b1;
	//assign led[11] = 1'b1;
	//assign led[12] = 1'b1;
	//assign led[13] = 1'b1;
	//assign led[14] = 1'b1;
	//assign led[15] = 1'b1;


/////////////////////////////////////calculation///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	wire [31:0] out_add, out_sub, out_mul, out_div, final_final, previous_result;
	alu32 al3(out_add, ,,, {22'b0,first_first}, {22'b0,second_second}, 3'h2);
	alu32 al4(out_sub, ,,, {22'b0,first_first}, {22'b0,second_second}, 3'h3);
	wallace w22(first_first[7:0],second_second[7:0], out_mul);
	division di1(first_first,second_second,out_div[9:0]);

	wire add_flag, sub_flag, mul_flag, div_flag;


	register #(1) add_flag_reg(add_flag, (curr == 5'd10), clk_in, DIGIT_ONE, reset);
	register #(1) sub_flag_reg(sub_flag, (curr == 5'd11), clk_in, DIGIT_ONE, reset);
	register #(1) mul_flag_reg(mul_flag, (curr == 5'd12), clk_in, DIGIT_ONE, reset);
	register #(1) div_flag_reg(div_flag, (curr == 5'd13), clk_in, DIGIT_ONE, reset);

		wire [1:0] final_sig;
		assign final_sig[0] = sub_flag | add_flag;
		assign final_sig[1] = mul_flag | add_flag;

	//add=0, sub=1, mul=2, div=3
	mux4v #(32)mux100(final_final, out_div, out_sub, out_mul, out_add, final_sig);
	DecimalDigitDecoder d100(final_final[7:0], final_hundreds, final_tens, final_ones);
	register #(32) mem_reg(previous_result, final_final, clk_in, (equal & DIGIT_RESTART_EQ), reset);
//////////////////////////////////////////
wire [3:0] final_hundreds_out,final_tens_out,final_ones_out;
wire [31:0] final_hundreds_plus,final_tens_plus,final_ones_plus;

	alu32 al5(final_hundreds_plus, ,,,{28'b0 ,final_hundreds}, 32'h2, 3'h2);
	mux2v #(4)mx1(final_hundreds_out, final_hundreds, final_hundreds_plus[3:0], final_final[8]);
	alu32 al6(final_tens_plus, ,,,{28'b0 ,final_tens}, 32'h5, 3'h2);
	mux2v #(4)mx2(final_tens_out, final_tens, final_tens_plus[3:0], final_final[8]);
	alu32 al7(final_ones_plus, ,,,{28'b0 ,final_ones}, 32'h6, 3'h2);
	mux2v #(4)mx3(final_one_out, final_ones, final_ones_plus[3:0], final_final[8]);

////////////////////////////////////////

	DecimalDigitDecoder pred_ddd(previous_result[7:0], prev_hundreds, prev_tens, prev_ones);


////////////////////first_input///////////////////////////////////////////

	wire [1:0] seg_mux;
	assign seg_mux[0] = DIGIT_ONE_di | DIGIT_RESTART_EQ_dos;
	assign seg_mux[1] = DIGIT_ONE_tri |  DIGIT_RESTART_EQ_tres;

	wire [4:0] first_ones_val, first_tens_val, first_hundreds_val;

	mux3v #(5) mux_one(first_hundreds_val, 5'b0, 5'b0,first_digit,seg_mux);

	mux3v #(5) mux_two(first_tens_val, 5'b0, first_digit, second_digit,seg_mux);
	//ones
	mux3v #(5) mux_three(first_ones_val, first_digit, second_digit, third_digit,seg_mux);

	wire [15:0] temp_hundred, temp_ten;
	wire [31:0] temp_o, temp_oo;
	wallace times_a_hundred({2'b0, first_hundreds_val}, 7'd100, temp_hundred);
	wallace times_a_ten({2'b0, first_tens_val}, 7'd10, temp_ten);

	alu32 al1(temp_o, ,,, {16'b0,temp_ten}, {16'b0,temp_hundred}, 3'h2);
	alu32 al2(temp_oo, ,,, temp_o, {27'b0, first_ones_val}, 3'h2);

	wire [9:0] first_first, second_second;
	register #(10) store_one(first_first, temp_oo, clk_in, (DIGIT_ONE_uno | DIGIT_ONE_di | DIGIT_ONE_tri), reset);
	register #(10) store_two(second_second, temp_oo, clk_in, (DIGIT_RESTART_EQ_uno | DIGIT_RESTART_EQ_dos | DIGIT_RESTART_EQ_tres), reset);


////////////////////////first_input//////////////////////////////////////

//	assign led[0] = WAIT_three;
//	assign led[1] = DIGIT_THREE;
//	assign led[2] = OPT;
//	assign led[3] = WAIT_all;
//	assign led[4] = DIGIT_RESTART_EQ_tres;
//	assign led[5] = 1'b0;
//	assign led[6] = 1'b0;
//	assign led[7] = 1'b0;
//	assign led[8] = temp_oo[8];
//	assign led[9] = temp_oo[9];
//	assign led[10] = 1'b0;
//	assign led[11] = 1'b0;
//	assign led[12] = 1'b0;
//	assign led[13] = 1'b0;
//	assign led[14] = 1'b0;
//	assign led[15] = 1'b0;

	assign led[0] = first_first[0];
	assign led[1] = first_first[1];
	assign led[2] = first_first[2];
	assign led[3] = first_first[3];
	assign led[4] = first_first[4];
	assign led[5] = first_first[5];
	assign led[6] = first_first[6];
	assign led[7] = first_first[7];
	assign led[8] = first_first[8];
	assign led[9] = first_first[9];
	assign led[10] = 1'b0;
	assign led[11] = 1'b0;
	assign led[12] = WAIT_MEM;
	assign led[13] = DIGIT_RESTART_mem;
	assign led[14] = final_sig[0];
	assign led[15] = final_sig[1];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




endmodule
