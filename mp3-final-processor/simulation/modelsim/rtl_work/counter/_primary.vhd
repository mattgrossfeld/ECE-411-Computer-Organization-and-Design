library verilog;
use verilog.vl_types.all;
entity counter is
    generic(
        WIDTH           : integer := 32
    );
    port(
        clk             : in     vl_logic;
        datain          : in     vl_logic;
        clear           : in     vl_logic;
        dataout         : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
end counter;
