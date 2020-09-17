library verilog;
use verilog.vl_types.all;
entity mp3 is
    port(
        clk             : in     vl_logic;
        pmem_resp       : in     vl_logic;
        pmem_read       : out    vl_logic;
        pmem_write      : out    vl_logic;
        pmem_address    : out    vl_logic_vector(31 downto 0);
        pmem_rdata      : in     vl_logic_vector(255 downto 0);
        pmem_wdata      : out    vl_logic_vector(255 downto 0)
    );
end mp3;
