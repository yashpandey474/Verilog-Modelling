module ALU_CONTROL(
    funct, ALUOp,
    ALUControl
);
    input [1: 0] ALUOp;
    input [5: 0] funct;
    output [2: 0] ALUControl;
     
    assign ALUControl[0] = ALUOp[1] | funct[0] & funct[3];
    assign ALUControl[1] = (~ALUOp[1]) | (~funct[2]);
    assign ALUControl[2] = ALUOp[0] | ALUOp[1] & funct[1];

endmodule