module MULTICYCLE_CONTROL(
    clock,
    ALUSrcA, ALUSrcB, ALUOp,
    MemRead, MemWrite, PCSource, PCWrite,
    IorD, RegDst, RegWrite, PCWriteCond,
    MemtoReg, Op
);
    input clock;
    input [5: 0] Op;
    output[1: 0] ALUSrcB, ALUOp, PCSource;
    output MemRead, MemWrite, ALUSrcA;
    output PCWrite,IorD, RegDst, RegWrite;
    output PCWriteCond, MemtoReg;

    //REGISTER TO HOLD STATE
    reg [3: 0] state;

    //DEFINE PARAMETERS FOR DIFFERENT STATES
    parameter S0 = 4'd0, S1 = 4'd1, S2 = 4'd2, S3 = 4'd3, S4 = 4'd4, S5 = 4'd5, S6 = 4'd6, S7 = 4'd7, S8 = 4'd8, S9 = 4'd9;

    //DEFINE PARAMETERS FOR INSTR. TYPE
    parameter LW = 6'd0, SW = 6'd1, RTYPE = 6'd2, BRANCH = 6'd3, JUMP = 6'd4;

    //STATE ALWAYS BLOCK
    always @ (posedge clock)
        case(state)
            S0: state <= S1;
            S1: begin
                case(Op)
                    LW: state <= S2;
                    SW: state <= S2;
                    RTYPE: state <= S3;
                    BRANCH: state <= S4;
                    JUMP: state <= S5;
                endcase
            end
            S2: case(Op)
                LW: state <= S6;
                SW: state <= S7;
            endcase
            S3: state <= S8;
            S6: state <= S9;
            default: state <= S0;
        endcase

    //CONTROL SIGNALS ALWAYS BLOCK
    always @ (state)
        case(state)
            S0: begin MemRead = 1; ALUSrcA = 0;
            IorD = 0; IRWrite = 1; ALUSrcB = 2'b01;
            ALUOp = 2'b00; PCWrite = 1; PCSource = 2'b00;
            end
            S1: begin
                ALUSrcA = 0; ALUSrcB = 2'b11; ALUOp = 00;
            end
            S2: begin
                ALUSrcA = 1; ALUSrcB = 2'b10; ALUOp = 2'b00;
            end
            S3: begin
                ALUSrcA = 1; ALUSrcB = 2'b00; ALUOp = 2'b10;
            end
            S4: begin
                ALUSrcA = 1; ALUSrcB = 2'b00; ALUOp = 2'b01;
                PCWriteCond = 1; PCSource = 2'b01;
            end
            S5: begin
                PCWrite = 1; PCSource = 2'b10;
            end
            S6: begin
                MemRead = 1; IorD = 1;
            end
            S7: begin
                MemWrite = 1;
                IorD = 1;
            end
            S8: begin
                RegDst = 1; RegWrite = 1; MemtoReg = 0;
            end
            S9: begin
                RegDst = 0; RegWrite = 1; MemtoReg = 1;
            end
        endcase

    endmodule
            
    

