library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.math_real.all;

-- THIS MODULE IS A BRANCH HISTORY TABLE, WHICH CONTAINS A GENERIC # OF ENTRIES HANDLED BY THE VARIABLE 'N_ENTRIES'
-- EACH MEMORY CELL IS A 2-BIT SATURATING COUNTER, WHICH TRIES TO PREDICT THE CONDITIONAL BRANCHES EVEN BEFORE
-- THEIR EVALUATION IS PERFORMED.
-- AFTER THE PREDICTION AND THE EVALUATION, A FEEDBACK IS GIVEN TO THE BHT ITSELF BY WRITING INTO THE SAME LOCATION
-- JUST ACCESSED IN ORDER TO UPDATE THE COUNTER RELATIVE TO THAT CELL. IF THE BRANCH WAS TO BE TAKEN, THE CONTENT IS INCREASED
-- BY 1, WHILE ON THE OTHER CASE THE SAME DATA IS DECREASED BY 1.

-- INTERNALLY, THE BHT BLOCK EXTRACTS ONLY THE LOG2(N) BITS, DISCARDING THE WORD OFFSET BITS (THE 2 LSBs)
entity BHT is
  generic (
    NBIT : integer := 32;  -- NUMBER OF BITS OF THE PROGRAM COUNTER
    N_ENTRIES : integer := 16;    -- Change this value to set the number of entries
    WORD_OFFSET : integer := 0    -- Word offset bits, to be discarded by the internal memory
  );

  port (
    clock   : in std_logic;
    rst     : in std_logic;
    address : in std_logic_vector(NBIT - 1 downto 0);       -- address contained by the PC
    d_in    : in std_logic;                                 -- write 1 if the content of the memory should be incremented, 0 to decrement
    w_en    : in std_logic;                                 -- write enable
    d_out   : out std_logic                                 -- single bit to represent the prediction
  );
end BHT;

architecture Behavioral of BHT is
  type BHT_Array is array (0 to N_ENTRIES-1) of std_logic_vector(1 downto 0);  -- # OF ENTRIES = LOG2(T), LENGTH = 2
  signal entry : std_logic_vector(integer(ceil(log2(real(N_ENTRIES)))) - 1 downto 0);  -- value to extract the pointer of the BHT
  signal BHT : BHT_Array := (others => "00");  -- actual memory 

begin

  entry <= address(integer(ceil(log2(real(N_ENTRIES)))) + WORD_OFFSET - 1 downto WORD_OFFSET);  --EXTRACT THE ENTRY FROM THE PC
  d_out <= BHT(conv_integer(unsigned(entry)))(1);  -- extracting the MSB from the cell ==> PREDICTION

  rst_process : process(rst,clock)
  begin
    -- update the content of the memory at a particular location, only if the w_en is active
   if rst = '1' then
      BHT <= (others => "00");  -- Reset BHT to all zeros
      
    elsif clock = '0' and clock'event then
      
      if w_en = '1' then
        --increment or decrement the content of that cell, depending on the signal "d_in"
        if d_in = '1' then
          -- increment the content in case it is not equal to 3 (otherwise saturate)
          if conv_integer(BHT(conv_integer(unsigned(entry)))) /= 3 then
            BHT(conv_integer(unsigned(entry))) <= std_logic_vector(unsigned(BHT(conv_integer(unsigned(entry))) + 1));
        end if;

      else 
        -- decrement the content of that cell, WITHOUT REWRAP, so it is a 2-bit saturating counter
        if conv_integer(BHT(conv_integer(unsigned(entry)))) /= 0 then
          BHT(conv_integer(unsigned(entry))) <= std_logic_vector(unsigned(BHT(conv_integer(unsigned(entry))) - 1 ));
        end if;
    end if; 
  end if;
  end if;
  end process;


end Behavioral;
