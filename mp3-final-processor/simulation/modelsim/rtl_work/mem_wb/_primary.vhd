library verilog;
use verilog.vl_types.all;
library work;
entity mem_wb is
    port(
        clk             : in     vl_logic;
        load            : in     vl_logic;
        clear           : in     vl_logic;
        control_word_in : in     work.rv32i_types.rv32i_control_word;
        resp_b_in       : in     vl_logic;
        rd_in           : in     vl_logic_vector(4 downto 0);
        mem_rdata_in    : in     vl_logic_vector(31 downto 0);
        alu_data_in     : in     vl_logic_vector(31 downto 0);
        u_mem           : in     vl_logic_vector(31 downto 0);
        br_en           : in     vl_logic;
        pc_mem          : in     vl_logic_vector(31 downto 0);
        pc_wb           : out    vl_logic_vector(31 downto 0);
        br_en_zext      : out    vl_logic_vector(31 downto 0);
        u_wb            : out    vl_logic_vector(31 downto 0);
        control_word_out: out    work.rv32i_types.rv32i_control_word;
        resp_b_out      : out    vl_logic;
        rd_out          : out    vl_logic_vector(4 downto 0);
        mem_rdata_out   : out    vl_logic_vector(31 downto 0);
        alu_data_out    : out    vl_logic_vector(31 downto 0)
    );
end mem_wb;
