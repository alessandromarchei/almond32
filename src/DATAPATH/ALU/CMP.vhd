library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

--THIS BLOCK IS A GENERIC COMPARATOR, THAT IS USED TO GENERATE RESULT AFTER THE COMPARISON BETWEEN 2 INTEGERS.
--IT RECEIVES SUM AND COUT COMING FROM THE ADDER, AND THANKS TO THE ALU THAT CONFIGURES THE ADDER AS A SUBTRACTOR,
--IT IS POSSIBLE TO COMPARE THE 2 OPERANDS BY LOOKING AT THE OUTPUT RESULTS

--INTERNALLY, Z (ZERO) AND C(CARRY) SIGNALS ARE USED IN ORDER TO UNIVOCALLY ESTABILISH THE OUTCOME OF THE COMPARISON
entity CMP is
    generic (NBIT : integer := 32);
    port (
        SUM     : in std_logic_vector (NBIT -1 downto 0); --The adder receives A and B as inputs and generates SUM and Cout as outputs
        Cout    : in std_logic;
        A_L_B   : out std_logic; -- A < B
        A_LE_B  : out std_logic; -- A <= B
        A_G_B   : out std_logic; -- A > B
        A_GE_B  : out std_logic; -- A >= B
        A_E_B   : out std_logic; -- A = B
        A_NE_B  : out std_logic  -- A /= B
    );
end CMP;

architecture structural of CMP is

    signal Cn, Zn, Z: std_logic;
    
begin

    -- Bits of SUM are the inputs of NOR gate
    -- The output of NOR gate is 1 only if all the bits of SUM are equal to 0
    -- This will be synthesized using multiple NOR gates
    Z <= '1' when to_integer(unsigned(SUM))= 0 else
	 '0';
	
    Cn <= not Cout;
    Zn <= not Z;
   
    A_L_B <= Cn and Zn;
    A_GE_B <= Cout or Z;
    A_E_B <= Z;
    A_NE_B <= Zn;
    A_G_B <= Cout and Zn;
    A_LE_B <= Cn or Z;

end structural ; 