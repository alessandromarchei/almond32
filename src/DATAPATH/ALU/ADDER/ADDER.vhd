library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all; -- we need a conversion to unsigned
use ieee.math_real.all;
use WORK.constants.all;

--THE ADDER USED IN THE PENTIUM 4 IS MADE UP OF TWO MAIN SUB-BLOCKS:
--  1) A CARRY SELECT FOR THE SUM GENERATION
--  2) A SPARSE TREE FOR THE CARRY GENERATION

--THE CLA-SPARSE TREE CARRY GENERATOR RECIEVES A, B AND A CARRY IN AS INPUTS
--AND GENERATES A CARRY EVERY NBIT_PER_BLOCK, ACCORDING TO ITS OWN ALGORITHM.
--RECALL THAT THE CARRY IN IS EQUAL TO THE FIRST CARRY OUT (C_0) GENERATED BY THE CARRY GENERATOR,  
--WHILE THE LAST ONE (C_NBIT) IS THE CARRY OUT OF THE FINAL SUM COMPUTED BY THE P4 ADDER(Cout).

--THE OUTPUTS OF CARRY GENERATOR FEED THE ADDER PART, WHICH IS COMPOSED BY SEVERAL CARRY SELECT ADDERS
--                      #CSA = NBIT/NBIT_PER_BLOCK
--EACH OF THEM RECIEVES A CARRY FORM THE CARRY GENERATOR THAT ACTS AS A SELECTOR
--FOR THE MUX THAT IS INTO THAT CS-BLOCK.

entity ADDER is
  generic (NBIT: integer := 32;
           NBIT_PER_BLOCK: integer := 4);
  port (
         A: in std_logic_vector(NBIT-1 downto 0);
         B: in std_logic_vector(NBIT-1 downto 0);
         ADD_SUB: in std_logic; -- Bit to select addition/subtraction
         Cin: in std_logic; -- Transparent in addition, fixed to 1 in subtraction
         S: out std_logic_vector(NBIT-1 downto 0);
         Cout: out std_logic
         );
end ADDER;


architecture STRUCTURAL of ADDER is
  
  component CARRY_GENERATOR
  generic (NBIT : integer := 8*numBit;
           NBIT_PER_BLOCK : integer := numBit); --NBIT/NBIT_PER_BLOCK = NBLOCKS
  port (
      A: in std_logic_vector (NBIT-1 downto 0); 
      B: in std_logic_vector (NBIT-1 downto 0);
      Cin: in std_logic; --Cin = c0
      Co: out std_logic_vector (NBIT/NBIT_PER_BLOCK downto 0) --MSB is Cout 
  );                                                                                                             
  end component;

  component SUM_GEN_N
    generic ( NBIT_PER_BLOCK: integer := numBit;
              NBLOCKS: integer := 8);
     port (
            A:	in	std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0);
            B:	in	std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0);
            Ci:	in	std_logic_vector(NBLOCKS-1 downto 0);
            S:	out	std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0));
  end component;

  --vector of carries generated by CARRY_GENERATOR
  signal carry : std_logic_vector(NBIT/NBIT_PER_BLOCK downto 0);
  signal B_in : std_logic_vector(NBIT-1 downto 0);
  signal C_internal : std_logic;

  begin
  
  C_internal <= Cin when (ADD_SUB = '0') else 
                '1';
  
  B_in <= B when (ADD_SUB = '0') else
          not(B);

  Cout <= carry(NBIT/NBIT_PER_BLOCK);

  U1: CARRY_GENERATOR
    generic map (NBIT, NBIT_PER_BLOCK)
    port map (A, B_in, C_internal, carry);

  U2: SUM_GEN_N
    generic map (NBIT_PER_BLOCK, NBIT/NBIT_PER_BLOCK)
    port map (A, B_in, carry(NBIT/NBIT_PER_BLOCK-1 downto 0), S);
 
 
  end STRUCTURAL;