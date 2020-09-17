library verilog;
use verilog.vl_types.all;
entity is_hit is
    generic(
        width           : integer := 24
    );
    port(
        address_tag     : in     vl_logic_vector;
        cache_tag       : in     vl_logic_vector;
        valid_bit       : in     vl_logic;
        hit             : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of width : constant is 1;
end is_hit;
