module INSTRUCTION_MEMORY(
    address, data_out, clock
);

    reg [31: 0] memory [31: 0];
    input [4: 0] address;
    output [31: 0] data_out;
    integer k;
    initial begin
        for (k = 0; k < 32; k = k + 1);
            memory[k] = (k * k) % 32;
    end

    always @ (posedge clock)
        data_out <= memory[address]

endmodule