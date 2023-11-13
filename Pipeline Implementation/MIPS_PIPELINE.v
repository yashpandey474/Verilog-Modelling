module PIPELINE_MIPS (clock1, clock2);

    input clock1, clock2;

    reg [31: 0] PC, IF_ID_IR, IF_ID_NPC;

    reg[31: 0] ID_EX_IR, ID_EX_NPX, ID_EX_A, ID_EX_B, ID_EX_Imm;

    reg[2: 0] ID_EX_type, EX_MEM_type, MEM_WB_type;

    reg[31: 0] EX_MEM_IR, EX_MEM_ALUOut, EX_MEM_B;

    reg EX_MEM_cond;

    reg [31: 0] MEM_WB_IR, MEM_WB_ALUOut, MEM_WB_LMD;

    reg [31: 0] RegisterFile [0: 31] // 32 X 32 REGISTER FILE
    reg [31: 0] Memory [0: 1023] //1024 X32 MEMORY

    //OPCODES FOR INSTRUCTIONS [6 BITS]
    parameter ADD = 6'd0, SUB = 6'd1, AND = 6'd2, OR = 6'd3, SLT = 6'd4;

    //TYPE OF INSTRUCTION
    parameter RR_ALU = 3'b000, RM_ALU = 3'b001, LOAD = 3'b010, STORE = 3'b011, BRANCH = 3'b100, HALT = 3'b101;

    reg HALTED; //SET AFTER HLT COMPLETE TO DISABLE WRITES

    reg BRANCH_TAKEN; //DISABLE INSTRUCTIONS ALREADY IN PIPELINE WHEN A BRANCH IS TAKEN


    //INSTRUCTION FETCH STAGE
    always @ (posedge clock1)
    begin
        if (HALTED == 0)
        begin
            if(
                ((EX_MEM_IR[31: 26] == BEQZ) && (EX_MEM_cond == 1))
                ||
                ((EX_MEM_IR[31: 26] == BNEQZ) && (EX_MEM_cond == 0))
            )
            begin
                IF_ID_IR  <= #2 Memory[EX_MEM_ALUOut];
                BRANCH_TAKEN <= #2 1'b1;
                IF_ID_NPC <= #2 EX_MEM_ALUOut + 1;
                PC <= #2 EX_MEM_ALUOut + 1;
            end

            else begin
                IF_ID_IR <= #2 Mem[PC];
                IF_ID_NPC <= #2 PC + 1;
                PC <= #2 PC + 1;
            end
        end    
    end
        //INSTRUCTION DECODE STAGE (ID)
        always @ (posedge clock2)
        begin
            if (HALTED == 0)
            begin
                //IF ONE OF THE REGISTERS IS R0; JUST GET 0
                if (IF_ID_IR[25: 21] == 5'd0) ID_EX_A <= 0;
                else ID_EX_A <= #2 RegisterFile[IF_ID_IR[25: 21]];

                if (IF_ID_IR[20: 16] == 5'd0) ID_EX_B <= 0;
                else ID_EX_B <= #2 RegisterFile[IF_ID_IR[20: 16]];


                //CARRY FORWARD THE NEXT PC
                ID_EX_NPC <= #2 IF_ID_NPC;
                //CARRY FORWARD THE FETCHED INSTRUCTION
                IF_EX_IR <= #2 IF_ID_IR;
                //SIGN EXTEND THE OFFSET
                ID_EX_Imm <= #2 {{16{IF_ID_IR[15]}},{IF_ID_IR[15: 0]}};
            
                // "DECODE" THE INSTRUCTION
                case (IF_ID_IR[31: 26])
                ADD, SUB, AND, OR, SLT, MUL: ID_EX_type <= #2 RR_ALU;
                LW: ID_EX_type <= #2 LOAD;
                SW: ID_EX_type <= #2 STORE;
                BNEQZ, BEQZ: ID_EX_type <= #2 BRANCH;
                default: ID_EX_type <= #2 HALT;
                endcase
            end
        end

        //EX STAGE
        always @ (posedge clock1)
        begin
            if (HALTED == 0)
            begin
                EX_MEM_type <= #2 ID_EX_type;
                EX_MEM_IR <= #2 ID_EX_IR;
                //ONLY 2 DELAYS [WAS SET IN IF]
                BRANCH_TAKEN <= #2 0;

                case (ID_EX_type)
                RR_ALU:
                    begin
                        case(ID_EX_IR[31: 25])
                            ADD: EX_MEM_ALUOut <= #2 ID_EX_A + ID_EX_B;
                            SUB: EX_MEM_ALUOut <= #2 ID_EX_A - ID_EX_B;
                            AND: EX_MEM_ALUOut <= #2 ID_EX_A &  ID_EX_B;
                            OR: EX_MEM_ALUOut <= #2 ID_EX_A | ID_EX_B;
                            SLT: EX_MEM_ALUOut <= #2 ID_EX_A <  ID_EX_B;
                            MUL: EX_MEM_ALUOut <= #2 ID_EX_A * ID_EX_B;
                            default: EX_MEM_ALUOut <= #2 32'hxxxxxxxx;
                        endcase
                    end

                LOAD, STORE:
                    begin
                        EX_MEM_ALUOut <= #2 ID_EX_A + ID_EX_Imm;
                        EX_MEM_B <= #2 ID_EX_B;
                    end

                BRANCH: 
                    begin
                        EX_MEM_ALUOut <= #2 ID_EX_NPC + ID_EX_Imm;
                        EX_MEM_cond <= #2 (ID_EX_A == 0);
                    end
                endcase
        end
        end

        //MEMORY STAGE
        always @ (posedge clock2)
        begin
            if (HALTED == 0)
            begin
                MEM_WB_type <= EX_MEM_type;
                MEM_WB_IR <= #2 EX_MEM_IR;

                case (EX_MEM_type)
                    RR_ALU: MEM_WB_ALUOut <= #2 EX_MEM_ALUOUT;
                    LOAD: MEM_WB_LMD <= #2  Memory[EX_MEM_ALUOUT];
                    STORE: if (BRANCH_TAKEN == 0) Memory[EX_MEM_ALUOUT] <= #2 EX_MEM_B;
                endcase
            end
        end

        //WRITE BACK STAGE
        always @(posedge clock1)
        begin
            if (BRANCH_TAKEN == 0)
            case(MEM_WB_type)
                RR_ALU: RegisterFile[MEM_WB_IR[15: 11]] <= #2 MEM_WB_ALUOut; 
                LOAD: RegisterFile[MEM_WB_IR[20: 16]] <=  #2 MEM_WB_LMD;
                HALT: HALTED <= #2 1'b1;
            endcase
        end
    
endmodule
