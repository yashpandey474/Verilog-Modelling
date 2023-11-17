module ALU (input1, input2, control, out);
    input [3: 0] input1, input2;
    output reg[3: 0] out;
    parameter ADD = 3'b000, SUB = 3'b001, XOR = 3'b010, OR = 3'b011, AND = 3'b100, 
    NOR = 2'b101, NAND = 3'b110, XNOR = 3'b111;


    always @ (input1 or input2 or control)
    begin
        case(control)
        ADD: out <= input1 + input2; 
        SUB: out <= input1 - input2;
        XOR: out <= input1 ^ input2;
        NOR: out <= ~ (input1 | input2);
        NAND: out <= ~ (input1 & input2);
        XNOR: out <= ~ (input1 ^ input2);
        default: out <= 4'hx;
        endcase
    end
endmodule
