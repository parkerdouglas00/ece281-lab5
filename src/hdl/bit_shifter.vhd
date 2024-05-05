----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2024 04:47:36 PM
-- Design Name: 
-- Module Name: bit_shifter - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;


entity bit_shifter is
    port (
        --inputs
        i_direction : in std_logic;
        i_amount : in std_logic_vector(7 downto 0);
        i_original : in std_logic_vector(7 downto 0);
        
        --output
        o_shifted : out std_logic_vector(7 downto 0)
    );
end bit_shifter;

architecture Behavioral of bit_shifter is

    signal w_left_shift     :   std_logic_vector(7 downto 0)    := "00000000";
    signal w_right_shift    :   std_logic_vector(7 downto 0)    := "00000000";
    signal v_amount         :   integer                         := 0;

begin
    
    v_amount    <=  to_integer(unsigned(i_amount));
    
    w_left_shift    <=  std_logic_vector(shift_left(unsigned(i_original), v_amount));
    w_right_shift   <=  std_logic_vector(shift_right(unsigned(i_original), v_amount));
    
    with i_direction select
        o_shifted   <= w_left_shift when '0',
                       w_right_shift when others;
    
    

end Behavioral;
