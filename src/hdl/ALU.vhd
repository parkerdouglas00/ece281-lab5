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
	
    component bit_shifter is
        port (
            --inputs
            i_direction : in std_logic;
            i_amount : in std_logic_vector(7 downto 0);
            i_original : in std_logic_vector(7 downto 0);
            
            --output
            o_shifted : out std_logic_vector(7 downto 0)
        );
    end component;
	
	-- signals
	
	signal w_A         :   std_logic_vector(7 downto 0)   := "00000000";
	signal w_B         :   std_logic_vector(7 downto 0)   := "00000000";
	signal w_sum       :   std_logic_vector(7 downto 0)   := "00000000";
    signal w_Cout      :   std_logic                      := '0';
    signal v_sum       :   integer                        := 0;
    signal v_A         :   integer                        := 0;
    signal v_B         :   integer                        := 0;
    signal w_B_neg     :   std_logic_vector(7 downto 0)   := "00000000";
    signal w_B_adj     :   std_logic_vector(7 downto 0)   := "00000000";
	signal w_and       :   std_logic_vector(7 downto 0)   := "00000000";
	signal w_or        :   std_logic_vector(7 downto 0)   := "00000000";
	signal w_and_or    :   std_logic_vector(7 downto 0)   := "00000000";
	signal w_result    :   std_logic_vector(7 downto 0)   := "00000000";
	signal w_shifted   :   std_logic_vector(7 downto 0)   := "00000000";
	

  
begin
	-- PORT MAPS ----------------------------------------
	
	bit_shifter_inst : bit_shifter
	   port map (
	       -- inputs
	       i_direction => i_op(0),
	       i_original  => i_A,
	       i_amount    => i_B,
	       
	       --output
	       o_shifted   => w_shifted
	   );

	
	
	-- CONCURRENT STATEMENTS ----------------------------
	v_A        <= to_integer(unsigned(i_A));
	
	v_sum      <= v_A + v_B;
	w_sum      <= std_logic_vector(to_unsigned(v_sum, 8));
	w_Cout     <= i_A(7) and i_B(7);
	
	w_B_neg    <= std_logic_vector(to_unsigned(to_integer(unsigned(not i_B)) + 1, 8));
	
	with i_op(0) select
	   v_B <=  to_integer(unsigned(i_B)) when '0',
	           to_integer(unsigned(w_B_neg)) when others;
	           
	w_and  <= i_A and i_B;
	w_or   <= i_A or i_B;
	
	with i_op(0) select
	   w_and_or    <= w_and when '0',
	                  w_or when others;
	
	with i_op(2 downto 1) select
	   w_result    <=  w_and_or    when "01",
	                   w_shifted   when "10",
	                   w_sum       when others;
	
	
	o_flags(0) <= w_Cout;
	
	with w_sum select
	   o_flags(1)  <= '1' when "00000000",
	                  '0' when others;
	
	o_flags(2)     <= w_sum(7);
	
	o_result       <= w_result;
	
	
end behavioral;