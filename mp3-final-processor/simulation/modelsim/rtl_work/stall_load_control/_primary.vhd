library verilog;
use verilog.vl_types.all;
library work;
entity stall_load_control is
    port(
        icache_resp     : in     vl_logic;
        dcache_resp     : in     vl_logic;
        d_write         : in     vl_logic;
        d_read          : in     vl_logic;
        stall_for_load  : in     vl_logic;
        eb_stall_for_load: in     vl_logic;
        pc_ex           : in     vl_logic_vector(31 downto 0);
        pc_mem          : in     vl_logic_vector(31 downto 0);
        pc_wb           : in     vl_logic_vector(31 downto 0);
        br_en           : in     vl_logic;
        ctrl_mem        : in     work.rv32i_types.rv32i_control_word;
        load_pc         : out    vl_logic;
        load_if_id      : out    vl_logic;
        load_id_ex      : out    vl_logic;
        load_ex_mem     : out    vl_logic;
        load_mem_wb     : out    vl_logic;
        load_count      : out    vl_logic;
        clear_ex_mem    : out    vl_logic;
        clear_id_ex     : out    vl_logic
    );
end stall_load_control;
