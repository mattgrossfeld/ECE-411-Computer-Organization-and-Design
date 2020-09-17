library verilog;
use verilog.vl_types.all;
library work;
entity if_id is
    port(
        clk             : in     vl_logic;
        load            : in     vl_logic;
        clear           : in     vl_logic;
        read_data_in    : in     vl_logic_vector(31 downto 0);
        pc_in           : in     vl_logic_vector(31 downto 0);
        prediction_if   : in     vl_logic;
        pc_out          : out    vl_logic_vector(31 downto 0);
        rs1             : out    vl_logic_vector(4 downto 0);
        rs2             : out    vl_logic_vector(4 downto 0);
        rd              : out    vl_logic_vector(4 downto 0);
        u_imm           : out    vl_logic_vector(31 downto 0);
        b_imm           : out    vl_logic_vector(31 downto 0);
        s_imm           : out    vl_logic_vector(31 downto 0);
        j_imm           : out    vl_logic_vector(31 downto 0);
        i_imm           : out    vl_logic_vector(31 downto 0);
        opcode          : out    work.rv32i_types.rv32i_opcode;
        funct3          : out    vl_logic_vector(2 downto 0);
        funct7          : out    vl_logic_vector(6 downto 0);
        prediction_id   : out    vl_logic
    );
end if_id;
