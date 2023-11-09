module DATA_MEMORY(
    address,
    read,
    write,
    writeData,
    readData
    clock
);  
    //REGISTERS FOR MEMORY
    reg [31: 0] memory [31: 0];
    //ADDRESS LINES
    input [4: 0] address;
    //SIGNALS
    input read, write, clock;
    //DATA TO WRITE INTO MEMORY
    input [31: 0] writeData;
    //DATA TO READ FROM MEMORY
    output [31: 0] readData;

    assign readData = read ? memory[address]:32'hxxxxxxxx;
    always @ (posedge clock)
    begin
        if (read) readData <= memory[address];
        if (write) memory[address] = writeData;
    end
endmodule
    
