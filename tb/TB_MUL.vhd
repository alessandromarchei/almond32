library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TB_MUL is
    end TB_MUL;

architecture Testbench of TB_MUL is


component MUL is
        Port (	CLOCK : in std_logic;
              A:	In	std_logic_vector(15 downto 0);
              B:	In	std_logic_vector(15 downto 0);
                  Y:	Out	std_logic_vector(31 downto 0));
    end component;


signal ain, bin : std_logic_vector(15 downto 0);
signal yout : std_logic_vector(31 downto 0);
signal clk : std_logic := '0';

begin

DUT : MUL port map(clk, ain, bin, yout);

PCLOCK : process(clk)
begin
    clk <= not(clk) after 0.5 ns;	
end process;

TEST : process
begin

    wait for 1.5 ns;

    ain <= "0000000000001010";      --10
    bin <= "0001110100000100";      --4
    --YOUT EXPECTED = 40
    wait for 1 ns;

    ain <= "0000000000010100";        --20
    bin <= "0000000001101011";        --3
    --YOUT EXPECTED = 60
    wait for 1 ns;

    ain <= "0000000000000111";          --7
    bin <= "0110000001010100";          --4
    --YOUT EXPECTED = 28
    wait for 1 ns;

    ain <= "0000000000101010";          --7
    bin <= "0000110101000100";          --4
    --YOUT EXPECTED = 28
    wait for 1 ns;


end process;



end architecture;

