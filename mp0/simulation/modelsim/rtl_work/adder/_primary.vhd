library verilog;
use verilog.vl_types.all;
entity adder is
    generic(
        width           : integer := 16
    );
    port(
        offset          : in     vl_logic_vector(15 downto 0);
        addr_in         : in     vl_logic_vector(15 downto 0);
        addr_out        : out    vl_logic_vector(15 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of width : constant is 1;
end adder;
