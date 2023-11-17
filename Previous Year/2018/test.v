module TESTBENCH;
    reg a, b, c;
    wire res;

    or OR1 (res, a, b, c);
    initial begin
        a = 1'b0; b = 1'b0; c = 1'b0;
        $monitor($time, "RES = %b", res);
    end
endmodule