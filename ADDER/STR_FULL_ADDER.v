module full_adder (
    sum, cout, input1, input2, cin
);

    input input1, input2, cin;
    output sum, cout;

    //SUM = A XOR B XOR CIn
    wire s1, c2, c1;

    xor G1 (s1, input1, input2), G2 (sum, s1, cin), G3 (cout, c2, c1);

    //COUT = A XOR B AND CIN XOR A AND B
    and G4 (c1, input1, input2), G5 (c2, s1, cin);

endmodule

module FA_test;

    reg a, b, cin;
    wire sum, cout;

    full_adder FA (sum, cout, a, b, cin);
    
    initial
    begin
        $monitor($time, "A = %d, B = %d, CIN=  %d, SUM = %d, COUT = %d\n",a, b, cin, sum, cout);

        #5 a = 1'b0; b = 1'b1; cin = 1'b0;
        #5 a = 1'b1; b = 1'b1; cin = 1'b1; 

    end

endmodule