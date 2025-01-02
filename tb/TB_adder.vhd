library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity TB_ADDER is
end TB_ADDER;

architecture TEST of TB_ADDER is
	
	-- P4 component declaration
	component ADDER is
		generic (
			NBIT : 	integer := 32;
                        NBIT_PER_BLOCK: integer := 4);
		port (
			A :    	in	std_logic_vector(NBIT-1 downto 0);
			B :    	in	std_logic_vector(NBIT-1 downto 0);
			ADD_SUB :	in	std_logic;
      Cin : in std_logic;
			S :    	out	std_logic_vector(NBIT-1 downto 0);
			Cout :	out	std_logic
      );
	end component;

        constant NBIT : integer := 32;
        constant NBIT_PER_BLOCK : integer := 4;
        signal A1, B1 : std_logic_vector (NBIT-1 downto 0);
        signal sel, cin, carryout : std_logic;
	signal sum : std_logic_vector (NBIT-1 downto 0);
        
begin
	-- P4 instantiation
         DUT: ADDER
         generic map (32, 4)
         port map (A1, B1, sel, cin, sum, carryout);

         --PROCESS FOR TESTING TEST
         
         ptest: process
         begin

           cin <= '0';

           --test 10 + 1
           A1 <= "00000000000000000000000000001010";
           B1 <= "00000000000000000000000000000001";
           sel <= '0';
           cin <= '0';
            wait for 20 ns;
        

           A1 <= std_logic_vector(to_unsigned(10,32));
           B1 <= std_logic_vector(to_unsigned(7,32));
           sel <= '1';
           wait for 20 ns;

            --test 10 + (-3)
            A1 <= "00000000000000000000000000001010";
            B1 <= "11111111111111111111111111111101";
            sel <= '0';
            cin <= '0';
             wait for 20 ns;

             --test 10 + (-3)
            A1 <= "00000000000000000000000000001010";
            B1 <= "11111111111111111111111111111101";
            sel <= '0';
            cin <= '0';
             wait for 20 ns;

             --test 10 + (-3)
            A1 <= "00000000000000000000000000001010";
            B1 <= "11111111111111111111111111111101";
            sel <= '0';
            cin <= '0';
            wait for 20 ns;

             A1 <= std_logic_vector(to_unsigned(12,32));
             B1 <= std_logic_vector(to_unsigned(12,32));
             sel <= '1';
             wait for 20 ns;

           --test: 5 - 3 = 2
           A1 <= "00000000000000000000000000000101";
           B1 <= "00000000000000000000000000000011";
           sel <= '1';
           wait for 20 ns;

           A1 <= "00000000000000000000000000000101";
           B1 <= "11111111111111111111111111111100";
           sel <= '0';
           cin <= '1';
           wait for 20 ns;

           A1 <= "00000000000000000000000000000101";
           B1 <= "11111111111111111111111111111101";
           sel <= '0';
           cin <= '0';
           wait for 20 ns;

           A1 <= (others => '1');
           B1 <= (others => '1');
           sel <= '1';
           wait for 20 ns;
           
        

          
           
           A1 <= "00000000000000000000000000001110";
           B1 <= "00000000000000000000000001111111";
           sel <= '0';
           wait for 30 ns;
          

           A1 <= "00000000000000000000000000000001";
           B1 <= (others =>'1');
           sel <= '0';
            wait for 20 ns;
           

           A1 <= (others => '1');
           B1 <= (others => '0');
           sel <= '1';
           wait for 20 ns;
           

           A1 <= "00000000000000000000000001000000";
           B1 <= "00000000000000000000000001110110";
           sel <= '0';
           wait for 20 ns;
           

           A1 <= "00000000000000000000000000000101";
           B1 <= "00000000000000000000000001100110";
           sel <= '0';
           

           wait;

        end process ptest;
         
	
end TEST;
