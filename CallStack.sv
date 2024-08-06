module CallStack(
    input [9:0] din,
    input clk,
    input en,
    input sel,
    output [9:0] dout
);

reg [10:0] cscell [15:0];
reg [3:0] cspoint;

always_ff @(posedge clk) begin
    if(en && sel) begin
        cscell[cspoint] <= din;
        cspoint <= cspoint + 1;
    end
    if(en && !sel) begin
        cspoint <= cspoint - 1;
    end
end

assign dout = cscell[cspoint];

endmodule : CallStack
