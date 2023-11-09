`include "REG_5BIT.v"
`include "INSTRUCTION_MEMORY.v"
`include "DATA_MEMORY.v"
`include "CONTROL_SINGLE_CYCLE.v"
module SINGLE_CYCLE_datapath(
    clock, PC
);
    //CLOCK INPUT
    input clock;
    //PC INPUT
    input [4: 0] PC;
    //CURRENT PC OUTPUT & ALUOUTPUT
    wire [4: 0] PCOut, ALUOut;
    //INSTRUCTION READ FROM IM & OUTPUT OF MEMORY
    wire [31: 0] Instruction, MemOut;
    //OUTPUT OF REG-FILE
    wire [31: 0] Rs, Rt;
    //CONTROL SIGNALS
    wire [1: 0] ALUOp;
    wire [2: 0] ALUControl;
    wire  RegDst, Jump, Branch;
    wire MemRead, MemtoReg, ALUOp;
    wire MemWrite, ALUSrc, RegWrite;


    REGISTER_5bit PC (
        PCOut, PCInput, PCWrite, clock
    );

    INSTRUCTION_MEMORY IM (
        PCOut, Instruction, clock
    );

    DATA_MEMORY DM(
        MemAddress, MemRead,
        MemWrite, ALUOut,
        MemOut, clock
    );

    SINGLE_CYCLE_control CON(
    Instruction [31: 26],
    RegDst, Jump, Branch,
    MemRead, MemtoReg, ALUOp,
    MemWrite, ALUSrc, RegWrite
    );

    ALU_Control ALUCON(
        Instruction [5: 0],
        ALUOp,
        ALUControl
    );

    REGISTER_FILE RF(
        Instruction[25: 21],
        Instruction[20: 16],
        //VALUES READ FROM RF
        Rs, Rt,
        WriteReg,
        WriteDataRF,RegWrite, clock
    );

    ALU alu (
        ALUOut, Rs, ALUInput2,
        ALUControl
    );

    //INSTANTIATE ALL MUXES
    MUX2TO1 ALUINPUTMUX (
        ALUInput2,
        Rt, SignExtendedOffset,
        ALUSrc
    );

    MUX2TO1_5bit REGDSTMUX (
        WriteReg,
        Instruction[20: 16],
        Instruction[15: 11],
        RegDst
    );

    MUX2TO1 MEMTOREGMUX (
        WriteDataRF,
        ALUOut,
        MemOut,
        MemtoReg
    );

    MUX2TO1 PWRITEMUX (
        PCI
    )





endmodule