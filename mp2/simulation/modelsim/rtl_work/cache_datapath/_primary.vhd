library verilog;
use verilog.vl_types.all;
entity cache_datapath is
    port(
        clk             : in     vl_logic;
        hit0            : out    vl_logic;
        hit1            : out    vl_logic;
        write_data0     : in     vl_logic;
        write_data1     : in     vl_logic;
        write_tag0      : in     vl_logic;
        write_tag1      : in     vl_logic;
        write_dirty0    : in     vl_logic;
        write_dirty1    : in     vl_logic;
        write_valid0    : in     vl_logic;
        write_valid1    : in     vl_logic;
        write_lru       : in     vl_logic;
        addr_mux_sel    : in     vl_logic_vector(1 downto 0);
        datainmux_sel   : in     vl_logic;
        valid0_dataout  : out    vl_logic;
        valid1_dataout  : out    vl_logic;
        valid0_datain   : in     vl_logic;
        valid1_datain   : in     vl_logic;
        dirty0_dataout  : out    vl_logic;
        dirty1_dataout  : out    vl_logic;
        dirty0_datain   : in     vl_logic;
        dirty1_datain   : in     vl_logic;
        lru_dataout     : out    vl_logic;
        lru_datain      : in     vl_logic;
        mem_byte_enable : in     vl_logic_vector(3 downto 0);
        mem_address     : in     vl_logic_vector(31 downto 0);
        mem_wdata       : in     vl_logic_vector(31 downto 0);
        mem_rdata       : out    vl_logic_vector(31 downto 0);
        pmem_rdata      : in     vl_logic_vector(255 downto 0);
        pmem_wdata      : out    vl_logic_vector(255 downto 0);
        pmem_address    : out    vl_logic_vector(31 downto 0)
    );
end cache_datapath;
