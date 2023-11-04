module 16b_adder(input1, input2, sum, carry, sign, zero, parity, overflow);

    input [15: 0] input1, input2;
    output [15: 0] sum;

    //INTMD. CARRY WIRES
    wire carry[3: 1];

    output carry, zero, parity, overflow;

    //MSB OF SUM = SIGN [2'S COMP. REPRS.]
    assign sign = sum[15];

    //NOR OPERATION = 1 WHEN ALL BITS 0
    assign zero = ~|sum;

    //EXCLUSIVE NOR: PARITY
    assign parity = ~^sum;

    //OVERFLOW: NEG & NEG LEADS TO POS OR POS & POS LEADS TO NEG
    assign overflow = (~sum[15] & input1[15] & input2[15] )

    //INSTANTIATE 4 ADDERS
    genvar j;

    generate for (j = 0; j < 4; j = j + 1) begin: adder_loop
        if (j == 3)
        begin
            4bit_adder A3 (
                sum[4*j + 3:4*j],
                carry,
                input1 [4*j + 3: 4*j],
                input2 [4*j + 3: 4*j],
                c[3]
                );
        end

        if (j == 0)
        begin
            4bit_adder A0 (
                sum[3: 0],
                c[1],
                input1[3: 0],
                input2[3: 0],
                1'b0
            );
        end

        else
        begin
            4bit_adder Aj (
                sum[4*j + 3: 4*j],
                c[j + 1],
                input1[4*j + 3: 4*j],
                input2[4*j + 3: 4*j],
                c[j]
            );
        end

    end
    endgenerate

endmodule

//4-BIT ADDER
module adder4(sum, cout, input1, input2, cin);
    input [3: 0] input1, input2;
    output [3: 0] sum;
    input cin;
    output cout;

    //BEHAVIOURAL
    assign {cout, sum} = (input1 + input2)
endmodule

module alutest;
    reg [15: 0] input1, input2;
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