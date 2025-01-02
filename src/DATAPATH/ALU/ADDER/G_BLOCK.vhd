library IEEE;
use IEEE.std_logic_1164.all; 
use WORK.constants.all;

--THIS MODULE DESCRIBES THE G (CARRY GENERATOR) BLOCK OF THE PENTIUM 4 ADDER
entity G_block is
  port (
      A: in std_logic_vector(1 downto 0); -- A(1)=Pi:k  A(0)=Gi:k
      B: in std_logic; --Gk-1:j
      Gout: out std_logic); --Gij
end G_block;

architecture BEHAVIORAL of G_block is

begin
  
  Gout <= A(0) or (A(1) and B); --Gi:j = Gi:k + Pi:k * Gk-1:j 
  
end BEHAVIORAL;
