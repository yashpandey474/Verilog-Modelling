module MUX2TO1 (
    out, in1, in2, sel
);

    output [31: 0] out;
    input [31: 0] in1, in2;
    input sel;

    always @ (*)
    begin
        if (sel) out <= in2;
        else out <= in1;
    end
endmodule

module MUX2TO1_5bit(
    out, in1, in2, sel
);
    output [4: 0] out;
    input [4: 0] in1, in2;
    input sel;

    always @ (*)
    begin
        if (sel) out <= in2;
        else out <= in1;
    end
endmodule