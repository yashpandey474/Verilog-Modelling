module ALU (out, in1, in2, control);

    input [15: 0] in1, in2;
    output reg[15: 0] out;
    input control;

    always @ (*)
    begin
        if (control) out <= in1 - in2;
        else out <= in1 + in2;
    end
endmodule

module COMPARATOR (out, in);
    input [15: 0] in;
    output out;

    assign out = (in == 0);
endmodule

module REG_1 (out, in, serial_in, clock, load, clear, shift);
    input [15: 0] in;
    output reg [15: 0] out;
    input serial_in, load, clear, clock, shift;

    always @ (posedge clock)
    begin
        if (clear) out <= 0;

        else if (load) out <= in;

        else if (shift) out <= {serial_in, lut [15: 1]};
    end
endmodule

module REG_2 (out, in, load, clock)
input [15: 0] in;
    output [15: 0] out;
    input load, clock;

    always @ (posedge clock)
        if (load) out <= in;
endmodule

module COUNTER (out, decr, load, clock);
    output [4: 0] out;
    input decr, load, clock;

    always @ (*)
    begin
        if (decr) out <= out - 1;
        if (load) out <= 16;
    end
endmodule
module BOOTH_MUL_datapath(data_in, clock,
ldA, ldQ, ldM, ldcnt, clrQ, clrA, decr
sftQ, sftA, addSub,clrff, qm1, eqz);

    input clrff, decr, clock, ldA, ldQ, ldM, clrQ, clrA, sftQ, sftA, addSub;
    output qm1, eqz;
    input [15: 0] data_in;

    wire [15: 0] A, M, Q, Z;
    wire [4: 0] count;

    ALU alu (Z, A, M, addSub);
    COMPARATOR comp (eqz, count);
    REG_1 AR (A, Z, A[15], clock, ldA, clrA, sftA);
    REG_1 QR (Q, data_in, A[0], clock, ldQ, clrQ, sftQ);
    dff QM1 (Q[0], qm1l, clock, clrff);
    REG_2 MR (data_in, M, clock, ldM);
    COUNTER CN (count, decr, ldcnt, clk)
endmodule

module BOOTH_MUL_controlpath(ldA, clrA, sftA, ldQ, clrQ, sftQ, ldM, clrff,
addsub, start, decr, ldcnt, done, clk, qo, qm1);
    input clock, q0, qm1, start;

    output reg ldA, clrA, sftA, ldQ, clrQ, sftQ, ldM, clrff, addsub, decr, ldcnt, done;
    reg [2: 0] state;

    parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101, S6 = 3'b110;
    
    always @ (posedge clock)
    begin
        case(state)
            S0: if (start) state <= S1;
            S1: state <= S2;
            S2: begin if ({q0, qm} == 2'b10) state <= S4;
                else if ({q0, qm} == 2'b01) state <= S3;
                else state <= S5;
            end

            S3: state <= S5;
            S4: state <= S5;

            S5: #2 if (({q0, qm} == 2'b10) && !eqz ) state <= S4;
                else if (({q0, qm} == 2'b01) && (!eqz)) state <= S3;
                else if (!eqz) state <= S5;
                else state <= S0;

            S6: state <= S6;
            default: STATE<= S0;
        endcase

        always @ (state)
        begin
            case(state)
                S0: begin
                    clrA = 0; ldA = 0; sftA = 0; clrQ = 0; ldQ = 0; sftQ = 0;
                    ldM = 0; clrff = 0; done = 0;
                end
                S1: begin
                    clrA = 1; ldA = 0; sftA = 0; clrQ = 1; ldQ = 0; sftQ = 0;
                    ldM = 1; clrff = 1; done = 0; ldcnt = 1;
                end

                S2: begin
                    clrA = 0; ldA = 0; sftA = 0; clrQ = 0; ldQ = 1; sftQ = 0;
                    ldM = 0; clrff = 0; done = 0;
                end
                S3: begin
                    clrA = 0; ldA = 1; sftA = 0; clrQ = 0; ldQ = 0; sftQ = 0;
                    ldM = 0; clrff = 0; done = 0; addsub = 0;
                end
                S4: begin
                    clrA = 0; ldA = 1; sftA = 0; clrQ = 0; ldQ = 0; sftQ = 0;
                    ldM = 0; clrff = 0; done = 0; addsub = 1;
                end
                S5: begin
                    clrA = 0; ldA = 0; sftA = 1; clrQ = 0; ldQ = 0; sftQ = 1;
                    ldM = 0; clrff = 0; done = 0; decr = 1;
                end
                S6: done = 1;
                default: begin clrA = 0; sftA =  0; ldQ = 0; sftQ = 0; end
            endcase
        end
    end
endmodule

module BOOTH_MUL_tb;

endmodule