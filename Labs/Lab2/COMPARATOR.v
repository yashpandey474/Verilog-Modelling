//MODULE TO GET THE SIGN OF A NUMBER IN 2'S COMPLEMENT
module GETSIGN (neg, A);
    input [3: 0] A;
    output reg neg;

    always @ (A)
    begin
        if (A[3] == 1) neg = 1;
        else neg = 0;
    end
endmodule
module COMPARATOR (A, B, gt, lt, eq);
    input [3: 0] A, B;
    output reg gt, lt, eq;

    wire signA, signB;
    GETSIGN GET1(signA, A);
    GETSIGN GET2(signB, B);

    always @ (A or B or signA or signB)
    begin
        if (signA == 1 && signB == 0)
        begin
            gt = 0; eq = 0; lt = 1;
        end

        else if (signA == 0 && signB == 1)
        begin
            gt = 1; eq = 0; lt = 0;
        end

        //CAN DIRECTLY COMPARE IF SAME SIGN [HANDLED BY VERILOG]
        else if (A > B)
        begin
            gt = 1; eq = 0; lt = 0;
        end

        else if (A < B)
        begin
            gt = 0; eq = 0; lt = 1;
        end

        else begin
            gt = 0; eq = 1; lt = 0;
        end
    end
endmodule

module TESTBENCH;
    reg [3: 0] A, B;
    wire gt, eq, lt;

    COMPARATOR CMP(A, B, gt, lt, eq);

    initial begin
        $monitor ($time, "A = %d, B = %d, GT = %d, LT = %b, EQ = %b  SIGNA = %b SIGNB = %b\n", A, B, gt,lt, eq, CMP.signA, CMP.signB);

        #1 A = 4'b1100; B = 4'b1101;
        #2 A = 2; B = 7;
        #1 A = 4'b0101; B = 4'b1001;
    end
endmodule