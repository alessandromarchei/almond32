library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.math_real.all;
use WORK.all;

--NBIT = DATA PARALLELISM OF EACH REGISTER
--NREG = NUMBER OF REGISTERS IN THE FILE

--THIS REGISTER FILE IS A 2-PORT READ AND 1-PORT WRITE, IMPLEMENTED IN A BEHAVIORAL WAY

--TO BE NOTED THAT IN ORDER TO AVOID CONCURRENCIES WHEN IT COMES TO WRITE AND READ THE SAME REGISTER LOCATION
--AT THE SAME TIME, (TYPICALLY WHEN RF IS ACCESSED DURING THE DECODE STAGE AND WRITE BACK STAGE), THE READ AND WRITE 
--OPERATIONS OCCURS IN 2 DIFFERENT CLOCK EDGES.
entity RF is
 generic(NBIT : integer := 32;
         NREG : integer := 32);
 port ( CLK: 		IN std_logic;
         RESET: 	IN std_logic;
          ENABLE: 	IN std_logic;
          RD1: 		IN std_logic;
          RD2: 		IN std_logic;
          WR: 		IN std_logic;
          ADD_WR: 	IN std_logic_vector(integer(log2(real(NREG)))-1 downto 0);
          ADD_RD1: 	IN std_logic_vector(integer(log2(real(NREG)))-1 downto 0);
          ADD_RD2: 	IN std_logic_vector(integer(log2(real(NREG)))-1 downto 0);
          DATAIN: 	IN std_logic_vector(NBIT - 1 downto 0);
         OUT1: 		OUT std_logic_vector(NBIT - 1 downto 0);
	 OUT2: 		OUT std_logic_vector(NBIT - 1 downto 0));
end RF;

architecture BEHAVIORAL of RF is

        -- suggested structures
  subtype REG_ADDR is natural range 0 to NREG-1; -- ADDRESSES OF THE RF
  type REG_ARRAY is array (REG_ADDR) of std_logic_vector(NBIT - 1 downto 0);
--BANK OF REGISTERS
  signal REGISTERS : REG_ARRAY; --
	
begin 

-- Write with the falling edge of the clock and read with the rising edge of the clock

reg : process(CLK)
  begin
    if (CLK = '0') then
      if(RESET = '1') then                     --SYNCHRONOUS RESET
        for i in 0 to NREG-1 loop 
          REGISTERS(i) <= (others => '0');      --EVERY REGISTER IS CLEARED
        end loop;
      elsif(ENABLE = '1') then                  --WR/RD ONLY IF ENABLE IS ACTIVE
        if(WR = '1' and (conv_integer(unsigned(ADD_WR)) /= 0)) then
          REGISTERS(conv_integer(unsigned(ADD_WR))) <= DATAIN;          --SIMOULTANEOUS WRITE
        end if;
      end if;
    elsif (CLK = '1') then
        if(RD1 = '1' and (conv_integer(unsigned(ADD_RD1)) /= 0)) then
          OUT1 <= REGISTERS(conv_integer(unsigned(ADD_RD1)));          --SIMOULTANEOUS READ AT PORT 1
		else OUT1 <= (others => '0');
        end if;
        if(RD2 = '1' and (conv_integer(unsigned(ADD_RD2)) /= 0)) then
          OUT2 <= REGISTERS(conv_integer(unsigned(ADD_RD2)));          --SIMOULTANEOUS READ AT PORT 2
		else OUT2 <= (others => '0');
        end if;
    end if;
end process;




end BEHAVIORAL;
