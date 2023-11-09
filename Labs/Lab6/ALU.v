module ALU (
    out, in1, in2, control
);
    input [31: 0] in1, in2;
    output [31: 0] out;
    input [2: 0] control;

    parameter ADD  = 3'b010, SUBTRACT = 3'b110, AND = 3'b000;
    parameter OR = 3'b001, SLT = 3'b111; 
    always @ (*)
        case(control)
        ADD: out <= in1 + in2;
        SUBTRACT: out <= in1 - in2;
        AND: out <= in1 & in2;
        OR: out <= in1 | in2;
        SLT: begin
            if (in1 < in2) out <= 1;
            else out <= 0;
        end
        endcase
endmodule
