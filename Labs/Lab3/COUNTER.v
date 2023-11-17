//4-BIT SYNCHRONOUS COUNTER USING J-K FLIP FLOPS
module JK_FLIP_FLOP (J, K, clock, Q);
    input J, K, clock;
    output reg Q;
    
    initial begin
        Q = 1'b0;
    end
    always @ (posedge clock)
    begin
        case({J, K})
        2'b00: Q <= Q;
        2'b01: Q <= 1'b0;
        2'b10: Q <= 1'b1;
        2'b11: Q <= ~Q;
        default: Q <= 1'b0;
        endcase
    end
endmodule

module COUNTER_4BIT_JK_SYNC (counter_out, clock);
    input clock;
    output [3: 0] counter_out;

    JK_FLIP_FLOP JKFF0(1'b1, 1'b1, clock, counter_out[0]);
    JK_FLIP_FLOP JKFF1(counter_out[0], counter_out[0], clock, counter_out[1]);
    JK_FLIP_FLOP JKFF2(counter_out[1] & counter_out[0], counter_out[1] & counter_out[0], clock, counter_out[2]);
    JK_FLIP_FLOP JKFF3(counter_out[0] & counter_out[1] & counter_out[2], counter_out[0] & counter_out[1] & counter_out[2], clock, counter_out[3]);
endmodule

module TESTBENCH;
    wire [3: 0] counter_out;
    reg clock;

    COUNTER_4BIT_JK_SYNC COUNTER(counter_out, clock);

    initial begin
        clock = 1'b0;
    end

    always #5 clock = ~clock;

    initial begin
        $monitor ($time, "COUNTER OUT = %b", counter_out);

    end
endmodule