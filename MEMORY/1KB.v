module memory_model();
//EACH ENTRY => 8 BITS
//TOTAL ENTRIES => 1024 
    reg [7: 0] mem [0: 1023];

    initial begin
        mem[0] = 8'b01001101;
        mem[4] = 8'b00000000;
    end
endmodule
