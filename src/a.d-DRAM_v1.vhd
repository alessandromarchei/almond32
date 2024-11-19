library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;  -- Use this library instead

-- BLC : BYTE LANE CONTROL ==> allows to configure the proper way to store a word : 
-- BLC = "00" ==> STORE WORD
-- BLC = "01" ==> STORE LEAST SIGNIFICANT BYTE OF DATAIN
-- BLC = "10" ==> STORE LEAST SIGNIFICANT HALF OF DATAIN
entity DRAM is
    generic(ADDR_BUS_SIZE : integer := 32;
            DATA_BUS_SIZE : integer := 32);
    Port (  CLOCK : in std_logic;
            Rst : in  std_logic;
            WR : in std_logic;
            RD : in std_logic;
            BLC : in std_logic_VECTOR(1 downto 0); -- Byte lane control
            ADDR : in  std_logic_VECTOR(ADDR_BUS_SIZE - 1 downto 0);
            DataIn : in  std_logic_VECTOR(DATA_BUS_SIZE - 1 downto 0);
            DataOut : out  std_logic_VECTOR(DATA_BUS_SIZE - 1 downto 0));
end DRAM;

architecture Behavioral of DRAM is

    constant MEM_SIZE : integer := 15;
    type RAM_Array is array (integer range 0 to 2**MEM_SIZE -1) of std_logic_VECTOR(DATA_BUS_SIZE - 1 downto 0);
    signal RAM_Memory : RAM_Array;
    signal ADDR_tmp : std_logic_vector(ADDR_BUS_SIZE - 1 downto 0);

    --MEMORY IMPLEMENTED IN BIG ENDIAN 
begin
    ADDR_tmp <= ADDR when to_integer(unsigned(ADDR)) > 0 else (others => '0');
    process(Rst,CLOCK)
    begin
        if Rst = '1' then
            for i in 0 to (2**MEM_SIZE -1)-1 loop
                RAM_Memory(i) <= (others => '0');
            end loop;
        elsif(CLOCK = '1' and CLOCK' event) then    --WRITE AT THE RISING EDGE
            if WR = '1' and (to_integer(unsigned(ADDR)) >= 0 ) and (to_integer(unsigned(ADDR))<2**MEM_SIZE -1) then
                case BLC is
                    when "00" =>    -- BLC = "00" ==> STORE WORD
                        RAM_Memory(to_integer(unsigned(ADDR))) <= DataIn(7 downto 0) & DataIn(15 downto 8) & DataIn(23 downto 16) & DataIn(31 downto 24);

                    when "01" =>    -- BLC = "01" ==> STORE LEAST SIGNIFICANT BYTE OF DATAIN
                        RAM_Memory(to_integer(unsigned(ADDR)))(7 downto 0) <= DataIn(7 downto 0);

                    when "10" =>    -- BLC = "10" ==> STORE LEAST SIGNIFICANT HALF OF DATAIN
                        RAM_Memory(to_integer(unsigned(ADDR)))(15 downto 0) <= DataIn(15 downto 0);
                    when others =>
                        null;
                end case;
            elsif RD = '1' and (to_integer(unsigned(ADDR)) >= 0 ) and (to_integer(unsigned(ADDR))<2**MEM_SIZE -1) then
                -- Memory read
                DataOut <= RAM_Memory(to_integer(unsigned(ADDR_tmp)));
            else
                DataOut <= RAM_Memory(0);       --read at location 0 as default
            end if;
        end if;
    end process;


end Behavioral;
