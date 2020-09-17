library verilog;
use verilog.vl_types.all;
library work;
entity cmp is
    generic(
        width           : integer := 32
    );
    port(
        cmpop           : in     work.rv32i_types.branch_funct3_t;
        a               : in     vl_logic_vector(31 downto 0);
        b               : in     vl_logic_vector(31 downto 0);
        \out\           : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of width : constant is 1;
end cmp;
