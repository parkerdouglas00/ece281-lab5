----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2024 02:49:38 PM
-- Design Name: 
-- Module Name: controller_fsm - Behavioral
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

entity controller_fsm is
    Port ( i_reset : in std_logic;
           i_adv : in std_logic;
           o_cycle : out std_logic_vector(3 downto 0)
           );
end controller_fsm;

architecture Behavioral of controller_fsm is

    signal f_Q      : std_logic_vector(3 downto 0) := "0001";
    signal f_Q_next : std_logic_vector(3 downto 0) := "0001";
    signal last_state : std_logic := '0';

begin
    process(i_adv, i_reset)
    begin
        if i_reset = '1' then
            f_Q         <= "0001";
        elsif i_adv = '1' and last_state = '0' then
            f_Q <= f_Q_next;
        end if;
        last_state <= i_adv;
    end process;
   
    with f_Q select
        f_Q_next <= "0010" when "0001",
                    "0100" when "0010",
                    "1000" when "0100",
                    "0001" when others;
        
        o_cycle <= f_Q;
   


end Behavioral;
