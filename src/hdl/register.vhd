--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg is
    port ( i_A      : in std_logic_vector(7 downto 0);
           i_clk    : in std_logic;
           o_B      : out std_logic_vector(7 downto 0)
    );
end reg;

architecture Behavioral of reg is
    signal f_A      : std_logic_vector(7 downto 0) := "00000000";
    signal f_B      : std_logic_vector(7 downto 0) := "00000000";

    begin
        process(i_clk)
        begin
        if rising_edge(i_clk) then
            f_B <= f_A;
        end if;
        end process;
        
        f_A <= i_A;
        o_B <= f_B;


end Behavioral;
