//ANOTHER SEQ LOGIC EXAMPLE (?)

module incomp_state_spec (curr_state, flag)
    input [0: 1]  curr_state;
    output reg [0: 1] flag;

    always @ (curr_state)
    begin
        //NOW; FOR UNSPEC. VALUES; FLAG = 0
        //COMBIINATIONAL CIRCUIT
        flag = 0
        case (curr_state)
            2'b0, 2'b01: flag = 2'b10;
            2'b11   : flag = 2'b0;
        //VAL 2 MISSING => FLAG WILL NOT CHANGE
        //HENCE, SEQUENTIAL CIRCUIT.
        endcase
    end
endmodule