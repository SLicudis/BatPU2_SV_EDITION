module ALU(
    input [7:0] a,
    input [7:0] b,
    input [2:0] op,
    input cin,
    output logic [7:0] result,
    output logic cout,
    output zero
);

always_comb begin
    case(op)
    3'b000: {cout, result} = {1'b0, a} + {1'b0, b};
    3'b001: {cout, result} = {1'b0, a} - {1'b0, b};
    3'b010: {cout, result} = {1'b0, !(a | b)};
    3'b011: {cout, result} = {1'b0, (a & b)};
    3'b100: {cout, result} = {1'b0, (a ^ b)};
    3'b101: {cout, result} = {1'b0, (a >> 1)};
    default: {cout, result} = 0;
    endcase
end

assign zero = ~(| result);

endmodule : ALU
