//2TO1 MUX USING DATAFLOW MODELLING
module MUX_SMALL (in1, in2, sel, out);
    input in1,in2, sel;
    output out;

    assign out = sel ? in2: in1;
endmodule

//8TO1MUX USING 2TO1MUXES
module MUX_BIG (in, sel, out);
    input [7: 0] in;
    input [2: 0] sel;
    output out;

    //OUTER MUXES
    wire [3: 0] out1;
    MUX_SMALL M10(in[0], in[1], sel[0], out1[0]);
    MUX_SMALL M11(in[2], in[3], sel[0], out1[1]);
    MUX_SMALL M12(in[4], in[5], sel[0], out1[2]);
    MUX_SMALL M13(in[6], in[7], sel[0], out1[3]);

    //MIDDLE MUXES
    wire [1: 0] out2;
    MUX_SMALL M20(out1[0], out1[1], sel[1], out2[0]);
    MUX_SMALL M21(out1[2], out1[3], sel[1], out2[1]);

    //OUTER MUX
    MUX_SMALL M30(out2[0], out2[1], sel[2], out);
endmodule


//T FLIP FLOP WITH ASYNCHRONOUS CLEAR. BEHAVIOURAL MDELLINIG
module TFF (T, clock, clear, Q);
    output reg Q;
    input T, clock, clear;

    always @ (posedge clock or posedge clear)
    begin
        if (clear) Q <= 1'b0;
        else begin
            case(T)
            1'b0: Q<=Q;
            1'b1: Q<=~Q;
            endcase
        end
    end
endmodule

//4-BIT SYNCHRONOUS UP COUNTER WITH ASYNCHRONOUS CLEAR
module COUNTER_4BIT (counterOut, clock, clear);
    input clock, clear;
    output [3: 0] counterOut;

    TFF TFF0(1'b1, clock, clear, counterOut[0]);
    TFF TFF1(counterOut[0], clock, clear, counterOut[1]);
    TFF TFF2(counterOut[1] & counterOut[0], clock, clear, counterOut[2]);
    TFF TFF3(counterOut[2] & counterOut[1] & counterOut[0], clock, clear, counterOut[3]);
endmodule

//3-BIT SYNCHRONOUS UP COUNTER WITH ASYNCHRONOUS CLEAR
module COUNTER_3BIT (counterOut, clock, clear);
    output [2: 0] counterOut;
    input clock, clear;

    TFF TFF0(1'b1, clock, clear, counterOut[0]);
    TFF TFF1(counterOut[0], clock, clear, counterOut[1]);
    TFF TFF2(counterOut[1] & counterOut[0], clock, clear, counterOut[2]);
endmodule

//16X8 MEMORY 
module MEMORY (address, dataOut);
    input [3: 0] address;
    output [7: 0] dataOut;
    reg [7: 0] memory [15: 0];
    integer k;

    initial begin
        for (k = 0; k < 16; k = k + 1)
        begin
            if (k % 2 == 0) memory[k] = 8'hcc;
            else memory[k] = 8'haa;
        end
    end

    assign dataOut = memory[address];
endmodule

//INTEGRATED
module INTG (clock, clear, out);
    input clock, clear;
    output out;

    wire [2: 0] counterOut1;
    wire [3: 0] counterOut2;
    wire [7: 0] dataOut;

    MEMORY MEM(counterOut2, dataOut);
    COUNTER_3BIT COUNTER1(counterOut1, clock, clear);
    COUNTER_4BIT COUNTER2(counterOut2, counterOut1[2] & counterOut1[1] & counterOut1[0], clear);
    MUX_BIG MUX(dataOut, counterOut1, out);
endmodule

module TESTBENCH;
    reg clock, clear;
    wire out;

    INTG DP(clock, clear, out);
    initial begin
        clock = 1'b0;
        clear = 1'b1;
    end

    always #500000 clock  = ~clock;

    initial begin
        $monitor ($time, "CLEAR = %b OUT = %b COUNTER1 = %b COUNTER2 = %b\n", clear, out, DP.counterOut1, DP.counterOut2);
        #5 clear = 1'b0;
        #1000000000 $finish;
    end
    
endmodule