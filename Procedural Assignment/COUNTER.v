//4BIT COUNTER
module counter (clock, reset, count);


    //ASYNCH RESET => WHENEVER ACTIVE; RESET
    input clock, reset;
    output reg [3: 0] count;

    always @ (posedge clock, posedge reset)
    begin
        if(reset)count <= 4'b0;
        else count <= count + 1;
    end 
endmodule