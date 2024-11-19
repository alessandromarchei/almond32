library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--THIS MODULE IMPLEMENTS A GENERIC 5 TO 1 MULTIPLEXER IN A BEHAVIORAL WAY
entity MUX5to1 is
  Generic (NBIT: integer := 32);
  Port (
    A, B, C, D, E: in std_logic_vector(NBIT-1 downto 0);
    SEL: in std_logic_vector(2 downto 0);
    Y: out std_logic_vector(NBIT-1 downto 0)
  );
end entity MUX5to1;

architecture Behavioral of MUX5to1 is
begin
  process (SEL, A, B, C, D, E)
  begin
    case SEL is
      when "000" =>
        Y <= A;
      when "001" =>
        Y <= B;
      when "010" =>
        Y <= C;
      when "011" =>
        Y <= D;
      when "100" =>
        Y <= E;
      when others => null;
    end case;
  end process;
end architecture Behavioral;
