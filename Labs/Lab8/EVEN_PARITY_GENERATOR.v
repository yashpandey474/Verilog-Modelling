module EVEN_PARITY_GENERATOR(
    X, Out
);
    //OUTPUT IS 1 WHEN NUMBE OF 1'S IS EVEN
    input [3: 0] X;
    output Out;
    assign Out = ~ (X[0] ^ X[1] ^ X[2] ^ X[3]);
endmodule