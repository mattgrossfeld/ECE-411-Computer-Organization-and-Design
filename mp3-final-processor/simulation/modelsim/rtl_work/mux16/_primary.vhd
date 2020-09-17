library verilog;
use verilog.vl_types.all;
entity mux16 is
    generic(
        width           : integer := 32
    );
    port(
        sel             : in     vl_logic_vector(3 downto 0);
        a               : in     vl_logic_vector;
        b               : in     vl_logic_vector;
        c               : in     vl_logic_vector;
        d               : in     vl_logic_vector;
        e               : in     vl_logic_vector;
        f               : in     vl_logic_vector;
        g               : in     vl_logic_vector;
        h               : in     vl_logic_vector;
        i               : in     vl_logic_vector;
        j               : in     vl_logic_vector;
        k               : in     vl_logic_vector;
        l               : in     vl_logic_vector;
        m               : in     vl_logic_vector;
        n               : in     vl_logic_vector;
        o               : in     vl_logic_vector;
        p               : in     vl_logic_vector;
        \out\           : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of width : constant is 1;
end mux16;
