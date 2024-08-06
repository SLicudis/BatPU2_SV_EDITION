module regfile(
    input wire [7:0] din,
    input wire [3:0] asel,
    input wire [3:0] bsel,
    input wire [3:0] csel,
    input wire clk,
    input wire b_we,
    input wire c_we,
    input wire a_we,
    output logic [7:0] aout,
    output logic [7:0] bout
);

reg [7:0] memreg [15:1];
always_ff @(posedge clk) begin
    if(a_we) begin
        memreg[asel] <= din;
    end
    if(b_we) begin
        memreg[bsel] <= din;
    end
    if(c_we) begin
        memreg[csel] <= din;
    end
end

always_comb begin
    case(asel)
    4'b0000: aout = 0;
    default: aout = memreg[asel];
    endcase
    case(bsel)
    4'b0000: bout = 0;
    default: bout = memreg[bsel];
    endcase
end

endmodule : regfile
