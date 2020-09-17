library verilog;
use verilog.vl_types.all;
entity ewb_datapath is
    port(
        clk             : in     vl_logic;
        read_entry      : in     vl_logic;
        write_entry     : in     vl_logic;
        entry_written   : in     vl_logic;
        wdata_ewb       : in     vl_logic_vector(255 downto 0);
        address_ewb     : in     vl_logic_vector(31 downto 0);
        pmem_rdata      : in     vl_logic_vector(255 downto 0);
        rdata_ewb       : out    vl_logic_vector(255 downto 0);
        pmem_wdata      : out    vl_logic_vector(255 downto 0);
        pmem_address    : out    vl_logic_vector(31 downto 0);
        hit             : out    vl_logic
    );
end ewb_datapath;
