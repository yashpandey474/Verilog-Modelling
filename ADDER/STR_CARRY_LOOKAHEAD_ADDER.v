//gi = a and b
//pi = a xor b
//c i + 1 = gi or pi.ci
module 4b_adder(sum, cout, a, b, c);

    input c;
    output cout;
    input [3: 0] a, b;
    output [3: 0] sum;

    wire c1, c2, c3;
    wire p0, p1, p2, p3;
    wire g0, g1, g2, g3;

    assign p0 = (a[0] ^ b[0]), p1 = (a[1] ^ b[1]), p2 = (a[2] ^ b[2]), p3 = (a[3] ^ b[3]);
    assign g0 = (a[0] & b[0]), g1 = (a[1] & b[1]), g2 = (a[2] & b[2]), g3 = (a[3] & b[3]);

    assign c1 = g0 | (p0 & c), c2 = g1 | (p1 & c1), c3 = g2 | (p2 & c2), cout = g3 | (p3 & c3);

    assign sum[0] = p0 ^ c, sum[1] = p1 ^ c1, sum[2] = p2 ^ c2, sum[3] = p3 ^ c3;

endmodule