module FSM_1 (
    state,
    in,
    reset,
    out
);

    input reset, in;
    output reg out;
    output reg [1: 0] state;
    parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    always @ (*)
    begin
        
        if (reset)
            state <= A;
            out <= 0;

        else
        begin
            if (in)
            case(state)
                A: out <= 0, state <= B;
                B: out <= 0, state <= C;
                C: out <= 1, state <= D;
                D: out <= 1, state <= D;
            endcase
            else
            case(state)
                A: out <= 0, state <= A;
                B: out <= 0, state <= A;
                C: out <= 0, state <= A;
                D: out <= 0, state <= A;
            endcase
        end
    end
endmodule