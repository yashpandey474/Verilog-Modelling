//2TO1 MUX USING DATAFLOW MODELLING
module MUX2TO1 (in1, in2, sel, out);
    input in1, in2, sel;
    output out;

    assign out = (in1 & (~sel)) | (in2 & sel);
endmodule

//8TO1 MUX USING DATAFLOW MODELLING
module MUX8TO1 (in, sel, out);
    input [7: 0] in;
    input [2: 0] sel;
    output out;

    assign out = in[sel];
endmodule

//USES THE MUXES, BUILD USING GENERATE STATEMENT
module MUX_ARRAY (muxInput1, mux1Sel, mux2Sel, mux2Out);
    input [7: 0] muxInput1;
    input [7: 0] mux1Sel;
    input [2: 0] mux2Sel;
    output mux2Out;

    genvar j;
    
    //INSTANTIATE THE 8 MUXES
    wire [7: 0] muxOut1;
    generate for (j = 0; j < 8; j = j + 1) begin: MUX_LOOP
        MUX2TO1 MUXj(muxInput1[j], 1'b0, mux1Sel[j], muxOut1[j]);
    end
    endgenerate

    //INSTANTIATE THE 8TO1 MUX
    MUX8TO1 MUX2(muxOut1, mux2Sel, mux2Out);
endmodule

//3-BIT SYNCHRONOUS UP COUNTER WITH AN ASYNCHRONOUS CLEAR, BEHAVIIOURAL MODELLING
module COUNTER_3BIT (clear, clock, counterOut);
    input clear, clock;
    output reg [2: 0] counterOut;

    always @ (posedge clock or posedge clear)
    begin
        if (clear) counterOut <= 3'b000;
        else begin
            counterOut <= counterOut + 1;
        end
    end
endmodule

//3T08DECODER WITH ACTIVE HIGH ENABLE AND ACTIVE HIGH OUTPUTS. BEHAVIOURAL MODELLING
module DECODER (decoderIn, enable, decoderOut);
    input [2: 0] decoderIn;
    output reg [7: 0] decoderOut;
    input enable;

    always @ (*)
    begin
        if (enable)
        begin
            case(decoderIn)
            3'b000: decoderOut <= 8'b00000001;
            3'b001: decoderOut <= 8'b00000010;
            3'b010: decoderOut <= 8'b00000100;
            3'b011: decoderOut <= 8'b00001000;
            3'b100: decoderOut <= 8'b00010000;
            3'b101: decoderOut <= 8'b00100000;
            3'b110: decoderOut <= 8'b01000000;
            3'b111: decoderOut <= 8'b10000000;
            endcase
        end
    end
endmodule

//8X8 INITIALISED MEMORY
module MEMORY (address, dataOut);
    input [2: 0] address;
    output [7: 0] dataOut;
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

    assign dataOut = memory[address];
endmodule

//INTEGRATE THE MODULES
module TOP_MODULE(clear, clock, address, out);
    input clear, clock;
    input [2: 0] address;
    output out;

    //INSTANTIATE THE 3-BIT COUNTER
    wire [2: 0] counterOut;
    COUNTER_3BIT COUNTER(clear, clock, counterOut);

    //INSTANTIATE THE 3TO8 DECODER
    wire [7: 0] decoderOut;
    DECODER DEC(counterOut, 1'b1, decoderOut);

    //INSTANTIIATE THE 8X8 MEMORY
    wire [7: 0] dataOut;
    MEMORY MEM(address, dataOut);
    
    //INSTANTIATE THE MUX ARRAYY
    MUX_ARRAY MUXES(decoderOut, dataOut, counterOut, out);
endmodule

//TESTBENCH
module TESTBENCH;
    reg clear, clock;
    reg [2: 0] address;
    wire out;
    TOP_MODULE DP(clear, clock, address, out);

    initial begin
        clear = 1'b1;
        clock = 1'b0;
        address = 3'b000;
    end

    always #500000 clock = ~clock;
    always #8000000 address = address + 1;
    initial begin
        $monitor ($time, " ADDRESS = %b COUNTER_OUT = %b OUT = %b", address, DP.counterOut, out);
        #5 clear = 1'b0;
        #1000000000 $finish;
    end
endmodule

