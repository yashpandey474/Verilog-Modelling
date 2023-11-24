//FROM SECOND FLIP FLOP, THE Q OF PREVIOUS FLIP FLOP USED AS CLOCK

//D FLIP FLOP
module D_FLIP_FLOP (D, Q, clock, reset);
    input D, clock, reset;
    output reg Q;

    always @ (negedge clock or posedge reset)
    begin
        if (reset) Q <= 1'b0;
        else Q <= D;
    end
endmodule

//T FLIP FLOP USING D FLIP FLOP
module T_FLIP_FLOP (Q, clock, reset);
    output Q;
    input clock, reset;

    D_FLIP_FLOP DFF0 (~Q, Q, clock, reset);
endmodule

//RIPPLE CARRY COUNTER USING T FLIP FLOPS
module RIPPLE_CARRY_COUNTER_TFF (counterOut, clock, reset);
    //4-BIT COUNTER
    parameter N = 4;
    input clock, reset;
    output [N - 1: 0] counterOut;

    T_FLIP_FLOP TFF0(counterOut[0], clock, reset);
    T_FLIP_FLOP TFF1(counterOut[1], counterOut[0], reset);
    T_FLIP_FLOP TFF2(counterOut[2], counterOut[1], reset);
    T_FLIP_FLOP TFF3(counterOut[3], counterOut[2], reset);
endmodule

module TESTBENCH;
    parameter N = 4;
    reg clock, reset;
    wire [N - 1: 0] counterOut;

    RIPPLE_CARRY_COUNTER_TFF COUNTER(counterOut, clock, reset);

    initial begin
        clock = 1'b0;
        reset = 1'b1;

        #15 reset = 1'b0;
    end

    always #5 clock = ~clock;


    initial begin
        $monitor ($time, " COUNTER OUT = %b RESET = %b\n", counterOut, reset);
        #1000 $finish;
    end


endmodule