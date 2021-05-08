----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2019/04/04 19:50:09
-- Design Name: 
-- Module Name: tansig - Behavioral
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

entity tansig is
	Generic ( N : integer := 16;
			  F : integer := 6);
    Port ( x : in signed (N-1 downto 0);
           y : out signed (N-1 downto 0);
           CLK : in STD_LOGIC);
end tansig;

architecture Behavioral of tansig is
	constant ONE : real := 2.0**F;
    constant one_s : signed(N-1 downto 0) := to_signed(integer(1.0*ONE), N);
    constant neg_one_s : signed(N-1 downto 0) := to_signed(integer(-1.0*ONE), N);
    constant L : signed(N-1 downto 0) := to_signed(integer(2.0*ONE), N);
    constant neg_L : signed(N-1 downto 0) := to_signed(integer(-2.0*ONE), N);
    
    signal z1,z1_1,z_1 : signed(N-1 downto 0);
    signal H: signed (2*N-1 downto 0);
    signal neg : std_logic;
begin
process(CLK)
begin
if(rising_edge(CLK))then
    z1_1 <= z1;
    z_1 <= x;
end if;
end process;
    neg <= x(N-1);
    
    z1 <= one_s + shift_right(x, 2) when neg = '1' else
          one_s - shift_right(x, 2);
    
    H <= z_1*z1_1;

    y <= one_s when z_1 > L else
         neg_one_s when z_1 < neg_L else
         H(N+F-1 downto F);
         
end Behavioral;

