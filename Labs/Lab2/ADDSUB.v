module FULLADDER(in1, in2, cin, sum, cout);
    input in1, in2, cin;
    output reg sum, cout;

    always @ (*)
    begin
        sum = in1 ^ in2 ^ cin;
        cout = (in1 & in2) | (cin & (in1 ^ in2)); // Carry calculation
    end
endmodule

// sum = in1 ^ in2 ^ cin;
// cout = in1 & in2 || cin & (in1 ^ in2)

module ADDSUB(A, B, M, cin, cout, overflow, sum);
    input [3: 0] A, B;
    input cin, M;

    output cout, overflow;
    output [3: 0] sum;

    wire [3: 0] carry;
    FULLADDER FA0(A[0], M ^ B[0], cin, sum[0], carry[0]);
    FULLADDER FA1(A[1], M ^ B[1], carry[0], sum[1], carry[1]);
    FULLADDER FA2(A[2], M ^ B[2], carry[1], sum[2], carry[2]);
    FULLADDER FA3(A[3], M ^ B[3], carry[2], sum[3], carry[3]);
    assign overflow = carry[2] ^ carry[3];
    assign cout = carry[3];
endmodule

module TESTBENCH;
    reg [3: 0] A, B;
    reg M, cin;

    wire cout, overflow;
    wire [3: 0] sum;
    ADDSUB MOD(A, B, M, M, cout, overflow, sum);

    initial begin
        $monitor ($time, "A = %d B = %d COUT = %b OVERFLOW = %b SUM = %d\n", A, B, cout, overflow, sum);

        #5 A = 10; B = 5; M = 0;
        #10 A = 9; B = 4; M = 1;
        
    end
endmodule