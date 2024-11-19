library IEEE;
use IEEE.std_logic_1164.all;
use WORK.constants.all;

--THIS MODULE DESCRIBES THE PG (CARRY GENERATOR AND PROPAGATOR) BLOCK OF THE PENTIUM 4 ADDER

entity PG_block is
  port (
    A: in std_logic_vector(1 downto 0);        --A(1)=Pi:k       A(0)=Gi:k
    B: in std_logic_vector(1 downto 0);        --B(1)=Pk-1:j     B(0)=Gk-1;j
    PGout: out std_logic_vector (1 downto 0)); --PGout(1)=Pi:j   PGout(0)=Gi:j
end PG_block;

architecture BEHAVIORAL of PG_block is
  
begin
  
  PGout(0) <= A(0) or (A(1) and B(0));        --Gi:j = Gi:k + Pi:k * Gk-1:j
  PGout(1) <= A(1) and B(1);                  --Pi:j = Pi:k * Pk-1:j 
  
end BEHAVIORAL;
