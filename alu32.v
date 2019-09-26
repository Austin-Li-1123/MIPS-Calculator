//implement your 32-bit ALU
module alu32(out, overflow, zero, negative, A, B, control);
    output [31:0] out;
    output        overflow, zero, negative;
    input  [31:0] A, B;
    input   [2:0] control;
    wire [31:0] chain, cout;
     
    alu1 alu0(out[0], cout[0], A[0], B[0], control[0], control[2:0]);
    alu1 alu1(out[1], cout[1], A[1], B[1], cout[0], control[2:0]);
    alu1 alu2(out[2], cout[2], A[2], B[2], cout[1], control[2:0]);
    alu1 alu3(out[3], cout[3], A[3], B[3], cout[2], control[2:0]);
    alu1 alu4(out[4], cout[4], A[4], B[4], cout[3], control[2:0]);
    alu1 alu5(out[5], cout[5], A[5], B[5], cout[4], control[2:0]);
    alu1 alu6(out[6], cout[6], A[6], B[6], cout[5], control[2:0]);
    alu1 alu7(out[7], cout[7], A[7], B[7], cout[6], control[2:0]);
    alu1 alu8(out[8], cout[8], A[8], B[8], cout[7], control[2:0]);
    alu1 alu9(out[9], cout[9], A[9], B[9], cout[8], control[2:0]);
    alu1 alu10(out[10], cout[10], A[10], B[10], cout[9], control[2:0]);
    alu1 alu11(out[11], cout[11], A[11], B[11], cout[10], control[2:0]);
    alu1 alu12(out[12], cout[12], A[12], B[12], cout[11], control[2:0]);
    alu1 alu13(out[13], cout[13], A[13], B[13], cout[12], control[2:0]);
    alu1 alu14(out[14], cout[14], A[14], B[14], cout[13], control[2:0]);
    alu1 alu15(out[15], cout[15], A[15], B[15], cout[14], control[2:0]);
    alu1 alu16(out[16], cout[16], A[16], B[16], cout[15], control[2:0]);
    alu1 alu17(out[17], cout[17], A[17], B[17], cout[16], control[2:0]);
    alu1 alu18(out[18], cout[18], A[18], B[18], cout[17], control[2:0]);
    alu1 alu19(out[19], cout[19], A[19], B[19], cout[18], control[2:0]);
    alu1 alu20(out[20], cout[20], A[20], B[20], cout[19], control[2:0]);
    alu1 alu21(out[21], cout[21], A[21], B[21], cout[20], control[2:0]);
    alu1 alu22(out[22], cout[22], A[22], B[22], cout[21], control[2:0]);
    alu1 alu23(out[23], cout[23], A[23], B[23], cout[22], control[2:0]);
    alu1 alu24(out[24], cout[24], A[24], B[24], cout[23], control[2:0]);
    alu1 alu25(out[25], cout[25], A[25], B[25], cout[24], control[2:0]);
    alu1 alu26(out[26], cout[26], A[26], B[26], cout[25], control[2:0]);
    alu1 alu27(out[27], cout[27], A[27], B[27], cout[26], control[2:0]);
    alu1 alu28(out[28], cout[28], A[28], B[28], cout[27], control[2:0]);
    alu1 alu29(out[29], cout[29], A[29], B[29], cout[28], control[2:0]);
    alu1 alu30(out[30], cout[30], A[30], B[30], cout[29], control[2:0]);
    alu1 alu31(out[31], cout[31], A[31], B[31], cout[30], control[2:0]);

    or or1(chain[1], out[0], out[1]);
    or or2(chain[2], out[2], chain[1]);
    or or3(chain[3], out[3], chain[2]);
    or or4(chain[4], out[4], chain[3]);
    or or5(chain[5], out[5], chain[4]);
    or or6(chain[6], out[6], chain[5]);
    or or7(chain[7], out[7], chain[6]);
    or or8(chain[8], out[8], chain[7]);
    or or9(chain[9], out[9], chain[8]);
    or or10(chain[10], out[10], chain[9]);
    or or11(chain[11], out[11], chain[10]);
    or or12(chain[12], out[12], chain[11]);
    or or13(chain[13], out[13], chain[12]);
    or or14(chain[14], out[14], chain[13]);
    or or15(chain[15], out[15], chain[14]);
    or or16(chain[16], out[16], chain[15]);
    or or17(chain[17], out[17], chain[16]);
    or or18(chain[18], out[18], chain[17]);
    or or19(chain[19], out[19], chain[18]);
    or or20(chain[20], out[20], chain[19]);
    or or21(chain[21], out[21], chain[20]);
    or or22(chain[22], out[22], chain[21]);
    or or23(chain[23], out[23], chain[22]);
    or or24(chain[24], out[24], chain[23]);
    or or25(chain[25], out[25], chain[24]);
    or or26(chain[26], out[26], chain[25]);
    or or27(chain[27], out[27], chain[26]);
    or or28(chain[28], out[28], chain[27]);
    or or29(chain[29], out[29], chain[28]);
    or or30(chain[30], out[30], chain[29]);
    or or31(chain[31], out[31], chain[30]);

    not all_ors(zero, chain[31]);
    assign negative = out[31];
    xor for_overflow(overflow, cout[31], cout[30]);


endmodule // alu32
