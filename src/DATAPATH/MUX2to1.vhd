library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic
use WORK.constants.all; -- libreria WORK user-defined

--THIS MODULE IMPLEMENTS A GENERIC 2 TO 1 MULTIPLEXER IN A BEHAVIORAL WAY

entity MUX2to1 is
        Generic (NBIT: integer:= 32);
	Port (	A:	In	std_logic_vector(NBIT-1 downto 0) ;
		B:	In	std_logic_vector(NBIT-1 downto 0);
		SEL:	In	std_logic;
		Y:	Out	std_logic_vector(NBIT-1 downto 0));
end MUX2to1;


architecture BEHAVIORAL of MUX2to1 is

begin
	pmux: process(A,B,SEL)
	begin
                 if SEL = '0' then
			Y <= A; 
		else
			Y <= B;
		end if;
            
	end process;

end BEHAVIORAL;
