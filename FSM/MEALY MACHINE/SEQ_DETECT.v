//WHENEVER "0110" APPEARS, OUTPUT - 1.
//OVERLAPPING ALSO POSSIBLE

module seq_detect_0110 (
    input_bit,
    output_bit,
    clock
);
    input input_bit, clock;
    output reg output_bit;
    reg [1: 0] state;

    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3;
    //STATE CHANGE ALWAYS BLOCK

    always @ (posedge clock)
        begin
            case(state)
            S0: state <= input_bit ? S0: S1;
            S1: state <= input_bit ? S2: S1;
            S2: state <= input_bit ? S3: S1;
            S3: state <= input_bit ? S0: S1;
            default: state <= S0;
            endcase
        end

    //OUTPUT CHANGE ALWAYS BLOCK
    always @ (input_bit, state)
    case(state)

        S3: begin
            output_bit = input_bit ? 0: 1;
        end

        default: output_bit <= 0;
    endcase
endmodule