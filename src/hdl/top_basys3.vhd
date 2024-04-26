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


entity top_basys3 is
    port (
        --inputs
        clk     : in std_logic; -- native 100MHz FPGA clock
        btnU    : in std_logic;
        btnC    : in std_logic;
        sw      : in std_logic_vector(15 downto 0);
        
        --outputs
        led     : out std_logic_vector(15 downto 13);
        seg     : out std_logic_vector(7 downto 0);
        an      : out std_logic_vector(3 downto 0)
    );

end top_basys3;

architecture top_basys3_arch of top_basys3 is 
  
	-- declare components and signals
	component controller_fsm is
        port ( i_reset : in std_logic;
               i_adv : in std_logic;
               o_cycle : out std_logic_vector(3 downto 0)
             );
    end component controller_fsm;
    
    component reg is
        port ( i_A      : in std_logic_vector(7 downto 0);
               i_clk    : in std_logic;
               o_B      : out std_logic_vector(7 downto 0)
        );
    end component reg;
    
    -- ALU Component
    
    -- twoscomp_decimal component
    
    -- TDM4 component
    
    -- sevenSegDecoder component
    
    -- clock divider component

  
begin
	-- PORT MAPS ----------------------------------------
    
    -- controller_fsm_inst
    
    -- register_inst_A
    
    -- register_inst_B
    
    -- ALU_inst
    
    -- twoscomp_decimal_inst
    
    -- TDM4 inst
    
    -- sevenSegDecoder inst
    
    -- cock_divider_inst
	
	
	-- CONCURRENT STATEMENTS ----------------------------
	
	
	
end top_basys3_arch;
