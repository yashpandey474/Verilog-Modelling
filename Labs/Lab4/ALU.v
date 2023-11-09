module ALU (
    result, cout, in1, in2, cin,
    binvert, control
);
    input [31: 0] in1, in2;
    output [31: 0] result;

    output cout;
    input cin, binvert;

    wire [31: 0] ANDRes, ORRes, ADDRes;
    wire [31: 0] not_in2, ADDInput;

    not NOT_GATE (not_in2, in2);
    MUX_2TO1_32bit MUX_IN2(ADDInput, in2, not_in2, binvert);

    FULL_ADDER_32bit FA (ADDRes, cout, in1, ADDInput, cin);
    AND_32bit AND (ANDRes, in1, in2);
    OR_32bit OR (ORRes, in1, in2);

    MUX_4TO1_32bit MUX_RESULT (result, ADDRes, ORRes, ADDRes, 32'b0,control);

endmodule