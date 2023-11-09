//32 x 32 reg file
module REGFILE_v2 (
    rdData1, rdData2, wrData, rdReg1,
    rdReg2, wrReg, write, clock,
    reset
);
    //PORT DECLARATIONS
    input [4: 0] rdReg1, rdReg2, wrReg;

    output [31: 0] rdData1, rdData2;

    input [31: 0] wrData;
    
    integer k; 

    input write, reset, clock;

    //REGIISTER BANK: 32 BITS EACH AND 32 REGISTERS
    reg [31: 0] regfile [0: 31];

    //BEHAVIOURAL
    assign rdData1 = regfile [rdReg1];
    assign rdData2 = regfile [rdReg2];

    always @ (posedge clock)
        if (reset) begin
            for (k = 0; k<32; k = k + 1) begin
                regfile[k] <= 32'b0;
            end
        end
        else begin
            if (write) regfile[wrReg] <= wrData;
        end
endmodule

module regfile_test;
    reg [4: 0] rdReg1, rdReg2, wrReg;
    reg [31: 0] wrData;

    reg write, reset, clock;
    wire [31: 0] rdData1, rdData2;

    integer k;

    REGFILE_v2 RF (rdData1, rdData2, wrData, 
    rdReg1, rdReg2, wrReg, write, clock, reset);

    //SET CLOCK TO 0
    initial clock = 0;

    //CLOCK ALWAYS BLOCK
    always #5 clock = ~clock;

    //RESET REGISTERS
    initial begin
        #1 reset = 1; write = 0;
        #5 reset = 0;
    end

    initial begin
        #7
        for (k = 0; k<32; k = k + 1)
        begin
            wrReg = k; wrData = 10 * k;
            write = 1;
        #10 write = 0;
        end

        #20 
        for (k = 0; k < 32; k = k  + 2)
        begin
            rdReg1 = k; rdReg2 = 32 - k;
            #5
            $display ("reg[%2d] = %d, reg[%2d] = %d",rdReg1, rdData1, rdReg2, rdData2);
        end

        #2000 $finish;
    end
endmodule