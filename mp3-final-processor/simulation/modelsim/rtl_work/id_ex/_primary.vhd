library verilog;
use verilog.vl_types.all;
library work;
entity id_ex is
    port(
        clk             : in     vl_logic;
        load            : in     vl_logic;
        clear           : in     vl_logic;
        control_word_in : in     work.rv32i_types.rv32i_control_word;
        pc_in           : in     vl_logic_vector(31 downto 0);
        rd_in           : in     vl_logic_vector(4 downto 0);
        u_imm_in        : in     vl_logic_vector(31 downto 0);
        b_imm_in        : in     vl_logic_vector(31 downto 0);
        s_imm_in        : in     vl_logic_vector(31 downto 0);
        j_imm_in        : in     vl_logic_vector(31 downto 0);
        i_imm_in        : in     vl_logic_vector(31 downto 0);
        rs1_data_in     : in     vl_logic_vector(31 downto 0);
        rs2_data_in     : in     vl_logic_vector(31 downto 0);
        cmp_data_in     : in     vl_logic;
        pc_out          : out    vl_logic_vector(31 downto 0);
        control_word_out: out    work.rv32i_types.rv32i_control_word;
        rs1_data_out    : out    vl_logic_vector(31 downto 0);
        rs2_data_out    : out    vl_logic_vector(31 downto 0);
        rd_out          : out    vl_logic_vector(4 downto 0);
        u_imm_out       : out    vl_logic_vector(31 downto 0);
        b_imm_out       : out    vl_logic_vector(31 downto 0);
        s_imm_out       : out    vl_logic_vector(31 downto 0);
        j_imm_out       : out    vl_logic_vector(31 downto 0);
        i_imm_out       : out    vl_logic_vector(31 downto 0);
        cmp_data_out    : out    vl_logic
    );
end id_ex;
