module FULL_ADDER_1BIT (in1, in2, cin, cout, sum);
    input in1, in2, cin;
    output cout, sum;

    assign {cout, sum} = (in1 + in2 + cin);
endmodule

module FULL_ADDER_32BIT (in1, in2, cin, cout, sum);
    input [31: 0] in1, in2;
    input cin;

    output [31: 0] sum;
    output cout;

    wire [32: 0] carry;

    assign carry[0] = cin;

    genvar j;
    generate for (j = 0; j < 32; j = j + 1) begin: FULL_ADDER_LOOP
        FULL_ADDER_1BIT FAj(in1[j], in2[j], carry[j], carry[j + 1], sum[j]);
    end

    assign cout = carry[32];
    endgenerate
endmodule

// module TESTBENCH;
//     reg [31: 0] in1, in2;
//     reg cin;

//     wire [31: 0] sum;
//     wire cout;

//     FULL_ADDER_32BIT FA(in1, in2, cin, cout, sum);

//     initial begin
//         $monitor ($time, "IN1 = %d IN2 = %d CIN = %b SUM = %d COUT = %b\n", in1, in2, cin, sum, cout);
//         in1 = 32'd100; in2 = 32'd100; cin = 1'b0;
//         #100 in1 = 32'd50; in2 =32'd45; cin = 1'b0;
//         #100 $finish;
//     end
// endmodule