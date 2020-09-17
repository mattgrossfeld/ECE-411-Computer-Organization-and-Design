library verilog;
use verilog.vl_types.all;
entity is_hit is
    port(
        address_tag     : in     vl_logic_vector(23 downto 0);
        cache_tag       : in     vl_logic_vector(23 downto 0);
        valid_bit       : in     vl_logic;
        hit             : out    vl_logic
    );
end is_hit;
