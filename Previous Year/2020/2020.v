//4-BIT RIPPLE COUNTER USING RS FLI; FLOP

//R-S FLIP FLOP
module RS_FLIP_FLOP (Q, Qbar, clock, reset, S, R);
    input S, R, clock, reset;
    output reg Q, Qbar;

    always @ (posedge clock or posedge reset)
    begin
        if (reset) begin
            Q <= 1'b0;
            Qbar <= 1'b1;
        end
        else begin
            case ({S, R})
                2'b01: begin
                    Q <= 1'b0;
                    Qbar <= 1'b1;
                end
                2'b10: begin
                    Q <= 1'b1;
                    Qbar <= 1'b0;
                end
                2'b11: begin
                    Q <= 1'b1;
                    Qbar <= 1'b0;
                end
            endcase
        end
    end
endmodule

//IMPLEMENT A D FLIP FLOP USING RS FLIP FLOP
module D_FLIP_FLOP (Q, Qbar, clock, reset, D);
    input clock, reset, D;
    output Q, Qbar;

    RS_FLIP_FLOP RSFF (Q, Qbar, clock, reset, D, ~D);
endmodule

//IMPLEMENT 4-BIT COUNTER USING D FLIP FLOPS
module RIPPLE_COUNTER (counterOutput, clock, reset);
    input clock, reset;
    output [3: 0] counterOutput;
    wire [3: 0] Qbar;

    D_FLIP_FLOP DFF0(counterOutput[0], Qbar[0], clock, reset,  Qbar[0]);
    D_FLIP_FLOP DFF1(counterOutput[1], Qbar[1], Qbar[0], reset, Qbar[1]);
    D_FLIP_FLOP DFF2(counterOutput[2], Qbar[2], Qbar[1], reset, Qbar[2]);
    D_FLIP_FLOP DFF3(counterOutput[3], Qbar[3], Qbar[2], reset, Qbar[3]);
endmodule

//INITIALISE 8X8 MEMORY BANKS WITH DATA AND PARITY
module MEM1 (address, data_out, parity_out);
    input [2: 0] address;
    output [7: 0] data_out;
    output parity_out;

    //REGISTERS TO HOLD DATA
    reg [7: 0] memory [7: 0];
    //REGISTERS TO HOLD PARITY
    reg [7: 0] parity;

    //INITIALISE
    initial begin
        parity = 8'b11111111;
        memory[0] = 8'b00011111;

        memory[1] = 8'b00110001;

        memory[2] = 8'b01010011;

        memory[3] = 8'b01110101;

        memory[4] = 8'b10010111;

        memory[5] = 8'b10111001;

        memory[6] = 8'b11011011;

        memory[7] = 8'b11111101;
    end

    assign data_out = memory[address];
    assign parity_out = parity[address];
endmodule 

module MEM2 (address, data_out, parity_out);
    input [2: 0] address;
    output [7: 0] data_out;
    output parity_out;

    //REGISTERS FOR DATA
    reg [7: 0] memory [7: 0];
    //REGISTERS FOR PARITY;
    reg [7: 0] parity;

    initial begin
        parity = 8'b00000000;
        memory[0] = 8'b00000000;
        memory[1] = 8'b00100010;
        memory[2] = 8'b01000100;
        memory[3] = 8'b01100110;
        memory[4] = 8'b10001000;
        memory[5] = 8'b10101010;
        memory[6] = 8'b11001100;
        memory[7] = 8'b11101110;
    end

    assign data_out = memory[address];
    assign parity_out = parity[address];
    
endmodule


//FETCH DATA; TAKE INPUT FROM RIPPLE COOUNTER AND OUTPUT THE DATA AND PARIITY

//2TO1 MUX 1 BIT
module MUX2TO1 (in1, in2, sel, out);
    input in1, in2, sel;
    output out;

    assign out = sel ? in2 : in1;
endmodule

//16TO8 MUX USING 2TO1 MUXES
module MUX16TO8 (in1, in2, sel, out);
    input [7: 0] in1, in2;
    input sel;
    output [7: 0] out;

    MUX2TO1 MUX0(in1[0], in2[0], sel, out[0]);
    MUX2TO1 MUX1(in1[1], in2[1], sel, out[1]);
    MUX2TO1 MUX2(in1[2], in2[2], sel, out[2]);
    MUX2TO1 MUX3(in1[3], in2[3], sel, out[3]);
    MUX2TO1 MUX4(in1[4], in2[4], sel, out[4]);
    MUX2TO1 MUX5(in1[5], in2[5], sel, out[5]);
    MUX2TO1 MUX6(in1[6], in2[6], sel, out[6]);
    MUX2TO1 MUX7(in1[7], in2[7], sel, out[7]);

endmodule

//FETCH THE FINAL DATA AND PARITY
module FETCH_DATA (counterOutput, data_out, parity_out);
    input [3: 0] counterOutput;
    output [7: 0] data_out;
    output parity_out;

    wire [7: 0] data_out1, data_out2;
    wire parity_out1, parity_out2;

    MEM1 mem1(counterOutput[2: 0], data_out1, parity_out1);
    MEM1 mem2(counterOutput[2: 0], data_out2, parity_out2);

    MUX16TO8 MUXDATA(data_out1, data_out2, counterOutput[3], data_out);
    MUX2TO1 MUXPAR(parity_out1, parity_out2, counterOutput[3], parity_out);
endmodule

//RECOMPUTE THE ODD PARITY FROM DATA AND COMPARE WITH STORED PARITY
module PARITY_CHECKER(data, parity, parity_compute, result);
    input [7: 0] data;
    input parity;
    output result;
    output parity_compute;

    assign parity_compute = ^data;
    assign result = (parity == parity_compute) ? 1: 0;
endmodule

//INTEGRATE THE OVERALL DESIGN
module DESIGN (clock, reset, data_out, result);
    input clock, reset;
    output result;
    output [7: 0] data_out;

    wire [3: 0] counterOutput;
    wire parity_out, parity_compute;
    
    RIPPLE_COUNTER COUNTER(counterOutput, clock, reset);
    FETCH_DATA DATA(counterOutput, data_out, parity_out);
    PARITY_CHECKER CHECKER(data_out, parity_out, parity_compute, result);
endmodule

module TESTBENCH;
    reg clock, reset;
    wire [7: 0] data_out;
    wire result;

    DESIGN DP(clock, reset, data_out, result);

    initial begin
        clock = 1'b0;
        reset = 1'b1;
    end

    initial
        begin
        $dumpfile("filename.vcd");
        $dumpvars;
    end
    always #5 clock = ~clock;

    initial begin
        $monitor ($time, " RESET = %b COUNTER OP = %b, DATA OP = %b PARITY OP = %b PARITY COMPUTE = %b MATCH = %b\n", reset, DP.counterOutput, data_out, DP.parity_out, DP.parity_compute, result);
        #5 reset = 1'b0;
        #1000 $finish;
    end
endmodule