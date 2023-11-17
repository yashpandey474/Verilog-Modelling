module MUX_4TO1_GATE(input [3: 0] in, input [1: 0] sel, output out);
    wire N_S0, N_S1;

    wire AND_1, AND_2, AND_3, AND_4;

    not N0 (N_S0, sel[0]);
    not N1 (N_S1, sel[1]);

    and A0 (AND_1, in[0], N_S1, N_S0);
    and A1 (AND_2, in[1], N_S1, S0);
    and A2 (AND_3, in[2], sel[1], N_S0);
    and A3 (AND_4, in[3], sel[1], sel[0]);

    or OR0 (out, AND_1, AND_2, AND_3, AND_4);
endmodule

//16TO1 MUX USING THE 4TO1 MUX
module MUX_16TO1 (output out, input [15: 0] in,
input [3: 0] sel);
wire [3: 0] MuxOutputs;
    MUX_4TO1_GATE M0 (in[15: 12], sel[1: 0], MuxOutputs[0]);
    MUX_4TO1_GATE M1 (in[11: 8], sel[1: 0], MuxOutputs[1]);
    MUX_4TO1_GATE M2 (in[7: 4], sel[1: 0], MuxOutputs[2]);
    MUX_4TO1_GATE M3 (in[3: 0], sel[1: 0], MuxOutputs[3]);
    
    MUX_4TO1_GATE M4 (MuxOutputs, sel[3: 2], out);
endmodule


