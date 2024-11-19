library IEEE;
use IEEE.std_logic_1164.all;
use WORK.constants.all;

--THIS MODULE IS THE PG NETWORK OF THE PENTIUM 4 ADDER AND IT IS ABLE TO GENERATE THE P AND G VALUES FROM EACH BLOCK
entity PG_network is
  generic (NBIT : integer := numBit);
  port(
    A: in std_logic_vector(NBIT-1 downto 0);
    B: in std_logic_vector(NBIT-1 downto 0);
    Pout: out std_logic_vector(NBIT-1 downto 0);
    Gout: out std_logic_vector(NBIT-1 downto 0));
end PG_network;

architecture BEHAVIORAL of PG_network is

begin

  --The PG network generates the propagate and generate terms
  Pout <= (A xor B); --Pout_i = p_i = A(i) xor B(i) --> propagate
  Gout <= (A and B); --Gout_i = g_i = A(i) and B(i) --> generate

end BEHAVIORAL;
