library verilog;
use verilog.vl_types.all;
entity cc_comp is
    port(
        nzp_value       : in     vl_logic_vector(2 downto 0);
        ir_dest         : in     vl_logic_vector(2 downto 0);
        branch_enable   : out    vl_logic
    );
end cc_comp;
