//2TTO1 MUX [DATAFLOW MODELLING]
module MUX_2X1 (in1, in2, sel, out);
    input in1, in2, sel;
    output out;

    //DATAFLOW MODELLING USES OPERATORS LIKE &, \, ~ AND CONTINOUS ASSIGNMENT (ASSIGN STATEMENT)
    assign out  = (sel == 0 ? in1: in2);
endmodule

//8TO1 MUX [DDATAFLOW MODELLING; SINGLE ASSIGN STATEMENT]
module MUX_8X1(in, sel, out);
    input [7: 0] in;
    input [2: 0] sel;
    output out;

    assign out = (
        (sel == 0) ? in[0]: 
        (sel == 1) ? in[1]:
        (sel == 2) ? in[2]:
        (sel == 3) ? in[3]:
        (sel == 4) ? in[4]:
        (sel == 5) ? in[5]:
        (sel == 6) ? in[6]: in[7]
    );
endmodule

//GENERATE STATEMENT
module MUX_ARRAY(in1, sel1, sel2, out2);
    input [7: 0] in1, in2, sel1;
    input [2: 0] sel2;
    wire [7: 0] out1;
    output out2;

    genvar j;
    generate for (j = 0; j < 8; j = j + 1) begin: MUX_LOOP
        MUX_2X1 Mj(in1[j], 1'b0, sel1[j], out1[j]);
    end
    endgenerate

    MUX_8X1 M8 (out1, sel2, out2);
endmodule

//3 BIT SYNCHRONOUS UP COUNTER WITH ASYNCHRONOUS CLEAR [BEHAVIOURAL MODELLING]
module COUNTER_3BIT (Q, clock, clear);
    output reg [2: 0] Q;
    input clock, clear;

    always @ (negedge clock or clear)
    begin
        if (clear) Q <= 3'b0;
        else Q <= Q + 3'b001;
    end

endmodule

//3TO8 DECODER WITH ACTIVE HIGH OUTPUTS AND ACTIVE HIGH ENABLE (BEHAVIIOURAL)
module DECODER (enable, in, out);
    input [2: 0] in;
    output reg [7: 0] out;
    input enable;

    always @ (*)
    begin
        if (enable) begin
            case(in)
            3'b000: out <= 8'b00000001;
            3'b001: out <= 8'b00000010;
            3'b010: out <= 8'b00000100;
            3'b011: out <= 8'b00001000;
            3'b100: out <= 8'b00010000;
            3'b101: out <= 8'b00100000;
            3'b110: out <= 8'b01000000;
            3'b111: out <= 8'b10000000;
            default: out <= 8'b00000000;
            endcase
        end
    end
endmodule

//8X8 MEMORY [BEHAVIOURAL MODELLING]
module MEMORY (address, data_out);
    input [2: 0] address;
    output reg [7: 0] data_out;
    reg [7: 0] memory [7: 0];

    initial begin
        memory[0] = 8'h01;
        memory[1] = 8'h03;
        memory[2] = 8'h07;
        memory[3] = 8'h0f;
        memory[4] = 8'h1f;
        memory[5] = 8'h3f;
        memory[6] = 8'h7f;
        memory[7] = 8'hff;
    end

    always @ (*)
        data_out <= memory[address];
endmodule

module TOP_MODULE(o, counterOut, clock, clear, S2, S1, S0);
    input clock, clear, S2, S1, S0;
    output [2: 0] counterOut;
    output o;

    //INSTANTIATE THE 3-BIT COUNTER
    COUNTER_3BIT COUNTER(counterOut, clock, clear);

    //INSTANTIATE THE 3TO8 DECODER
    wire [7: 0] decoderOut;
    DECODER DEC(1'b1, counterOut, decoderOut);

    //INSTANTIATE THE MEMORY
    wire [7: 0] memoryOut;
    MEMORY MEM({S2, S1, S0}, memoryOut);

    //INSTANTIATE THE MUX ARRAY
    MUX_ARRAY MUXES (decoderOut, memoryOut, counterOut, o);

endmodule

module TESTBENCH;
    reg clock, clear;
    reg [2: 0] s;
    wire o;
    wire [2: 0] counterOut;
    TOP_MODULE DP(o, counterOut, clock, clear, s[2], s[1], s[0]);

    initial begin
        clock = 1'b0;
        clear = 1'b1;
        s  = 3'b000;
    end

    always #500 clock = ~clock;

    initial begin
        $monitor ($time, "ADDRESS = %b, COUNTER_OUT = %d, OUTPUT = %b\n", s, counterOut, o);
        #500 clear = 1'b0;
        #7500 s = s + 1;
        repeat (6) begin
            #8000
            s = s + 1;
        end

        #100 $finish;
    end
endmodule