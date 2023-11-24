`include "RIPPLE_FULL_ADDER.v"
`include "MUX2TO1.v"
`include "AND_OR.v"

module ALU (a, b, binvert, carryin, operation, result, carryout);
    input [31: 0] a, b;
    output [31: 0] result;
    input carryin, binvert;
    input [1: 0] operation;
    output carryout;

    wire [31: 0] addOut, andOut, orOut, in2;
    MUX2TO1_32BIT MUX_INPUT(b, ~b, binvert, in2);
    MUX4TO1_32BITS MUX_RESULT(andOut, orOut, addOut, 32'd0,operation, result);
    OR_32IBIT OR(orOut, a, in2);
    AND_32BIT AND(andOut, a, in2);
    FULL_ADDER_32BIT FA(a, in2, carryin, carryout, addOut);
endmodule

module TESTBENCH;
    reg [31: 0] a,b;
    reg binvert, carryin;
    reg [1: 0] operation;

    wire [31: 0] result;
    wire carryout;
    
    ALU alu(a, b, binvert, carryin, operation, result, carryout);

    initial begin
       $monitor ($time, "OP = %b A = %d B = %d CIN = %b RES = %d COUT = %b\n", operation, a, b, carryin, result, carryout);
       a = 32'd100; b = 32'd100; binvert = 1'b0; carryin = 1'b0; operation = 2'b10;
       #100 a = 32'd200; b = 32'd200; binvert = 1'b1; carryin = 1'b1; operation = 2'b10;

    end
endmodule