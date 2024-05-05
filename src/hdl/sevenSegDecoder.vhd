--+----------------------------------------------------------------------------
--| 
--| COPYRIGHT 2023 United States Air Force Academy All rights reserved.
--| 
--| United States Air Force Academy     __  _______ ___    _________ 
--| Dept of Electrical &               / / / / ___//   |  / ____/   |
--| Computer Engineering              / / / /\__ \/ /| | / /_  / /| |
--| 2354 Fairchild Drive Ste 2F6     / /_/ /___/ / ___ |/ __/ / ___ |
--| USAF Academy, CO 80840           \____//____/_/  |_/_/   /_/  |_|
--| 
--| ---------------------------------------------------------------------------
--|
--| FILENAME      : sevenSegDecoder.vhd
--| AUTHOR(S)     : C3C Parker Douglas
--| CREATED       : 22 Feb 2023
--| DESCRIPTION   : Seven Segment Decoder - ECE 281: Lab 2
--|
--| DOCUMENTATION : Include all documentation statements in README.md
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std, unisim
--|    Files     : LIST ANY DEPENDENCIES
--|
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

-- Input: 4-bit binary value
-- 0x0 --> 0x9: Displays Value
-- 0xA --> 0xE: Not accepted, not needed in basic_cpu design requirements
-- 0xF: Represents negative value, displays "-" on seven-segment display

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity sevenSegDecoder is
    port ( i_D : std_logic_vector (3 downto 0);
           o_S : out std_logic_vector (6 downto 0));
end sevenSegDecoder;

architecture sevenSegDecoder_arch of sevenSegDecoder is

    signal c_Sa : std_logic := '1';
    signal c_Sb : std_logic := '1';
    signal c_Sc : std_logic := '1';
    signal c_Sd : std_logic := '1';
    signal c_Se : std_logic := '1';
    signal c_Sf : std_logic := '1';
    signal c_Sg : std_logic := '1';

begin

    o_S(0) <= c_Sa;
    o_S(1) <= c_Sb;
    o_S(2) <= c_Sc;
    o_S(3) <= c_Sd;
    o_S(4) <= c_Se;
    o_S(5) <= c_Sf;
    o_S(6) <= c_Sg;
    
    c_Sa <= '1' when ( (i_D = x"1") or
                       (i_D = x"4")or
                       (i_D = x"F") ) else '0';
    
    c_Sb <= '1' when ( (i_D = x"5") or
                       (i_D = x"6")or
                       (i_D = x"F") ) else '0';
    
    c_Sc <= '1' when (  (i_D = x"2") or
                        (i_D = x"F") ) else '0';
    
    c_Sd <= '1' when (  (i_D = x"1") or
                        (i_D = x"4") or
                        (i_D = x"7") or
                        (i_D = x"9") or
                        (i_D = x"F") ) else '0';
   
    c_Se <= '1' when (  (i_D = x"1") or
                        (i_D = x"3") or    
                        (i_D = x"4") or    
                        (i_D = x"5") or    
                        (i_D = x"7") or    
                        (i_D = x"9")or
                         (i_D = x"F") ) else '0';
                        
    c_Sf <= '1' when (  (i_D = x"1") or
                        (i_D = x"2") or
                        (i_D = x"3") or
                        (i_D = x"7") or
                        (i_D = x"F") ) else '0';
                        
    c_Sg <= '1' when (  (i_D = x"0") or
                        (i_D = x"1") or
                        (i_D = x"7") ) else '0';
        
end sevenSegDecoder_arch;
