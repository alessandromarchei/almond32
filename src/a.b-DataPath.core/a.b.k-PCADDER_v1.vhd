library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--THIS MODULES IMPLEMENTS A SIMPLE ADDER IN A BEHAVIORAL WAY.
--ALTHOUGH WITHIN THE ALU A P4 ADDER IS USED INSTEAD, THE PC-ADDER HAS BEEN DESIGNED
--THIS WAY SINCE DURING THE SYNTHESIS AN OPTIMIZATION ON THIS COMPONENT WILL BE PERFORMED
--SINCE THE 2ND OPERAND IS FIXED AT 1.
entity PC_adder is
    Port ( A, B : in STD_LOGIC_VECTOR (31 downto 0);
           Sum : out STD_LOGIC_VECTOR (31 downto 0));
end PC_adder;

architecture Behavioral of PC_adder is
begin
    process (A, B)
    begin
        Sum <= (others => '0'); 
        Sum <= A + B;            -- BINARY SUM
    end process;
end Behavioral;