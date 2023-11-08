//ROM / EPROM

module rom (addr, data, rd_en, cs);

    input [2: 0] addr;
    input rd_en, cs;

    output reg [7: 0] data;

    always @ (addr or rd_en or cs)
        case(addr)
            0: data = 22;
            1: data = 45;
            2: data = 33;
            7: data = 12;
            default: data = 0;
        endcase
endmodule