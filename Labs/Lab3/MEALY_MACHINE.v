//MEALY MACHINE => OUTPUT BASED ON STATE AND INPUT
module MEALY_MACHINE (
    input in, output reg out, input clock, input reset);

    //REGISTERS FOR HOLDING STATE
    reg [1: 0] state;

    //PARAMETERS FOR DEFINING STATES
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;

    //ALWAYS BLOCK FOR STATE CHANGE
    always @ (posedge clock or posedge reset)
    begin
        if (reset)begin
             state <= S0;
             out <= 1'b0;
        end

        else begin
            case(state)
            S0: begin
                state <= in ? S1: S2;
                out <= 1'b0; 
            end
            S1: begin 
                state <= in ? S0: S2;
                out <= in ? 1'b1: 1'b0;
            end
            S2: begin 
                state <= in ? S1: S0;
                out <= in ? 1'b0: 1'b1;
            end
            default: begin 
                state <= S0;
                out <= 1'b0;
            end
            endcase
        end
    end
endmodule

module TESTBENCH;
    reg in, clock, reset;
    wire out;
    integer i;
    reg [15: 0] sequence;
    MEALY_MACHINE MACHINE (in, out, clock, reset);

    initial begin
        clock = 1'b0;
        reset = 1'b1;
        sequence = 16'b0101011101110010;
        #5 reset = 1'b0;
    
    
        for (i = 0; i <= 15; i = i + 1)
        begin
            in = sequence[i];
            #4
            $display ("STATE = %b, INPUT = %b, OUTPUT = %b", MACHINE.state, in, out);
        end
    end

    always #2 clock = ~clock;

    task testing;
        for( i = 0; i <= 15; i = i + 1) begin
            in = $random % 2;
            #2 clock = 1;
            #2 clock = 0;
            $display("State = ", MACHINE.state, " Input = ", in, ", Output =", out);
        end
        #100 $finish
    endtask
    
endmodule