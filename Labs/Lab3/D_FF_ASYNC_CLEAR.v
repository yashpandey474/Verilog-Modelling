module D_FLIP_FLOP_ASYNC_CLEAR (D, Q, clock, clear);
    input D, clock, clear;
    output reg Q;

    always @ (posedge clock or negedge clear)
    begin
        if (!clear) Q <= 1'b0;
        else Q <= D;
    end
endmodule

module TESTBENCH;
    reg clock, clear, D;
    wire Q;
    D_FLIP_FLOP_ASYNC_CLEAR DFF(D, Q, clock, clear);

    initial begin
        clock = 1'b0;
        clear = 1'b0;
    end

    always #5 clock = ~clock;

    always @ (posedge clock)
    begin
        $display("D = %b CLOCK = %b CLEAR = %b Q = %b\n", D, clock, clear, Q);
    end

    initial
    begin
        $dumpfile("filename.vcd");
        $dumpvars;
    end

    initial begin
        #5 clear = 1'b1;
        #10 D = 1'b0;
        #25 D = 1'b1;
        #100 $finish;
    end
endmodule

