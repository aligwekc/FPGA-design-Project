library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.nn_package.all;

entity n_hidden is
    Port ( 
        clk : in std_logic; 
        x, w : in x_array;
        bi : in signed(N-1 downto 0);
        sum_out : out signed(N-1 downto 0));
end n_hidden;

architecture Behavioral of n_hidden is
    component mult 
         Port ( a : in SIGNED (N-1 downto 0);
           b : in SIGNED (N-1 downto 0);
           c : out SIGNED (N-1 downto 0));
    end component;
    
    signal mult_array : x_array;
    signal sum : signed(N-1 downto 0);

begin
mult_1:  for i in 0 to NUM_X-1 generate
   begin
   mult_1: mult
   port map(a => x(i),  b => w(i), c => mult_array(i));
   end generate;
   -- Multiply each input with its corresponding weight
  
    -- YOUR CODE HERE
process (clk)
	variable temp_sum1 : signed(15 downto 0);
	begin 
	if rising_edge(clk) then
	       temp_sum1  := (others=>'0');
	
         sum_1: for i in 0 to NUM_X-1 loop
         --begin
         temp_sum1 := mult_array(i) + temp_sum1; 
         end loop;
         temp_sum1 := temp_sum1 + bi;
     end if;
     sum <= temp_sum1;
     end process;
    -- Sum the products and bias
    
    -- YOUR CODE HERE
    sum_out <= resize(sum, N);
end Behavioral;
