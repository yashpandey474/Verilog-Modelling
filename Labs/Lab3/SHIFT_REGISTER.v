module D_FLIP_FLOP (D, Q, clock);
    input D, clock;
    output reg Q;

    initial begin
        Q = 1'b0;
    end
    always @ (posedge clock)
        Q <= D;
endmodule

module SHIFT_REGISTER (enable, in, clock, Q);
    input enable, in, clock;
    output [3: 0] Q;

    D_FLIP_FLOP DFF0(in, Q[0], clock);
    D_FLIP_FLOP DFF1(Q[0], Q[1], clock);
    D_FLIP_FLOP DFF2(Q[1], Q[2], clock);
    D_FLIP_FLOP DFF3(Q[2], Q[3], clock);
endmodule

module TESTBENCH;
    reg enable, in, clock;
    wire [3: 0] Q;

    SHIFT_REGISTER SHIFT_REG(enable, in, clock, Q);

    initial begin
        clock = 1'b0;
        enable = 1'b1;
    end

    always #5 clock = ~clock;

    always @ (posedge clock)
        $display ("IN = %b ENABLE = %b Q = %b\n", in, enable, Q);

    initial begin
        in = 1'b0;
        #10 in = 1'b1;
        #10 in = 1'b1;
        #10 in = 1'b0;
        #10 $finish;
    end

endmodule