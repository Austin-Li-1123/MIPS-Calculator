// 00 -> AND, 01 -> OR, 10 -> NOR, 11 -> XOR
module logicunit(out, A, B, control);
    output      out;
    input       A, B;
    input [1:0] control;

    wire and_wire, or_wire, nor_wire, xor_wire; 
    and both0(and_wire, A, B);
    or ctrl0_1(or_wire, A, B);
    nor ctrl1_1(nor_wire, A, B);
    xor both1(xor_wire, A, B);
    mux4v select_lu(out, and_wire, or_wire, nor_wire, xor_wire, control);

endmodule // logicunit
