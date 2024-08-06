module toplevel(
    input halt,
    input clk,
    input start,
    input [7:0] din_bus,
    input [15:0] inst_bus,
    output [7:0] dout_bus,
    output [7:0] mem_addr_bus,
    output [9:0] inst_addr_bus,
    output we,
    output clk_out
);

wire dp_fout;
reg enable;
always_ff @(posedge clk) begin
    if(start) begin
        enable <= 1;
    end
    if(cu_control_lines[13] || halt) begin
        enable <= 0;
    end
end

assign clk_out = clk;
datapath dp(
    .clk(clk),
    .load_bus(din_bus),
    .inst_bus(inst_bus),
    .store_bus(dout_bus),
    .mem_addr_bus(mem_addr_bus),
    .inst_addr_bus(inst_addr_bus),
    .flag_out(dp_fout),
    .cs_en(cu_control_lines[0]),
    .cs_sel(cu_control_lines[1]),
    .flags_we(cu_control_lines[2]),
    .flags_sel(inst_bus[11:10]),
    .pc_in_sel(cu_control_lines[3]),
    .pc_en(enable),
    .pc_sync_rst(cu_control_lines[13] || halt),
    .pc_jmp(cu_control_lines[5]),
    .rb_a_we(cu_control_lines[6]),
    .rb_b_we(cu_control_lines[7]),
    .rb_c_we(cu_control_lines[8]),
    .alu_b_sel(cu_control_lines[9]),
    .reg_in_sel(cu_control_lines[11:10])

);

logic [13:0] cu_control_lines;
logic [13:0] intermediate_control_lines;

always_comb begin
    case(enable)
    1'b0: cu_control_lines = 0;
    1'b1: cu_control_lines = intermediate_control_lines;
    endcase
end

ControlUnit cu(
    .opcode(inst_bus[15:12]),
    .control_lines(intermediate_control_lines),
    .flag_in(dp_fout)
);

assign we = cu_control_lines[13];

endmodule : toplevel