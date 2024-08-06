module datapath(
    input clk,
    input logic [15:0] inst_bus,
    input logic [7:0] load_bus,
    input cs_en,
    input cs_sel,
    input flags_we,
    input flags_sel,
    input pc_in_sel,
    input pc_en,
    input pc_sync_rst,
    input pc_jmp,
    input rb_a_we,
    input rb_b_we,
    input rb_c_we,
    input alu_b_sel,
    input logic [1:0] reg_in_sel,
    output [7:0] store_bus,
    output [7:0] mem_addr_bus,
    output [9:0] inst_addr_bus,
    output flag_out
);

logic [7:0] reg_aout;
logic [7:0] reg_bout;
logic [1:0] alu_fout;
logic [7:0] alu_b;
logic [2:0] alu_op;
logic [7:0] reg_din;
logic [7:0] alu_res;

regfile RF(
    .din(reg_din),
    .aout(reg_aout),
    .bout(reg_bout),
    .asel(inst_bus[11:8]),
    .bsel(inst_bus[7:4]),
    .csel(inst_bus[3:0]),
    .a_we(rb_a_we),
    .b_we(rb_b_we),
    .c_we(rb_c_we),
    .clk(clk)
);

ALU ALU_inst(
    .result(alu_res),
    .a(reg_aout),
    .b(alu_b),
    .op(alu_op),
    .cout(alu_fout[1]),
    .zero(alu_fout[0])
);


flags flag_inst(
    .flag_out(flag_out),
    .din(alu_fout),
    .we(flags_we),
    .sel(flags_sel),
    .clk(clk)
);

always_comb begin
    case(alu_b_sel)
    1'b0: alu_b = reg_bout;
    1'b1: alu_b = inst_bus[7:0];
    endcase
end


always_comb begin
    case(inst_bus[15:12])
    4'b0010: alu_op = 0;
    4'b0011: alu_op = 1;
    4'b0100: alu_op = 2;
    4'b0101: alu_op = 3;
    4'b0110: alu_op = 4;
    4'b0111: alu_op = 5;
    default: alu_op = 0;
    endcase
end

always_comb begin
    case(reg_in_sel)
    2'b00: reg_din = alu_res; 
    2'b01: reg_din = inst_bus[7:0];
    2'b10: reg_din = load_bus[7:0];
    default: reg_din = 0;
    endcase
end

logic [9:0] pc_in;
logic [9:0] cs_stack_out;
always_comb begin
    case(pc_in_sel)
    1'b0: pc_in = inst_bus[9:0];
    1'b1: pc_in = cs_stack_out;
    endcase
end

program_counter PC(
    .en(pc_en),
    .din(pc_in),
    .dout(inst_addr_bus),
    .clk(clk),
    .jmp(pc_jmp),
    .sync_rst(pc_sync_rst)
);

CallStack C_Stack(
    .din(inst_addr_bus),
    .clk(clk),
    .en(cs_en),
    .sel(cs_sel),
    .dout(cs_stack_out)
);

assign store_bus = reg_bout;
assign mem_addr_bus = reg_aout + {{4{inst_bus[3]}}, inst_bus[3:0]};

endmodule : datapath
