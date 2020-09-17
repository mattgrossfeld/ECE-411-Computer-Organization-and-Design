library verilog;
use verilog.vl_types.all;
library work;
entity fwd_logic is
    port(
        rs1             : in     vl_logic_vector(4 downto 0);
        rs2             : in     vl_logic_vector(4 downto 0);
        rd_ex           : in     vl_logic_vector(4 downto 0);
        rd_mem          : in     vl_logic_vector(4 downto 0);
        rd_wb           : in     vl_logic_vector(4 downto 0);
        ctrl_id         : in     work.rv32i_types.rv32i_control_word;
        ctrl_ex         : in     work.rv32i_types.rv32i_control_word;
        ctrl_mem        : in     work.rv32i_types.rv32i_control_word;
        ctrl_wb         : in     work.rv32i_types.rv32i_control_word;
        rs1mux_sel      : out    vl_logic_vector(3 downto 0);
        rs2mux_sel      : out    vl_logic_vector(3 downto 0);
        eb_rs1mux_sel   : out    vl_logic_vector(3 downto 0);
        eb_rs2mux_sel   : out    vl_logic_vector(3 downto 0);
        wdatamux_sel    : out    vl_logic;
        id_rs1mux_sel   : out    vl_logic;
        id_rs2mux_sel   : out    vl_logic;
        stall_for_load  : out    vl_logic;
        eb_stall_for_load: out    vl_logic
    );
end fwd_logic;
