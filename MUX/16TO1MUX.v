module mux16to1 (in, sel, out);
    input [15: 0] in;
    input [3: 0] sel;
    output out;


    assign out = in[sel];

endmodule;

module tb_mux16to1

    reg [15: 0] A;
    reg [3: 0] S;
    wire F;

    mux16to1 M(A, S, F);

    initial
    begin
        $monitor($time, "A = %h, S = %h, F = %h", A, S,F);
        #5 A = 16'h3f0a; S = 4'h0;
        #5 S = 4'h1;
        #5 S = 4'h6;
        #5 S = 4'hc;
        #5 $finish;
    end
endmodule;