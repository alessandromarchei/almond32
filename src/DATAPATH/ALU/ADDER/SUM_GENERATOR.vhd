library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; -- we need a conversion to unsigned
use WORK.constants.all;

--THIS MODULE IS A GENERIC SUM GENERATOR OF THE PENTIUM 4 ADDER
--IT CONTAINS A SERIES OF CARRY SELECTORS ADDERS THAT WILL GENERATE THE BLOCKS OF THE OUTPUT VECTOR
entity SUM_GEN_N is
  generic ( NBIT_PER_BLOCK: integer := numBit;
            NBLOCKS:	integer := 8);
  port (
         A:	in	std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0);
         B:	in	std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0);
         Ci:	in	std_logic_vector(NBLOCKS-1 downto 0);
         S:	out	std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0));
end SUM_GEN_N;


architecture STRUCTURAL of SUM_GEN_N is
  
  component CARRY_SEL_N    
    generic(NBIT: integer := numBit);
    port (A:       in   std_logic_vector(NBIT-1 downto 0);
          B:       in   std_logic_vector(NBIT-1 downto 0);
          Ci:      in   std_logic;
          S:       out  std_logic_vector(NBIT-1 downto 0));
  end component;

  begin

    --Each carry select block operates on a small group of bits of the two
    --operands (A and B)
    --Each block will receive a carry in (Ci) form carry generator and
    --will compute the sum (S) of a "group" of bits of A and B (NBIT_PER_BLOCK) 

    FOR1: for i in 1 to NBLOCKS generate
      begin
        
        UCSi: CARRY_SEL_N
          generic map(NBIT_PER_BLOCK)
          port map (A(i*NBIT_PER_BLOCK-1 downto (i-1)*NBIT_PER_BLOCK), B(i*NBIT_PER_BLOCK-1 downto (i-1)*NBIT_PER_BLOCK), Ci(i-1), S(i*NBIT_PER_BLOCK-1 downto (i-1)*NBIT_PER_BLOCK));
        
    end generate;
    
end STRUCTURAL;

