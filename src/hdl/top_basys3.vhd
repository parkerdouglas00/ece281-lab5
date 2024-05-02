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
        led     : out std_logic_vector(15 downto 0);
        seg     : out std_logic_vector(6 downto 0);
        an      : out std_logic_vector(3 downto 0)
    );

end top_basys3;

architecture top_basys3_arch of top_basys3 is 
  
	-- declare components and signals
	component controller_fsm is
        port ( i_reset : in std_logic;
               i_adv : in std_logic;
               i_clk   : in std_logic;
               o_cycle : out std_logic_vector(3 downto 0)
             );
    end component controller_fsm;
    
    component reg is
        port ( i_A      : in std_logic_vector(7 downto 0);
               i_clk    : in std_logic;
               o_B      : out std_logic_vector(7 downto 0)
        );
    end component reg;
    
    component ALU is
        port(
            --inputs
            i_op        : in std_logic_vector(2 downto 0);
            i_A         : in std_logic_vector(7 downto 0);
            i_B         : in std_logic_vector(7 downto 0);
            
            --outputs
            o_result    : out std_logic_vector(7 downto 0);
            o_flags     : out std_logic_vector(2 downto 0)
        );
    end component ALU;
    
    component twoscomp_decimal is
        port (
            i_binary: in std_logic_vector(7 downto 0);
            o_negative: out std_logic_vector(3 downto 0);
            o_hundreds: out std_logic_vector(3 downto 0);
            o_tens: out std_logic_vector(3 downto 0);
            o_ones: out std_logic_vector(3 downto 0)
        );
    end component twoscomp_decimal;
    
    component TDM4 is
        generic ( constant k_WIDTH : natural  := 4); -- bits in input and output
        Port ( i_clk		: in  STD_LOGIC;
               i_reset      : in  STD_LOGIC; -- asynchronous
               i_D3         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_D2         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_D1         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_D0         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               o_data       : out STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               o_sel        : out STD_LOGIC_VECTOR (3 downto 0)    -- selected data line (one-cold)
        );
    end component TDM4;
    
    component sevenSegDecoder is
        port ( i_D : in std_logic_vector (3 downto 0);
               o_S : out std_logic_vector (6 downto 0)
        );
    end component sevenSegDecoder;
    
    component clock_divider is
        generic ( constant k_DIV : natural := 2	); -- How many clk cycles until slow clock toggles
                                                   -- Effectively, you divide the clk double this 
                                                   -- number (e.g., k_DIV := 2 --> clock divider of 4)
        port (  i_clk    : in std_logic;
                i_reset  : in std_logic;           -- asynchronous
                o_clk    : out std_logic           -- divided (slow) clock
        );
    end component clock_divider;
    
    
    signal w_cycle          : std_logic_vector(3 downto 0)  := "0000";
    signal w_clk_TDM        : std_logic                     := '0';
    signal w_clk_controller : std_logic                     := '0';
    signal w_A              : std_logic_vector(7 downto 0)  := "00000000";
    signal w_B              : std_logic_vector(7 downto 0)  := "00000000";
    signal w_flags          : std_logic_vector(2 downto 0)  := "000";
    signal w_result         : std_logic_vector(7 downto 0)  := "00000000";
    signal w_binary         : std_logic_vector(7 downto 0)  := "00000000";
    signal w_negative       : std_logic_vector(3 downto 0)  := "0000";
    signal w_hundreds       : std_logic_vector(3 downto 0)  := "0000";
    signal w_tens           : std_logic_vector(3 downto 0)  := "0000";
    signal w_ones           : std_logic_vector(3 downto 0)  := "0000";
    signal w_data           : std_logic_vector(3 downto 0)  := "0000";
    signal w_sel            : std_logic_vector(3 downto 0)  := "0000";
  
begin
	-- PORT MAPS ----------------------------------------
    
    controller_fsm_inst : controller_fsm
        port map (
            -- inputs
            i_reset => btnU,
            i_adv   => btnC,
            i_clk   => w_clk_controller,
            
            -- output
            o_cycle => w_cycle
        );
        
    clock_divider_inst_TDM : clock_divider
        generic map ( k_DIV => 1000 ) -- output clock is 50 kHz
        port map (
            -- inputs
            i_clk   => clk,
            i_reset => btnU,
            
            --output
            o_clk   => w_clk_TDM
        );
        
    clock_divider_inst_controller : clock_divider
            generic map ( k_DIV => 250000 ) -- output clock is 200 Hz
            port map (
                -- inputs
                i_clk   => clk,
                i_reset => btnU,
                
                --output
                o_clk   => w_clk_controller
            );

    reg_inst_A : reg
        port map (
            --inputs
            i_clk   => w_cycle(1),
            i_A     => sw(7 downto 0),
            
            --output
            o_B     => w_A
        );
    
    reg_inst_B : reg
        port map (
            --inputs
            i_clk   => w_cycle(2),
            i_A     => sw(7 downto 0),
            
            --output
            o_B     => w_B
        );
    
    ALU_inst : ALU
        port map (
            -- inputs
            i_A     => w_A,
            i_B     => w_B,
            i_op    => sw(2 downto 0),
            
            --outputs
            o_result    => w_result,
            o_flags     => led(15 downto 13)
        );
    
    twoscomp_decimal_inst : twoscomp_decimal
        port map (
            --input
            i_binary    => w_binary,
            
            --outputs
            o_negative  => w_negative,
            o_hundreds  => w_hundreds,
            o_tens      => w_tens,
            o_ones      => w_ones
        );
    
    TDM4_inst : TDM4
        generic map ( k_WIDTH => 4 )
        port map (
            -- inputs
            i_clk   => w_clk_TDM,
            i_reset => btnU,
            i_D3 => w_negative,
            i_D2    => w_hundreds,
            i_D1    => w_tens,
            i_D0    => w_ones,
            
            --outputs
            o_data  => w_data,
            o_sel   => an
        );
    
    sevenSegDecoder_inst : sevenSegDecoder
        port map (
            --input
            i_D     => w_data,
            
            --output
            o_S     => seg
        );
	
	
	-- CONCURRENT STATEMENTS ----------------------------
	
	with w_cycle select
	   w_binary    <=  w_A when "0010",
	                   w_B when "0100",
	                   w_result when "1000",
	                   "00000000" when others;
	
	led(3 downto 0)    <= w_cycle;
	led(12 downto 4)   <= "000000000";
	
	
end top_basys3_arch;