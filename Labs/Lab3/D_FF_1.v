//D FLIP FLOP WITH SYNCHRONOUUS CLEAR
module D_FF_SYNC_CLEAR (output reg Q, input D, input clock, input reset);
    always @ (negedge clock)
    begin
        if  (!reset) Q <= 1'b0;
        else Q <= D;    
    end
endmodule

//D FLIP FLOP WITH ASYNCHRONOUS CLEAR
module D_FF_ASYNC_CLEAR (
    output reg Q, input D, input clock, input clear
);
    always @ (negedge clock or negedge clear)
    begin
        if (!clear) Q <= 1'b0;
        else Q <= D;
    end
endmodule

module TESTBENCH;
    reg d, clock, reset;
    wire q;

    D_FF_SYNC_CLEAR DFF (q, d, clock, reset);

    always @ (posedge clock)
    begin
        $display ("D = %b Q = %b RESET = %b", d, q, reset);
    end

    initial begin
        forever begin
            clock = 1'b0;
            #5 clock = 1'b1;
            #5 clock = 1'b0;
        end
    end

    initial begin
        d = 1'b0; reset = 1'b1;
        #4 d = 1'b1; reset = 1'b0;

        #50 d = 1'b1; reset = 1'b1;

        #20 d = 0; reset = 1'b0;;

        #100 $finish;
    end
endmodule




