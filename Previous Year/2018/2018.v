`timescale 1us / 1us

//D FLIP FLOP FOR OUTPUT
module D_FLIP_FLOP(Q, D, clock);
    input D, clock;
    output reg Q;

    always @ (negedge clock)
    begin
        //ALLOW DEFAULT VALUE
        case (D)
        1'b0: Q <= 1'b0;
        1'b1: Q <= 1'b1;
        //SO THAT Q IS SET TO 0 WHEN INPUT HAS NO VALUE
        default: Q <= 1'b0;
        endcase
    end
endmodule   

//CONTROL UNIT
module CONTROLLOGIC (start, Z, X, clock, clear, T0, T1, T2);
    //PORTS OF MODULE
    input start, Z, X, clock, clear;
    output T0, T1, T2;

    //INPUTS OF FLIP FLOPS
    wire input1, input2, input3;

    //GATE OUTPUTS
    wire T0_NS, T2_Z, T0_S, T2_NX_NZ, T1_NX, T1_X, T2_NZ_X;
    wire NS, NX, NZ;

    //INSTANTIATE FLIP FLOPS
    D_FLIP_FLOP DFF0(T0, input1, clock);
    D_FLIP_FLOP DFF1(T1, input2, clock);
    D_FLIP_FLOP DFF2(T2, input3, clock);

    not N0 (NS, start);
    not N1 (NX, X);
    not N2 (NZ, Z);

    and A0 (T0_NS, T0, NS);
    and A1 (T2_Z, T2, Z);

    and A4 (T0_S, T0, start);
    and A5 (T2_NX_NZ, T2, NX, NZ);
    and A6 (T1_NX, T1, NX);

    and A2 (T1_X, T1, X);
    and A3 (T2_NZ_X, T2, NZ, X);

    or OR1 (input1, T0_NS, T2_Z);
    or OR2 (input2, T0_S, T2_NX_NZ, T1_NX);
    or OR3 (input3, T1_X, T2_NZ_X);

endmodule

//TFLIP FLOP WITH A SYNCHRONOUS CLEAR
module T_FLIP_FLOP (T, Q, clock, clear);
    input T, clock, clear;
    output reg Q;

    always @ (negedge clock)
    begin
        //SYNCHRONOUS CLEAR
        if (clear) Q <= 1'b0;
        //ALLOW DEFAULT VALUE
        else case(T)
        1'b0: Q <= Q;
        1'b1: Q <= ~Q;
        //WHEN T = 1'bx
        default: Q <= 1'b0;
        endcase
    end
endmodule

//SYNCHRONOUS 4 BIT COUNTER WITH SYNCHRONOUS CLEAR
module COUNTER_4BIT (counter_out, enable, clear, clock);
    //PORTS OF MODULE
    input enable, clear, clock;
    output [3: 0] counter_out;

    //INSTANTIATE FLIP FLOPS
    T_FLIP_FLOP TFF0(1'b1, counter_out[0], clock, clear);
    T_FLIP_FLOP TFF1(counter_out[0], counter_out[1], clock, clear);
    T_FLIP_FLOP TFF2(counter_out[0] & counter_out[1],counter_out[2], clock, clear);
    T_FLIP_FLOP TFF3(counter_out[0] & counter_out[1] & counter_out[2], counter_out[3], clock, clear);
endmodule

//INTEGRATE ALL THESE MODULES
module INTG (start, clock, X, counter_out, G);
    //PORTS OF MODULE
    input start, clock, X;
    output G;
    output [3: 0] counter_out;

    //GATE & MODULE WIRES
    wire Z, enableCounter, clearCounter, flipFlopInput;
    wire T0, T1, T2;
    wire T1_X, T2_NZ_X;
    wire NZ, NS;


    //NOTS
    not N1 (NZ, Z);

    //ANDS
    and A0(clearCounter, T0, start);
    and A1 (T1_X, T1, X);
    and A2 (T2_NZ_X, T2, NZ, X);
    and A4 (flipFlopInput, Z, T2);

    //ORS
    or OR0 (enableCounter, T1_X, T2_NZ_X);

    //ASSIGN Z
    assign Z = counter_out[0] & counter_out[1] & counter_out[2] & counter_out[3];

    //INSTANTIATE THE OUTPUT FLIP FLOP
    D_FLIP_FLOP D0(G, flipFlopInput, clock);

    //INSTANTITATE THE CONTROLLER
    CONTROLLOGIC CON(start, Z, X, clock, clear, T0, T1, T2);

    //INSTANTITATE THE COUNTER
    COUNTER_4BIT COUNTER(counter_out, enableCounter, clearCounter, clock);
endmodule

module TESTBENCH;
    //VARY START, X AND CLOCK
    reg start, X, clock;

    //OUTPUT
    wire G;
    wire [3: 0] counter_out;

    INTG DP(start, clock, X, counter_out, G);

    initial begin
        //INITIIALLY ALL INPUTS ARE 0
        clock = 1'b0;
        start = 1'b0;
        X = 1'b0;
    end

    always #500 clock = ~clock;

    initial begin
        $monitor ($time, "COUNTER_OUT = %d G = %b", counter_out, G);
        //START MADE 1 (SO COUNTER SHOULD BE CLEARED NOW)
        #1000 start = 1'b1; X = 1'b1;
        #10000 $finish;
    end
endmodule