module bcd_to_7seg (bcd, seg);

//0 TO 9
input [3: 0] bcd;

//A -> MSB. G -> LSB
output reg [6: 0] seg;

always @ (bcd)
case
    //SEGMENT GLOWS -> BIT = 0

    //GLOW ALL EXCEPT G
    0: seg = 6'b0000001;
    1: seg = 6'b1001111;
    2: seg = 6'b0010010;
    3: seg = 6'b0000110;
    4: seg = 6'b1001100;
    5: seg = 6'b0100100;
    6: seg = 6'b0100000;
    7: seg = 6'b0001111;
    8: seg = 6'b0000000;
    9: seg = 6'b0000100;

    //ALL OFF
    default: seg = 6'b1111111;
    endcase