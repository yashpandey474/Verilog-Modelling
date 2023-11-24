module FSM (state, x, clock, reset);
    output reg [2: 0] state;
    input x, clock, reset;

    parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100;
    always @ (posedge clock)
    begin

        if (reset) state <= S0;
        else begin
            case(state)
                S0: state <= (x ? S1: S0);
                S1: state <= S2;
                S2: state <= S3;
                S3: state <= (x ? S3: S4);
                S4: state <= S0;
            endcase
        end
    end
endmodule

module TESTBENCH;
    reg x, clock, reset;
    wire [2: 0] state;

    FSM fsm(state, x, clock, reset);

    initial begin
        clock = 1'b0;
        reset = 1'b1;

        #15 reset  = 1'b0;
    end

    always #5 clock = ~clock;

    always @ (posedge clock)
        $display ("RESET = %b STATE = %b X = %b\n", reset, state, x);

    initial begin
        #12 x = 0; #10 x = 0; #10 x = 1; #10 x = 0; #10 x = 1;
        #10 $finish;
    end
endmodule