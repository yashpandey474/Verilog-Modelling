//IMPLEMENT A FULL ADDER USING A 3TO8 DECODER

//3TO8 DECODER USING GATE LEVEL MODEL
module DECODER(in, out);
    input [2: 0] in;
    output [7: 0] out;

    wire NZ, NX, NY;

    not N0 (in[0], NZ);
    not N1 (in[1], NY);
    not N2 (in[2], NX);

    and A0 (out[0], NX, NY, NZ);
    and A1 (out[1], NX, NY, in[0]);
    and A2 (out[2], NX, in[1], in[0]);
    and A3 (out[3], NX, in[1], in[0]);
    and A4 (out[4], in[2], NY, NZ);
    and A5 (out[5], in[2], NY, in[0]);
    and A6 (out[6], in[2], in[1], NZ);
    and A7 (out[7], in[2], in[1], in[0]);
    
endmodule

//FULL ADDER
module FADDER(x, y, z, s, c);
    input x, y, z;
    output s, c;

    wire [7: 0] decoderOut;
    DECODER DEC({x, y, z}, decoderOut);

    assign s = decoderOut[1] & decoderOut[2] & decoderOut[4] & decoderOut[7];
    assign c = decoderOut[3] & decoderOut[5] & decoderOut[6] & decoderOut[7];


endmodule