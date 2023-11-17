module D_FLIP_FLOP (input clock,
 input reset, input d, output reg q);

    always @ (negedge clock)
    begin
        if (reset) q <= 1'b0;
        else q <= d;
    end
endmodule

module D_FLIP_FLOP_REGFILE_REGISTER (input clock,
input reset, input init_value1b, input regWrite, input deOut1b,
input d, output reg q);
    always @ (negedge clock)
    begin
        if (reset) q <= init_value1b;
        else begin
            if (regWrite && decOut1b == 1) q = d; 
        end
    end
endmodule

module pipelineReg16b(input clock, input reset, input [15: 0] regIn, output [15: 0] regOut);
    genvar j;
    generate for (j = 0; j < 16; j = j  + 1) begin: PIPELINE_REG_LOOP
    end
    endgenerate
endmodule

module registerFile( input clk, input reset, 
input [31:0] init_reg0, input [31:0] init_reg1,
 input [31:0] init_reg2, input [31:0] init_reg3,
  input [31:0] init_reg4, input [31:0] init_reg5,
   input [31:0] init_reg6, input [31:0] init_reg7,
    input [2:0] rs1, input [2:0] rs2, input [2:0] rs3,
     input [2:0] ds1, input regWrite, input [31:0] wData,
      output [31:0] RD1, output [31:0] RD2, output [31:0] RD3);

    //INITIALISE 8 X 32b REGISTERS
    register32bit REG0(
            clk, reset, 
            init_reg0, regWrite,
            decOut1b, wData,
            outBus0
    );
    end
    endgenerate
endmodule

module decoder3to8(input [2:0] destReg,
 output reg [7:0] decOut);
    always @ (*)
    begin
        case(destReg)
        0: decOut <= 8'b00000001;
        1: decOut <= 8'b00000010;
        2: decOut <= 8'b00000100;
        3: decOut <= 8'b00001000;
        4: decOut <= 8'b00010000;
        5: decOut <= 8'b00100000;
        6: decOut <= 8'b01000000;
        7: decOut <= 8'b10000000;
        default: decOut <= 8'h00;
    end
endmodule


module register32bit(
    input clk, input reset, 
input [31:0] init_value, input regWrite,
input decOut1b, input [31:0] writeData,
output [31:0] outBus);

endmodule

