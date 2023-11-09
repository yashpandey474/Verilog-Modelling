module REGISTER_5bit (
    out, in,
    write, clock
);

    input clock, write;
    input [31: 0] in;
    output [31: 0] out;

    always @ (posedge clock)
        if (write) out <= in;
endmodule
