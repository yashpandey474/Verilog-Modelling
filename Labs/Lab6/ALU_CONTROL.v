module ALU_Control(
    funct,
    ALUOp,
    ALUControl
);
    //FUNCT FIELD OF INSTRUCTION
    input [5: 0] funct;

    //FROM MAIN CONTROL
    input [1: 0] ALUOp;

    //TO ALU
    output [2: 0] ALUControl;


    always @ (*)
        case(ALUOp)
        //LW/SW => ADD
        2'b00: ALUControl = 3'b010;
        //BRANCH => SUBTRACT
        2'b01: ALUControl = 3'b110;
        2'b10: begin
            case(funct)
            //ADD
            6'b000000: ALUControl = 3'b010;
            //SUBTRACT
            6'b100010: ALUControl = 3'b110;
            //AND
            6'b100100: ALUControl = 3'b000;
            //OR
            6'b100101: ALUControl = 3'b001;
            //SLT
            6'b101010: ALUControl = 3'b111;
            endcase
        end
        endcase
endmodule;