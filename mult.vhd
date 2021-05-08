
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.nn_package.all;

entity mult is
    Port ( a : in SIGNED (N-1 downto 0);
           b : in SIGNED (N-1 downto 0);
           c : out SIGNED (N-1 downto 0));
end mult;

architecture Behavioral of mult is
    signal temp: SIGNED (2*N-1 downto 0);
begin

    temp <= a*b;
    c <= temp(2*N-1-I downto F);

end Behavioral;
