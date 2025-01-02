library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--THIS MODULE IMPLEMENTS A GENERIC 3 TO 1 MULTIPLEXER IN A BEHAVIORAL WAY
entity MUX3to1 is
  Generic (NBIT: integer := 32);
  Port (
    A, B, C: in std_logic_vector(NBIT-1 downto 0);
    SEL: in std_logic_vector(1 downto 0);
    Y: out std_logic_vector(NBIT-1 downto 0)
  );
end entity MUX3to1;

architecture Behavioral of MUX3to1 is
begin
  process (SEL, A, B, C)
  begin
    case SEL is
      when "00" =>
        Y <= A;
      when "01" =>
        Y <= B;
      when "10" =>
        Y <= C;
      when others => null;
    end case;
  end process;
end architecture Behavioral;
