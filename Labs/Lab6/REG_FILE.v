module REGISTER_FILE (
    readReg1, readReg2,
    readData1, readData2,
    writeReg,
    writeData, write, clock
);
    input [4: 0] readReg1, readReg2;
    input [31: 0] writeData;
    input write, clock;
    output [31: 0] readData1, readData2;

    reg [31: 0] registers [31: 0];

    initial begin
        for (k = 0; k < 32; k = k + 1)
            registers[k] = (k*k)%100;
    end
    
    assign readData1 = registers[readReg1];
    assign readData2 = registers[readReg2];

    always @ (posedge clock)
        registers[writeReg] <= writeData;

endmodule