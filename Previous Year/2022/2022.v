module REG_8BIT (reg_out, num_in, clock, reset);
    input [7: 0] num_in;
    input clock, reset;
    output reg [7: 0] reg_out;


    always @ (posedge clock)
    begin
        if (reset) reg_out <= 8'h00;
        else reg_out <= num_in;
    end
endmodule

module EXPANSION_BOX (in, out);
    input [3: 0] in;
    output [7: 0] out;

    assign out = {in[3], in[0], in[1], in[2], in[1], in[3], in[2], in[0]};
endmodule

module XOR_8BIT (xout_8, xin1_8, xin2_8);
    input [7: 0] xin1_8, xin2_8;
    output [7: 0] xout_8;

    assign xout_8 = xin1_8 ^ xin2_8;
endmodule

module XOR_4BIT (xout_4, xin1_4, xin2_4);
    input [3: 0] xin1_4, xin2_4;
    output [3: 0] xout_4;

    assign xout_4 = xin1_4 ^ xin2_4;
endmodule

module FULL_ADDER (in1, in2, cin, cout, sum);
    input in1, in2, cin;
    output cout, sum;

    assign {cout, sum} = (in1 + in2 + cin);
endmodule

module MUX2TO1_1BIT (in1, in2, sel, out);
    input in1, in2, sel;
    output out;

    assign out = sel ? in2: in1;
endmodule

module MUX2TO1_4BIT (in1, in2, sel, out);
    input [3: 0] in1, in2;
    output [3: 0] out;
    input sel;

    genvar j;

    generate for (j = 0; j < 4; j = j + 1) begin: MUX_LOOP
        MUX2TO1_1BIT Mj(in1[j], in2[j], sel, out[j]);
    end
    endgenerate

endmodule

module CSA_4BIT (inA, inB, cin, cout, sum);
    input [3: 0] inA, inB;
    input cin;
    output cout;
    output [3: 0] sum;

    wire [3: 0] sum1, sum2;
    wire cout1, cout2;
    wire [4: 0] carry1, carry2;

    assign carry1[0] = 1'b0;
    assign carry2[0] = 1'b1;

    genvar j;
    generate for (j = 0; j < 4; j = j + 1) begin: FULL_ADDER_1BIT
        FULL_ADDER Fj1(inA[j], inB[j], carry1[j], carry1[j + 1], sum1[j]);
        FULL_ADDER Fj2(inA[j], inB[j], carry2[j], carry2[j + 1], sum2[j]);
    end
    endgenerate

    MUX2TO1_1BIT MUX_COUT(carry1[4], carry2[4], cin, cout);
    MUX2TO1_4BIT MUX_SUM (sum1, sum2, cin, sum);
endmodule

module CONCAT (concat_out, concat_in1, concat_in2);
    input [3: 0] concat_in1, concat_in2;
    output [7: 0] concat_out;

    assign concat_out = {concat_in1, concat_in2};
endmodule

module ENCRYPT (number, key, clock, reset, enc_number);
    input [7: 0] number, key;
    input clock, reset;
    output [7: 0] enc_number;

    wire [3: 0] xor2Out, CSAOut;
    wire [7: 0] numRegOut, keyRegOut, expBoxOut, xor1Out;
    wire CSACout;
    
    REG_8BIT NUM(numRegOut, number, clock, reset);
    REG_8BIT KEY(keyRegOut, key, clock, reset);
    EXPANSION_BOX EXP(numRegOut[3: 0], expBoxOut);
    XOR_8BIT XOR8 (xor1Out, expBoxOut, keyRegOut);
    CSA_4BIT CSA(xor1Out[7: 4], xor1Out[3: 0], keyRegOut[0], CSACout, CSAOut);
    XOR_4BIT XOR4 (xor2Out, numRegOut[7: 4], CSAOut);
    CONCAT CONCAT(enc_number, xor2Out, numRegOut[3: 0]);
endmodule

module TESTBENCH;
    reg [7: 0] number, key;
    wire [7: 0] enc_number;
    reg clock, reset;

    ENCRYPT ENC(number, key, clock, reset, enc_number);

    initial begin
        clock = 1'b0;
        reset = 1'b1;

        #15 reset = 1'b0;
    end

    always #5 clock = ~clock;

    always @ (posedge clock)
        $display("NUM = %d KEY = %d RESET = %b ENCRYPTED = %d\n", number, key, reset, enc_number);
    initial begin
       #12 number = 8'b01000110; key = 8'b10010011;
       #10 number = 8'b11001001; key = 8'b10101100;
       #10 number = 8'b10100101; key = 8'b01011010;
       #10 number = 8'b11110000; key = 8'b10110001;
       #10 $finish;
    end
endmodule