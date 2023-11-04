//NEGATIVE EDGE TRIGGERED D FLIP FLOP
module dff_negedge(d, clock, q, qbar);

    input d, clock;
    //REG => CHANGED IN ALWAYS BLOCK
    output reg q, qbar;

    always @(negedge clock)
    begin
        //<= => NONBLOCKING. AVOID RACE CONDITIIONS
        q <= d;
        qbar <= ~d;
    end

endmodule