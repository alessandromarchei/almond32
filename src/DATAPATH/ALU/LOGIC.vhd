library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--T2 LOGIC
--We implement logic functions using only NAND gates.
--T2 implementation embeds both logical evaluation and selection, they are no longer two separeted stages.
--Logic functions are related to the selection signal according to this table:
--  S = "0001" --> NOR
--  S = "1110" --> OR
--  S = "0111" --> NAND
--  S = "1000" --> AND
--  S = "0110" --> XOR
--  S = "1001" --> XNOR

entity LOGIC is
    generic (NBIT: integer := 32;
             N_SELECTOR: integer := 4
    );
    port (
        S   : in std_logic_vector (N_SELECTOR-1 downto 0); --Selector
        A, B: in std_logic_vector (NBIT-1 downto 0); --Operands
        O   : out std_logic_vector (NBIT-1 downto 0)--Logical evaluation
    );
end LOGIC;

architecture structural of LOGIC is

    signal An, Bn: std_logic_vector(NBIT-1 downto 0);
    signal l0, l1, l2, l3: std_logic_vector(NBIT-1 downto 0);

    component IV is
        Port (	A:	In	std_logic;
            Y:	Out	std_logic);
    end component;

    component ND3 is
        port (
            A, B, C: in  std_logic;
            Y: out std_logic
        );
    end component;

    component ND4 is
        port (
            A, B, C, D: in  std_logic;
            Y: out std_logic
        );
	end component;
begin

    --FIRST PART : COMPLEMENTATION OF THE OPERANDS 'A' AND 'B'
    INV_A : for i in 0 to NBIT-1 generate
	A_i : IV port map(A(i),An(i));
    end generate;

    INV_B : for i in 0 to NBIT-1 generate
	B_i : IV port map(B(i),Bn(i));
    end generate;

    --LOGIC DESCRIBED IN THE T2 LOGICAL
    P1: for i in 0 to NBIT-1 generate
        U0: ND3 port map (S(0), An(i), Bn(i),l0(i));
        U1: ND3 port map (S(1), An(i), B(i),l1(i));
        U2: ND3 port map (S(2), A(i), Bn(i),l2(i));
        U3: ND3 port map (S(3), A(i), B(i),l3(i));
        U4: ND4 port map (l0(i), l1(i), l2(i), l3(i), O(i));
    end generate;

end structural ; 