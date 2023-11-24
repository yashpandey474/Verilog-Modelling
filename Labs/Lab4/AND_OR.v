//DATAFLOW MODELLING
module AND_32BIT (out, in1, in2);
    input [31: 0] in1, in2;
    output [31: 0] out;

    assign out = in1 & in2;
endmodule

module OR_32IBIT (out, in1, in2);
    input [31: 0] in1, in2;
    output [31: 0] out;

    assign out = in1 | in2;
endmodule

