library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


--THIS SIMPLE BLOCK IS A 3-BIT NAND IMPLEMENTED IN A BEHAVIORAL WAY
--IT IS USED INSIDE THE LOGICAL BLOCK WITHIN THE ALU
entity ND3 is
    port (
        A, B, C: in  std_logic;
        Y: out std_logic
    );
end entity;

architecture ARCH1 of ND3 is
begin
    P1: process (A,B,C)
    begin
        if (A='1' and B='1' and C='1') then
           Y <= '0';
        else 
            Y<='1';
        end if;
    end process;

end ARCH1;