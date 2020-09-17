library verilog;
use verilog.vl_types.all;
entity data_decoder is
    generic(
        width           : integer := 32
    );
    port(
        mem_byte_enable : in     vl_logic_vector(3 downto 0);
        offset          : in     vl_logic_vector(4 downto 0);
        mem_wdata       : in     vl_logic_vector;
        datain          : in     vl_logic_vector(255 downto 0);
        dataout         : out    vl_logic_vector(255 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of width : constant is 1;
end data_decoder;
