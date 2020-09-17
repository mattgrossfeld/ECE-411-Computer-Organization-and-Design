library verilog;
use verilog.vl_types.all;
entity cache_control is
    port(
        counter_pick    : out    vl_logic_vector(1 downto 0);
        clk             : in     vl_logic;
        hit0            : in     vl_logic;
        hit1            : in     vl_logic;
        write_data0     : out    vl_logic;
        write_data1     : out    vl_logic;
        write_tag0      : out    vl_logic;
        write_tag1      : out    vl_logic;
        write_dirty0    : out    vl_logic;
        write_dirty1    : out    vl_logic;
        write_valid0    : out    vl_logic;
        write_valid1    : out    vl_logic;
        write_lru       : out    vl_logic;
        valid0          : in     vl_logic;
        valid1          : in     vl_logic;
        valid0_out      : out    vl_logic;
        valid1_out      : out    vl_logic;
        dirty0          : in     vl_logic;
        dirty1          : in     vl_logic;
        dirty0_out      : out    vl_logic;
        dirty1_out      : out    vl_logic;
        lru             : in     vl_logic;
        lru_out         : out    vl_logic;
        addr_mux_sel    : out    vl_logic_vector(1 downto 0);
        datainmux_sel   : out    vl_logic;
        mem_read        : in     vl_logic;
        mem_write       : in     vl_logic;
        mem_byte_enable : in     vl_logic_vector(3 downto 0);
        mem_resp        : out    vl_logic;
        pmem_resp       : in     vl_logic;
        pmem_read       : out    vl_logic;
        pmem_write      : out    vl_logic
    );
end cache_control;
