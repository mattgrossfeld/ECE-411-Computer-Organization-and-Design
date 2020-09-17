import rv32i_types::*;

module fwd_logic
(
	input rv32i_reg rs1, rs2,
	input rv32i_reg rd_ex, rd_mem, rd_wb,
	input rv32i_control_word ctrl_id, ctrl_ex, ctrl_mem, ctrl_wb,
	output logic [3:0] rs1mux_sel, rs2mux_sel, eb_rs1mux_sel, eb_rs2mux_sel,
	output logic wdatamux_sel, id_rs1mux_sel, id_rs2mux_sel,
	output logic stall_for_load,
	output logic eb_stall_for_load
);

/* INSTR | RS1? | RS2? | RD?
    jalr | yes  | no   | yes
    jal  | no   | no   | yes
    br   | yes  | yes  | no
    lui  | no   | no   | yes
   auipc | no   | no   | yes
   load  | yes  | no   | yes
   store | yes  | yes  | no
   imm   | yes  | no   | yes
   reg   | yes  | yes  | yes


*/

always_comb
begin
	/* Default Assignments */
	rs1mux_sel = 4'b0000;
	rs2mux_sel = 4'b0000;
	wdatamux_sel = 1'b0;
	id_rs1mux_sel = 1'b0;
	id_rs2mux_sel = 1'b0;
	stall_for_load = 1'b0;
	eb_rs1mux_sel = 4'b0000;
	eb_rs2mux_sel = 4'b0000;
	eb_stall_for_load = 1'b0;

/* Transparent Register Workaround */
	if ((rs1 == rd_wb) && ctrl_wb.load_regfile && (rd_wb != 5'b0))
		id_rs1mux_sel = 1'b1;
	if ((rs2 == rd_wb) && ctrl_wb.load_regfile && (rd_wb != 5'b0))
		id_rs2mux_sel = 1'b1;

/* RS1 FORWARDING */
//EX->EX
	if ((ctrl_ex.rs1 == rd_mem) && ctrl_mem.load_regfile && (rd_mem != 5'b0)) // EX->EX (rs1)
	begin
		if (ctrl_mem.regfilemux_sel == 4'b0001) //RD from cmp.
			rs1mux_sel = 4'b0010; //Forward comparator result.

		else if (ctrl_mem.regfilemux_sel == 4'b0000) //RD from ALU.
			rs1mux_sel = 4'b0001; //Forward ALU result.

		else if (ctrl_mem.regfilemux_sel == 4'b1000) //RD = pc+4
			rs1mux_sel = 4'b0100;

		else if (ctrl_mem.regfilemux_sel == 4'b0010) //RD = u_imm (LUI)
			rs1mux_sel = 4'b0101;

		else if ((ctrl_mem.regfilemux_sel == 4'b0011)) //op_load
			//stall for FE ID EX for 1 cycle for load to go from MEM to WB
			// then forward rdata from WB to EX
			stall_for_load = 1'b1;
	end
	else if ((ctrl_ex.rs1 == rd_wb) && ctrl_wb.load_regfile && (rd_wb != 5'b0)) // MEM->EX (rs1)
	begin
		if (ctrl_wb.regfilemux_sel == 4'b0001) //RD from cmp.
			rs1mux_sel = 4'b1000; //Forward comparator result.

		else if (ctrl_wb.regfilemux_sel == 4'b0000) //RD from ALU.
			rs1mux_sel = 4'b0111; //Forward ALU result.

		else if (ctrl_wb.regfilemux_sel == 4'b1000) //RD = pc+4
			rs1mux_sel = 4'b1001;

		else if (ctrl_wb.regfilemux_sel == 4'b0010) //RD = u_imm (LUI)
			rs1mux_sel = 4'b1010;

		else if (ctrl_wb.regfilemux_sel == 4'b0011) //op_load word
			rs1mux_sel = 4'b0110;
	end

//MEM->EX
	if (ctrl_wb.load_regfile && (rd_wb != 5'b0) && !(ctrl_mem.load_regfile && (rd_mem != 5'b0) && (rd_mem == ctrl_ex.rs1)) && (rd_wb == ctrl_ex.rs1)) //Revised MEM->EX (rs1)
	begin
		if ((ctrl_wb.regfilemux_sel == 4'b0011) || (ctrl_wb.regfilemux_sel == 4'b0100) || (ctrl_wb.regfilemux_sel == 4'b0101) || (ctrl_wb.regfilemux_sel == 4'b0110) || (ctrl_wb.regfilemux_sel == 4'b0111)) //Any of the variants of load.
			rs1mux_sel = 4'b0011; //Forwards appropriate loaded value.
	end

/* RS2 FORWARDING */
	//EX->EX
		if ((ctrl_ex.rs2 == rd_mem) && ctrl_mem.load_regfile && (rd_mem != 5'b0)) // EX->EX (rs2)
		begin
			if (ctrl_mem.regfilemux_sel == 4'b0001) //RD from cmp.
				rs2mux_sel = 4'b0010; //Forward comparator result.

			else if (ctrl_mem.regfilemux_sel == 4'b0000) //RD from ALU.
				rs2mux_sel = 4'b0001; //Forward ALU result.

			else if (ctrl_mem.regfilemux_sel == 4'b1000) //RD = pc+4
				rs2mux_sel = 4'b0100;

			else if (ctrl_mem.regfilemux_sel == 4'b0010) //RD = u_imm (LUI)
				rs2mux_sel = 4'b0101;

			else if ((ctrl_wb.regfilemux_sel == 4'b0011)) //op_load
				stall_for_load = 1'b1;
		end
		else if ((ctrl_ex.rs2 == rd_wb) && ctrl_wb.load_regfile && (rd_wb != 5'b0)) // MEM->EX (rs1)
		begin
			if (ctrl_wb.regfilemux_sel == 4'b0001) //RD from cmp.
				rs2mux_sel = 4'b1000; //Forward comparator result.

			else if (ctrl_wb.regfilemux_sel == 4'b0000) //RD from ALU.
				rs2mux_sel = 4'b0111; //Forward ALU result.

			else if (ctrl_wb.regfilemux_sel == 4'b1000) //RD = pc+4
				rs2mux_sel = 4'b1001;

			else if (ctrl_wb.regfilemux_sel == 4'b0010) //RD = u_imm (LUI)
				rs2mux_sel = 4'b1010;

			else if (ctrl_wb.regfilemux_sel == 4'b0011) //op_load
				rs1mux_sel = 4'b0110;
		end
	//MEM->EX
		if (ctrl_wb.load_regfile && (rd_wb != 5'b0) && !(ctrl_mem.load_regfile && (rd_mem != 5'b0) && (rd_mem == ctrl_ex.rs2)) && (rd_wb == ctrl_ex.rs2)) //Revised MEM->EX (rs2)
		begin
			if ((ctrl_wb.regfilemux_sel == 4'b0011) || (ctrl_wb.regfilemux_sel == 4'b0100) || (ctrl_wb.regfilemux_sel == 4'b0101) || (ctrl_wb.regfilemux_sel == 4'b0110) || (ctrl_wb.regfilemux_sel == 4'b0111)) //Any of the variants of load.
				rs2mux_sel = 4'b0011; //Forwards appropriate loaded value.
		end

	//MEM->MEM
		if (ctrl_wb.load_regfile && (rd_wb != 5'b0) && (ctrl_mem.rs2 == rd_wb))
			wdatamux_sel = 1'b1;

		/* Forwarding logic for early branch */
		//RS1
		if ((rs1 == rd_ex) && ctrl_ex.load_regfile && (rd_ex != 5'b0)) begin//EX -> ID
			if (ctrl_ex.regfilemux_sel == 4'b0001) //RD from cmp.
				eb_rs1mux_sel = 4'b0010; //Forward comparator result.

			else if (ctrl_ex.regfilemux_sel == 4'b0000) //RD from ALU.
				eb_rs1mux_sel = 4'b0001; //Forward ALU result.

			else if (ctrl_ex.regfilemux_sel == 4'b1000) //RD = pc+4
				eb_rs1mux_sel = 4'b0100;

			else if (ctrl_ex.regfilemux_sel == 4'b0010) //RD = u_imm (LUI)
				eb_rs1mux_sel = 4'b0101;

			else if ((ctrl_ex.regfilemux_sel == 4'b0011) || (ctrl_ex.regfilemux_sel == 4'b0100) ||
							 (ctrl_ex.regfilemux_sel == 4'b0101) || (ctrl_ex.regfilemux_sel == 4'b0110) ||
							 (ctrl_ex.regfilemux_sel == 4'b0111)) //op_load
				//stall for FE ID EX for 1 cycle for load to go from MEM to WB
				// then forward rdata from WB to EX
				eb_stall_for_load = 1'b1;
		end
		else if ((rs1 == rd_mem) && ctrl_mem.load_regfile && (rd_mem != 5'b0)) begin //MEM -> ID
			if (ctrl_mem.regfilemux_sel == 4'b0001) //RD from cmp.
				eb_rs1mux_sel = 4'b1000; //Forward comparator result.

			else if (ctrl_mem.regfilemux_sel == 4'b0000) //RD from ALU.
				eb_rs1mux_sel = 4'b0111; //Forward ALU result.

			else if (ctrl_mem.regfilemux_sel == 4'b1000) //RD = pc+4
				eb_rs1mux_sel = 4'b1001;

			else if (ctrl_mem.regfilemux_sel == 4'b0010) //RD = u_imm (LUI)
				eb_rs1mux_sel = 4'b1010;

			else if (ctrl_mem.regfilemux_sel == 4'b0011) //op_load
				eb_rs1mux_sel = 4'b0110;

			else if (ctrl_mem.regfilemux_sel == 4'b0100) //op_load half word signed
				eb_rs1mux_sel = 4'b1011;

			else if (ctrl_mem.regfilemux_sel == 4'b0101) //op_load byte signed
				eb_rs1mux_sel = 4'b1100;

			else if (ctrl_mem.regfilemux_sel == 4'b0110) //op_load half word unsigned
				eb_rs1mux_sel = 4'b1101;

			else if (ctrl_mem.regfilemux_sel == 4'b0111) //op_load byte unsigned
				eb_rs1mux_sel = 4'b1110;
		end
		else if ((rs1 == rd_wb) && ctrl_wb.load_regfile && (rd_wb != 5'b0)) begin //WB -> ID
			eb_rs1mux_sel = 4'b0011;
		end

		//RS2
		if ((rs2 == rd_ex) && ctrl_ex.load_regfile && (rd_ex != 5'b0)) begin //EX -> ID
			if (ctrl_ex.regfilemux_sel == 4'b0001) //RD from cmp.
				eb_rs2mux_sel = 4'b0010; //Forward comparator result.

			else if (ctrl_ex.regfilemux_sel == 4'b0000) //RD from ALU.
				eb_rs2mux_sel = 4'b0001; //Forward ALU result.

			else if (ctrl_ex.regfilemux_sel == 4'b1000) //RD = pc+4
				eb_rs2mux_sel = 4'b0100;

			else if (ctrl_ex.regfilemux_sel == 4'b0010) //RD = u_imm (LUI)
				eb_rs2mux_sel = 4'b0101;

			else if ((ctrl_ex.regfilemux_sel == 4'b0011) || (ctrl_ex.regfilemux_sel == 4'b0100) ||
							 (ctrl_ex.regfilemux_sel == 4'b0101) || (ctrl_ex.regfilemux_sel == 4'b0110) ||
							 (ctrl_ex.regfilemux_sel == 4'b0111)) //op_load
				//stall for FE ID EX for 1 cycle for load to go from MEM to WB
				// then forward rdata from WB to EX
				eb_stall_for_load = 1'b1;
		end
		else if ((rs2 == rd_mem) && ctrl_mem.load_regfile && (rd_mem != 5'b0)) begin //MEM -> ID
			if (ctrl_mem.regfilemux_sel == 4'b0001) //RD from cmp.
				eb_rs2mux_sel = 4'b1000; //Forward comparator result.

			else if (ctrl_mem.regfilemux_sel == 4'b0000) //RD from ALU.
				eb_rs2mux_sel = 4'b0111; //Forward ALU result.

			else if (ctrl_mem.regfilemux_sel == 4'b1000) //RD = pc+4
				eb_rs2mux_sel = 4'b1001;

			else if (ctrl_mem.regfilemux_sel == 4'b0010) //RD = u_imm (LUI)
				eb_rs2mux_sel = 4'b1010;

			else if (ctrl_mem.regfilemux_sel == 4'b0011) //op_load
				eb_rs2mux_sel = 4'b0110;

			else if (ctrl_mem.regfilemux_sel == 4'b0100) //op_load half word signed
				eb_rs2mux_sel = 4'b1011;

			else if (ctrl_mem.regfilemux_sel == 4'b0101) //op_load byte signed
				eb_rs2mux_sel = 4'b1100;

			else if (ctrl_mem.regfilemux_sel == 4'b0110) //op_load half word unsigned
				eb_rs2mux_sel = 4'b1101;

			else if (ctrl_mem.regfilemux_sel == 4'b0111) //op_load byte unsigned
				eb_rs2mux_sel = 4'b1110;
		end
		else if ((rs2 == rd_wb) && ctrl_wb.load_regfile && (rd_wb != 5'b0)) begin //WB -> ID
			eb_rs2mux_sel = 4'b0011;
		end
end

endmodule : fwd_logic
