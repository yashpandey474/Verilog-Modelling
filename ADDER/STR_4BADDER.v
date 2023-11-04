//RIPPLE CARY 4B ADDER
module 4b_adder(
    sum, cout, input1, input2, cin
);

    input [3: 0] input1, input2;
    input cin;
    output [3: 0] sum;
    output cout;
    wire carry[3: 1];


    fulladder FA0 (
        sum[0], carry[1],
        input1[0], input2[0], cin
    );

    fulladder FA1 (
        sum[1], carry[2],
        input1[1], input2[1],
        carry[1]
    );

    fulladder FA2(
        sum[2], carry[3],
        input1[2], input2[2],
        carry[2]
    );

    fulladder FA3(
        sum[3], cout,
        input1[3], input2[3],
        carry[3]
    );

endmodule

