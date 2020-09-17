import rv32i_types::*;

module pipe_datapath
(
	 input clk,

    /* Port A */
    output logic read_a,
	 output logic [31:0] address_a,
    input resp_a,
    input [31:0] rdata_a,

    /* Port B */
    output logic read_b,
    output logic write_b,
    output logic [3:0] wmask_b,
    output logic [31:0] address_b,
    output logic [31:0] wdata_b,
    input resp_b,
    input [31:0] rdata_b,

	 /* for hit/miss counter logic */
	 input logic [1:0] counter_pick_i,
	 input logic [1:0] counter_pick_d,
	 input logic [1:0] counter_pick_L2
);

// signals needed for data path connection
// IF
rv32i_word pcmux_out;
rv32i_word pc_out;
rv32i_word pc_plus_4;

// IF/ID
rv32i_control_word ctrl_id;
rv32i_word pc_id;
rv32i_reg rs1;
rv32i_reg rs2;
rv32i_reg rd;
rv32i_word i_id;
rv32i_word s_id;
rv32i_word b_id;
rv32i_word u_id;
rv32i_word j_id;
rv32i_opcode opcode;
logic [2:0] funct3;
logic [6:0] funct7;
// ID
rv32i_control_word ctrl_rom_out;
rv32i_word rs1_id;
rv32i_word rs2_id;
// ID/EX
rv32i_word pc_ex;
rv32i_control_word ctrl_ex;
rv32i_word rs1_ex;
rv32i_word rs2_ex;
rv32i_word u_ex;
rv32i_word b_ex;
rv32i_word s_ex;
rv32i_word j_ex;
rv32i_word i_ex;
rv32i_reg rd_ex;
// EX
rv32i_word alumux1_out;
rv32i_word alumux2_out;
rv32i_word alu_out;
logic cmp_out;
rv32i_word cmpmux_out;
// EX/MEM
rv32i_control_word ctrl_mem;
rv32i_word rs2_mem;
rv32i_word pc_mem;
logic br_en;
rv32i_word alu_mem;
rv32i_reg rd_mem;
rv32i_word u_mem;
// MEM
rv32i_word memdatamux_out;
// MEM/WB
rv32i_word u_wb;
rv32i_word pc_wb;
rv32i_control_word ctrl_wb;
logic resp_b_wb;
rv32i_word rdata_b_wb;
rv32i_word alu_wb;
rv32i_reg rd_wb;
rv32i_word br_en_zext;
// WB
rv32i_word wbmux_out;

logic load_pc;
logic load_if_id;
logic load_id_ex;
logic load_ex_mem;
logic load_mem_wb;

/* counters */
logic set;
logic load_count;
logic [31:0] mem_rdata_in;

logic enable_br;
logic enable_MisP;
logic enable_Stall;
logic enable_hit_i;
logic enable_miss_i;
logic enable_hit_d;
logic enable_miss_d;
logic enable_hit_L2;
logic enable_miss_L2;

logic clear_br;
logic clear_MisP;
logic clear_Stall;
logic clear_hit_i;
logic clear_miss_i;
logic clear_hit_d;
logic clear_miss_d;
logic clear_hit_L2;
logic clear_miss_L2;

logic [31:0] out_br;
logic [31:0] out_MisP;
logic [31:0] out_Stall;
logic [31:0] out_hit_i;
logic [31:0] out_miss_i;
logic [31:0] out_hit_d;
logic [31:0] out_miss_d;
logic [31:0] out_hit_L2;
logic [31:0] out_miss_L2;

/* Forwarding */

logic id_rs1mux_sel;
logic id_rs2mux_sel;
rv32i_word id_rs1mux_out;
rv32i_word id_rs2mux_out;

logic [3:0] rs1mux_sel;
logic [3:0] rs2mux_sel;
rv32i_word rs1mux_out;
rv32i_word rs2mux_out;

logic wdatamux_sel;
rv32i_word wdatamux_out;
logic stall_for_load;
logic clear_id_ex;
logic clear_ex_mem;
logic clear;

/* Early branch resolution */
rv32i_word eb_rs1mux_out;
rv32i_word eb_rs2mux_out;
rv32i_word eb_cmpmux_out;
rv32i_word eb_cmp_out;
logic [3:0] eb_rs1mux_sel, eb_rs2mux_sel;
logic eb_stall_for_load;

logic [1:0] pcmux_sel; //Select bits for pcmux
logic branch_prediction; //Our prediction from IF(T/NT)
rv32i_word target_address; //Target address going into pcmux for predictions.
logic prediction_id;
logic clear_from_ex;
logic clear_from_mem;
//logic clear_stages; //Clears stages if we mispredict.

//logic [32:0] line;

//assign line = ((pc_out - 32'h00000060)/32'h00000004);

/* Some Signal Assignments */
assign address_a = pc_out;
assign address_b = alu_mem;
assign wdata_b = memdatamux_out;
assign wmask_b = 4'b1111;
assign clear = 1'b0;

stall_load_control slc
(
	.icache_resp(resp_a),
	.dcache_resp(resp_b),
	.d_write(write_b),
	.d_read(read_b),
	.stall_for_load,
	.eb_stall_for_load,
	.ex_prediction(ctrl_ex.prediction),
	.mem_prediction(ctrl_mem.prediction),
	.pc_ex,
	.pc_mem,
	.pc_wb,
	.br_en,
	.ctrl_mem,
	.cmpout(cmp_out),
	.ex_opcode(ctrl_ex.opcode),
	.load_pc,
	.load_if_id,
	.load_id_ex,
	.load_ex_mem,
	.load_mem_wb,
	.load_count,
	.clear_ex_mem,
	.clear_id_ex
);

// IF
// read instruction from memory
pc_register pc
(
	.clk,
	.load(load_pc),
	.in(pcmux_out),
	.out(pc_out)
);

mux4 pcmux
(
	.sel(pcmux_sel),
	.a(pc_plus_4),
	.b(alu_mem),
	.c(target_address),
	.d(pc_ex + 4),
	.f(pcmux_out)
);

plus4 pc_adder
(
	.in(pc_out),
	.out(pc_plus_4)
);


//IF/ID
if_id if_id
(
	 .clk,
	 .load(load_if_id),
	 .clear(clear_from_ex || clear_from_mem),
	 .read_data_in(rdata_a),
	 .pc_in(pc_out),
	 .pc_out(pc_id),
	 .prediction_if(branch_prediction),
	 .rs1,
	 .rs2,
	 .rd,
	 .u_imm(u_id),
	 .b_imm(b_id),
	 .s_imm(s_id),
	 .j_imm(j_id),
	 .i_imm(i_id),
	 .prediction_id(prediction_id),
	 .opcode,
	 .funct3,
	 .funct7
);


// ID
control_rom control_rom
(
	.funct3,
	.funct7,
	.rs1,
	.rs2,
	.opcode,
	.prediction(prediction_id),
	.ctrl(ctrl_rom_out)
);

regfile regfile
(
	.clk,
	.load(ctrl_wb.load_regfile), // ctrl.load_regfile
	.in(wbmux_out),
	.src_a(rs1),
	.src_b(rs2),
	.dest(rd_wb),
	.reg_a(rs1_id),
	.reg_b(rs2_id)
);


//early branch resolution
//moving comparator to the id stage
mux2 cmpmux
(
	.sel(ctrl_rom_out.cmpmux_sel),
	.a(eb_rs2mux_out),
	.b(i_id),
	.f(eb_cmpmux_out)
);

cmp cmp
(
	.cmpop(ctrl_rom_out.cmpop),
	.a(eb_rs1mux_out),
	.b(eb_cmpmux_out),
	.out(eb_cmp_out[0])
);

mux16 eb_rs1mux
(
	.sel(eb_rs1mux_sel),
	.a(id_rs1mux_out), //default, nonforwarded value.
	.b(alu_out), //Forwarded alu output. EX->EX
	.c({31'b0, cmp_out}), // Forwarded cmp output. EX->EX
	.d(wbmux_out), //Forwarded rdata output (from dcache) MEM->EX
	.e(pc_ex + 4), //Forwarded PC + 4 (when jal, jalr are previous instr) EX->EX
	.f(u_ex), //Forwarded u_imm (when LUI is previous instruction). EX->EX.
	.g(mem_rdata_in), //Forwarded rdata
	.h(alu_mem), //Forwarding MEM->EX (non-load values), same order as above
	.i({31'b0, br_en}),
	.j(pc_mem + 4),
	.k(u_mem),
	.l(32'($signed(mem_rdata_in[15:0]))),
	.m(32'($signed(mem_rdata_in[7:0]))),
	.n({16'b0, mem_rdata_in[15:0]}),
	.o({24'b0, mem_rdata_in[7:0]}),
	.p(32'b0),
	.out(eb_rs1mux_out)
);

mux16 eb_rs2mux
(
	.sel(eb_rs2mux_sel),
	.a(id_rs2mux_out), //default, nonforwarded value.
	.b(alu_out), //Forwarded alu output. EX->EX
	.c({31'b0, cmp_out}), // Forwarded cmp output. EX->EX
	.d(wbmux_out), //Forwarded rdata output (from dcache) MEM->EX
	.e(pc_ex + 4), //Forwarded PC + 4 (when jal, jalr are previous instr) EX->EX
	.f(u_ex), //Forwarded u_imm (when LUI is previous instruction). EX->EX.
	.g(mem_rdata_in), //Forwarded rdata
	.h(alu_mem), //Forwarding MEM->EX (non-load values), same order as above
	.i({31'b0, br_en}),
	.j(pc_mem + 4),
	.k(u_mem),
	.l(32'($signed(mem_rdata_in[15:0]))),
	.m(32'($signed(mem_rdata_in[7:0]))),
	.n({16'b0, mem_rdata_in[15:0]}),
	.o({24'b0, mem_rdata_in[7:0]}),
	.p(32'b0),
	.out(eb_rs2mux_out)
);

//ID/EX
id_ex id_ex
(
   .clk,
   //.load(resp_a),
	.load(load_id_ex),
	.clear(clear_from_ex || clear_from_mem),
	.control_word_in(ctrl_rom_out),
	.pc_in(pc_id),
	.u_imm_in(u_id),
	.b_imm_in(b_id),
	.s_imm_in(s_id),
	.j_imm_in(j_id),
	.i_imm_in(i_id),
	//.rs1_data_in(rs1_id),
	//.rs2_data_in(rs2_id),
	.rs1_data_in(id_rs1mux_out),
	.rs2_data_in(id_rs2mux_out),
	.rd_in(rd),
	.cmp_data_in(eb_cmp_out[0]),

	.pc_out(pc_ex),
	.control_word_out(ctrl_ex),
	.rs1_data_out(rs1_ex),
	.rs2_data_out(rs2_ex),
	.u_imm_out(u_ex),
	.b_imm_out(b_ex),
	.s_imm_out(s_ex),
	.j_imm_out(j_ex),
	.i_imm_out(i_ex),
	.rd_out(rd_ex),
	.cmp_data_out(cmp_out)
);


// EX
mux2 alumux1
(
	.sel(ctrl_ex.alumux1_sel),
	//.a(rs1_ex),
	.a(rs1mux_out),
	.b(pc_ex),
	.f(alumux1_out)
);

mux8 alumux2
(
	.sel(ctrl_ex.alumux2_sel),
	.a(i_ex),
	.b(u_ex),
	.c(b_ex),
	.d(s_ex),
	.e(j_ex),
	.f(0),
	//.g(rs2_ex),
	.g(rs2mux_out),
	.h(0),
	.out(alumux2_out)
);

alu alu
(
	.aluop(ctrl_ex.aluop),
	.a(alumux1_out),
	.b(alumux2_out),
	.f(alu_out)
);

/*
mux2 cmpmux
(
	.sel(ctrl_ex.cmpmux_sel),
	//.a(rs2_ex),
	.a(rs2mux_out),
	.b(i_ex),
	.f(cmpmux_out)
);

cmp cmp
(
	.cmpop(ctrl_ex.cmpop),
	//.a(rs1_ex),
	.a(rs1mux_out),
	.b(cmpmux_out),
	.out(cmp_out)
);
*/

//EX/MEM
ex_mem ex_mem
(
   .clk,
   //.load(resp_a),
	.load(load_ex_mem),
	.clear(clear_from_mem),
	.control_word_in(ctrl_ex),
	.pc_in(pc_ex),
	.rd_in(rd_ex),
	//.rs2_data_in(rs2_ex),
	.rs2_data_in(rs2mux_out),
	.cmp_data_in(cmp_out),
	.alu_data_in(alu_out),
	.u_ex,

	.u_mem,
	.pc_out(pc_mem),
	.control_word_out(ctrl_mem),
	.rs2_data_out(rs2_mem),
	.cmp_data_out(br_en),
	.alu_data_out(alu_mem),
	.rd_out(rd_mem)
);


// MEM
// access data for load and store
mux4 memdata_mux //Mux chooses what we are storing.
(
	.sel(ctrl_mem.memdatamux_sel),
	.a(rs2_mem), //32 bits
	.b({16'b0, rs2_mem[15:0]}), //Unsigned 16-bits
	.c({24'b0, rs2_mem[7:0]}), //Unsigned 8 bits
	/*
	.a(wdatamux_out),
	.b({16'b0, wdatamux_out[15:0]}),
	.c({24'b0, wdatamux_out[7:0]}),
	*/
	.d(32'b0),
	.f(memdatamux_out)
);

//MEM/WB
mem_wb mem_wb
(
   .clk,
   //.load(resp_a),
	.load(load_mem_wb),
	.clear,
	.control_word_in(ctrl_mem),
	.resp_b_in(resp_b),
	.mem_rdata_in,
	.alu_data_in(alu_mem),
	.rd_in(rd_mem),
	.u_mem,
	.br_en,
	.pc_mem(pc_mem),

	.br_en_zext,
	.u_wb,
	.control_word_out(ctrl_wb),
	.resp_b_out(resp_b_wb),
	.mem_rdata_out(rdata_b_wb),
	.alu_data_out(alu_wb),
	.rd_out(rd_wb),
	.pc_wb(pc_wb)
);


//WB
mux16 wbmux
(
	.sel(ctrl_wb.regfilemux_sel),
	.a(alu_wb),
	.b(br_en_zext),
	.c(u_wb),
	.d(rdata_b_wb),
	.e(32'($signed(rdata_b_wb[15:0]))), //16 bits SIGNED
	.f(32'($signed(rdata_b_wb[7:0]))),	//8 bits SIGNED
	.g({16'b0, rdata_b_wb[15:0]}),				//16 bits UNSIGNED
	.h({24'b0, rdata_b_wb[7:0]}),				//8 bits UNSIGNED
	.i(pc_wb + 4),
	.j(32'b0),
	.k(32'b0),
	.l(32'b0),
	.m(32'b0),
	.n(32'b0),
	.o(32'b0),
	.p(32'b0),
	.out(wbmux_out)
);


//counters
counter Branches // 0xFFFE
(
	.clk,
	.datain(enable_br && load_count),
	.clear(set || clear_br),
	.dataout(out_br)
);

counter MisPredicts // 0xFFFC
(
	.clk,
	.datain(enable_MisP && load_count),
	.clear(set || clear_MisP),
	.dataout(out_MisP)
);

counter Stalls // 0xFFFA
(
	.clk,
	.datain(enable_Stall && load_count),
	.clear(set || clear_Stall),
	.dataout(out_Stall)
);


counter Hits_i // 0xFFF8
(
	.clk,
	.datain(enable_hit_i && load_count),
	.clear((set || clear_hit_i) && load_count),
	.dataout(out_hit_i)
);



counter Hits_d // 0xFFF6
(
	.clk,
	.datain(enable_hit_d && load_count),
	.clear(set || clear_hit_d),
	.dataout(out_hit_d)
);



counter Hits_L2 // 0xFFF4
(
	.clk,
	.datain(enable_hit_L2 && load_count),
	.clear(set || clear_hit_L2),
	.dataout(out_hit_L2)
);



counter Misses_i // 0xFFF2
(
	.clk,
	.datain(enable_miss_i && load_count),
	.clear(set || clear_miss_i),
	.dataout(out_miss_i)
);



counter Misses_d // 0xFFF0
(
	.clk,
	.datain(enable_miss_d && load_count),
	.clear(set || clear_miss_d),
	.dataout(out_miss_d)
);



counter Misses_L2 // 0xFFEE
(
	.clk,
	.datain(enable_miss_L2 && load_count),
	.clear(set || clear_miss_L2),
	.dataout(out_miss_L2)
);


always_comb
begin
	if (pc_out == 8'h00000060)
		set = 1;
	else
		set = 0;

	//software conditions for load (will make a module)
	if (ctrl_mem.opcode == op_store)
		mem_rdata_in = rdata_b;
	else if ((address_b == 32'hFFFFFFFE) && (ctrl_mem.opcode == op_load)) begin
		mem_rdata_in = out_br;
		$display("The value of a is: %b", out_br);
	end
	else if ((address_b == 32'hFFFFFFFC) && (ctrl_mem.opcode == op_load))
		mem_rdata_in = out_MisP;
	else if ((address_b == 32'hFFFFFFFA) && (ctrl_mem.opcode == op_load))
		mem_rdata_in = out_Stall;
	else if ((address_b == 32'hFFFFFFF8) && (ctrl_mem.opcode == op_load))
		mem_rdata_in = out_hit_i;
	else if ((address_b == 32'hFFFFFFF6) && (ctrl_mem.opcode == op_load))
		mem_rdata_in = out_hit_d;
	else if ((address_b == 32'hFFFFFFF4) && (ctrl_mem.opcode == op_load))
		mem_rdata_in = out_hit_L2;
	else if ((address_b == 32'hFFFFFFF2) && (ctrl_mem.opcode == op_load))
		mem_rdata_in = out_miss_i;
	else if ((address_b == 32'hFFFFFFF0) && (ctrl_mem.opcode == op_load))
		mem_rdata_in = out_miss_d;
	else if ((address_b == 32'hFFFFFFEE) && (ctrl_mem.opcode == op_load))
		mem_rdata_in = out_miss_L2;
	else
		mem_rdata_in = rdata_b;
end


always_ff @(posedge clk)
begin

	//software conditions for clear (will make a module)
	if ((address_b == 32'hFFFFFFFE) && (ctrl_mem.opcode == op_store))
		clear_br <= 1;
	else
		clear_br <= 0;

	if ((address_b == 32'hFFFFFFFC) && (ctrl_mem.opcode == op_store))
		clear_MisP <= 1;
	else
		clear_MisP <= 0;

	if ((address_b == 32'hFFFFFFFA) && (ctrl_mem.opcode == op_store))
		clear_Stall <= 1;
	else
		clear_Stall <= 0;

	if ((address_b == 32'hFFFFFFF8) && (ctrl_mem.opcode == op_store))
		clear_hit_i <= 1;
	else
		clear_hit_i <= 0;

	if ((address_b == 32'hFFFFFFF6) && (ctrl_mem.opcode == op_store))
		clear_hit_d <= 1;
	else
		clear_hit_d <= 0;

	if ((address_b == 32'hFFFFFFF4) && (ctrl_mem.opcode == op_store))
		clear_hit_L2 <= 1;
	else
		clear_hit_L2 <= 0;

	if ((address_b == 32'hFFFFFFF2) && (ctrl_mem.opcode == op_store))
		clear_miss_i <= 1;
	else
		clear_miss_i <= 0;

	if ((address_b == 32'hFFFFFFF0) && (ctrl_mem.opcode == op_store))
		clear_miss_d <= 1;
	else
		clear_miss_d <= 0;

	if ((address_b == 32'hFFFFFFEE) && (ctrl_mem.opcode == op_store))
		clear_miss_L2 <= 1;
	else
		clear_miss_L2 <= 0;

	// enable (hardware) conditions (will make a module)
	if ((ctrl_mem.opcode == op_br))
		enable_br <= 1;
	else
		enable_br <= 0;

	if (br_en && (ctrl_mem.opcode == op_br)) // static NT, this will change for Dynamic BP
		enable_MisP <= 1;
	else
		enable_MisP <= 0;

	if (!load_count)
		enable_Stall <= 1;
	else
		enable_Stall <= 0;

	if(counter_pick_i == 0)
	begin
		enable_hit_i <= 1;
		enable_miss_i <= 0;
	end
	else if(counter_pick_i == 1)
	begin
		enable_hit_i <= 0;
		enable_miss_i <= 1;
	end
	else
	begin
		enable_hit_i <= 0;
		enable_miss_i <= 0;
	end

	if(counter_pick_d == 0)
	begin
		enable_hit_d <= 1;
		enable_miss_d <= 0;
	end
	else if(counter_pick_d == 1)
	begin
		enable_hit_d <= 0;
		enable_miss_d <= 1;
	end
	else
	begin
		enable_hit_d <= 0;
		enable_miss_d <= 0;
	end

	if(counter_pick_L2 == 0)
	begin
		enable_hit_L2 <= 1;
		enable_miss_L2 <= 0;
	end
	else if(counter_pick_L2 == 1)
	begin
		enable_hit_L2 <= 0;
		enable_miss_L2 <= 1;
	end
	else
	begin
		enable_hit_L2 <= 0;
		enable_miss_L2 <= 0;
	end
end


//FORWARDING LOGIC AND MUXES

fwd_logic forward_logic
(
	.rs1,
	.rs2,
	.rd_ex,
	.rd_mem,
	.rd_wb,
	.ctrl_id(ctrl_rom_out),
	.ctrl_ex,
	.ctrl_mem,
	.ctrl_wb,
	.rs1mux_sel,
	.rs2mux_sel,
	.eb_rs1mux_sel,
	.eb_rs2mux_sel,
	.wdatamux_sel,
	.id_rs1mux_sel,
	.id_rs2mux_sel,
	.stall_for_load,
	.eb_stall_for_load
);

mux16 rs1mux
(
	.sel(rs1mux_sel),
	.a(rs1_ex), //default, nonforwarded value.
	.b(alu_mem), //Forwarded alu output. EX->EX
	.c({31'b0, br_en}), // Forwarded cmp output. EX->EX
	.d(wbmux_out), //Forwarded rdata output (from dcache) MEM->EX
	.e(pc_mem + 4), //Forwarded PC + 4 (when jal, jalr are previous instr) EX->EX
	.f(u_mem), //Forwarded u_imm (when LUI is previous instruction). EX->EX.
	.g(rdata_b_wb), //Forwarded rdata
	.h(alu_wb), //Forwarding MEM->EX (non-load values), same order as above
	.i(br_en_zext),
	.j(pc_wb + 4),
	.k(u_wb),
	.l(32'b0),
	.m(32'b0),
	.n(32'b0),
	.o(32'b0),
	.p(32'b0),
	.out(rs1mux_out)
);

mux16 rs2mux
(
	.sel(rs2mux_sel),
	.a(rs2_ex), //default, nonforwarded value.
	.b(alu_mem), //Forwarded alu output. EX->EX
	.c({31'b0, br_en}), // Forwarded cmp output. EX->EX
	.d(wbmux_out), //Forwarded rdata output (from dcache) MEM->EX
	.e(pc_mem + 4), //Forwarded PC + 4 (when jal, jalr are previous instr) EX->EX
	.f(u_mem), //Forwarded u_imm (when LUI is previous instruction). EX->EX.
	.g(rdata_b_wb), //Forwarded rdata
	.h(alu_wb), //Forwarding MEM->EX (non-load values), same order as above
	.i(br_en_zext),
	.j(pc_wb + 4),
	.k(u_wb),
	.l(32'b0),
	.m(32'b0),
	.n(32'b0),
	.o(32'b0),
	.p(32'b0),
	.out(rs2mux_out)
);

mux2 wdatamux
(
	.sel(wdatamux_sel),
	.a(rs2_mem),
	.b(wbmux_out),
	.f(wdatamux_out)
);

mux2 id_rs1mux
(
	.sel(id_rs1mux_sel),
	.a(rs1_id),
	.b(wbmux_out),
	.f(id_rs1mux_out)
);

mux2 id_rs2mux
(
	.sel(id_rs2mux_sel),
	.a(rs2_id),
	.b(wbmux_out),
	.f(id_rs2mux_out)
);

/* BTB and BHT Combined into one declaration */
btb_datapath btb_datapath
(
	.clk(clk),
	.pc_out(pc_out), //output from PC in IF stage.
	.pc_ex(pc_ex),
	.pc_mem(pc_mem), //the value of PC in the MEM stage.
	.if_opcode(rv32i_opcode'(rdata_a[6:0])), //rdata_a[6:0]. Check if branch or jump.
	.ex_opcode(ctrl_ex.opcode),
	.mem_opcode(ctrl_mem.opcode), // ctrl_mem.opcode
	.br_en(cmp_out), //Take in the branch
	.calculated_addr(alu_mem), //The calculated target address in MEM (alu_mem)
	.target_address(target_address), // The target address in the IF stage. Goes into PCMUX
	.branch_prediction(branch_prediction) //The outputted prediction (T/NT).
);

pcmux_logic pcmux_logic
(
	.p_if(branch_prediction), //prediction in IF
	.p_ex(ctrl_ex.prediction),
	.p_mem(ctrl_mem.prediction), //prediction in MEM
	.br_en(br_en),
	.cmp_out(cmp_out),
	.if_opcode(rv32i_opcode'(rdata_a[6:0])),
	.mem_opcode(ctrl_mem.opcode),
	.ex_opcode(ctrl_ex.opcode),
	.pcmux_sel(pcmux_sel),
	.clear_from_ex(clear_from_ex),
	.clear_from_mem(clear_from_mem)
	//.clear_stages(clear_stages) //1 if p_mem != br_en. 0 if pmem == br_en. Clear signal for registers
);

//Assignments
assign write_b = ctrl_mem.write;
assign read_b = ctrl_mem.read;
assign read_a = 1'b1;

endmodule : pipe_datapath
