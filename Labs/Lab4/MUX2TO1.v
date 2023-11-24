module MUX2TO1 (in1, in2, sel, out);
    input in1, in2, sel;
    output out;

    wire not_sel, a1, a2;

    not N0 (not_sel, sel);
    and A0 (a1, in1, not_sel);
    and A1 (a2, in2, sel);

    or OR0 (out, a1, a2);
endmodule

//8-BIT WIDE 2TO1MUX
module MUX2TO1_8BIT (in1, in2, sel, out);
    input [7: 0] in1, in2;
    input sel;
    output [7: 0] out;

    genvar j;

    generate for (j = 0; j < 8; j = j + 1) begin: MUX_LOOP
        MUX2TO1 MUXj(in1[j], in2[j], sel, out[j]);
    end
    endgenerate

endmodule

//32 BIT WIDE 2TO1 MUX
module MUX2TO1_32BIT (in1, in2, sel, out);
    input [31: 0] in1, in2;
    input sel;
    output [31: 0] out;


    genvar j;

    generate for (j = 0; j < 4; j = j + 1) begin: MUX_LOOP_1
        MUX2TO1_8BIT MUXj(in1[8*j + 7: 8*j + 0], in2[8*j + 7: 8*j + 0], sel, out[8*j + 7: 8*j + 0]);
    end
    endgenerate
endmodule

//4TO1 MUX OF 1BIT
module MUX4TO1_1BIT(in1, in2, in3, in4, sel, out);
    input in1, in2, in3, in4;
    input [1: 0] sel;
    output out;

    assign out = sel == 0? in1: sel == 1? in2: sel == 2? in3: in4;
endmodule

//4TO1 MUX OF 32BITS
module MUX4TO1_32BITS (in1, in2, in3, in4, sel, out);
    input [31: 0] in1, in2, in3, in4;
    output [31: 0] out;
    input [1: 0] sel;

    genvar j;
    generate for (j = 0; j < 32; j = j + 1) begin: MUX_LOOP_2
        MUX4TO1_1BIT MUXj(in1[j],in2[j],in3[j],in4[j], sel[1: 0], out[j]);
    end
    endgenerate
endmodule
//TESTBENCH
// module TESTBENCH;
//     reg [31: 0] in1, in2;
//     reg sel;
//     wire [31: 0] out;

//     MUX2TO1_32BIT MUX(in1, in2, sel, out);

//     initial begin
//         $monitor ($time, "IN1 = %h IN2 = %h SEL = %b OUT = %h\n", in1, in2, sel, out);
//         in1 = 32'hABCDEF12;
//         in2 = 32'h12345678;
//         sel = 1'b0;
//         #100 sel = 1'b1;
//         #1000 $finish;
//     end
// endmodule

