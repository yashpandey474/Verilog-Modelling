//MULTIPLE TWO INTEGERS BY REPEATED ADDITION

//A * B

//B IS NON ZERO

//COMPARATOR TO CHECK FOR ZERO

//ADDER TO ADD A TO P

//B IS A DOWN-COUNTER

module control_path(
    start,
    done,
    eqz,
    ldA,
    ldB,
    ldP,
    clrP,
    decB,
    clock
);
    //DEFINE INPUTS AND OUTPUTS
    input start, eqz, clock;
    output reg done, ldA, ldB, ldP, clrP, decB;


    //DEFINE THE STATES
    reg [2: 0] state;
    parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100;

    //STATE CONTROL BLOCK
    always @ (posedge clock)
        case(state)
            S0: state <= start ? S1: S0;
            S1: state <= S2;
            S2: state <= S3;
            S3: #2 if (eqz) state <= S4;
            S4: state <= S4;
            default: state <= S0;
        endcase

    //SIGNALS CONTROL BLOCK
    always @ (state)
        case(state)
            S0: begin #1
                done = 0;
                ldA = 0;
                ldB = 0;
                ldP = 0;
                clrP = 0;
                decB = 0;
            end
            S1: begin #1
                done = 0;
                ldA = 1;
                ldB = 0;
                ldP = 0;
                clrP = 0;
                decB = 0;
            end
            S2: begin #1
                done = 0;
                ldA = 0;
                ldB = 1;
                ldP = 0;
                clrP = 1;
                decB = 0;
            end
            S3: begin #1
                done = 0;
                ldA = 0;
                ldB = 0;
                ldP = 1;
                clrP = 0;
                decB = 1;
            end
            S4: begin #1
                done = 1;
                ldA = 0;
                ldB = 0;
                ldP = 0;
                clrP = 0;
                decB = 0;
            end
            default: begin #1
                done = 0;
                ldA = 0;
                ldB = 0;
                ldP = 0;
                clrP = 0;
                decB = 0;
            end
        endcase

endmodule

//COMPARATOR TO ZERO
module EQZ (out, in);
    output out;
    input [15: 0] in;
    assign out = (in == 0);
endmodule

//REGISTER WITHOUT CLEAR
module PIPO1 (out, in, load, clock);
    output reg [15: 0] out;
    input [15: 0] in;
    input load, clock;

    always @ (posedge clock)
    begin
        if (load) out <= in;
    end
endmodule

//REGISTER WITH CLEAR
module PIPO2 (out, in, load, clear, clock);
    output reg [15: 0] out;
    input [15: 0] in;
    input load, clear, clock;

    always @ (posedge clock)
    begin
        if (clear) out <= 16'b0;
        else if (load) out <= in;
    end
endmodule

//ADDER
module ADD (out, in1, in2);

    input [15: 0] in1, in2;
    output reg [15: 0] out;

    always @ (*)
    begin
        out = in1 + in2;
    end
endmodule

//COUNTER
module CNTR (out, in, load, decr, clock);
    input load, decr, clock;
    output reg [15: 0] out;
    input [15: 0] in;

    always @ (posedge clock)
    begin
        if (load) out <= in;
        else if (decr) out <= out - 1;
    end

endmodule

module MUL_datapath(
    eqz, ldA, ldB, ldP, clrP, decB, data_in, clock
);

    input ldA, ldB, ldP, clrP, decB, clock;
    input [15: 0] data_in;
    output eqz;

    wire [15: 0] X, Y, Z, Bout, Bus;


    //INSTANTIATE REGISTERS
    assign Bus = data_in;
    PIPO1 A (X, Bus, ldA, clock);
    PIPO2 P (Y, Z, ldP, clrP, clock);
    CNTR B(Bout, Bus, ldB, decB, clock);
    ADD AD (Z, X, Y);
    EQZ COMP (eqz, Bout);
endmodule

module tb_mult;

    reg [15: 0] data_in;
    reg clock, start;
    wire done;

    MUL_datapath DP(eqz, ldA, ldB, ldP, clrP, decB, data_in, clock);
    control_path CON(
    start,
    done,
    eqz,
    ldA,
    ldB,
    ldP,
    clrP,
    decB,
    clock
    );

    initial begin
        clock = 1'b0;
        #1 start = 1'b1;
        #500 $finish;
    end

    always #5 clock = ~clock;

    initial
        begin
            #17 data_in = 17;
            #10 data_in = 5;
        end

    initial begin
        $monitor ($time, "%d %b %d %d  %d %d %b", DP.Bout, DP.eqz, CON.state, data_in, DP.X, DP.Y, done);
    end

endmodule
