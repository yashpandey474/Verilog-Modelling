module priority_encoder(in, code);
    input [7: 0] in;

    //REG => HAVE TO CHANGE VALUE IN ALWAYS
    output reg [2: 0] code;

    //SAY INPUT 0 HAS A HIGHE PRIORITY THAN 7

    always @ (in)
    begin
        if (in[0]) code = 3'b0;
        else if (in[1]) code = 3'd1;
        else if (in[2]) code = 3'd2;
        else if (in[3]) code = 3'd3;
        else if (in[4]) code = 3'd4;
        else if (in[5]) code = 3'd5;
        else if (in[6]) code = 3'd6;
        else if (in[7]) code = 3'd7;
        else code  = 3'bxxx;
    end
endmodule