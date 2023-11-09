module MUX_4TO1_32bit (
    out, in1, in2, in3, sel
);
    input [31: 0] in1, in2, in3;
    output [31: 0] out;
    input [1: 0] sel;

    always @ (*)
        case(sel)
            2'b00: out <= in1;
            2'b01: out <= in2;
            2'b10: out <= in3;
            2'b11: out <= in4;
            default: out <= 32'hxxxxxxxx;
        endcase

endmodule