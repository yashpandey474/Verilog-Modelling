module COUNTER (counterOut, clock, clear);
    input clock, clear;
    output reg [3: 0] counterOut;

    always @ (posedge clock or posedge clear)
    begin
        if (clear) counterOut <= 4'b0000;
        else counterOut <= 1 + counterOut;
    end
endmodule


module TESTBENCH;
    reg clock, clear;
    wire [3: 0] counterOut;

    COUNTER COUNT(counterOut, clock, clear);

    initial begin
        clock = 1'b0;
        clear = 1'b1;

        #15 clear = 1'b0;

        #1000 $finish;
    end

    always #5 clock = ~clock;

    always @ (posedge clock)
        $display("COUNTER OUTPUT = %b CLEAR = %b\n", counterOut, clear);
    

endmodule