//4-BIT SYNCHRONOUS COUNTER USING JK FLIP FLOPS


//JK FLIP FLOP
module JK_FLIP_FLOP (J, K, clock, Q);
    input J, K, clock;
    output reg Q;

    initial begin
        Q = 1'b0;
    end

    always @ (posedge clock)
        case({J, K})
            //BOTH 0: SAME
            2'b00: Q <= Q;
            //BOTH 1: OPPOSITE
            2'b11: Q <= ~Q;
            //OTHERWISE, EQUAL TO J
            default: Q <= J;
        endcase
endmodule

//4-BIT COUNTER
module COUNTER_4BIT (counterOut, clock);
    input clock;
    output [3: 0] counterOut;

    JK_FLIP_FLOP JKFF0 (1'b1, 1'b1, clock, counterOut[0]);
    JK_FLIP_FLOP JKFF1 (counterOut[0], counterOut[0], clock, counterOut[1]);
    JK_FLIP_FLOP JKFF2 (counterOut[0] & counterOut[1], counterOut[0] & counterOut[1], clock, counterOut[2]);
    JK_FLIP_FLOP JKFF3 (counterOut[0] & counterOut[1] & counterOut[2], counterOut[0] & counterOut[1] & counterOut[2], clock, counterOut[3]);
endmodule


//TESTBENCH
module TESTBENCH;
    reg clock;
    wire [3: 0] counterOut;

    COUNTER_4BIT COUNTER(counterOut, clock);

    initial begin
        clock = 1'b0;
    end

    always #5 clock = ~clock;

    always @ (posedge clock)
        $display("COUNTER OUTPUT = %b\n", counterOut);

    initial begin
        #1000 $finish;
    end
endmodule