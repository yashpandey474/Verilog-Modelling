// `include "D_FLIP_FLOP.v"
module D_FLIP_FLOP(
    q, d, clock, reset
);
    output reg q;
    input d, clock, reset;

    always @ (posedge clock)
    begin
        if (~reset) q <= 0;
        else q <= d;
    end
endmodule

module REGISTER_32bit (q, d, clock, reset);
    input [31: 0] d;
    output [31: 0] q;
    input clock, reset;

    genvar j;

    generate for (j = 0; j<32; j = j + 1) begin: REGISTER_LOOP
        D_FLIP_FLOP DJ(q[j], d[j], clock, reset);
    end
    endgenerate
endmodule

module tb32reg;
    reg [31:0] d;
    reg clock,reset;
    wire [31:0] q;
    REGISTER_32bit R(q,d,clock,reset);

    always #5 clock = ~clock;

    initial
        begin
        clock= 1'b0;
        reset=1'b0;
        $monitor($time, "D = %d, Q = %d CLOCK = %b", d, q, clock);
        #20 reset=1'b1;
        #20 d=32'hAFAFAFAF;
        #200 $finish;
    end
endmodule