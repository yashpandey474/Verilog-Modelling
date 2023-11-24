//MODELLING BOOTH'S MULTIPLICATION ALGORITHM

//SHIFT REGISTER WITH LOAD
module SHIFT_REGISTER (out, dataIn, load, shift, clear, clock, serialIn);
    //16 BIT REGISTER
    parameter N = 16;

    input [N - 1: 0] dataIn;
    input load, shift, clear, clock, serialIn;
    output reg [N - 1: 0] out;

    always @ (posedge clock)
    begin
        if (clear) out <= 16'b0;
        else if (load) out <= dataIn;
        else if (shift) out <= {serialIn, out[N - 1: 1]};
    end
endmodule

//D FLIP FLOP FOR STORING Q-1
module D_FLIP_FLOP (D, Q, clear, clock);
    input D, clear, clock;
    output reg Q;

    always @ (posedge clock)
    begin
        if (clear) Q <= 1'b0;
        else Q <= D;
    end
endmodule

//ALU FOR ADDING OR SUBTRACTING A & M
module ALU (control, out, in1, in2);
    parameter N = 16;
    input [N - 1: 0] in1, in2;
    output reg [N - 1: 0] out;
    input control;

    always @ (*)
    begin
        if (control) out <= in1 - in2;
        else out <= in1 + in2;
    end
endmodule

//COUNTER FOR STORING COUNT OF ITERATIONS REMAINING [DOWN COUNTER]
module DOWN_COUNTER (counterOut, decr, load, clock);
    //16 TO 0; 4 BITS
    parameter N = 4;

    input decr, load, clock;
    output reg [N: 0] counterOut;

    always @ (posedge clock)
    begin
        if (load) counterOut <= 16;
        else if (decr) counterOut <= counterOut - 1;
    end
endmodule

module REGISTER(regOut, dataIn, clock, load);
    parameter N  = 16;

    input [N - 1: 0] dataIn;
    input clock, load;
    output reg [N - 1: 0] regOut;

    always @ (posedge clock)
    begin
        if (load) regOut <= dataIn;
    end
endmodule

//COMPARE OUTPUT OF COUNTER TO 0
module COMPARATOR (out, in);
    output out;
    input [4: 0] in;

    assign out = (in == 0);
endmodule

module DATAPATH(Qm1, Q0, countEqZero, dataInM, dataInB, loadA, loadB, loadM, loadCount, decrCount,
clearA, clearQm1, ALUControl, shift, clock);

    parameter N = 16;
    input clock, loadA, loadB, loadM, loadCount, shift, decrCount, clearA, clearQm1, ALUControl;
    input [N - 1: 0] dataInB, dataInM;
    wire [N - 1: 0] regOutA, regOutB, regOutM, ALUOut;
    wire [4: 0] counterOut;
    output Qm1, Q0, countEqZero;

    assign Q0 = regOutB[0];

    //STORE A
    // SHIFT_REGISTER (out, dataIn, load, shift, clear, clock, serialIn);
    SHIFT_REGISTER REGA(regOutA, ALUOut, loadA, shift, clearA, clock, regOutA[15]);

    //STORE B
    SHIFT_REGISTER REGB(regOutB, dataInB, loadB, shift, 1'b0, clock, regOutA[0]);

    //STORE M
    REGISTER REGM(regOutM, dataInM, clock, loadM);

    //STORE Q-1
    D_FLIP_FLOP QM1(regOutB[0], Qm1, clearQm1, clock);

    //STORE THE COUNT OF BITS
    DOWN_COUNTER counter(counterOut, decrCount, loadCount, clock);

    //FIND IF COUNT IS EQUAL TO ZERO
    COMPARATOR compare (countEqZero, counterOut);

    //FIND VALUE TO LOAD INTO A
    ALU alu(ALUControl, ALUOut, regOutA, regOutM);


endmodule


//CONTROLLER FOR BOOTH MULTIPLICATION
module CONTROLLER (start, done, Qm1, Q0, countEqZero, loadA, loadB, loadM, loadCount, decrCount,
    clearA, clearQm1, ALUControl, shift, clock);

    input start, Qm1, Q0, countEqZero, clock;
    output reg loadA, loadB, loadM, loadCount;
    output reg decrCount, clearA, clearQm1, ALUControl, shift, done;

    //REGISTER TO HOLD STATE
    reg [2: 0] state;

    //PARAMETERS FOR STATE
    parameter S0  =3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101, S6 = 3'b110;

    //PARAMETERS FOR ALU CONTROL
    parameter ADD = 1'b0, SUBTRACT = 1'b1;

    //ALWAYS BLOCK FOR STATE CHANGE
    always @ (posedge clock)
    begin
        case (state)
        S0: state <= start ? S1: S0;
        S1: state <= S2;
        S2: begin
            case({Q0, Qm1})
                2'b00, 2'b11: state <= S5;
                2'b01: state <= S3;
                2'b10: state <= S4;
            endcase
        end
        S3: state <= S5;
        S4: state <= S5;
        S5: begin
            if (countEqZero) state <= S6;
            else begin
                case({Q0, Qm1})
                2'b00, 2'b11: state <= S5;
                2'b01: state <= S3;
                2'b10: state <= S4;
                endcase
            end
        end
        S6: state <= S6;
        default: state <= S0;
        endcase
    end

    //ALWAYS BLOCK FOR CONTROL SIGNALS
    always @ (state)
    begin
        case(state)
        S0: begin
            done = 1'b0;
            loadA = 1'b0;
            loadB = 1'b0; loadM = 1'b0; loadCount = 1'b0;
            decrCount = 1'b0; clearA = 1'b0; shift = 1'b0;
        end
        S1: begin
            done = 1'b0;
            loadA = 1'b0;
            loadB = 1'b1;
            loadM = 1'b1;
            loadCount = 1'b1;
            decrCount = 1'b0;
            clearA = 1'b1;
            clearQm1 = 1'b1;
            shift = 1'b0;
        end
        S2: begin
            done = 1'b0;
            loadA = 1'b0;
            loadB = 1'b0;
            loadM = 1'b0;
            loadCount = 1'b0;
            decrCount = 1'b0; clearA = 1'b0; shift = 1'b0;
        end
        S3: begin
            done = 1'b0;
            loadA = 1'b1;
            loadB = 1'b0;
            loadM = 1'b0;
            loadCount = 1'b0;
            decrCount = 1'b0;
            clearA = 1'b0;
            shift = 1'b0;
            ALUControl = ADD;
        end
        S4: begin
            done = 1'b0;
            loadA = 1'b1;
            loadB = 1'b0; loadM = 1'b0; loadCount = 1'b0;
            decrCount = 1'b0; clearA = 1'b0; shift = 1'b0;
            ALUControl = SUBTRACT;
        end
        S5: begin
            done = 1'b0;
            loadA = 1'b0;
            loadB = 1'b0; loadM = 1'b0; loadCount = 1'b0;
            decrCount = 1'b1; clearA = 1'b0; shift = 1'b1;
        end
        S6: begin
            done = 1'b1;
            loadA = 1'b0;
            loadB = 1'b0; loadM = 1'b0; loadCount = 1'b0;
            decrCount = 1'b0; clearA = 1'b0; shift = 1'b0;
        end
        endcase
    end
endmodule

//TESTBENCH FOR BOOTH MULTIPLICATION
module TESTBENCH;
    parameter N = 16;
    reg [N - 1: 0] dataInB, dataInM;
    reg clock, start;
    wire done, Qm1, Q0, countEqZero, loadA, loadB, loadM, loadCount, decrCount;
    wire clearA, clearQm1, ALUControl, shift;

    DATAPATH DP(Qm1, Q0, countEqZero, dataInM, dataInB, loadA, loadB, loadM, loadCount, decrCount,
clearA, clearQm1, ALUControl, shift, clock);

    CONTROLLER CP(start, done, Qm1, Q0, countEqZero, loadA, loadB, loadM, loadCount, decrCount,
    clearA, clearQm1, ALUControl, shift, clock);


    initial begin
        clock = 1'b0;
        start = 1'b1;
    end

    always #5 clock  = ~clock;

    initial begin
        $monitor ($time, " ALUControl = %b LOADA = %b LOADB = %b START = %b, DONE = %b, STATE = %b, COUNTER = %b, A = %b, Q = %b, M = %b\n", DP.ALUControl, DP.loadA, DP.loadB, start, done, CP.state, DP.counterOut, DP.regOutA, DP.regOutB, DP.regOutM);
        #12 dataInB = 16'hABCD; dataInM = 16'h1234;
        #1000 $finish;
    end
endmodule
