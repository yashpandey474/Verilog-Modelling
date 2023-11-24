//PARITY DETECTOR FOR A STREAM OF INPUT BITS
module PARITY_DETECTOR (in, clock, reset,  out);
    input in, clock, reset;
    output reg out;

    //REGISTERS FOR STATE
    reg state;

    //PARAMETERS FOR STATE [EVEN PARITY; MAKES TOTAL NUMBER OF ZEROES (INPUT & PARITY BIT) AS EVEN]
    parameter ODD = 1'b1, EVEN = 1'b0;

    //ALWAYS BLOCK FOR STATE CHANGE
    always @ (posedge clock or posedge reset)
    begin
        if (reset) state <= EVEN;
        else begin
            if (in)
            case(state)
                ODD: state <= EVEN;
                EVEN: state <= ODD;
            endcase

            //ELSE REMAINS AT SAME STATE [NOT SPECIFIED IN ALWAYS =>> REMAINS SAME]
        end
    end

    //ALWAYS BLOCK FOR OUTPUT
    always @ (state)
        case(state)
        ODD: out <= 1'b1;
        EVEN: out <= 1'b0;
        endcase
endmodule

module TESTBENCH;
    reg in, clock, reset;
    wire out;

    PARITY_DETECTOR PAR_DETECT(in, clock, reset,  out);

    initial begin
        clock = 1'b0;
        reset = 1'b1;

        #15 reset = 1'b0;
    end

    always #5 clock = ~clock;

    initial begin
        $monitor ($time, " RESET = %b IN = %b OUT = %b STATE = %b\n", reset, in, out, PAR_DETECT.state);
        #12 in = 0; #10 in = 0; #10 in = 1; #10 in = 0; #10 in = 1;
        #10 $finish;
    end


endmodule