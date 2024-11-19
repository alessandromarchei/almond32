library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--THIS SIMPLE BLOCK IS A 4-BIT NAND IMPLEMENTED IN A BEHAVIORAL WAY
--IT IS USED INSIDE THE LOGICAL BLOCK WITHIN THE ALU
entity ND4 is
    port (
        A, B, C, D: in  std_logic;
        Y: out std_logic
    );
end entity;

architecture ARCH1 of ND4 is

begin
    process (A,B,C,D)
    begin
        if (A='1' and B='1' and C='1' and D='1') then
            Y <= '0';
        else
            Y <='1';
        end if;
    end process;

end ARCH1;