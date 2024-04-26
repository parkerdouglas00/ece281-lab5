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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bit_shifter is
    Port ( i_direction : in STD_LOGIC;
           i_amount : in STD_LOGIC_VECTOR (7 downto 0);
           i_A : in STD_LOGIC_VECTOR (8 downto 0);
           o_B : out STD_LOGIC_VECTOR (7 downto 0));
end bit_shifter;

architecture Behavioral of bit_shifter is

begin


end Behavioral;
