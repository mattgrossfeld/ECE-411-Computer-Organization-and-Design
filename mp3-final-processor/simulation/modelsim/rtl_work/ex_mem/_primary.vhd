library verilog;
use verilog.vl_types.all;
library work;
entity ex_mem is
    port(
        clk             : in     vl_logic;
        load            : in     vl_logic;
        clear           : in     vl_logic;
        control_word_in : in     work.rv32i_types.rv32i_control_word;
        pc_in           : in     vl_logic_vector(31 downto 0);
        rd_in           : in     vl_logic_vector(4 downto 0);
        rs2_data_in     : in     vl_logic_vector(31 downto 0);
        cmp_data_in     : in     vl_logic;
        alu_data_in     : in     vl_logic_vector(31 downto 0);
        u_ex            : in     vl_logic_vector(31 downto 0);
        u_mem           : out    vl_logic_vector(31 downto 0);
        pc_out          : out    vl_logic_vector(31 downto 0);
        control_word_out: out    work.rv32i_types.rv32i_control_word;
        rs2_data_out    : out    vl_logic_vector(31 downto 0);
        cmp_data_out    : out    vl_logic;
        alu_data_out    : out    vl_logic_vector(31 downto 0);
        rd_out          : out    vl_logic_vector(4 downto 0)
    );
end ex_mem;
