import lc3b_types::*;

module mp0
(
    input clk,

    /* Memory signals */
    input mem_resp,
    input lc3b_word mem_rdata,
    output mem_read,
    output mem_write,
    output lc3b_mem_wmask mem_byte_enable,
    output lc3b_word mem_address,
    output lc3b_word mem_wdata
);

/* Instantiate MP 0 top level blocks here */
logic pcmux_sel, load_pc, storemux_sel, load_ir, load_regfile, alumux_sel, load_mar, load_mdr, marmux_sel, mdrmux_sel, load_cc, regfilemux_sel, branch_enable;
lc3b_aluop aluop;
lc3b_opcode opcode;

datapath datapath
(
	.clk(clk),
	.pcmux_sel(pcmux_sel),
	.load_pc(load_pc),
	.load_ir(load_ir),
	.load_regfile(load_regfile),
	.load_mar(load_mar),
	.load_mdr(load_mdr),
	.load_cc(load_cc),
	.storemux_sel(storemux_sel),
	.alumux_sel(alumux_sel),
	.regfilemux_sel(regfilemux_sel),
	.marmux_sel(marmux_sel),
	.mdrmux_sel(mdrmux_sel),
	.aluop(aluop),
	.opcode(opcode),
	.branch_enable(branch_enable),
	.mem_rdata(mem_rdata),
	.mem_address(mem_address),
	.mem_wdata(mem_wdata)
);

control cpu
(
	 .clk(clk),
    .opcode(opcode),
	 .branch_enable(branch_enable),
	 .load_pc(load_pc),
	 .load_ir(load_ir),
	 .load_regfile(load_regfile),
	 .load_mar(load_mar),
	 .load_mdr(load_mdr),
	 .load_cc(load_cc),
	 .pcmux_sel(pcmux_sel),
	 .storemux_sel(storemux_sel),
	 .alumux_sel(alumux_sel),
	 .regfilemux_sel(regfilemux_sel),
	 .marmux_sel(marmux_sel),
	 .mdrmux_sel(mdrmux_sel),
	 .aluop(aluop),
	 .mem_resp(mem_resp),
	 .mem_read(mem_read),
	 .mem_write(mem_write),
	 .mem_byte_enable(mem_byte_enable)
);
endmodule : mp0
