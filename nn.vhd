library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.nn_package.all;

entity nn is
    Port ( 
        clk : in std_logic;
        x_in : in x_array;
        y_out : out y_array);
end nn;

architecture Behavioral of nn is

    -- Component declarations
    component n_hidden
        port (
            clk : in std_logic;
            x, w : in x_array;
            bi : in signed(N-1 downto 0);
            sum_out : out signed(N-1 downto 0));
    end component;
    
    component n_output
        port (
            clk : in std_logic;
            x, w : in a_array;
            bi : in signed(N-1 downto 0);
            sum_out : out signed(N-1 downto 0));
    end component;
    
    component input_processing     
        port (
            clk : in std_logic;
            x : in x_array;
            p1, p2, p3 : in p1_array;
            x_norm : out x_array);
    end component;
    
    component output_processing
        port (
            clk : in std_logic;
            y_norm : in y_array;
            p1, p2, p3 : in p2_array;
            y : out y_array);
    end component;
    
    component tansig
        port (
            clk : in std_logic;
            x : in signed(N-1 downto 0);
            y : out signed(N-1 downto 0));
    end component;
    
    component purelin
        port (
            clk : in std_logic;
            x : in signed(N-1 downto 0);
            y : out signed(N-1 downto 0));
    end component;
    
    
    -- Intermediate signal declarations
    signal b1 : b1_array;
    signal w1 : w1_array;
    signal sum1 : sum1_array;
    signal a1 : a_array;
    signal b2 : b2_array;
    signal w2 : w2_array;
    signal sum2 : sum2_array;
    signal p11, p12, p13 : p1_array;
    signal p21, p22, p23 : p2_array;
    signal x, x_norm : x_array;
    signal y, y_norm : y_array;

begin
    
    -- Generate signed parameter arrays for input processing
    P1GEN: for i in 0 to NUM_X-1 generate
    begin
        p11(i) <= to_signed(integer(p11r(i)*ONE),N);
        p12(i) <= to_signed(integer(p12r(i)*ONE),N);
        p13(i) <= to_signed(integer(p13r(i)*ONE),N);
    end generate;
    
    -- Generate signed parameter arrays for output processing
    P2GEN: for i in 0 to NUM_Y-1 generate
    begin
        p21(i) <= to_signed(integer(p21r(i)*ONE),N);
        p22(i) <= to_signed(integer(p22r(i)*ONE),N);
        p23(i) <= to_signed(integer(p23r(i)*ONE),N);
    end generate;

	-- Generate signed hidden layer weights and biases
	W1GEN: for j in 0 to NUM_L1-1 generate
    begin
       W1GEN_0: for i in 0 to NUM_X-1 generate
        begin
            w1(j)(i) <= to_signed(INTEGER(w1r(j*NUM_X+i)*ONE), N);
        end generate;
        b1(j) <= to_signed(INTEGER(b1r(j)*ONE), N);
    end generate;
	
	-- Generate signed output layer weights and biases
    W2GEN: for j in 0 to NUM_Y-1 generate
    begin
        W2GEN_0: for i in 0 to NUM_L1-1 generate
        begin
            w2(j)(i) <= to_signed(INTEGER(w2r(j*NUM_L1+i)*ONE), N);
        end generate;
        b2(j) <= to_signed(INTEGER(b2r(j)*ONE), N);
    end generate;
	
	-- Input processing
    process_input_unit: input_processing
    port map (clk=>clk, x=>x, p1=>p11, p2=>p12, p3=>p13, x_norm=>x_norm);
	
    -- Hidden layer neurons
    L1_GEN0: for j in 0 to NUM_L1-1 generate
    begin 
    L1_GEN1: n_hidden port map(clk => clk, x=>x_norm, w =>w1(j), bi=>b1(j), sum_out => sum1(j));
    end generate;
    
    -- Tansig transfer function for hidden layer
    TF1_GEN0: for j in 0 to NUM_L1-1 generate
    begin 
    TF1_GEN1: tansig port map (clk=>clk, x=>sum1(j), y=>a1(j));
    end generate;
	
    -- Output layer neurons
    L2_GEN0: for j in 0 to NUM_Y-1 generate
    begin 
    L2_GEN1: n_output port map(clk => clk, x=>a1, w =>w2(j), bi=>b2(j), sum_out => sum2(j));
    end generate;
	
    
    -- Purelin transfer function for output layer
    TF2_GEN0: for i in 0 to NUM_Y-1 generate 
    begin
    TF2_GEN1: purelin port map (clk=>clk, x=>sum2(i), y=>y_norm(i));
    end generate;
	
    
    -- Output Processing
    process_output_unit: output_processing
    port map (clk=>clk, y_norm=>y_norm, p1=>p21, p2=>p22, p3=>p23, y=>y);
        
    x <= x_in;
    y_out <= y;

end Behavioral;
