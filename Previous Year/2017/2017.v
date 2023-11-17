module MUX_SMALL  (in1, in2, sel, out);
    input in1, in2, sel;
    output out;

    assign out = ((~sel) & in1 | (sel & in2));
endmodule

//8TO1 MUX USING MULTIPLE 2TO1 MUX
module MUX_BIG(in, sel, out);
    input [2: 0] sel;
    input [7: 0] in;
    output out;

    wire out_1, out_2, out_3, out_4;
    wire out_5, out_6;
    MUX_SMALL M0(in[0], in[1], sel[0], out_1);    
    MUX_SMALL M1(in[2], in[3], sel[0], out_2); 
    MUX_SMALL M2(in[4], in[5], sel[0], out_3); 
    MUX_SMALL M3(in[6], in[7], sel[0], out_4); 


    MUX_SMALL M4(out_1, out_2, sel[1], out_5); 
    MUX_SMALL M5(out_3, out_4, sel[1], out_6); 

    MUX_SMALL M6(out_5, out_6, sel[2], out); 
endmodule


//T FLIP FLOP WITH ASYNCHRONOUS CLEAR
module TFF (T, Q, Qbar, clock, clear);
    input T, clock, clear;
    output reg Q, Qbar;

    always @ (negedge clock or clear)
    begin
        if (clear) begin
            Q <= 1'b0;
            Qbar <= 1'b1;
        end
        else begin
            if (T) begin
                Q <= ~Q;
                Qbar <= Q;
            end
            else begin
                Q <= Q;
                Qbar <= ~Q;
            end
        end
    end
endmodule

//SYNCHRONOUS BINARY UP COUNTER WITH ASYNCHRONOUS CLEAR
module COUNTER_4BIT (Q, clock, clear);
    output [3: 0] Q;
    input clock, clear;

    //INSTANTIATE 4 T FLIP FLOPS
    wire [3: 0] Qbar;
    TFF T0 (1'b1, Q[0], Qbar[0], clock, clear);
    TFF T1 (Q[0], Q[1], Qbar[1], clock, clear);
    TFF T2 (Q[0] & Q[1], Q[2], Qbar[2], clock, clear);
    TFF T3 (Q[0] & Q[1] & Q[2], Q[3], Qbar[3], clock, clear);
endmodule

module COUNTER_3BIT (Q, clock, clear);
    output [2: 0] Q;
    input clock, clear;

    //INSTANTIATE 4 T FLIP FLOPS
    wire [2: 0] Qbar;
    TFF T0 (1'b1, Q[0], Qbar[0], clock, clear);
    TFF T1 (Q[0], Q[1], Qbar[1], clock, clear);
    TFF T2 (Q[0] & Q[1], Q[2], Qbar[2], clock, clear);
endmodule

//16X8 MEMORY
module MEMORY (address, data_out);
    reg [7: 0] memory [15: 0];
    output [7: 0] data_out;
    input [3: 0] address;
    integer k;

    initial begin
        for (k = 0; k < 16; k = k + 1)        
        begin
            memory[k] = (k%2 == 0) ? 8'hcc: 8'haa;
        end
    end

    assign data_out = memory[address];
endmodule

//INTEGRATING MODULE
module INTG (clock, clear, out);
    output out;
    input clock, clear;


    //INSTANTIATE MEMORY
    wire [7: 0] data_out;
    MEMORY MEM(counter1Out, data_out);

    //INSTANTIATE 3TO1 MUX
    wire [2: 0] counter2Out;
    COUNTER_3BIT COUNTER_2(counter2Out, clock, clear);
    
    //INSTANTIATE 4-BIT UP-COUNTER
    wire clock2;
    wire[3: 0] counter1Out;
    assign clock2 = &counter2Out;
    COUNTER_4BIT COUNTER_1(counter1Out, clock2, clear);


    //INSTANTIATE 8TO1 MUX
    MUX_BIG MUX(data_out, counter2Out, out);
endmodule

module TESTBENCH;
    reg clock, clear;
    wire out;

    INTG DP(clock, clear, out);

    initial begin
        clock = 1'b0;
        clear = 1'b1;
    end

    always #5 clock = ~clock;

    initial begin
        $monitor ($time, "COUNT1 = %d, COUNT2 = %d, OUT = %b\n", DP.counter1Out, DP.counter2Out, out);
        #5 clear = 1'b0;
        #100 $finish;
    end

endmodule