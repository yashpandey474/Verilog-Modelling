//MOORE MACHINE [OUTPUT DEPENDS ONLY ON STATE]
module MOORE_101 (in, clock, reset, out);
    input in, clock, reset;
    output reg out;

    //REGISTERS TO HOLD STATE
    reg [1: 0] state;

    //PARAMETERS FOR STATE
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

    //ALWAYS BLOCK FOR STATE CHANGE
    always @ (posedge clock)
    begin
        if (reset) state <= S0;
        else begin
            if (in) begin
                case(state)
                    S2: state <= S3;
                    S0, S1, S3: state <= S1;
                endcase
            end
            else begin
                case(state)
                    S3, S1: state <= S2;
                    S0, S2: state <= S0;
                endcase
            end
        end
    end

    //ALWAYS BLOCK FOR OUTPUT CHANGE
    always @ (state)
        case(state)
            S3: out <= 1'b1;
            S0, S1, S2: out <= 1'b0;
        endcase
endmodule

//TESTBECH
module TESTBENCH;
    reg in, clock, reset;
    wire out;
    MOORE_101 FSM(in, clock, reset, out);

    initial begin
        clock = 1'b0;
        reset = 1'b1;

        #15 reset = 1'b0;
    end

    always #5 clock = ~clock;

    initial begin
        $monitor ($time, " IN = %b RESET = %b OUT = %b STATE = %b\n", in, reset, out, FSM.state);
        #12 in = 1; #10 in = 0; #10 in = 1; #10 in = 0;
        #10 $finish;
    end
endmodule