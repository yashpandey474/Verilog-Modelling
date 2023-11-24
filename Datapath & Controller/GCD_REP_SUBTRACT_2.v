//FIND THE GCD OF TWO NUMBERS USING REPEATED SUBTRACTION

//SELECT THE INPUTS OF SUBTRACTOR WTH MUX
module MUX2TO1_1BIT(in1, in2, sel, out);
    input in1, in2, sel;
    output reg out;

    always @ (*)
        out = sel ? in2 : in1;
endmodule

module MUX2TO1_NBIT (in1, in2, sel, out);
    parameter N = 16;
                 
    input [N-1 : 0] in1, in2;
    input sel;
    output [N-1: 0] out;

    genvar j;
    generate for (j = 0; j < N; j = j + 1) begin: MUX_LOOP
        MUX2TO1_1BIT Mj(in1[j], in2[j], sel, out[j]);
    end
    endgenerate
endmodule

//SUBTRACT A-B OR B - A
module SUBTRACTOR (in1, in2, out);
    parameter N = 16;
    input [N-1:0] in1, in2;
    output reg [N-1:0] out;                       

    always @ (*)
        out <= in1 - in2; 
endmodule

//COMPARE A & B
module COMPARATOR(in1, in2, lt, gt, eq);
    parameter N = 16;
    input [N-1:0] in1, in2;
    output lt, gt, eq;

    assign lt = (in1 < in2);
    assign gt = (in1 > in2);
    assign eq = (in1 == in2);
endmodule

//REGISTERS TO HOLD A & B
module REGISTER_NBIT (regOut, dataIn, load, clock);
    parameter N = 16;
    input [N-1: 0] dataIn;
    output reg [N-1:0] regOut;
    input load, clock;

    always @ (posedge clock) begin
        if (load) regOut <= dataIn;
    end
endmodule

//MAIN DATAPATH
module GCD_DATAPATH(
    loadA, loadB, selLoadA, selLoadB, dataInA, dataInB,  clock, lt, gt, eq
);
    parameter N = 16;

    input loadA, loadB, clock, selLoadA, selLoadB;
    input [N - 1: 0] dataInA, dataInB;
    output lt, gt, eq;

    wire  [N - 1: 0] regOutA, regOutB, dataA, dataB, subtractOut, subtractIn1, subtractIn2;
    
    //INCOMPARATOR(in1, in2, lt, gt, eq);STANTIATE THE SUBTRACTOR
    COMPARATOR COMPARE(regOutA, regOutB, lt, gt, eq);

    //MUXES FOR CHOOSING LOAD VALUE OF A & B
    MUX2TO1_NBIT MUXA(dataInA, subtractOut, selLoadA, dataA);
    MUX2TO1_NBIT MUXB(dataInB, subtractOut, selLoadB, dataB);

    //MUXES FOR CHOOSING INPUTS OF SUBTRACTOR
    MUX2TO1_NBIT MUXIN1(regOutB, regOutA, gt, subtractIn1);
    MUX2TO1_NBIT MUXIN2(regOutA, regOutB, gt, subtractIn2);

    //INSTANTIATE REGISTER A
    REGISTER_NBIT REGA(regOutA, dataA, loadA, clock);

    //INSTANTIATE REGISTER B
    REGISTER_NBIT REGB(regOutB, dataB, loadB, clock);

    //SUBTRACTOR
    SUBTRACTOR SUBTRACT(subtractIn1, subtractIn2, subtractOut);

endmodule

//CONTROLLER
module CONTROLLER(start,  done, lt, gt, eq, loadA, loadB, selLoadA, selLoadB,  clock);
    input start, lt, gt, eq, clock;
    output reg done, loadA, loadB, selLoadA, selLoadB;

    //REGISTERS FOR HOLDING STATE
    reg [2: 0] state;

    //PARAMETERS FOR STATE
    parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101;

    //ALWAYS BLOCK FOR STATE CHANGE
    always @ (posedge clock)
    begin
        case(state)
            S0: state <= start ? S1: S0;
            S1: state <= S2;
            S2: begin
                if (lt) state <= S3;
                else if (gt) state <= S4;
                else if (eq) state <= S5;
            end
            S3: state <= S2;
            S4: state <= S2;
            S5: state <= S5;
            default: state <= S0;
        endcase
    end

    //ALWAYS BLOCK FOR CONTROL SIGNALS
    always @ (state)
        begin
            case(state)
                S0: begin done = 0; loadA = 0; loadB = 0; selLoadA = 0; selLoadB = 0; end
                S1: begin done = 0; loadA = 1; loadB = 1; selLoadA = 0; selLoadB = 0; end
                S2: begin done = 0; loadA = 0; loadB = 0; selLoadA = 0; selLoadB = 0; end
                S3: begin done = 0; loadA = 0; loadB = 1; selLoadA = 0; selLoadB = 1; end
                S4: begin done = 0; loadA = 1; loadB = 0; selLoadA = 1; selLoadB = 0; end
                S5: begin done = 1; loadA = 0; loadB = 0; selLoadA = 0; selLoadB = 0; end
                default: begin done = 0; loadA = 0; loadB = 0; selLoadA = 0; selLoadB = 0; end
            endcase
        end
endmodule


module TESTBENCH;
    parameter N = 16;
    reg [N-1: 0] dataInA, dataInB;
    reg clock, start;

    wire done, lt, gt, eq, loadA, loadB, selLoadA, selLoadB;

    GCD_DATAPATH DP(
    loadA, loadB, selLoadA, selLoadB, dataInA, dataInB,  clock, lt, gt, eq
    );
    CONTROLLER CP(start,  done, lt, gt, eq, loadA, loadB, selLoadA, selLoadB,  clock);


    initial begin
        clock = 1'b0;
        start = 1'b0;

        #12 start = 1'b1;
        #10 start = 1'b0;
    end

    always #5 clock = ~clock;


    initial begin
        $monitor ($time, "DONE = %b START = %b DATAA = %d A = %d DATAB = %d B = %d LT = %b GT = %b EQ = %b STATE = %b SELLOADA = %b LOADA = %b SELLOADB = %b LOADB = %b DONE = %b\n",done, start, dataInA, DP.regOutA, dataInB, DP.regOutB, lt, gt, eq, CP.state, selLoadA, loadA, selLoadB, loadB, done);
        //DATA TO INITIALLY LOAD
        #12 dataInA = 16'd26; dataInB = 16'd13;
        #1000 $finish;
    end
endmodule