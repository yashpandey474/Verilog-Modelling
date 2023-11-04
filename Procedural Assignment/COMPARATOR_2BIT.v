module compare(A1, A0, B1, B0, lt, gt, eq);
    input A1, A0, B1, B0;
    output reg lt, gt, eq;

    always @ (*)
        begin
            lt = ({A1, A0} < {B1, B0});
            gt = ({A1, A0} > {B1, B0});
            eq = ({A1, A0} == {B1, B0});
        end

endmodule