module ControlUnit(
    input [3:0] opcode,
    input flag_in,
    output logic [13:0] control_lines
);

//0 = cs_en
//1 = cs_sel
//2 = flags_we
//3 = pc_in_sel
//4 = pc_sync_rst
//5 = pc_jmp
//6 = rb_a_we
//7 = rb_b_we
//8 = rb_c_we
//9 = alu_b_sel
//10-11 = reg_in_sel (ALU, IMM, MEM)
//12 = mem_we
//13 = hlt


wire [3:0] decoded_inst;

always_comb begin
    case(opcode)
    4'b0000: control_lines = 0; //NOP
    4'b0001: control_lines = 14'b1000000010000; //HLT
    4'b0010, 4'b0011, 4'b0100, 4'b0101, 4'b0110, 4'b0111: control_lines = 14'b00000100000100; //ALU
    4'b1000: control_lines = 14'b00010001000000; //LDI
    4'b1001: control_lines = 14'b00001000000100; //ADI
    4'b1010: control_lines = 14'b00000000100000; //JMP
    4'b1011: control_lines = {8'h00, flag_in, 5'h00}; //BRH
    4'b1100: control_lines = 14'b00000000100001; //CAL
    4'b1101: control_lines = 14'b00000000101011; //RET
    4'b1110: control_lines = 14'b00100010000000; //LOD
    4'b1111: control_lines = 14'b01000000000000; //STR
    endcase
end

endmodule : ControlUnit
