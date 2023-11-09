module MUX_2TO1_1bit(out, in1, in2, sel);
    input in1,in2,sel;
    output out;
    wire not_sel,a1,a2;
    not (not_sel,sel);
    and (a1,sel,in2);
    and (a2,not_sel,in1);
    or(out,a1,a2);
endmodule

module MUX_2TO1_32bit (out, in1, in2, sel);
    input [31: 0] in1, in2;
    output [31: 0] out;

    input sel;

    genvar j;

    generate for(j = 0; j < 32; j = j + 1) begin: MUX_LOOP
        MUX_2TO1_1bit Mj(out[j], in1[j], in2[j], sel);
    end
    endgenerate
endmodule