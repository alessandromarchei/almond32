library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CMP_tb is
end CMP_tb;

architecture Testbench of CMP_tb is
    signal A, B : std_logic_vector(31 downto 0); --OPERANDS
    signal sum_tb : std_logic_vector(32 downto 0);
    signal a_less_b, a_lesseq_b, a_greater_b, a_greatereq_b, a_eq_b, a_noteq_b:  std_logic;

    component CMP is
    port (
        SUM     : in std_logic_vector (31 downto 0); --Sum of two operands (A,B)
        Cout    : in std_logic; -- Carry out of the sum A+B
        A_L_B   : out std_logic; -- A < B
        A_LE_B  : out std_logic; -- A <= B
        A_G_B   : out std_logic; -- A > B
        A_GE_B  : out std_logic; -- A >= B
        A_E_B   : out std_logic; -- A = B
        A_NE_B  : out std_logic  -- A /= B
    );
    end component;

begin

-- Instantiate the LOGIC entity
UUT: CMP
port map (
    SUM => sum_tb(31 downto 0),
    Cout => sum_tb(32),
    A_L_B => a_less_b,
    A_LE_B => a_lesseq_b,
    A_G_B  => a_greater_b,
    A_GE_B=> a_greatereq_b,
    A_E_B  => a_eq_b,
    A_NE_B => a_noteq_b
);

sum_tb <= ('0'& A) + ('0' & not(B)) + '1'; --SUM of the operands we want to compare

-- Stimulus generation
process
begin

  wait for 10 ns;
  
  --Test A=B
  A <= (others => '0');
  B <= (others => '0'); 
  wait for 10 ns;

  A <= "00000000000000000000000000000011";
  B <= "00000000000000000000000000000000"; 
  wait for 10 ns;

  --Test A>B, A>=B, A\=B
  A <= "00000000000000000000000000000001";
  B <= "00000000000000000000000000000100"; 
  wait for 10 ns;
  
  --Test A<B, A<=B, A\=B
  A <= "11111111111111111111111111111101";
  B <= "11111111111111111111111111111001";
  wait for 10 ns;

  A <= "11111111111111111111111111111101";
  B <= "11111111111111111111111111111101";
  wait for 10 ns;

  -- Add more test cases here

  wait;
end process;
end Testbench;