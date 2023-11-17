//FINITE STATE MACHINE TO ETECT 10110
module FSM_DETECT_10110 (reset, clock, in, out);
    input in, reset, clock;
    output reg out;

    //REGISTER TO HOLD STATE
    reg [2: 0] state;

    //PARAMETERS TO DEFINE STATES
    parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100;

    //ALWAYS BLOCK FOR STATE CHANGE
    always @ (posedge clock or posedge reset)
    begin
        if (reset) begin
            state <= S0;
            out <= 0;
        end
        else begin
            case(state)
            S0: begin 
                state <= in ? S1: S0;
                out <= 0;
            end
            S1: begin 
                state <= in ? S1: S2;
                out <= 0;
            end
            S2:begin 
                state <= in ? S3: S0;
                out <= 0;
            end
            S3: begin 
                state <= in ? S4: S2;
                out <= 0;
            end
            S4: begin 
                state <= in ? S1: S2;
                out <= in ? 0: 1;
            end
            default: state <= S0;
            endcase
        end
    end
endmodule

module TESTBENCH;
    reg reset, clock, in;
    wire out;
    reg [4: 0] sequence;
    integer i;

    FSM_DETECT_10110 FSM(reset, clock, in, out);

    initial begin
        clock = 1'b0;
        // reset = 1'b1;
        sequence = 10110;

        for (i = 0; i < 5; i = i + 1)
        begin
            in = sequence[i];
            #15 in = sequence[i];
        end
    end

    always #5 clock = ~clock;

    initial begin
        $monitor ($time, "IN = %b STATE = %b OUT = %b", in, FSM.state, out);
        #5 reset = 1'b0;
        #1000 $finish;
    end
endmodule
