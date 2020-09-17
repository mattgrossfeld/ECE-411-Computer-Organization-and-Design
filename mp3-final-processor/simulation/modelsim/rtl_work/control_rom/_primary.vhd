library verilog;
use verilog.vl_types.all;
library work;
entity control_rom is
    port(
        funct3          : in     vl_logic_vector(2 downto 0);
        funct7          : in     vl_logic_vector(6 downto 0);
        rs1             : in     vl_logic_vector(4 downto 0);
        rs2             : in     vl_logic_vector(4 downto 0);
        opcode          : in     work.rv32i_types.rv32i_opcode;
        prediction      : in     vl_logic;
        ctrl            : out    work.rv32i_types.rv32i_control_word
    );
end control_rom;
