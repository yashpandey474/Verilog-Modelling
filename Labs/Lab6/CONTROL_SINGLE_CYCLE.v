module SINGLE_CYCLE_control(
    Op,
    RegDst, Jump, Branch,
    MemRead, MemtoReg, ALUOp,
    MemWrite, ALUSrc, RegWrite
);

    input [5: 0] Op;
    output RegDst, Jump, Branch, MemRead, MemtoReg;
    output MemWrite, ALUSrc, RegWrite;
    output [1: 0] ALUOp;

    case(op)
            //R-TYPE
            6'b000000:begin
                RegDst <= 1; ALUSrc <= 0;
                MemtoReg <= 0; RegWrite <= 1;
                MemRead <= 0; MemWrite <= 0;
                Branch <= 0;  Jump = 0;
                ALUOp = 2'b00; //ADDITION
            end
            //LOAD WORD
            6'b100011: begin
                RegDst <= 0; ALUSrc <= 1;
                MemtoReg <= 1; RegWrite <= 1;
                MemRead <= 1; MemWrite <= 0;
                Branch <= 0; 
                ALUOp = 2'b10; //BASED ON FUNCT FIELD
            end
            //STORE WORD
            6'b101011: begin
                RegDst <= 1; ALUSrc <= 1;
                MemtoReg <= 1; RegWrite <= 1;
                MemRead <= 0; MemWrite <= 1;
                Branch <= 0; 
                ALUOp = 2'b00; //ADD
            end
            //BRANCH
            6'b000100: begin
                RegDst <= 1; ALUSrc <= 0;
                MemtoReg <= 1; RegWrite <= 0;
                MemRead <= 0; MemWrite <= 0;
                Branch <= 1; 
                ALUOp <= 2'b01; //SUBTRACT
            end
            //JUMP
            default: begin
                MemWrite = 0;
                MemRead = 0;
                Jump = 1;
                Branch = 0;
                RegDst = 0;
            end
        endcase
endmodule