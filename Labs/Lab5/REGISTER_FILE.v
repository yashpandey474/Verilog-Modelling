module MUX_2to1 (out, in1, in2, sel);
    output reg [31: 0] out;
    input [31: 0] in1, in2;
    input sel;

    always @ (*)
    begin
        if (sel) out <= in2;
        else out <= in1;
    end
endmodule

module MUX_4to1 (out, in1, in2, in3, in4, sel);
    output [31: 0] out;
    input [31: 0] in1, in2, in3, in4;
    input [1: 0] sel;
    wire [31: 0] MUX1_out, MUX2_out;
    
    MUX_2to1 MUX1(MUX1_out, in1, in2, sel[0]);
    MUX_2to1 MUX2(MUX2_out, in3, in4, sel[0]);
    MUX_2to1 MUX3(out, MUX1_out, MUX2_out, sel[1]);
endmodule

module DECODER_2to4 (
    out, in
);
    input [1: 0] in;
    output reg [3: 0] out;
    
    always @ (*)
    begin
        case(in)
        0: out <= 4'b0001;
        1: out <= 4'b0010;
        2: out <= 4'b0100;
        3: out <= 4'b1000;
        endcase
    end
endmodule

module D_FLIP_FLOP(
    q, d, clock, reset
);
    output reg q;
    input d, clock, reset;

    always @ (posedge clock)
    begin
        if (reset) q <= 0;
        else q <= d;
    end
endmodule


module REGISTER_32bit (q, d, clock, reset);
    input [31: 0] d;
    output [31: 0] q;
    input clock, reset;

    genvar j;

    generate for (j = 0; j<32; j = j + 1) begin: REGISTER_LOOP
        D_FLIP_FLOP DJ(q[j], d[j], clock, reset);
    end
    endgenerate
endmodule

module REGISTER_FILE (
    readReg1, readReg2, readData1, readData2,
    writeReg, writeData, RegWrite, clock, reset
);

    //DECLARE THE PORTS
    input [1: 0] readReg1, readReg2, writeReg;
    output [31: 0] readData1, readData2;
    input [31: 0] writeData;
    input RegWrite, clock, reset;
    wire [3: 0] DecoderOut;

    //CLOCK SIGNALS
    wire [3: 0] registerClocks;
    wire[31: 0] reg1Out, reg2Out, reg3Out, reg4Out;
    wire clockWriteSignal;

    and A0 (clockWriteSignal, clock, RegWrite);

    genvar j;
    generate for (j = 0; j < 4; j = j + 1) begin: clock_loop
        and Aj (registerClocks[j], clockWriteSignal, DecoderOut[j]);
    end
    endgenerate

    //INSTANTIATE THE DECODER
    DECODER_2to4 DECODER (
        DecoderOut, writeReg
    );

    //INSTANTATE THE TWO MUXEES
    MUX_4to1 MUX1(
        readData1,
        reg1Out, reg2Out, reg3Out, reg4Out,
        readReg1
    );

    MUX_4to1 MUX2(
        readData2, 
        reg1Out, reg2Out, reg3Out, reg4Out,
        readReg2
    );

    //DECLARE THE REGISTERS
    REGISTER_32bit R0(reg1Out, writeData, clock, reset);
    REGISTER_32bit R1(reg2Out, writeData, clock, reset);
    REGISTER_32bit R2(reg3Out, writeData, clock, reset);
    REGISTER_32bit R3(reg4Out, writeData, clock, reset);
    

endmodule

module RF_test;
    reg clock, reset, write;
    reg [31: 0] writeData;
    reg [1: 0] readReg1, readReg2, writeReg;
    wire [31: 0] readData1, readData2;

    REGISTER_FILE RF(
    readReg1, readReg2, readData1, readData2,
    writeReg, writeData, write, clock, reset
    );

    initial begin
        clock = 1'b0; reset = 1;
        #2 clock = 1'b1; reset = 0;
        #2 reset = 1; clock = 1'b0;
    end

    always #5 clock = ~clock;

    initial
    begin
            $monitor($time, "READREG1 = %d, READREG2 = %d, WRITEREG = %d, READDATA1 = %d, READDATA2 = %d, WRITEDATA = %d", readReg1, readReg2, writeReg, readData1, readData2, writeData);
            #5 writeData = 32'hABCD; writeReg = 0;
            #1 readReg1 = 0; 
            #4 writeData = 32'h1234; writeReg = 1;
            #1 readReg1 = 0; readReg2 = 1;
            #100 $finish;
    end
endmodule   