//SERIAL PARITY DETECTOR
//INPUT IS COMING BIT BY BIT

module pariity_detector(
    input_bit,
    parity,
    clock
);
    input clock, input_bit;
    output reg parity;
    reg state;

    parameter s0 = 0, s1 = 1;
    parameter ODD = 0, EVEN = 1;

    //STATE CHANGE ALWAYS BLOCK
    always @ (posedge clock)
    begin
        case(state)
            ODD: state <= input_bit ? EVEN: ODD;
            EVEN: state <= input_bit? ODD: EVEN;
            default: state <= EVEN;
        endcase
    end

    //OUTPUT CHANGE ALWAYS BLOCK
    always @ (state)
    begin
        case(state)
            ODD: parity <= 1;
            EVEN: parity <= 0;
        endcase
    end
endmodule

module test_parity;
    reg clock, input_bit;
    wire parity;

    pariity_detector PAR (input_bit, parity, clock);

    initial begin
        clock = 1'b0;
    end

    always # 5 clock = ~clock;

    initial begin
        $monitor($time, "INPUT = %b, PARITY = %b", input_bit, parity);
        #2 input_bit = 0;
        #10 input_bit = 1;
        #10 input_bit = 1;
        #10 input_bit = 1;
        #10 input_bit = 1;
        #10 input_bit = 1;
        #10 input_bit = 1;
        #5 input_bit = 1;
        #10 $finish;
    end
endmodule

