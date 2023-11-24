module FULL_ADDER (x, y, z, s, c);
    input x, y, z;
    output s, c;

    assign s = x ^ y ^ z;
    assign c = (x & y) | (z & (x ^ y));
endmodule

module SHIFT_REGISTER_4BIT (serialInput, clock, enable, out);
    input clock, serialInput, enable;
    output reg [3: 0] out;
    
    initial begin
        out = 4'b0101;
    end
    always @ (posedge clock)
        if (enable) out = {serialInput, out[3: 1]};
endmodule

module D_FLIP_FLOP (Q, D, clock, clear);
    input D, clock, clear;
    output reg Q;

    always @ (posedge clock or negedge clear)
    begin
        if (!clear) Q <= 1'b0;
        else Q <= D;
    end
endmodule

module SERIAL_ADDER(serialInput, clock, enable, clear, regA);
    input serialInput, clock, clear, enable;
    output [3: 0] regA;
    wire [3: 0] regB;

    wire s, c, Q;

    SHIFT_REGISTER_4BIT A(s, clock, enable, regA);
    SHIFT_REGISTER_4BIT B(serialInput, clock, enable, regB);

    FULL_ADDER FA(regA[0], regB[0], Q, s, c);

    D_FLIP_FLOP DFF(Q, c, clock & enable, clear);
endmodule

module TESTBENCH;
    reg serialInput, clock, enable, clear;
    wire [3: 0] regA;
    integer i;

    SERIAL_ADDER ADDER(serialInput, clock, enable, clear, regA);

    initial begin
        clock = 1'b0;
        clear = 1'b0;
        enable = 1'b1;
    end

    always #5 clock = ~clock;

    initial begin
        $monitor($time, " IN = %b CLEAR = %b ENABLE = %b REGA = %b\n", serialInput, clear, enable, regA);

        #5 clear = 1'b1; serialInput = 1'b1;
        #10 serialInput = 1'b0;
        #10 serialInput = 1'b1;
        #100 $finish;
    end
endmodule