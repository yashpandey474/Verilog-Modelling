//8 BIT REGISTER
module REG_8BIT (
    output reg [7: 0] reg_out,
    input [7: 0] num_in, input clock, input reset
);
    always @ (posedge clock)
    begin
        if (reset == 1'b0) reg_out <= num_in;
    end
endmodule

//EXPANDS THE 40BIT INIPUT INTO AN 8BIT OUTPUT
module EXPANSION_BOX (input [3: 0] in, output [7: 0] out);
    assign out = {in[3], in[0], in[1], in[2], in[1], in[3], in[2], in[0]};
endmodule

//XOR TWO 8-BIT INPUTS
module XOR_8BIT (output [7: 0] xout_8, input [7: 0] xin1_8, 
input [7: 0] xin2_8);
    assign xout_8 = xin1_8 ^ xin2_8;
endmodule

//XOR TWO 4 BIT INPUTS 
module XOR_4BIT (output [3: 0] xout_4, input [3: 0] xin1_4,
input [3: 0] xin2_4);
    assign xout_4 = xin1_4 ^ xin2_4;
endmodule

module MUX_2TO1_1BIT (input in1, input in2, input sel, output out);
    assign out = sel ? in2: in1;
endmodule

module MUX_2TO1_4BIT(input [3: 0] in1, input [3: 0] in2,
input sel, output [3: 0] out);
    assign out = sel ? in2: in1;
endmodule

module FULL_ADDER_1BIT (input cin, input inA, input inB,
output cout, output out);
    assign {cout, out} = {inA, inB};
endmodule


//CONCAT TWO-4BIT INPUTS
module CONCAT (output [7: 0] concat_out, input [3: 0] concat_in1, 
input [3 : 0] concat_in2);
    assign concat_out = {concat_in1, concat_in2};
endmodule
//CSA ADDER: USE TWO RIPPLE  CARRY ADDERS AND SELECT OUTPUT USING MUX
module CSA_4BIT (input cin, input [3: 0] inA, input[3: 0] inB, output cout, output [3: 0] out);

    //INSTANTIATE RIPPLE ADDER 1
    wire [3: 0] out1;
    wire [3: 0] carry1;
    FULL_ADDER_1BIT FA10(cin, inA[0], inB[0], carry1[0], out1[0]);
    FULL_ADDER_1BIT FA11(carry1[0], inA[1], inB[1], carry1[1], out1[1]);
    FULL_ADDER_1BIT FA12(carry1[1], inA[2], inB[2], carry1[2], out1[2]);
    FULL_ADDER_1BIT FA13(carry1[2], inA[3], inB[3], carry1[3], out1[3]);


    //INSTANTIIATE RIPPLE ADDER 2
    wire [3: 0] out2;
    wire [3: 0] carry2;
    FULL_ADDER_1BIT FA20(cin, inA[0], inB[0], carry2[0], out2[0]);
    FULL_ADDER_1BIT FA21(carry2[0], inA[1], inB[1], carry2[1], out2[1]);
    FULL_ADDER_1BIT FA22(carry2[1], inA[2], inB[2], carry2[2], out2[2]);
    FULL_ADDER_1BIT FA23(carry2[2], inA[3], inB[3], carry2[3], out2[3]);

    //INSTANTIATE MUX TO CHOOSE CARRY
    MUX_2TO1_1BIT MUX_COUT (carry1[3], carry2[3], cin, cout);
    MUX_2TO1_4BIT MUX_OUT (out1, out2, cin, out);
endmodule

//WRAPPER MODULE
module ENCRYPT (input [7: 0] number, input [7: 0] key,
 input clock, input reset, output [7: 0] enc_number);
    //8BIT REGISTER TO HOLD NUMBER
    wire [7: 0] numberRegOut;
    REG_8BIT REG_NUM(numberRegOut, number, clock, reset);

    //8BIT REGISTER TO HOLD KEY
    wire [7: 0] keyRegOut;
    REG_8BIT REG_KEY (keyRegOut, key, clock, reset);

    //INSTANTIATE EXPANSION BOX
    wire [7: 0] expBoxOut;
    EXPANSION_BOX EXP_BOX (numberRegOut[3: 0], expBoxOut);

    //INSTANTIATE 8-BIT XOR
    wire [7: 0] xor1Out;
    XOR_8BIT XOR_1 (xor1Out, expBoxOut, keyRegOut);

    //INSTANTIATE  CSA
    wire CSAcout;
    wire [3: 0] CSAOut;
    CSA_4BIT CSA(keyRegOut[0], xor1Out[3: 0],
     xor1Out[7: 4], CSAcout, CSAOut);

    //INSTANTIATE THE 4-BIT XOR
    wire [3: 0] xor2Out;
    XOR_4BIT XOR_2 (xor2Out, numberRegOut[7: 4], CSAOut);

    //INSTANTIATE THE CONCATENATION MODULE
    CONCAT concat (enc_number, xor2Out, numberRegOut[3: 0]);
endmodule

module TESTBENCH;
    wire [7: 0] enc_number;
    reg [7: 0] number, key;
    reg clock, reset;

    ENCRYPT ENC(number, key, clock, reset, enc_number);

    initial begin
        clock = 1'b0;
        reset = 1'b0;
    end

    always #5 clock = ~clock;

    initial begin
        $monitor ($time, " NUM = %b, KEY = %b, ENC NUM = %b\n", number, key, enc_number);
        #100 number = 8'b01000110; key = 8'b10010011;
        #100 number = 8'b11001001; key = 8'b10101100;
        #100 number = 8'b10100101; key=  8'b01011010;
        #100 number = 8'b11110000; key = 8'b10110001;
        #500 $finish;
    end
endmodule