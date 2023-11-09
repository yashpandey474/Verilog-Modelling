module MUX_2to1 (out, in1, in2, sel);
    output [31: 0] out;
    input [31: 0] in1, in2;
    input sel;

    always @ (*)
    begin
        if (sel) out <= in2;
        else out <= in1;
    end
endmodule

module MUX_4to1 (out, in1, in2, in3, in4, sel);
    output [31: 0] out;
    input [31: 0] in1, in2, in3, in4;
    input [1: 0] sel;
    wire [31: 0] MUX1_out, MUX2_out;
    
    MUX_2to1 MUX1(MUX1_out, in1, in2, sel[0]);
    MUX_2to1 MUX2(MUX2_out, in3, in4, sel[0]);
    MUX_2to1 MUX3(out, MUX1_out, MUX2_out, sel[1]);
endmodule