module program_counter(
    input [9:0] din,
    input clk,
    input en,
    input sync_rst,
    input jmp,
    output [9:0] dout
);

reg [9:0] pc;
always_ff @(posedge clk) begin
    if(en && !sync_rst) begin
        if(jmp) begin
            pc <= din;
        end
        if(!jmp) begin
            pc <= pc + 2;
    end
    if(sync_rst) begin
        pc <= 0;
    end
end
end

assign dout = pc;

endmodule : program_counter
