module ram_2 (addr,
data, rd, wr, cs);

    input [9 :0] addr;
    inout [7: 0] data;
    input rd, wr, cs;

    reg [7: 0] mem [1023: 0];
    reg [7: 0] dataout;

    assign data = (cs && rd) ? dataout: 8'bz;

    always @ (addr or data or rd or wr or cs)
        if (cs && wr && !rd) mem[addr] = data;

    always @ (addr or rd or wr or cs)
        if (cs && rd && !wr) dataout = mem[addr];
endmodule