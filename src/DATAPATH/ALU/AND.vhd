-- 2-input AND gate
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--THIS MODULE IS A SIMPLE BEHAVIORAL 2 BIT AND BLOCK, USED FREQUENTLY WITHIN THE DATAPATH OF THE DLX
entity AND2 is
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           Y : out STD_LOGIC);
end AND2;

architecture Behavioral of AND2 is
begin
    Y <= A AND B;
end Behavioral;
