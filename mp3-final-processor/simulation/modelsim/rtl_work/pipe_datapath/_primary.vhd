library verilog;
use verilog.vl_types.all;
entity pipe_datapath is
    port(
        clk             : in     vl_logic;
        read_a          : out    vl_logic;
        address_a       : out    vl_logic_vector(31 downto 0);
        resp_a          : in     vl_logic;
        rdata_a         : in     vl_logic_vector(31 downto 0);
        read_b          : out    vl_logic;
        write_b         : out    vl_logic;
        wmask_b         : out    vl_logic_vector(3 downto 0);
        address_b       : out    vl_logic_vector(31 downto 0);
        wdata_b         : out    vl_logic_vector(31 downto 0);
        resp_b          : in     vl_logic;
        rdata_b         : in     vl_logic_vector(31 downto 0);
        counter_pick_i  : in     vl_logic_vector(1 downto 0);
        counter_pick_d  : in     vl_logic_vector(1 downto 0);
        counter_pick_L2 : in     vl_logic_vector(1 downto 0)
    );
end pipe_datapath;
