module ram_3(data_out, data_in, addr, wr, cs);

    parameter addr_size = 10, word_size = 8, memory_Size = 1024;

    input [addr_size - 1: 0] addr;
    input [word_size - 1: 0] data_in;
    input wr, cs;

    output [wrd_size - 1: 0] data_out;
    reg [word_size - 1: 0] mem [memory_size - 1: 0];

    assign data_out = mem[addr];

    always @ (wr or cs)
    begin
        
        if (wr) mem[addr] = data_in;
    end
endmodule

module tri_state;
    tri [7: 0] Bus;
    wire [7: 0] data_out, data_in;
    assign data_in = write ? Bus: 8'bz;
    assign Bus = read ? data_out: 8'hzz;

endmodule

module RAM_test;    
    reg[ 9: 0] address;
    wire [7: 0] data_out;
    wire [7: 0] data_in;
    reg write, select;
    integer k, myseed;

    ram_3 RAM(data_out, data_in, address, write, select);

    initial
    begin
        for (k = 0; k <= 1023; k = k + 1)
        begin
            data_in = (k + k) % 256;
            read = 0;
            write = 1;
            select = 1;
            address = k;

            #2 write = 0; select = 0;
        end
        repeat( 20)
        begin
            #2 address = $random(myseed) % 1024;
            write = 0; select = 1;
            $display ("Address : %5d, Data: %4d", address,data);
        end
    end