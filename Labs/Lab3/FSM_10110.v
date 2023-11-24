
module FSM_10110 (in, reset, clock, out);
    input in, reset, clock;
    output reg out;

    reg [2: 0] state;

    parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100;

    always @ (posedge clock)
    begin
        if (reset) begin
            state <= S0;
            out <= 0;
        end 

        else begin
            case(state)
            S0: begin
                state <= (in ? S1: S0);
                out <= 0;
            end
            S1: begin
                state <= (in ? S1: S2);
                out <= 0;
            end
            S2: begin
                state <= (in ? S3: S0);
                out <= 0;
            end
            S3: begin
                state <= (in ? S4: S2); 
                out <= 0;
            end
            S4: begin
                state <= (in ? S1: S2);
                out <= (in ? 0: 1);
            end
            endcase
        end
    end
endmodule

module TESTBENCH;
    reg in, clock, reset;
    wire out;
    reg [15: 0] sequence;
    integer k;
    FSM_10110 FSM(in, reset, clock, out);

    initial begin
        $monitor($time, "CLOCK = %b STATE = %b IN = %b RESET = %b OUT = %b\n", clock ,FSM.state, in, reset, out);
        clock = 1'b0;
        reset = 1'b1;

        //SECOND POSEDGE
        #15 reset = 1'b0;
    end

    always #5 clock = ~clock;

    initial begin
        #12 in = 1; #10 in = 0; #10 in = 1; #10 in = 1;
        #10 in = 0; #10 in = 1;
        #10 $finish;
    end
endmodule