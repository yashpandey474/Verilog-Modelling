//4 x 32 REGISTERS
module REGFILE_v1 (
    rdData1, rdData2, wrData,
    rdreg1, rdreg2, wrreg, write, clock
);
    //2 BIT SELECT
    input [1: 0] rdreg1, rdreg2, wrreg;

    //32 BIT DATA
    input [31: 0] wrData;

    //32 BIT OUTPUTS
    output reg [31: 0] rdData1, rdData2;

    //SIGNALS
    input write, clock;

    //4 REGISTERS; EACH OF 32 BITS
    reg [31: 0] regBank [3: 0]

    //1. READ ALWAYS BLOCK - 1
    always @ (*)
        case(rdreg1)
        0: rdData1 <= regBank[0]
        1: rdData1 <= regBank[1]
        2: rdData1 <= regBank[2]
        3: rdData1 <= regBank[3]
        default: rdData1 <= 32'hxxxxxxxx;
        endcase

    //2. READ ALWAYS BLOCK - 2
    always @ (*)
        case(rdreg2)
        0: rdData2 <= regBank[0]
        1: rdData2 <= regBank[1]
        2: rdData2 <= regBank[2]
        3: rdData2 <= regBank[3]

        //DEFAULT
        default: rdData2 <= 32'hxxxxxxxx;
        endcase

    //3. WRITE ALWAYS BLOCK [SYNCH. WITH CLOCK]
    always @ (posedge clock)
    begin
        if (write)
        case(wrreg)
        0: regBank[0] <= wrData
        1: regBank[1] <= wrData
        2: regBank[2] <= wrData
        3: regBank[3] <= wrData
        default: rdData2 <= 32'hxxxxxxxx;
        endcase
    end
endmodule