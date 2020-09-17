library verilog;
use verilog.vl_types.all;
entity ewb_control is
    port(
        clk             : in     vl_logic;
        hit             : in     vl_logic;
        write_ewb       : in     vl_logic;
        read_ewb        : in     vl_logic;
        pmem_resp       : in     vl_logic;
        read_entry      : out    vl_logic;
        write_entry     : out    vl_logic;
        entry_written   : out    vl_logic;
        ewb_resp        : out    vl_logic;
        pmem_read       : out    vl_logic;
        pmem_write      : out    vl_logic
    );
end ewb_control;
