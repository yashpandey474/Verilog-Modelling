module D_FLIP_FLOP_SYNC_CLEAR (D, Q, clock, clear);
    input D, clock, clear;
    output reg Q;

    always @ (posedge clock)
    begin
        if (!clear) Q <= 1'b0;
        else Q <= D;
    end
endmodule

