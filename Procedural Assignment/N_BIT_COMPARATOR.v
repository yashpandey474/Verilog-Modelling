module nbit_comparator(A, B, lt, gt, eq);

    parameter word_size = 16;
    input [word_size - 1: 0] A, B;
    //REG => HAVE TO CHANGE IN ALWAYS 
    output reg lt, gt, eq;

    always @ (*)
    begin
        gt = 0; lt = 0; eq = 0;
        if (A > B) gt = 1;
        else if (A < B) lt = 1;
        else eq = 1;
    end
endmodule