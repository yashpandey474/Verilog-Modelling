module TEST_MIPS_1;
     reg clock1, clock2;
     integer k;


     PIPELINE_MIPS (clock1, clock2);

     initial 
     begin
        clock1 = 0; clock2 = 0;
        repeat (20)
        begin
            35 clock1 = 1; #5 clock1 = 0;
            #5 clock2 = 1; #5 clock2 = 0;
        end
     end

     initial begin
        for (k = 0; k<31; k = k + 1)
            PIPELINE_MIPS.RegisterFile[k] = k;

        PIPELINE_MIPS.Memory[0] = 32'h2801000A;
        PIPELINE_MIPS.Memory[1] = 32'h28020014;
        PIPELINE_MIPS.Memory[2] = 32'h28030019;

        PIPELINE_MIPS.HALTED = 0;
        PIPELINE_MIPS.PC = 0;
        PIPELINE_MIPS.BRANCH_TAKEN = 0;
    
        #280
        for (k = 0; k < 6; k = k + 1)
            $display("R%1d = %2d", k, PIPELINE_MIPS.RegisterFile[k]);
     end

    
endmodule