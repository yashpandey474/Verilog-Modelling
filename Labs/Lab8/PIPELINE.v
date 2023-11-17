module EVEN_PARITY_GENERATOR(
    X, Out
);
    //OUTPUT IS 1 WHEN NUMBE OF 1'S IS EVEN
    input [3: 0] X;
    output Out;
    assign Out = ~ (X[0] ^ X[1] ^ X[2] ^ X[3]);
endmodule

module ENCODER_8TO3 (in, out);
    input [7: 0] in;
    output reg [2: 0] out;

    always @ (*)
    begin
        case(in)
            8'b00000001: out <= 3'd0;
            8'b00000010: out <= 3'd1;
            8'b00000100: out <= 3'd2;
            8'b00001000: out <= 3'd3;
            8'b00010000: out <= 3'd4;
            8'b00100000: out <= 3'd5;
            8'b01000000: out <= 3'd6;
            8'b10000000: out <= 3'd7;
        endcase
    end
endmodule

module ALU (input1, input2, control, out);
    input [3: 0] input1, input2;
    input [2: 0] control;
    output reg[3: 0] out;

    parameter ADD = 3'b000, SUB = 3'b001, XOR = 3'b010, OR = 3'b011, AND = 3'b100, 
    NOR = 3'b101, NAND = 3'b110, XNOR = 3'b111;


    always @ (input1 or input2 or control)
    begin
        case(control)
        ADD: out <= input1 + input2; 
        SUB: out <= input1 - input2;
        XOR: out <= input1 ^ input2;
        NOR: out <= ~ (input1 | input2);
        NAND: out <= ~ (input1 & input2);
        XNOR: out <= ~ (input1 ^ input2);
        default: out <= 4'hx;
        endcase
    end
endmodule


module PIPELINE (
    funct, clock, Result,
    A, B
);
    input clock;
    input [3: 0] A, B;
    input [7: 0] funct;
    output Result; 
    wire [3: 0] ALUOut;
    wire [2: 0] ctrl;
    reg [3: 0] CTRL_12, A_12, B_12, X_23;
    reg RES_34;
    wire ParityGenOut;
    //ENCODER
    ENCODER_8TO3 ENC(funct, ctrl);

    //ALU 
    ALU alu(A_12, B_12, ctrl, ALUOut);

    //PARITY GENERATOR
    EVEN_PARITY_GENERATOR parity(X_23, ParityGenOut);

    assign Result = RES_34;

    //FIRST PIPELINE STAGE
    always @ (posedge clock)
    begin
        CTRL_12 <= ctrl;
        A_12 = A;
        B_12 = B;
    end

    //SECOND PIPELINE STAGE
    always @ (posedge clock)
    begin
        X_23 <= ALUOut;
    end

    //THIRD PIPELINE STAGE
    always @ (posedge clock)
    begin
        RES_34 <= ParityGenOut;
    end

endmodule

module TESTBENCH;
    reg clock;
    reg [3: 0] A, B;
    reg [7: 0] funct;
    wire result;

    PIPELINE mod(funct, clock, result, A, B);
    initial begin
        $monitor($time, "A = %b, B = %b, RESULT = %b\n", A, B, result);

        clock = 1'b1;
        #4 A = 4'b0101; B = 4'b1110; funct = 8'h80;
        #4 A = 4'b0100; B = 4'b1111; funct = 8'h01;
        #50 $finish;
    end
    always #5 clock = ~clock;

endmodule