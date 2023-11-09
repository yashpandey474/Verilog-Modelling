module D_FLIP_FLOP(
    q, d, clock, reset
);
    output q;
    input d, clock, reset;

    always @ (posedge clock)
    begin
        if (reset) q <= 0;
        else q <= d;
    end
endmodule