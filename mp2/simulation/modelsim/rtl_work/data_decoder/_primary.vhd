library verilog;
use verilog.vl_types.all;
entity data_decoder is
    port(
        mem_byte_enable : in     vl_logic_vector(3 downto 0);
        offset          : in     vl_logic_vector(4 downto 0);
        mem_wdata       : in     vl_logic_vector(31 downto 0);
        datain          : in     vl_logic_vector(255 downto 0);
        dataout         : out    vl_logic_vector(255 downto 0)
    );
end data_decoder;
