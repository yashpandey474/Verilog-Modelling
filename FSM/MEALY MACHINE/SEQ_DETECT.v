//SEQUENCE DETECTOR FOR "0110"
module FSM_0110 (in, clock, reset, out);
    input in, clock, reset;
    output reg out;

    //REGISTERS FOR HOLDING STATE
    reg [2: 0] state;

    //PARAMETERS FOR STATE
    parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100;

    //ALWAYS BLOCK FOR CHANGE OF STATE
    always @ (posedge clock)
    begin
        //IF RESET
        if (reset) state <= S0;
        //RESET INACTIVE
        else begin
            //INPUT  = 1
            if (in) begin
                case(state)
                S0: state <= S0;
                S1: state <= S2;
                S2: state <= S3;
                S3: state <= S0;
                endcase
            end
            //INPUT = 0
            else begin
                //IF SEQUENCE DETECTED
                if (state == S3)begin
                     out <= 1'b1;
                     state <= S1;
                end

                //STATE CHANGE BUT NO SEQUENCE DETECTED
                else begin
                    out <= 1'b0;
                    state <= S1;
                end
            end
        end
    end
endmodule

module TESTBENCH;
    reg in, clock, reset;
    wire out;

    FSM_0110 FSM(in, clock, reset, out);

    initial begin
        clock = 1'b0;
        reset = 1'b1;

        #15 reset = 1'b0;
    end

    always #5 clock = ~clock;

    initial begin
        $monitor ($time, " IN = %b RESET = %b OUT = %b STATE = %b\n", in, reset, out, FSM.state);
        #12 in = 0; #10 in = 1; #10 in = 1; #10 in = 0;
        #10 $finish;
    end
endmodule