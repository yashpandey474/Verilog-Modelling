module mux21 (in1, in0, s, f);
    input in1, in0, s;
    output reg f;

    always @ (in1 or in0 or s)
    begin
        if (s) f = in1;
        else f = in0;
    end
endmodule

module mux21_1 (in1, in0, s, f);
    input in1, in0, s;
    output reg f;

    always @ (in1, in0, s)
    begin
        if (s) f = in1;
        else f = in0;
    end
endmodule

module mux21_2 (in1, in0, s, f);
    input in1, in0, s;
    output reg f;

    //* => ANY OF INPUT VARIABLES CHANGE
    always @ (*)
    begin
        if (s) f = in1;
        else f = in0;
    end
endmodule