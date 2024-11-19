library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; -- we need a conversion to unsigned
use WORK.constants.all;

--THIS MODULE PRESENTS THE CARRY SELECT FOR THE PENTIUM 4 ADDER
--IT IS DESIGNED IN A STRUCTURAL WAY AND IT CONTAINS BOTH THE RCA WITH A PRE-INFERED INPUT EQUAL TO 1
-- AND ANOTHER WITH A FORCED CARRY IN = 0, SO THAT PRE-COMPUTATION CAN OCCUR
entity CARRY_SEL_N is
  generic(NBIT: integer := numBit);
  port (A:       in std_logic_vector(NBIT-1 downto 0);
        B:       in std_logic_vector(NBIT-1 downto 0);
        Ci:      in  std_logic;
        S:       out  std_logic_vector(NBIT-1 downto 0));
end CARRY_SEL_N;

architecture STRUCTURAL of CARRY_SEL_N is
  component RCAN
        generic ( NBIT : integer := numBit);
	Port (	A:	In	std_logic_vector(NBIT-1 downto 0);
		B:	In	std_logic_vector(NBIT-1 downto 0);
		Ci:	In	std_logic;
		S:	Out	std_logic_vector(NBIT-1 downto 0);
		Co:	Out	std_logic);
  end component;

  component MUX2to1 is
        Generic (NBIT: integer:= numBit);
	Port (	A:	In	std_logic_vector(NBIT-1 downto 0);
                B:	In	std_logic_vector(NBIT-1 downto 0);
		SEL:	In	std_logic;
		Y:	Out	std_logic_vector(NBIT-1 downto 0));
  end component;

  signal S1, S0: std_logic_vector(NBIT-1 downto 0);
  signal Cout0, Cout1: std_logic; --these signals contain the carry out generated by the two
                                  --adders (actually, we'll neglect the carry out)
                                              
  begin

      --INSTANTIATON OF BOTH THE RIPPLE CARRYS

      --RIPPLE CARRY WITH INPUT = 1
     RCA1: RCAN   
           generic map (NBIT)
           port map (A, B, '1', S1, Cout1);
     
      --RIPPLE CARRY WITH INPUT = 0
     RCA0: RCAN 
	   generic map (NBIT)
           port map (A, B, '0', S0, Cout0);

      --SELECTOR ABLE TO SELECT THE PROPER OUTPUT BASED ON THE PREVIOUS RCA MODULE
     MUX21: MUX2to1
	   generic map (NBIT)
	   port map (S0, S1, Ci, S);
     
    
end STRUCTURAL;