module SHIFT_REGISTER (
    input clock,
    input enable, input data_in, output reg [3: 0] out);


    always @ (posedge clock)
    begin
        if (enable)
        begin
            out <= {data_in, out[2: 0]}
        end
    end
endmodule

module TESTBENCH;
    reg enable, in, clock;
    wire [3: 0] out;

    SHIFT_REGISTER REG (clock, enable, in, out);

    initial begin
        clock = 1'b0;
    end
    
    always #2 clock = ~clock;

    initial begin
       in = 0; enable = 0;
       $monitor ($time, "EN = %b, IN = %b, OUT = %b", enable, in, out);
       #4 in = 1; enable = 1;
       #4 in = 1; enable = 0;
       #4 in = 0; enable = 1;
       #5 $finish;

    end
    endmodule
