//ADDITION
//GENERATION OF STATUS FLAGS: SIGN, ZERO, CARRY, PARITY, OVERFLOW

module 16b_adder(
    input1, input2, sum, carry, sign
    zero, parity, overflow
    );

    input [15: 0] input1, input2;
    output [15: 0] sum;

    output carry, zero, parity, overflow;

    //CARRY AND SUM
    assign {carry, sum} = (input1 + input2);

    //MSB OF SUM = SIGN [2'S COMP. REPRS.]
    assign sign = sum[15];

    //NOR OPERATION = 1 WHEN ALL BITS 0
    assign zero = ~|sum;

    //EXCLUSIVE NOR: PARITY
    assign parity = ~^sum;

    //OVERFLOW: NEG & NEG LEADS TO POS OR POS & POS LEADS TO NEG
    assign overflow = (~sum[15] & input1[15] & input2[15] )


endmodule

//TESTBENCH 
module alutest;
    reg [15: 0] input1, iinput2;
    wire [15: 0] sum;
    wire carry, sign, zerro, parity, overflow;


    16b_adder Adder (input1, input2, 
    sum, carry, sign, zero, parity, overflow);


    initial
        begin
            $monitor($time, "IINPUT1 = %h, INPUT2 = %h, 
            SUM = %H, CARRY = %h, SIGN = %h, PARITY  = %h
            OVERFLOW = %h\n", input1, input2, sum, carry, sign,
            parity, overflow);
            #5 input1 = 16'hBFFF, input2 = 15'h8000
        end

endmodule