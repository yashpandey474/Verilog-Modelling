module SHIFT_REGISTER (
    input clock,
    input enable, input data_in, output reg [3: 0] out,
    input [3: 0] data_load);


    always @ (posedge clock)
    begin
        if (enable)
        begin
            //SHIFT
            out <= {data_in, out[2: 0]};
        end
        else begin
            //LOAD
            out <= data_load;
         end
    end
endmodule

module D_FLIP_FLOP(Q, D, clear, clock);
    input D, clear, clock;
    output reg Q;

    always @ (negedge clock or negedge clear)
    begin
        if (!clear) Q <= 1'b0;
        else Q <= D;
    end
endmodule

module FULL_ADDER(x, y, z, s, c);
    input  x, y;
    output  s;
    input z;
    output c;

    assign {c, s} = (x + y + z);
endmodule

module INTG (clock, regEnable, clear, A, B);
    input clock, regEnable, clear;
    input [3: 0] A, B;
    
    //INSTANTIATE FULL ADDER
    wire [3: 0] outRegA, outRegB;
    wire flipFlopOut, sumOut, carryOut;

    FULL_ADDER FA(outRegA[3], outRegB[3], flipFlopOut, sumOut, carryOut);

    //INSTANTIATE SHIFT REG A
    SHIFT_REGISTER EGA (clock, regEnable, sumOut, outRegA, A);

    //INSTANTIATE SHIFT REG B
    SHIFT_REGISTER REGB (clock, regEnable, sumOut, outRegB, B);

    //IINSTANTIATE FLIP FLOP TO STORE CARRRY
    D_FLIP_FLOP DFF(flipFlopOut, carryOut, clear, clock & regEnable);

endmodule
