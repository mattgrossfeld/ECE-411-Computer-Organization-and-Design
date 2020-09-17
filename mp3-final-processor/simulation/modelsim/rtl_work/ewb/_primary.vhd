library verilog;
use verilog.vl_types.all;
entity ewb is
    port(
        clk             : in     vl_logic;
        read_ewb        : in     vl_logic;
        write_ewb       : in     vl_logic;
        wdata_ewb       : in     vl_logic_vector(255 downto 0);
        address_ewb     : in     vl_logic_vector(31 downto 0);
        pmem_resp       : in     vl_logic;
        pmem_rdata      : in     vl_logic_vector(255 downto 0);
        ewb_resp        : out    vl_logic;
        rdata_ewb       : out    vl_logic_vector(255 downto 0);
        pmem_read       : out    vl_logic;
        pmem_write      : out    vl_logic;
        pmem_address    : out    vl_logic_vector(31 downto 0);
        pmem_wdata      : out    vl_logic_vector(255 downto 0)
    );
end ewb;
