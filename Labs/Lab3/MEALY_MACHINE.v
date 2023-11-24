module MEALY_MACHINE (clock, reset, in, out);
    input clock, reset, in;
    output reg out;

    //REGISTER FOR HOLDING STATE
    reg [1: 0] state;

    //PARAMETERS FOR STATE
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;

    //ALWAYS BLOCK FOR STATE & INPUT [NOTE: RESET IS ASYNCHRONOUS?]
    always @ (posedge clock or posedge reset)
    begin
       if (reset) begin out <= 1'b0; state <= S0; end
       case(state)
       S0: begin 
            state <= in ? S1: S2;
            out <= 1'b0;
       end
       S1: begin
            state <= in ? S0: S2;
            out <= in ? 1: 0;
       end
       S2: begin
            state <= in ? S1: S0;
            out <= in ? 1'b0: 1'b1;
       end
       endcase 
    end
endmodule

module TESTBENCH;
    reg clock, reset, in;
    reg [15: 0] sequence;
    wire out;
    integer k;

    MEALY_MACHINE machine (clock, reset, in, out);

    initial begin
        clock = 1'b0;
        reset = 1'b1;
        sequence = 16'b0101011101110010;
    end

    // always #5 clock = ~clock;

    always @ (posedge clock)
        $display("RESET = %b IN = %b OUT =%b STATE = %b\n", reset, in, out, machine.state);

    initial begin
        #5 reset = 1'b0;
        for (k = 0; k < 16; k = k + 1) begin
            in = sequence[k];
            #2 clock = 1'b0;
            #2 clock = 1'b1;
        end
    end


endmodule
