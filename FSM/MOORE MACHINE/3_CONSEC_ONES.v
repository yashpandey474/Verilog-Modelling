//FSM TO DETECT 3 CONSECUTIVE ONES
module FSM (in, out, clock, reset);

    input in, clock, reset;
    output reg out;

    //REGISTERS FOR STATE
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
                    S0: state = S1;
                    S1: state = S2;
                    S2: state = S3;
                    S3: state = S3;
                endcase
            end
            else state = S0;
        end
    end

    //ALWAYS BLOCK FOR OUTPUT [ONLY DEPENDENT ON CURRENT STATE]
    always @ (state)
        case(state)
            S3: out = 1'b1;
            default: out = 1'b0;
        endcase
endmodule

//TESTBENCH FOR TESTING OUT = 1 ON 3 CONSECUTIVE ONES
module TESTBENCH;
    reg in, clock, reset;
    wire out;

    FSM fsm(in, out, clock, reset);

    initial begin
        reset = 1'b1;
        clock = 1'b0;

        #15 reset = 1'b0;
    end

    always #5 clock = ~clock;

    initial begin
        $monitor ($time, " IN = %b RESET = %b OUT = %b STATE = %b\n", in, reset, out, fsm.state);
        #12 in = 0; #10 in = 1; #10 in = 1; #10 in = 1; #10 in = 1; 
        #10 $finish;
    end
endmodule