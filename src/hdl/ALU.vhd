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
--|
--| ALU OPCODES:
--|
--|     ADD         000
--|     SUBTRACT    001
--|     AND         010
--|     OR          011
--|     LEFT SHIFT  100
--|     RIGHT SHIFT 101
--|
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity ALU is
    port(
        --inputs
        i_op        : in std_logic_vector(2 downto 0);
        i_A         : in std_logic_vector(7 downto 0);
        i_B         : in std_logic_vector(7 downto 0);
        
        --outputs
        o_result    : out std_logic_vector(7 downto 0);
        o_flags     : out std_logic_vector(2 downto 0)
    );
end ALU;

architecture behavioral of ALU is 
  
	-- declare components and signals
	
	-- components
	
	-- Task C: bit_shifter
	
	-- signals
	
	signal w_A     :   std_logic_vector(7 downto 0)  := "00000000";
	signal w_B     :   std_logic_vector(7 downto 0)  := "00000000";
	signal w_sum   :   std_logic_vector(7 downto 0)  := "00000000";
    signal w_Cout  :   std_logic    := '0';
    signal v_sum   :   integer := 0;
    signal v_A     :   integer := 0;
    signal v_B     :   integer := 0;
    -- Task B: w_B_neg
    -- Task B: w_B_adj
	-- Task C: signal w_and   : std_logic_vector(7 downto 0)  := "00000000";
	-- Task C: signal w_or    : std_logic_vector(7 downto 0)  := "00000000";
	-- Task C: w_and_or
	-- Task C: w_result
	-- Task C: w_shifted
	

  
begin
	-- PORT MAPS ----------------------------------------

	
	
	-- CONCURRENT STATEMENTS ----------------------------
	v_A    <= to_integer(unsigned(i_A));
	v_B    <= to_integer(unsigned(i_B));
	v_sum  <= v_A + v_B;
	w_sum  <= std_logic_vector(to_unsigned(v_sum, 8));
	w_Cout <= i_A(7) and i_B(7);
	
	o_flags(0) <= w_Cout;
	
	with w_sum select
	   o_flags(1)  <= '1' when "00000000",
	                  '0' when others;
	
	o_flags(2)     <= w_sum(7); -- temp i_op operation
	
	o_result       <= w_sum;
	
	
end behavioral;
