//RS FLIP FLOP
module RS_FF(Q, Qbar, S, R, clock, reset);
    input S, R, clock, reset;
    output reg Q, Qbar;

    always @ (negedge clock)
    begin
        if (reset) begin
            Q <= 1'b0;
            Qbar <= 1'b1;
        end

        else begin
            case({S, R})
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

//D FLIP FLOP
module D_FF (Q, Qbar, D, clock, reset);
    input D, clock, reset;
    output reg Q, Qbar;
    wire Q_rs, Qbar_rs;

    RS_FF RS (Q_rs, Qbar_rs, D, ~D, clock, reset);

    always @ (*)
    begin
     Q = Q_rs;
     Qbar = Qbar_rs;
    end
endmodule

//RIPPLE COUNTER
module RIPPLE_COUNTER_4BIT (Q, clock, reset);
    input clock, reset;
    output [3: 0] Q;
    wire [3: 0] Qbar;

    D_FF DFF0 (Q[0], Qbar[0], Qbar[0], clock, reset);
    D_FF DFF1 (Q[1], Qbar[1], Qbar[1], Q[0], reset);
    D_FF DFF2 (Q[2], Qbar[2], Qbar[2], Q[1], reset);
    D_FF DFF3 (Q[3], Qbar[3], Qbar[3], Q[2], reset);

endmodule

//MEMORY 1 & 2
module MEMORY_1 (address, data_out, parity_out);
    reg [7: 0] memory_1 [7: 0];
    reg [7: 0] parity_1;
    input [2: 0] address;
    output [7: 0] data_out;
    output parity_out;

    initial begin
        memory_1[0] = 8'b00011111;
        memory_1[1] = 8'b00110001;
        memory_1[2] = 8'b01010011;
        memory_1[3] = 8'b01110101;
        memory_1[4] = 8'b10010111;
        memory_1[5] = 8'b10111001;
        memory_1[6] = 8'b11011011;
        memory_1[7] = 8'b11111101;

        parity_1 = 8'b11111111;
    end

    assign data_out = memory_1[address];
    assign parity_out = parity_1[address];
endmodule

module MEMORY_2 (address, data_out, parity_out);
    reg [7: 0] memory_2 [7: 0];
    reg [7: 0] parity_2;
    input [2: 0] address;
    output [7: 0] data_out;
    output parity_out;

    initial begin
        memory_2[0] = 8'b00000000;
        memory_2[1] = 8'b00100010;
        memory_2[2] = 8'b01000100;
        memory_2[3] = 8'b01100110;
        memory_2[4] = 8'b10001000;
        memory_2[5] = 8'b10101010;
        memory_2[6] = 8'b11001100;
        memory_2[7] = 8'b11101110;

        parity_2 = 8'b0000000;
    end

    assign data_out = memory_2[address];
    assign parity_out = parity_2[address];
endmodule

module MUX_2TO1_1BIT (in1, in2, sel, out);
    input in1, in2, sel;
    output out;

    assign out = sel ? in2: in1;

endmodule

module MUX_16TO8 (in1, in2, sel, out);
    input [7: 0] in1, in2;
    input sel;
    output [7: 0] out;

    MUX_2TO1_1BIT MUX0(in1[0], in2[0], sel, out[0]);
    MUX_2TO1_1BIT MUX1(in1[1], in2[1], sel, out[1]);
    MUX_2TO1_1BIT MUX2(in1[2], in2[2], sel, out[2]);
    MUX_2TO1_1BIT MUX3(in1[3], in2[3], sel, out[3]);
    MUX_2TO1_1BIT MUX4(in1[4], in2[4], sel, out[4]);
    MUX_2TO1_1BIT MUX5(in1[5], in2[5], sel, out[5]);
    MUX_2TO1_1BIT MUX6(in1[6], in2[6], sel, out[6]);
    MUX_2TO1_1BIT MUX7(in1[7], in2[7], sel, out[7]);
endmodule


module FETCH_DATA (in, data_out, parity_out);
    input [3: 0] in;
    output [7: 0] data_out;
    output parity_out;
    wire [7: 0] data_out_1, data_out_2;

    MEMORY_1 MEM1(in[2: 0], data_out_1, parity_out_1);
    MEMORY_2 MEM2(in[2: 0], data_out_2, parity_out_2);


    MUX_16TO8 MUX_DATA (data_out_1, data_out_2, in[3], data_out);
    MUX_2TO1_1BIT MUX_PARITY (parity_out_1, parity_out_2, in[3], parity_out);
endmodule

module PARITY_CHECKER (data_in, parity_in, result);
    input [7: 0] data_in;
    input parity_in;
    output result;
    wire parity;

    assign parity = ^ data_in;
    assign result = (parity_in == parity);
endmodule

module Design (result, clock, reset);
    output result;
    input clock, reset;
    wire [3: 0] Q;
    wire [7: 0] data_out;
    wire parity_out;

    //INSTANTIATE RIPPLE COUNTER
    RIPPLE_COUNTER_4BIT COUNTER (Q, clock, reset);
    FETCH_DATA MEMORY(Q, data_out, parity_out);
    PARITY_CHECKER PARITY_CHECK (data_out, parity_out, result);
endmodule

module TestBench;
    reg clock, reset;
    wire result;
    Design main_module(result, clock, reset);

    initial begin
        reset = 1'b1;
        clock = 1'b0;
    end

    always #5 clock = ~clock;

    initial begin
        $monitor ($time, "COUNT = %b, DATA_OUT = %b, PARITY_OUT = %b, RESULT = %b\n",main_module.Q, main_module.data_out, main_module.parity_out, result);
        #5 reset = 1'b0;
        #100 $finish;
    end
endmodule