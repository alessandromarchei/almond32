library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity LOGIC_tb is
end LOGIC_tb;

architecture Testbench of LOGIC_tb is
    
    component LOGIC is
        generic (NBIT: integer := 32;
                 N_SELECTOR: integer := 4
        );
        port (
            S   : in std_logic_vector (N_SELECTOR-1 downto 0); --Selector
            A, B: in std_logic_vector (NBIT-1 downto 0); --Operands
            O   : out std_logic_vector (NBIT-1 downto 0)--Logical evaluation
        );
    end component;

    signal A_tb, B_tb : std_logic_vector(31 downto 0);
    signal S_tb : std_logic_vector(3 downto 0);
    signal out_data:  std_logic_vector(31 downto 0);

begin
-- Instantiate the LOGIC entity
UUT: LOGIC port map (S => S_tb,
                    A => A_tb,
                    B => B_tb,
                    O => out_data);

-- Stimulus generation
process
begin

  wait for 10 ns;
  
  A_tb <= (others => '0');
  B_tb <= "10001000000000100000000000000000"; 
  S_tb <= "0001"; --NOR
  wait for 10 ns;

  A_tb <= (others => '1');
  B_tb <= "11111111110111111101111111111111"; 
  S_tb <= "0001"; --NOR
  wait for 10 ns;

  A_tb <= (others => '1');
  B_tb <= (others => '1'); 
  S_tb <= "0001"; --NOR
  wait for 10 ns;

  A_tb <= (others => '1');
  B_tb <= (others => '1'); 
  S_tb <= "1110"; --OR
  wait for 10 ns;

  A_tb <= "10001000000000100000000000000000";
  B_tb <= "10001000000000100000000000000000"; 
  S_tb <= "1110"; --OR
  wait for 10 ns;

  A_tb <= (others => '1');
  B_tb <= (others => '0'); 
  S_tb <= "0111"; --NAND 
  wait for 10 ns;

  A_tb <= (others => '0');
  B_tb <= (others => '0'); 
  S_tb <= "0111"; --NAND 
  wait for 10 ns;

  A_tb <= (others => '0');
  B_tb <= (others => '0');
  S_tb <= "1000"; --AND
  wait for 10 ns;

  A_tb <= "10001000000000100000000001000000";
  B_tb <= "10101000001000100000110001000011";
  S_tb <= "1000"; --AND
  wait for 10 ns;


  A_tb <= "10001000000000100000001000000000";
  B_tb <= "11110111111111011111111111111111"; 
  S_tb <= "0110"; --XOR
  wait for 10 ns;

  A_tb <= "10001000000000100000001000000000";
  B_tb <= "01110111111111011111110111111111"; 
  S_tb <= "1001"; --XNOR
  wait for 10 ns;
  
  -- Add more test cases here

  wait;
end process;

end Testbench;
