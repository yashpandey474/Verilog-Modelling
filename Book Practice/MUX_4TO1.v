module MUX4TO1 (in1, in2, in3, in4, s0, s1, out);
    input in1, in2, in3, in4, s0, s1;
    output reg out;

    always @ (in1 or in2 or in3 or in4 or s0 or s1)
    begin
        case ({s1, s0})
        2'b00: out <= in1;
        2'b01: out <= in2;
        2'b10: out <= in3;
        2'b11: out <= in4;
        default: out <= 1'bx;
        endcase
    end
endmodule