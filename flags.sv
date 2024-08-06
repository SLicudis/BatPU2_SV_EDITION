module flags(
    input [1:0] din,
    input clk,
    input we,
    input [1:0] sel,
    output logic flag_out
);

reg [1:0] flag;
always_ff @(posedge clk) begin
    if(we) begin
        flag <= din;
    end
end

always_comb begin
    case(sel)
    2'b00: flag_out = flag[0];
    2'b01: flag_out = flag[1];
    2'b10: flag_out = !(flag[0]);
    2'b11: flag_out = !(flag[1]);
    endcase
end

endmodule : flags
