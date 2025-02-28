import rv32i_types::*;

module datapath
(
    input clk,

    /* control signals */
    input logic [1:0] pcmux_sel,
    input logic load_pc,
	 input logic cmpmux_sel,
	 input logic load_ir,
	 input logic load_regfile,
	 input logic load_mar,
	 input logic load_mdr,
	 input logic load_data_out,
	 input logic alumux1_sel,
	 input logic [1:0] memdatamux_sel,
	 input logic [2:0] alumux2_sel,
	 input logic [2:0] regfilemux_sel,
	 input logic marmux_sel,
	 input alu_ops aluop,
	 input rv32i_word mem_rdata,
	 input branch_funct3_t cmpop,
	 output rv32i_word mem_address,
	 output rv32i_word mem_wdata,
	 output rv32i_opcode opcode,
	 output logic [2:0] funct3,
	 output logic [6:0] funct7,
//	 output logic bit30,
	 output logic br_en
    /* declare more ports here */
);

/* declare internal signals */
rv32i_word pcmux_out;
rv32i_word pc_out;
rv32i_word alu_out;
//rv32i_word mdr_out;
rv32i_word pc_plus4_out;
rv32i_word rs1_out, rs2_out, i_imm, cmpmux_out; //For the cmpmux
rv32i_reg rs1, rs2, rd;
rv32i_word u_imm, b_imm, s_imm, j_imm;
rv32i_word alumux1_out, alumux2_out, regfilemux_out, marmux_out;
rv32i_word mdrreg_out;
rv32i_word memdatamux_out;


/*
 * PC
 */
mux4 pcmux
(
    .sel(pcmux_sel),
    .a(pc_plus4_out),
    .b(alu_out),
	 .c({alu_out[31:1], 1'b0}),
	 .d(32'b0),
    .f(pcmux_out)
);

pc_register pc
(
    .clk,
    .load(load_pc),
    .in(pcmux_out),
    .out(pc_out)
);

plus4 pc_plus4
(
	.in(pc_out),
	.out(pc_plus4_out)
);

/*
*	CMPMUX
*/
mux2 #(.width(32)) cmpmux
(
	.sel(cmpmux_sel),
	.a(rs2_out),
	.b(i_imm),
	.f(cmpmux_out)
);

/*
*	ALU MUXES
*/
mux2 #(.width(32)) alumux1
(
	.sel(alumux1_sel),
	.a(rs1_out),
	.b(pc_out),
	.f(alumux1_out)
);

mux8 #(.width(32)) alumux2
(
	.sel(alumux2_sel),
	.a(i_imm),
	.b(u_imm),
	.c(b_imm),
	.d(s_imm),
	.e(j_imm),
	.f(32'b00000000000000000000000000000100),
	.g(rs2_out),
	.h(32'b0),
	.out(alumux2_out)
);

/*
*	IR
*/
ir IR
(
	.clk(clk),
   .load(load_ir),
   .in(mdrreg_out),
   .funct3(funct3),
   .funct7(funct7),
   .opcode(opcode),
   .i_imm(i_imm),
   .s_imm(s_imm),
   .b_imm(b_imm),
   .u_imm(u_imm),
   .j_imm(j_imm),
   .rs1(rs1),
   .rs2(rs2),
   .rd(rd)
);

/*
*	REGFILE
*/

regfile regfile
(
	.clk(clk),
   .load(load_regfile),
   .in(regfilemux_out),
   .src_a(rs1), 
	.src_b(rs2), 
	.dest(rd),
   .reg_a(rs1_out), 
	.reg_b(rs2_out)
);

mux8 regfilemux
(
	.sel(regfilemux_sel),
	.a(alu_out),
	.b({31'b0000000000000000000000000000000,br_en}),
	.c(u_imm),
	.d(mdrreg_out),
	.e(32'($signed(mdrreg_out[15:0]))), //16 bits SIGNED
	.f(32'($signed(mdrreg_out[7:0]))),	//8 bits SIGNED
	.g({16'b0, mdrreg_out[15:0]}),				//16 bits UNSIGNED
	.h({24'b0, mdrreg_out[7:0]}),				//8 bits UNSIGNED
	.out(regfilemux_out)
);

mux2 marmux
(
	.sel(marmux_sel),
	.a(pc_out),
	.b(alu_out),
	.f(marmux_out)
);

register mdr
(
	 .clk(clk),
    .load(load_mdr),
    .in(mem_rdata),
    .out(mdrreg_out)
);

register mar
(
	.clk(clk),
	.load(load_mar),
	.in(marmux_out),
	.out(mem_address)
);

alu alu
(
	 .aluop(aluop),
    .a(alumux1_out), 
	 .b(alumux2_out),
    .f(alu_out)
);

register mem_data_out
(
	.clk(clk),
	.load(load_data_out),
	.in(memdatamux_out),
	.out(mem_wdata)
);

mux4 mem_data_mux
(
	.sel(memdatamux_sel),
	.a(rs2_out), //32 bits
	.b({16'b0, rs2_out[15:0]}), //Unsigned 16-bits
	.c({24'b0, rs2_out[7:0]}), //Unsigned 8 bits
	.d(32'b0),
	.f(memdatamux_out)
);

cmp cmp
(
	.cmpop(cmpop),
	.a(rs1_out),	
	.b(cmpmux_out),
	.out(br_en)
);


endmodule : datapath
