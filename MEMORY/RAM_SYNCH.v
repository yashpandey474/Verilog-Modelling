//SINGLE PORT RAM WITH SYNCHRONOUS READ/WRITE
module ram_1 (addr, data, clock, read, write, cs);
    //ADDRESS LINES
    input [9: 0] addr;

    //TO READ OR WRITE SIGNALS  & CHIP SELECT
    input clock, read, write, cs;

    //BIDRECTIONAL DATA
    inout [7: 0] data;

    reg [7: 0] mem [1023 : 0];
    reg [7: 0] dataout;

    assign data = (cs && read) ?  dataout: 8'bz;

    always @ (posedge clock)
        if (cs && write && !read) mem[addr] = data;

    //CANNOT HAVE AN INOUT IN AN ALWAYS BLOCK
    always @ (posedge clock)
        if (cs && read && !write) dataout = mem[addr];
endmodule
