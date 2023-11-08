module MUX_2to1(out, in1, in2, sel);
    input [15: 0] in1, in2;
    output reg [15: 0] out;
    input sel;

    always @ (*)
    begin
        if (sel) out <= in2;
        else out <= in1;
    end
endmodule

module SUBTRACTOR (out, in1, in2);
    input [15: 0] in1, in2;
    output reg [15: 0] out;

    always @ (*)
        out = in1 - in2;
endmodule

module REGISTER_16b (out, in, load,clock);
    input load, clock;
    output reg [15: 0] out;
    input [15: 0] in;

    always @ (posedge clock)
    begin
        if (load) out <= in;
    end
endmodule

module COMPARATOR(in1, in2, eq, gt, lt);
    input [15: 0] in1, in2;
    output eq, gt, lt;

    assign lt = (in1 < in2);
    assign eq = (in1 == in2);
    assign gt = (in1 > in2);
    
endmodule

module GCD_controlpath(start, done, clock, ldA, ldB, sel1, sel2, sel_in,
    lt, eq, gt
);
    input start, clock, lt, eq, gt;
    output reg done, ldA, ldB, sel1, sel2, sel_in;
    reg [2: 0] state;
    parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101;

    //STATE CONTROL BLOCK
    always @ (posedge clock)
        case(state)
            S0: if (start) state <= S1;
            S1: state <= S2;
            S2: begin
                #2 if (eq) state <= S5;
                else if (lt) state <= S3;
                else if (gt) state <= S4;
            end
            S3: begin
                #2 if (eq) state <= S5;
                else if (lt) state <= S3;
                else if (gt) state <= S4;
            end
            S4: #2 if (eq) state <= S5;
                else if (lt) state <= S3;
                else if (gt) state <= S4;

            S5: state <= S5;

            default: state <= S0;
        endcase

    //CONTROL SIGNALS ALWAYS BLOCK
    always @ (state)
        case(state)
            S0: begin
                sel_in = 1;
                ldA = 1;
                ldB = 0;
                done = 0;
            end
            S1: begin
                sel_in = 1;
                ldA = 0;
                ldB = 1;
                done = 0;
            end
            S2: begin
                if (eq) done = 1;
                else if (lt) begin
                    sel1 = 1; sel2 = 0; sel_in = 0;
                    #1 ldA = 0; ldB = 1;
                end
                else if (gt) begin
                    sel1 = 0; sel2 = 1; sel_in = 0;
                    #1 ldA = 1; ldB = 0;
                end
            end
            S3:
            begin
                if (eq) done = 1;
                else if (lt) begin
                    sel1 = 1; sel2 = 0; sel_in = 0;
                    #1 ldA = 0; ldB = 1;
                end
                else if (gt) begin
                    sel1 = 0; sel2 = 1; sel_in = 0;
                    #1 ldA = 1; ldB = 0;
                end
            end
            S4: begin
                if (eq) done = 1;
                else if (lt) begin
                    sel1 = 1; sel2 = 0; sel_in = 0;
                    #1 ldA = 0; ldB = 1;
                end
                else if (gt) begin
                    sel1 = 0; sel2 = 1; sel_in = 0;
                    #1 ldA = 1; ldB = 0;
                end
            end
            S5: begin
                done = 1; sel1 = 0; sel2 = 0; ldA = 0;
                ldB = 0;
            end

            default: begin
                ldA = 0; ldB = 0;
            end
        endcase

endmodule

module GCD_controlpath_2 (ldA, ldB, sel1, sel2, sel_in, done, clock, lt, gt, eq, start);
    input clock, lt, gt, eq, start;
    output reg ldA, ldB, sel1, sel2, sel_in, done;

    reg [2: 0] state, next_state;
    parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 =3'b100, S5 = 3'b101;

    always @ (posedge clock)
    begin
        state <= next_state;
    end

    always @ (state)
    begin
        case(state)
            S0: begin
                sel_in = 1;
                ldA = 1;
                ldB = 0;
                done = 0; next_state = S1;
            end
            S1: begin
                sel_in = 1;
                ldA = 0;
                ldB = 1;
                done = 0; next_state = S2;
            end
            S2: begin
                if (eq) begin done = 1; next_state = S5 end
                else if (lt) begin
                    sel1 = 1; sel2 = 0; sel_in = 0;
                    #1 ldA = 0; ldB = 1; next_state = S3;
                end
                else if (gt) begin
                    sel1 = 0; sel2 = 1; sel_in = 0;
                    #1 ldA = 1; ldB = 0; next_state = S4;
                end
            end
            S3:
            begin
                if (eq) begin done = 1; next_state = S5; end
                else if (lt) begin
                    sel1 = 1; sel2 = 0; sel_in = 0;
                    #1 ldA = 0; ldB = 1; next_state = S3;
                end
                else if (gt) begin
                    sel1 = 0; sel2 = 1; sel_in = 0;
                    #1 ldA = 1; ldB = 0; next_state = S4;
                end
            end
            S4: begin
                if (eq) begin done = 1; next_state = S5; end
                else if (lt) begin
                    sel1 = 1; sel2 = 0; sel_in = 0;
                    #1 ldA = 0; ldB = 1; next_state = S3;
                end
                else if (gt) begin
                    sel1 = 0; sel2 = 1; sel_in = 0;
                    #1 ldA = 1; ldB = 0; next_state = S4;
                end
            end
            S5: begin
                done = 1; sel1 = 0; sel2 = 0; ldA = 0;
                ldB = 0; next_state = s5;
            end

            default: begin
                ldA = 0; ldB = 0; next_state = S0;
            end
        endcase
    end
module GCD_datapath(gt, lt, eq, ldA, ldB, sel1, sel2, sel_in, data_in, clock);
    input clock;
    input [15: 0] data_in;
    output gt, lt, eq;
    input ldA, ldB, sel1, sel2, sel_in;
    wire [15: 0] Aout, Bout, X, Y, Bus, SubOut;

    REGISTER_16b A(Aout, Bus, ldA, clock);
    REGISTER_16b B(Bout, Bus, ldB, clock);
    MUX_2to1 MUX_in1 (X, Aout, Bout, sel1);
    MUX_2to1 MUX_in2 (Y, Aout, Bout, sel2);
    MUX_2to1 MUX_load(Bus, SubOut, data_in, sel_in);
    SUBTRACTOR SB (SubOut, X, Y);
    COMPARATOR COMP (Aout, Bout, eq, gt, lt);
endmodule

module GCB_tb;
    reg [15: 0] data_in;
    reg clock, start;
    wire done;

    GCD_datapath DP(gt, lt, eq, ldA, ldB, sel1, sel2,
     sel_in, data_in, clock
    );

    GCD_controlpath CON(start, done, clock, ldA, ldB,
    sel1, sel2, sel_in, lt, eq, gt
    );

    initial
    begin
        clock = 1'b0;
        #3 start = 1'b1;
        #1000 $finish;
    end
    
    always #5 clock = ~clock;

    initial begin
        #12 data_in  = 143;
        #10 data_in = 78;
    end

    initial begin
        $monitor ($time, "%d %b", DP.Aout, done);
    end
endmodule