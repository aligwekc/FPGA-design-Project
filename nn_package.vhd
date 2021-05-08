library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


package nn_package is

    -- Network architecture parameters
    constant NUM_X : integer := 6; -- Number of inputs
    constant NUM_L1 : integer := 8; -- Number of hidden layer neurons
    constant NUM_Y : integer := 3; -- Number of outputs
    
    -- Data representation constants
    constant N : integer := 16; -- Number of bits (data width)
    constant F : integer := 8; -- Number of fractional bits
    constant I : integer := N-F; -- Number of integer bits
    constant ONE : real := 2.0**F;
    constant ONE_int : integer := integer(ONE); -- 1 in fixed point representation
    
    -- Array types (for representing signals throughout the network
    type x_array is array(0 to NUM_X-1) of signed(N-1 downto 0); -- Array of inputs
    type y_array is array(0 to NUM_Y-1) of signed(N-1 downto 0); -- Array of outputs
    type sum1_array is array(0 to NUM_L1-1) of signed(N-1 downto 0); -- Array of hidden neuron outputs
    type sum2_array is array(0 to NUM_Y-1) of signed(N-1 downto 0); -- Array of output neuron outputs
    type a_array is array(0 to NUM_L1-1) of signed(N-1 downto 0); -- Array of hidden activation function outputs
    
    -- Array types (real valued for representation of bias, weight and
    -- normalization parameters
    type b1r_array is array(0 to NUM_L1-1) of real; -- Hidden layer biases
    type b2r_array is array(0 to NUM_Y-1) of real; -- Output layer biases
    type w1r_array is array(0 to NUM_X*NUM_L1-1) of real; -- Hidden layer weights
    type w2r_array is array(0 to NUM_L1*NUM_Y-1) of real; -- Output layer weights
    type p1r_array is array(0 to NUM_X-1) of real; -- Normalization parameters
    type p2r_array is array(0 to NUM_Y-1) of real; -- Denormalization parameters

    -- Array types (signed valued for representation of bias, weight and
    -- normalization parameters
    type b1_array is array (0 to NUM_L1-1) of signed(N-1 downto 0); -- Hidden layer biases
    type b2_array is array (0 to NUM_Y-1) of signed(N-1 downto 0); -- Output layer biases
    type w1_array is array (0 to NUM_L1-1) of x_array; -- Hidden layer weights
    type w2_array is array (0 to NUM_Y-1) of a_array; -- Output layer weights
    type p1_array is array (0 to NUM_X-1) of signed(N-1 downto 0); -- Normalization parameters
    type p2_array is array (0 to NUM_Y-1) of signed(N-1 downto 0); -- Denormalization parameters
    
    --  -- Real weights and biases
    -- hidden layer biases
    constant b1r : b1r_array := (0.85027630196538928,0.90727712641179281,0.95309656255860109,-0.37845106249305827,-0.50178883862680013,0.52140043629983168,-0.81254183659278989,-1.3901515678422789); 
    -- output layer biases
    constant b2r : b2r_array := (0.87048001214282766,-0.76711042369442239,-1.4040489640750959); 
    -- hidden layer weights
    constant w1r : w1r_array := (-1.0121921401618119, 0.21347495860798538, -0.85205926897612849, 0.99873242055578693, -0.19032632260078625, 0.52291847325998664, 0.26643775107814494, -0.10201831322458095, 0.4550343383395215, -0.2605398527846795, -0.1763752079202271, -0.38854792619871181, -0.36246105395876504, -0.41679452033201386, 0.083603730141570423, 0.73518712289609955, 0.45649960003210138, -0.11436074968043322, 0.11138402915697954, -0.30491409825307852, -0.032381284379258905, 0.076954727502122816, 0.32771259137753056, 0.021841124100181887, 0.88297547066200044, 0.72393864686560228, -0.54063031952442908, -0.83633949559387177, -0.71334245120695294, 0.35545053480628941,0.28306092887134282, -0.17769432580940506, 0.049652817843569196, -0.28375986472418269, 0.37299342684779235, -0.031045462286085797, -1.0133662541941555, 0.79300256560381177, 0.11378675748826869,1.0007295375183232, -0.52416252212153136, -0.097740711621578713, 0.3907528670774349, -0.097080600318804944, -0.015066567145772378, -0.57139019899230559, 0.081781195455330413, -0.053264858609173217);
    -- output layer weights
    constant w2r : w2r_array := (-0.070474449714484563, -0.085265325414244211, 1.1816966815535743, 5.0341028913205133, 
         -0.21579687536957853, -0.63438366739911534, -0.38562018350187727, -0.1147264074379699,
           0.14649788935236407, -0.19318228174157381, 0.009575163903197079, 0.13015193775233691, 
          0.35117664982147123, 4.5074881626559744, 1.9342957792000899, -0.17183131041969094,
       -1.6513099739683654, -0.47080099021866978, 0.07679075914390332, 1.1637555185233646,
-4.8232121677919784, 0.054910235752731927, -0.46407312171170256, -0.73164905873216579);
    -- Parameters for input and output processing
    -- min inputs
    constant p11r : p1r_array := (0.0, 0.0, 0.0, 0.00001009, 0.0000015907, 0.00000006496); 
    -- 2/(max inputs - min inputs)
    constant p12r : p1r_array := (2.0, 2.0, 2.0, 2.000100185, 2.000083185, 2.000840366); 
    -- 1's array
    constant p13r : p1r_array := (-1.0000000000, -1.0000000000, -1.0000000000, -1.0000000000, -1.0000000000,  -1.0000000000); 
    
    -- 1's array
    constant p21r : p2r_array := (-1.0000000000, -1.0000000000, -1.0000000000); 
    -- (max targets - min targets)/2
    constant p22r : p2r_array := (0.5, 0.5, 0.5); 
    -- min targets
    constant p23r : p2r_array := (0.0, 0.0, 0.0); 

end package nn_package;


