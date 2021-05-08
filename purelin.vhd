 ----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2019/04/04 20:30:34
-- Design Name: 
-- Module Name: purelin - Behavioral
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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity purelin is
	Generic ( N : integer := 16);
    Port ( x : in signed(N-1 downto 0);
           y : out signed(N-1 downto 0);
           clk : std_logic);
end purelin;

architecture Behavioral of purelin is

begin
process(clk)
begin
if (rising_edge(clk))then
    y <= x;
end if;
end process;
end Behavioral;
