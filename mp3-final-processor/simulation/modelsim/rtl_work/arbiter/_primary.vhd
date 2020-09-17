library verilog;
use verilog.vl_types.all;
entity arbiter is
    port(
        clk             : in     vl_logic;
        pmem_resp_i     : out    vl_logic;
        pmem_rdata_i    : out    vl_logic_vector(255 downto 0);
        pmem_read_i     : in     vl_logic;
        pmem_write_i    : in     vl_logic;
        pmem_address_i  : in     vl_logic_vector(31 downto 0);
        pmem_wdata_i    : in     vl_logic_vector(255 downto 0);
        pmem_resp_d     : out    vl_logic;
        pmem_rdata_d    : out    vl_logic_vector(255 downto 0);
        pmem_read_d     : in     vl_logic;
        pmem_write_d    : in     vl_logic;
        pmem_address_d  : in     vl_logic_vector(31 downto 0);
        pmem_wdata_d    : in     vl_logic_vector(255 downto 0);
        mem_address_out : out    vl_logic_vector(31 downto 0);
        mem_read_out    : out    vl_logic;
        mem_write_out   : out    vl_logic;
        mem_wdata_out   : out    vl_logic_vector(255 downto 0);
        mem_rdata_out   : in     vl_logic_vector(255 downto 0);
        mem_resp_out    : in     vl_logic
    );
end arbiter;
