module cyclic_lights(
    out,
    clock
);

    input clock, reset;
    output reg [2: 0] out;

    //ADDITIONAL REG TO STORE STATE
    reg [1: 0] state;
    parameter s0 = 0, s1 = 1, s2 = 2;

    //SAY, SIGNALS TO ACTIVATE LIGHTS
    parameter RED = 3'b000, GREEN = 3'b001, YELLOW = 3'b010;

    always @ (posedge clock)
    begin
        case(state)
            s0: state <= s1;
            s1: state <= s2;
            s2: state <= s0;
            default: state <= s0;
        endcase
    end

    always @(state)
    case(state)
        s0: out = RED;
        s1: out = GREEN;
        s2: out = YELLOW;
        default: out = RED;
    endcase
endmodule

module test_cyclic_lamp;
    reg clock;
    wire [2: 0] light;
    
    cyclic_lights LAMP (light, clock);

    always 
    begin
        #5 clock = ~clock;
    end

    initial begin
        clock = 1'b0;
        #100 $finish;
    end

    initial
    begin
        $dumpfile()
        $monitor($time, "RGY: %b", light);
    end
    endmodule
