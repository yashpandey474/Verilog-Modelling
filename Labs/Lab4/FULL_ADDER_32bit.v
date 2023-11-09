module FULL_ADDER_1bit (
    sum, cout, in1, in2, cin
);

    input in1, in2, cin;
    output sum, cout;
    

    assign {cout, sum} = (in1 + in2 + cin);

endmodule

module FULL_ADDER_32bit (
    sum, cout, in1, in2, cin
);

    input [31: 0] in1, in2;
    output [31: 0] sum;
    output cout;
    input cin;

    wire [32: 0] carry_chain;
    assign carry_chain[0] = cin;

    genvar j;
    generate for (j = 0; j < 32; j = j + 1) begin: FULL_ADDER_LOOP
        FULL_ADDER_1bit FAj(sum[j], carry_chain[j + 1], in1[j], in2[j], carry_chain[j]);
    end
    endgenerate

    assign cout = carry_chain[32];
endmodule


module FA_test;
    reg [31: 0] in1, in2;
    reg cin;

    wire [31: 0] sum;
    wire cout;
    FULL_ADDER_32bit FA(
    sum, cout, in1, in2, cin
    );

    initial begin
        $monitor($time, "IN1 = %d, IN2 = %d, CIN = %d, COUT = %d, SUM = %d\n", in1, in2, cin, cout, sum);
        in1 = 32'd1; in2 = 32'd1; cin = 0;

        #5 in1 = 32'd10; in2 = 32'd10; cin = 0;

        #5 in1 = 32'd100; in2 = 32'd50; cin = 0;

        #100 $finish;
        
    end
endmodule